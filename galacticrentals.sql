-- =============================================
-- Database: GalacticRentals
-- Assignment 1: Rental Transactions Table
-- =============================================

-- SECTION 1: DATABASE CREATION
-- =============================================
DROP DATABASE IF EXISTS GalacticRentals;
CREATE DATABASE GalacticRentals;
USE GalacticRentals;

-- SECTION 2: TABLE CREATION (DDL)
DROP TABLE IF EXISTS rentals;

CREATE TABLE rentals (
    rental_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Unique identifier
    customer_name VARCHAR(100) NOT NULL,               -- Cannot be empty
    costume_name VARCHAR(255) NOT NULL,                -- Cannot be empty
    rent_date DATETIME NOT NULL,                       -- Date of rental
    return_date DATETIME NULL CHECK (return_date IS NULL OR return_date >= rent_date), -- Nullable but must be after rent_date
    daily_fee DECIMAL(10, 2) NOT NULL CHECK (daily_fee > 0), -- Positive decimal
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Record creation timestamp
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Record update timestamp
);

-- SECTION 3: DATA INSERTION (DML)
INSERT INTO rentals (customer_name, costume_name, rent_date, return_date, daily_fee)
VALUES 
('Alice Johnson', 'Imperial Officer', '2025-04-01 10:00:00', '2025-04-03 15:30:00', 25.00),
('Bob Smith', 'Galaxy Explorer', '2025-04-02 09:15:00', '2025-04-05 11:00:00', 30.00),
('Carol Lee', 'Time Traveler', '2025-04-05 14:45:00', '2025-04-06 16:00:00', 20.00),
('Dave Martinez', 'Robot Droid', '2025-04-07 13:00:00', '2025-04-12 13:00:00', 28.50),
('Eva Wang', 'Alien Monarch', '2025-04-10 12:10:00', '2025-04-11 18:20:00', 22.00),
('Frank Davis', 'Imperial Officer', '2025-04-12 08:00:00', '2025-04-15 09:00:00', 25.00),
('Grace Kim', 'Galaxy Explorer', '2025-04-15 10:20:00', '2025-04-17 12:35:00', 30.00),
('Henry Brown', 'Robot Droid', '2025-04-18 11:00:00', '2025-04-19 14:15:00', 28.50),
('Isabel Clark', 'Time Traveler', '2025-04-20 09:30:00', '2025-04-23 10:00:00', 20.00),
('John Doe', 'Alien Monarch', '2025-04-22 14:00:00', NULL, 22.00);

-- SECTION 4: - BULK INSERT
--There is aproblem when make the loading for file i searched to fix it but i dont find the solving problem
/*
LOAD DATA LOCAL INFILE 'C:\xampp\mysql\data\Rentals sample.csv'
INTO TABLE rentals
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rental_id, customer_name, costume_name, rent_date, return_date, daily_fee)
SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP;

*/

-- SECTION 5: QUERYING (Exploratory Analysis)

-- Most popular costumes
SELECT costume_name, COUNT(*) AS rental_count
FROM rentals
GROUP BY costume_name
ORDER BY rental_count DESC;

-- Customers with most rentals
SELECT customer_name, COUNT(*) AS rental_count
FROM rentals
GROUP BY customer_name
ORDER BY rental_count DESC;

-- Current open rentals (not yet returned)
SELECT * FROM rentals
WHERE return_date IS NULL;

-- Calculate rental duration and total fees for returned items
SELECT 
    rental_id,
    customer_name,
    costume_name,
    TIMESTAMPDIFF(HOUR, rent_date, return_date)/24.0 AS days_rented,
    daily_fee,
    ROUND((TIMESTAMPDIFF(HOUR, rent_date, return_date)/24.0) * daily_fee, 2) AS total_fee
FROM rentals
WHERE return_date IS NOT NULL;
