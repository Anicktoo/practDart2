CREATE DATABASE test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE test;

CREATE TABLE Sector (
    sector_id INT PRIMARY KEY AUTO_INCREMENT,
    coordinates VARCHAR(50),
    light_intensity FLOAT,
    foreign_objects INT UNSIGNED,
    star_objects INT UNSIGNED,
    undefined_objects INT UNSIGNED,
    identified_objects INT UNSIGNED,
    notes TEXT
);

CREATE TABLE Objects (
    object_id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50),
    accuracy FLOAT,
    quantity INT UNSIGNED,
    time TIME,
    date DATE,
    notes TEXT(255)
);

CREATE TABLE Natural_objects (
    natural_object_id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50),
    galaxy VARCHAR(50),
    accuracy FLOAT,
    light_flux FLOAT,
    associated_objects INT UNSIGNED,
    notes TEXT(255)
);

CREATE TABLE Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    earth_position VARCHAR(255),
    sun_position VARCHAR(255),
    moon_position VARCHAR(255),
    notes TEXT(255)
);

CREATE TABLE Observation (
    observation_id INT PRIMARY KEY AUTO_INCREMENT,
    sector_id INT,
    object_id INT,
    natural_object_id INT,
    location_id INT,
    date_update DATETIME,
    observer_notes TEXT,
    FOREIGN KEY (sector_id) REFERENCES Sector(sector_id),
    FOREIGN KEY (object_id) REFERENCES Objects(object_id),
    FOREIGN KEY (natural_object_id) REFERENCES Natural_objects(natural_object_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

INSERT INTO Sector (coordinates, light_intensity, foreign_objects, star_objects, undefined_objects, identified_objects, notes)
VALUES 
    ('10.123, 20.456', 0.8, 2, 5, 1, 6, 'Sector near Orion Nebula'),
    ('30.789, 40.012', 0.6, 3, 7, 2, 8, 'Sector near Andromeda Galaxy'),
    ('50.234, 60.789', 0.7, 1, 4, 0, 5, 'Sector near Pleiades Cluster');

INSERT INTO Objects (type, accuracy, quantity, time, date, notes)
VALUES 
    ('Satellite', 0.95, 1, '12:00:00', '2024-06-01', 'Weather monitoring satellite'),
    ('Space Station', 0.98, 1, '14:30:00', '2024-06-02', 'International Space Station'),
    ('Debris', 0.70, 5, '16:45:00', '2024-06-03', 'Debris from old satellite');

INSERT INTO Natural_objects(type, galaxy, accuracy, light_flux, associated_objects, notes)
VALUES 
    ('Star', 'Milky Way', 0.99, 1.2e+30, 3, 'Nearby star in the Milky Way'),
    ('Planet', 'Milky Way', 0.95, 3.3e+24, 1, 'Planet in the Milky Way galaxy'),
    ('Galaxy', 'Andromeda', 0.90, 5.0e+35, 0, 'Andromeda Galaxy'),
    ('Asteroid', 'Solar System', 0.85, 4.5e+18, 0, 'Asteroid in the asteroid belt'),
    ('Comet', 'Solar System', 0.80, 1.0e+15, 0, 'Comet passing near Earth'),
    ('Nebula', 'Milky Way', 0.88, 2.5e+28, 2, 'Nebula observed in the Milky Way');

INSERT INTO Location(earth_position, sun_position, moon_position, notes)
VALUES 
    ('10.123, 20.456', '30.789, 40.012', '15.678, 25.123', 'Observation made from Earth to Sun direction'),
    ('30.789, 40.012', '50.234, 60.789', '35.678, 45.123', 'Observation made from Earth'),
    ('50.234, 60.789', '10.123, 20.456', '55.678, 65.123', 'Observation made from Earth to Moon direction');


INSERT INTO Observation (sector_id, object_id, natural_object_id, location_id, observer_notes, date_update)
VALUES 
    (1, 1, NULL, 1, 'Weather monitoring satellite observed in sector 1', NOW()),
    (2, 2, NULL, 2, 'International Space Station observed in sector 2', NOW()),
    (3, 3, NULL, 3, 'Debris from old satellite detected in sector 3', NOW()),
    (1, NULL, 1, 1, 'Bright star observed in sector 1', NOW()),
    (2, NULL, 2, 2, 'Planet observed in sector 2', NOW()),
    (3, NULL, 3, 3, 'Asteroids detected in sector 3', NOW()),
    (3, NULL, 4, 3, 'Galaxy Andromeda observed in sector 3', NOW()),
    (2, NULL, 5, 2, 'Comet observed in sector 2', NOW()),
    (3, NULL, 6, 3, 'Nebula detected in sector 3', NOW());

delimiter //

CREATE PROCEDURE observation_and_natural_objects()
BEGIN
    SELECT * FROM Observation NATURAL JOIN Natural_objects;
END//

CREATE TRIGGER update_date_trigger
BEFORE UPDATE ON Observation
FOR EACH ROW
BEGIN
    SET NEW.date_update = NOW();
END//

delimiter ;
