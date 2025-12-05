# LibraryManager

A simple SQL database project for managing a personal library.

## Quick Start

1. Clone the repo:
```bash
git clone https://github.com/ginomartelli/Library-Manager.git
cd Library-Manager
```

2. Run SQL files in order:
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/sample_data.sql
mysql -u root -p < database/queries.sql
```

## Features

-  Complete book catalog management
-  Loan tracking with due dates and returns
-  Rating system (1-5 stars)
-  Member status management (active/suspended/expired)
-  Multiple book genres
-  Ready-to-use SQL queries

## Sample Data Included

- 20 books (classics, sci-fi, fantasy, novels...)
- 15 members with different statuses
- 30 loans (returned, ongoing, overdue)
- 25 reviews and ratings

## Customize for Your Needs

1. Add your own books in `sample_data.sql`
2. Modify queries in `queries.sql`
3. Adjust loan durations in the schema
4. Add new tables or columns as needed

## 🗂 Database Schema Overview

- **books**: Book catalog with availability tracking
- **members**: Library members with status management
- **loans**: Loan history with due dates
- **reviews**: Book ratings and comments

## Getting Started Guide

1. Install MySQL on your system
2. Create a new database user (optional)
3. Run the schema.sql file first
4. Load sample data
5. Test with provided queries

## Useful Views Created

- `available_books_view`: Shows currently available books
- `current_loans_view`: Displays active loans
- `top_rated_books_view`: Lists books by average rating
