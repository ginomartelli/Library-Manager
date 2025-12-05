-- queries.sql
-- Collection de requêtes utiles pour la gestion de la bibliothèque
-- Exécutez ce fichier APRÈS avoir inséré les données

USE library_db;

-- ============================================
-- VUES UTILES (pour simplifier les requêtes courantes)
-- ============================================

-- Vue 1: Livres actuellement disponibles
CREATE OR REPLACE VIEW available_books_view AS
SELECT 
    book_id,
    title,
    author,
    genre,
    available_copies
FROM books
WHERE available_copies > 0
ORDER BY title;

-- Vue 2: Emprunts en cours
CREATE OR REPLACE VIEW current_loans_view AS
SELECT 
    l.loan_id,
    b.title,
    CONCAT(m.first_name, ' ', m.last_name) as member_name,
    l.loan_date,
    l.due_date,
    l.status,
    DATEDIFF(CURDATE(), l.due_date) as days_overdue
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.status IN ('borrowed', 'overdue')
    AND l.return_date IS NULL;

-- Vue 3: Meilleurs livres (note moyenne)
CREATE OR REPLACE VIEW top_rated_books_view AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    ROUND(AVG(r.rating), 2) as average_rating,
    COUNT(r.review_id) as review_count
FROM books b
LEFT JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title, b.author
HAVING COUNT(r.review_id) >= 1
ORDER BY average_rating DESC, review_count DESC;

-- ============================================
-- REQUÊTES STATISTIQUES ET RAPPORTS
-- ============================================

-- 1. STATISTIQUES GÉNÉRALES
SELECT 'Statistiques générales de la bibliothèque' as report;
SELECT 
    (SELECT COUNT(*) FROM books) as total_books,
    (SELECT COUNT(*) FROM members WHERE membership_status = 'active') as active_members,
    (SELECT COUNT(*) FROM loans WHERE MONTH(loan_date) = MONTH(CURDATE())) as loans_this_month,
    (SELECT COUNT(*) FROM loans WHERE status = 'overdue') as overdue_loans,
    (SELECT ROUND(AVG(rating), 2) FROM reviews) as average_rating;

-- 2. TOP 10 DES LIVRES LES PLUS EMPRUNTÉS
SELECT 'Top 10 des livres les plus empruntés' as report;
SELECT 
    b.title,
    b.author,
    COUNT(l.loan_id) as times_borrowed,
    b.total_copies,
    b.available_copies
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title, b.author, b.total_copies, b.available_copies
ORDER BY times_borrowed DESC
LIMIT 10;

-- 3. MEMBRES LES PLUS ACTIFS
SELECT 'Top 10 des membres les plus actifs' as report;
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) as member_name,
    m.email,
    COUNT(l.loan_id) as total_loans,
    COUNT(DISTINCT r.book_id) as different_books_read,
    AVG(r.rating) as average_rating_given
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN reviews r ON m.member_id = r.member_id
GROUP BY m.member_id, m.first_name, m.last_name, m.email
HAVING total_loans > 0
ORDER BY total_loans DESC
LIMIT 10;

-- 4. EMPRUNTS EN RETARD
SELECT 'Emprunts en retard (plus de 7 jours)' as report;
SELECT 
    l.loan_id,
    b.title,
    CONCAT(m.first_name, ' ', m.last_name) as borrower,
    m.email,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) as days_overdue,
    CASE 
        WHEN DATEDIFF(CURDATE(), l.due_date) BETWEEN 8 AND 14 THEN 'Modéré'
        WHEN DATEDIFF(CURDATE(), l.due_date) BETWEEN 15 AND 30 THEN 'Important'
        WHEN DATEDIFF(CURDATE(), l.due_date) > 30 THEN 'Critique'
        ELSE 'Faible'
    END as severity
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.status = 'overdue'
    AND DATEDIFF(CURDATE(), l.due_date) > 7
ORDER BY days_overdue DESC;

-- 5. GENRES LES PLUS POPULAIRES
SELECT 'Popularité des genres' as report;
SELECT 
    b.genre,
    COUNT(DISTINCT b.book_id) as number_of_books,
    COUNT(l.loan_id) as total_loans,
    ROUND(AVG(r.rating), 2) as average_rating
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
LEFT JOIN reviews r ON b.book_id = r.book_id
WHERE b.genre IS NOT NULL
GROUP BY b.genre
ORDER BY total_loans DESC;

-- 6. ACTIVITÉ MENSUELLE
SELECT 'Activité mensuelle (derniers 6 mois)' as report;
SELECT 
    DATE_FORMAT(loan_date, '%Y-%m') as month_year,
    COUNT(*) as total_loans,
    COUNT(DISTINCT member_id) as unique_borrowers,
    COUNT(DISTINCT book_id) as unique_books,
    SUM(CASE WHEN status = 'overdue' THEN 1 ELSE 0 END) as overdue_count
FROM loans
WHERE loan_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(loan_date, '%Y-%m')
ORDER BY month_year DESC;

-- 7. LIVRES JAMAIS EMPRUNTÉS
SELECT 'Livres jamais empruntés' as report;
SELECT 
    b.title,
    b.author,
    b.genre,
    b.total_copies,
    b.available_copies
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
WHERE l.loan_id IS NULL
ORDER BY b.title;

-- 8. MEMBRES AVEC ADHÉSION QUI EXPIRE BIENTÔT (dans 30 jours)
SELECT 'Membres avec adhésion qui expire bientôt' as report;
SELECT 
    member_id,
    CONCAT(first_name, ' ', last_name) as member_name,
    email,
    join_date,
    DATE_ADD(join_date, INTERVAL 1 YEAR) as expiry_date,
    DATEDIFF(DATE_ADD(join_date, INTERVAL 1 YEAR), CURDATE()) as days_until_expiry
FROM members
WHERE membership_status = 'active'
    AND DATEDIFF(DATE_ADD(join_date, INTERVAL 1 YEAR), CURDATE()) BETWEEN 1 AND 30;

-- ============================================
-- REQUÊTES OPÉRATIONNELLES (pour la gestion quotidienne)
-- ============================================

-- 9. EMPRUNTER UN LIVRE (procédure simulée)
-- Note: Dans une vraie application, ce serait une procédure stockée
SELECT 'Simulation: Emprunter un livre' as operation;
-- Variables pour la simulation
SET @book_id_to_borrow = 1;
SET @member_id_borrowing = 12;
SET @due_days = 14;

-- Vérifier si le livre est disponible
SELECT 
    title,
    author,
    available_copies,
    CASE 
        WHEN available_copies > 0 THEN 'DISPONIBLE'
        ELSE 'INDISPONIBLE'
    END as availability
FROM books 
WHERE book_id = @book_id_to_borrow;

-- 10. RETOURNER UN LIVRE (procédure simulée)
SELECT 'Simulation: Retourner un livre' as operation;
SET @loan_id_to_return = 2;

-- Info sur l'emprunt à retourner
SELECT 
    l.loan_id,
    b.title,
    CONCAT(m.first_name, ' ', m.last_name) as borrower,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) as days_late
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.loan_id = @loan_id_to_return;

-- ============================================
-- REQUÊTES POUR L'ANALYSE DES DONNÉES
-- ============================================

-- 11. CORRÉLATION ENTRE NOTES ET NOMBRE D'EMPRUNTS
SELECT 'Corrélation: Notes vs Popularité' as analysis;
SELECT 
    b.book_id,
    b.title,
    COUNT(l.loan_id) as loan_count,
    ROUND(AVG(r.rating), 2) as average_rating,
    CASE 
        WHEN COUNT(l.loan_id) > (SELECT AVG(loan_count) FROM (
            SELECT COUNT(*) as loan_count FROM loans GROUP BY book_id
        ) as sub) THEN 'Populaire'
        ELSE 'Moins populaire'
    END as popularity
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
LEFT JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title
HAVING average_rating IS NOT NULL
ORDER BY average_rating DESC, loan_count DESC;

-- 12. SAISONNALITÉ DES EMPRUNTS
SELECT 'Saisonnalité des emprunts par genre' as analysis;
SELECT 
    b.genre,
    MONTH(l.loan_date) as month,
    MONTHNAME(l.loan_date) as month_name,
    COUNT(*) as loans_count
FROM loans l
JOIN books b ON l.book_id = b.book_id
WHERE b.genre IS NOT NULL
GROUP BY b.genre, MONTH(l.loan_date), MONTHNAME(l.loan_date)
ORDER BY b.genre, month;

-- ============================================
-- EXEMPLE D'UTILISATION DES VUES
-- ============================================

SELECT 'Utilisation des vues créées' as section;

-- Utiliser la vue des livres disponibles
SELECT * FROM available_books_view LIMIT 5;

-- Utiliser la vue des emprunts en cours
SELECT * FROM current_loans_view WHERE days_overdue > 0;

-- Utiliser la vue des meilleurs livres
SELECT * FROM top_rated_books_view LIMIT 5;

-- ============================================
-- MAINTENANCE ET NETTOYAGE
-- ============================================

-- 13. IDENTIFIER LES DONNÉES INCOHÉRENTES
SELECT 'Vérification de l intégrité des données' as maintenance;
SELECT 'Livres avec copies disponibles négatives:' as check_type;
SELECT * FROM books WHERE available_copies < 0;

SELECT 'Emprunts avec dates incohérentes:' as check_type;
SELECT * FROM loans WHERE return_date < loan_date OR due_date < loan_date;

SELECT 'Membres sans emprunts ni avis:' as check_type;
SELECT m.* 
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN reviews r ON m.member_id = r.member_id
WHERE l.loan_id IS NULL AND r.review_id IS NULL;

-- 14. SUGGESTIONS D'ACHATS (livres très demandés)
SELECT 'Suggestions d achats (livres souvent indisponibles):' as suggestion;
SELECT 
    b.title,
    b.author,
    b.genre,
    b.total_copies,
    COUNT(l.loan_id) as times_requested,
    ROUND(COUNT(l.loan_id) / NULLIF(b.total_copies, 0), 2) as requests_per_copy
FROM books b
JOIN loans l ON b.book_id = l.book_id
WHERE b.available_copies = 0
    OR (COUNT(l.loan_id) / NULLIF(b.total_copies, 0)) > 5
GROUP BY b.book_id, b.title, b.author, b.genre, b.total_copies
ORDER BY requests_per_copy DESC;
