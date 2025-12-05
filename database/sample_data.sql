-- sample_data.sql
-- Données d'exemple pour la bibliothèque
-- Exécutez ce fichier APRÈS schema.sql

USE library_db;

-- Désactiver temporairement les vérifications de clés étrangères pour l'insertion
SET FOREIGN_KEY_CHECKS = 0;

-- Nettoyer les tables existantes (optionnel pour les tests)
TRUNCATE TABLE reviews;
TRUNCATE TABLE loans;
TRUNCATE TABLE members;
TRUNCATE TABLE books;

-- Réactiver les vérifications
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- LIVRES (20 livres variés)
-- ============================================
INSERT INTO books (title, author, isbn, publication_year, genre, total_copies, available_copies) VALUES
-- Classiques français
('Le Petit Prince', 'Antoine de Saint-Exupéry', '9782070612758', 1943, 'Fiction philosophique', 5, 3),
('Les Misérables', 'Victor Hugo', '9782253010661', 1862, 'Roman historique', 3, 1),
('L Étranger', 'Albert Camus', '9782070360023', 1942, 'Roman philosophique', 4, 2),

-- Romans contemporains
('La Vérité sur l Affaire Harry Quebert', 'Joël Dicker', '9782253186328', 2012, 'Policier', 2, 1),
('Changer l eau des fleurs', 'Valérie Perrin', '9782226435234', 2018, 'Roman contemporain', 3, 0),

-- Science-fiction
('Dune', 'Frank Herbert', '9782290114967', 1965, 'Science-fiction', 4, 2),
('Fondation', 'Isaac Asimov', '9782070360535', 1951, 'Science-fiction', 2, 1),

-- Fantasy
('Harry Potter à l école des sorciers', 'J.K. Rowling', '9782070518424', 1997, 'Fantasy', 6, 4),
('Le Seigneur des Anneaux : La Communauté de l Anneau', 'J.R.R. Tolkien', '9782266280015', 1954, 'Fantasy', 3, 1),

-- Policiers/Thrillers
('Da Vinci Code', 'Dan Brown', '9782253151883', 2003, 'Thriller', 3, 2),
('Millénium, Tome 1', 'Stieg Larsson', '9782738117999', 2005, 'Policier', 2, 0),

-- Biographies
('Steve Jobs', 'Walter Isaacson', '9782221109428', 2011, 'Biographie', 2, 1),
('Devenir', 'Michelle Obama', '9782221242881', 2018, 'Autobiographie', 3, 2),

-- Développement personnel
('Le Pouvoir du moment présent', 'Eckhart Tolle', '9782266200678', 1997, 'Développement personnel', 4, 3),

-- Cuisine
('Pâtisserie', 'Christophe Felder', '9782013961837', 2007, 'Cuisine', 2, 2),

-- Histoire
('Sapiens : Une brève histoire de l humanité', 'Yuval Noah Harari', '9782221157085', 2011, 'Histoire', 3, 1),

-- Science
('Une brève histoire du temps', 'Stephen Hawking', '9782080812384', 1988, 'Science', 2, 1),

-- Jeunesse
('Le Journal d un dégonflé', 'Jeff Kinney', '9782205061569', 2007, 'Jeunesse', 5, 3),

-- Poésie
('Les Fleurs du Mal', 'Charles Baudelaire', '9782253019213', 1857, 'Poésie', 2, 2),

-- Théâtre
('Le Misanthrope', 'Molière', '9782253010517', 1666, 'Théâtre', 3, 3);

-- ============================================
-- MEMBRES (15 membres)
-- ============================================
INSERT INTO members (first_name, last_name, email, join_date, membership_status) VALUES
-- Membres actifs
('Marie', 'Dupont', 'marie.dupont@email.com', '2023-06-15', 'active'),
('Pierre', 'Martin', 'pierre.martin@email.com', '2023-07-10', 'active'),
('Sophie', 'Bernard', 'sophie.bernard@email.com', '2023-08-05', 'active'),
('Lucas', 'Petit', 'lucas.petit@email.com', '2023-09-20', 'active'),
('Emma', 'Dubois', 'emma.dubois@email.com', '2023-10-12', 'active'),
('Hugo', 'Leroy', 'hugo.leroy@email.com', '2024-01-15', 'active'),
('Chloé', 'Moreau', 'chloe.moreau@email.com', '2024-02-22', 'active'),
('Thomas', 'Simon', 'thomas.simon@email.com', '2024-03-01', 'active'),

-- Membres suspendus (retards)
('Julie', 'Laurent', 'julie.laurent@email.com', '2023-11-08', 'suspended'),
('Nicolas', 'Roux', 'nicolas.roux@email.com', '2023-12-03', 'suspended'),

-- Membre expiré
('Camille', 'Fontaine', 'camille.fontaine@email.com', '2022-05-18', 'expired'),

-- Nouveaux membres
('Sarah', 'Giraud', 'sarah.giraud@email.com', '2024-03-10', 'active'),
('Maxime', 'Blanc', 'maxime.blanc@email.com', '2024-03-12', 'active'),
('Lisa', 'Caron', 'lisa.caron@email.com', '2024-03-14', 'active'),
('Antoine', 'Chevalier', 'antoine.chevalier@email.com', '2024-03-15', 'active');

-- ============================================
-- EMPRUNTS (30 emprunts historiques et actuels)
-- ============================================
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
-- Emprunts retournés
(1, 1, '2024-01-10', '2024-01-24', '2024-01-20', 'returned'),
(3, 2, '2024-01-15', '2024-01-29', '2024-01-28', 'returned'),
(6, 3, '2024-01-20', '2024-02-03', '2024-02-02', 'returned'),
(8, 4, '2024-02-01', '2024-02-15', '2024-02-14', 'returned'),
(12, 5, '2024-02-10', '2024-02-24', '2024-02-23', 'returned'),

-- Emprunts en cours (non retournés)
(2, 1, '2024-03-01', '2024-03-15', NULL, 'borrowed'),
(4, 2, '2024-03-03', '2024-03-17', NULL, 'borrowed'),
(7, 3, '2024-03-05', '2024-03-19', NULL, 'borrowed'),
(9, 4, '2024-03-07', '2024-03-21', NULL, 'borrowed'),
(11, 5, '2024-03-10', '2024-03-24', NULL, 'borrowed'),

-- Emprunts en retard
(5, 6, '2024-02-28', '2024-03-13', NULL, 'overdue'),
(10, 7, '2024-03-02', '2024-03-16', NULL, 'overdue'),
(13, 8, '2024-03-04', '2024-03-18', NULL, 'overdue'),

-- Historique plus ancien
(1, 9, '2023-11-10', '2023-11-24', '2023-12-05', 'returned'), -- retour en retard
(3, 10, '2023-12-01', '2023-12-15', '2024-01-10', 'returned'), -- très en retard
(6, 1, '2024-01-05', '2024-01-19', '2024-01-18', 'returned'),
(8, 2, '2024-01-12', '2024-01-26', '2024-01-25', 'returned'),
(12, 3, '2024-01-18', '2024-02-01', '2024-01-31', 'returned'),
(15, 4, '2024-02-05', '2024-02-19', '2024-02-18', 'returned'),
(17, 5, '2024-02-08', '2024-02-22', '2024-02-21', 'returned'),

-- Emprunts multiples par le même membre
(1, 1, '2023-12-10', '2023-12-24', '2023-12-22', 'returned'),
(2, 1, '2024-02-15', '2024-02-29', '2024-02-28', 'returned'),
(4, 1, '2024-02-20', '2024-03-05', '2024-03-04', 'returned'),

-- Nouveaux emprunts récents
(14, 12, '2024-03-11', '2024-03-25', NULL, 'borrowed'),
(16, 13, '2024-03-12', '2024-03-26', NULL, 'borrowed'),
(18, 14, '2024-03-13', '2024-03-27', NULL, 'borrowed'),
(19, 15, '2024-03-14', '2024-03-28', NULL, 'borrowed');

-- ============================================
-- AVIS/NOTES (25 avis)
-- ============================================
INSERT INTO reviews (book_id, member_id, rating, comment, review_date) VALUES
-- Avis sur Le Petit Prince (livre populaire)
(1, 1, 5, 'Un classique intemporel à lire et relire !', '2024-01-25'),
(1, 2, 4, 'Belle histoire pour tous les âges, mais parfois trop philosophique pour les enfants', '2024-02-10'),
(1, 3, 5, 'Mon livre préféré depuis l enfance', '2024-02-15'),

-- Avis sur Les Misérables
(2, 4, 4, 'Roman monumental, parfois long mais passionnant', '2024-02-20'),
(2, 5, 3, 'Très bien écrit mais trop long à mon goût', '2024-02-25'),

-- Avis sur Dune
(6, 6, 5, 'Chef-d œuvre de la SF ! Monde incroyablement riche', '2024-01-30'),
(6, 7, 4, 'Excellent mais un peu complexe au début', '2024-02-05'),

-- Avis sur Harry Potter
(8, 8, 5, 'Magique ! Parfait pour s évader', '2024-02-12'),
(8, 9, 5, 'Un must-read pour tous les fans de fantasy', '2024-02-18'),
(8, 10, 4, 'Très bon début de série', '2024-02-22'),

-- Avis sur Da Vinci Code
(10, 11, 3, 'Divertissant mais un peu tiré par les cheveux', '2024-02-28'),
(10, 12, 4, 'Page-turner, difficile de lâcher le livre', '2024-03-01'),

-- Avis sur Sapiens
(15, 13, 5, 'Change complètement votre vision de l humanité', '2024-03-05'),
(15, 14, 4, 'Fascinant, bien documenté', '2024-03-08'),

-- Avis sur Steve Jobs
(12, 15, 4, 'Biographie captivante d un visionnaire complexe', '2024-03-10'),

-- Avis sur Le Journal d un dégonflé
(17, 1, 4, 'Mes enfants adorent, moi aussi !', '2024-01-20'),
(17, 2, 3, 'Drôle mais très simple', '2024-02-15'),

-- Avis variés
(3, 3, 5, 'Camus au meilleur de sa forme', '2024-02-20'),
(4, 4, 4, 'Polar bien construit avec des rebondissements', '2024-02-25'),
(5, 5, 5, 'Touchant et bien écrit, j ai adoré', '2024-03-02'),
(7, 6, 4, 'Classique de la SF à lire absolument', '2024-03-05'),
(9, 7, 5, 'Tolkien est un génie, univers incroyable', '2024-03-08'),
(11, 8, 2, 'Déçu, je m attendais à mieux', '2024-03-10'),
(13, 9, 5, 'Livre qui change la vie, approche spirituelle intéressante', '2024-03-12'),
(14, 10, 4, 'Belles recettes bien expliquées', '2024-03-14');

-- ============================================
-- MISE À JOUR DES COPIES DISPONIBLES
-- ============================================
-- Cette mise à jour corrige les copies disponibles en fonction des emprunts en cours
UPDATE books b
SET available_copies = b.total_copies - (
    SELECT COUNT(*) 
    FROM loans l 
    WHERE l.book_id = b.book_id 
    AND l.status IN ('borrowed', 'overdue')
    AND l.return_date IS NULL
);

-- Message de confirmation
SELECT 'Données d exemple insérées avec succès !' as message;
SELECT 
    (SELECT COUNT(*) FROM books) as total_books,
    (SELECT COUNT(*) FROM members) as total_members,
    (SELECT COUNT(*) FROM loans) as total_loans,
    (SELECT COUNT(*) FROM reviews) as total_reviews;
