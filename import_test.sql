-- Creation of a test base...
CREATE DATABASE test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE test;

CREATE TABLE Individuals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    passport VARCHAR(10),
    tax_number VARCHAR(12),
    social_number VARCHAR(11) NOT NULL,
    driver_license VARCHAR(10),
    documents TEXT(255),
    notes TEXT(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;


INSERT INTO Individuals (last_name, first_name, middle_name, passport, tax_number, social_number, driver_license, documents, notes)
VALUES
('Ivanov', 'Ivan', 'Ivanovich', '4510123456', '770123456789', '12345678901', '5012345678', 'Passport copy, lease agreement', 'Excellent client with good credit history'),
('Petrova', 'Anna', 'Sergeevna', '4510234567', '780234567890', '23456789012', '5012346789', 'Passport copy, income statement', 'Regular client, always pays on time'),
('Sidorova', 'Maria', 'Alexandrovna', '4510345678', '773456789012', '34567890123', '5012347890', 'Passport copy, employment contract', 'New client, additional verification required'),
('Kuznetsov', 'Dmitry', 'Petrovich', '4510456789', '774567890123', '45678901234', '5012348901', 'Passport copy, bank statement', 'High-income client'),
('Smirnova', 'Ekaterina', 'Vladimirovna', '4510567890', '775678901234', '56789012345', '5012349012', 'Passport copy, sale agreement', 'Client with stable financial situation'),
('Popov', 'Alexey', 'Igorevich', '4510678901', '776789012345', '67890123456', '5012340123', 'Passport copy, tax certificate', 'Client with previous loans in other banks');