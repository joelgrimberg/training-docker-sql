-- Dierenverzekering Database Schema

-- Klanten tabel
CREATE TABLE klanten (
    id SERIAL PRIMARY KEY,
    voornaam VARCHAR(100) NOT NULL,
    achternaam VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefoon VARCHAR(20),
    adres TEXT,
    stad VARCHAR(100),
    provincie VARCHAR(50),
    postcode VARCHAR(10),
    aangemaakt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bijgewerkt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Huisdieren tabel
CREATE TABLE huisdieren (
    id SERIAL PRIMARY KEY,
    klant_id INTEGER NOT NULL REFERENCES klanten(id) ON DELETE CASCADE,
    naam VARCHAR(100) NOT NULL,
    soort VARCHAR(50) NOT NULL CHECK (soort IN ('Hond', 'Kat', 'Vogel', 'Konijn', 'Anders')),
    ras VARCHAR(100),
    geboortedatum DATE NOT NULL,
    geslacht VARCHAR(10) CHECK (geslacht IN ('Mannelijk', 'Vrouwelijk', 'Onbekend')),
    gewicht_kg DECIMAL(5,2),
    chipnummer VARCHAR(50),
    bestaande_aandoeningen TEXT,
    aangemaakt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bijgewerkt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dekkingstypes tabel
CREATE TABLE dekkingstypes (
    id SERIAL PRIMARY KEY,
    naam VARCHAR(100) NOT NULL UNIQUE,
    beschrijving TEXT,
    basis_maandpremie DECIMAL(10,2) NOT NULL,
    eigen_risico DECIMAL(10,2) NOT NULL,
    dekkingslimiet DECIMAL(12,2),
    vergoedingspercentage INTEGER CHECK (vergoedingspercentage BETWEEN 0 AND 100)
);

-- Polissen tabel
CREATE TABLE polissen (
    id SERIAL PRIMARY KEY,
    polisnummer VARCHAR(50) UNIQUE NOT NULL,
    huisdier_id INTEGER NOT NULL REFERENCES huisdieren(id) ON DELETE CASCADE,
    dekkingstype_id INTEGER NOT NULL REFERENCES dekkingstypes(id),
    status VARCHAR(20) NOT NULL DEFAULT 'Actief' CHECK (status IN ('Actief', 'Opgeschort', 'Geannuleerd', 'Verlopen')),
    startdatum DATE NOT NULL,
    einddatum DATE,
    maandpremie DECIMAL(10,2) NOT NULL,
    resterend_eigen_risico DECIMAL(10,2) NOT NULL,
    resterend_jaarlimiet DECIMAL(12,2),
    aangemaakt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bijgewerkt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Schades tabel
CREATE TABLE schades (
    id SERIAL PRIMARY KEY,
    schadenummer VARCHAR(50) UNIQUE NOT NULL,
    polis_id INTEGER NOT NULL REFERENCES polissen(id),
    schadedatum DATE NOT NULL DEFAULT CURRENT_DATE,
    incidentdatum DATE NOT NULL,
    diagnose VARCHAR(255) NOT NULL,
    behandeling_beschrijving TEXT,
    dierenkliniek VARCHAR(255),
    totale_kosten DECIMAL(10,2) NOT NULL,
    goedgekeurd_bedrag DECIMAL(10,2),
    vergoedingsbedrag DECIMAL(10,2),
    status VARCHAR(20) NOT NULL DEFAULT 'Ingediend' CHECK (status IN ('Ingediend', 'In Behandeling', 'Goedgekeurd', 'Afgekeurd', 'Uitbetaald')),
    afwijzingsreden TEXT,
    ingediend_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verwerkt_op TIMESTAMP,
    uitbetaald_op TIMESTAMP
);

-- Schade documenten tabel
CREATE TABLE schade_documenten (
    id SERIAL PRIMARY KEY,
    schade_id INTEGER NOT NULL REFERENCES schades(id) ON DELETE CASCADE,
    documenttype VARCHAR(50) NOT NULL CHECK (documenttype IN ('Factuur', 'Medisch Dossier', 'Recept', 'Foto''s', 'Anders')),
    bestandsnaam VARCHAR(255) NOT NULL,
    bestandspad TEXT NOT NULL,
    geupload_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Betalingsgeschiedenis tabel
CREATE TABLE betalingsgeschiedenis (
    id SERIAL PRIMARY KEY,
    polis_id INTEGER NOT NULL REFERENCES polissen(id),
    betalingsdatum DATE NOT NULL DEFAULT CURRENT_DATE,
    bedrag DECIMAL(10,2) NOT NULL,
    betaalmethode VARCHAR(50) CHECK (betaalmethode IN ('Creditcard', 'Bankpas', 'Bankoverschrijving', 'PayPal')),
    transactie_id VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'Voltooid' CHECK (status IN ('In Afwachting', 'Voltooid', 'Mislukt', 'Terugbetaald')),
    aangemaakt_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Voorbeelddata voor dekkingstypes
INSERT INTO dekkingstypes (naam, beschrijving, basis_maandpremie, eigen_risico, dekkingslimiet, vergoedingspercentage) VALUES
('Basis Ongevallen', 'Dekt alleen ongevallen en spoedeisende zorg', 25.00, 500.00, 5000.00, 70),
('Compleet', 'Dekt ongevallen, ziektes en erfelijke aandoeningen', 65.00, 250.00, 15000.00, 80),
('Premium Plus', 'Volledige dekking inclusief wellness, preventieve zorg en chronische aandoeningen', 95.00, 100.00, 25000.00, 90),
('Wellness Aanvulling', 'Preventieve zorg inclusief vaccinaties, controles en gebitsverzorging', 15.00, 0.00, 1000.00, 100);

-- Voorbeelddata klanten
INSERT INTO klanten (voornaam, achternaam, email, telefoon, adres, stad, provincie, postcode) VALUES
('Sanne', 'de Vries', 'sanne.devries@email.nl', '06-12345678', 'Prinsengracht 123', 'Amsterdam', 'Noord-Holland', '1015DW'),
('Michiel', 'van den Berg', 'michiel.vandenberg@email.nl', '06-23456789', 'Witte de Withstraat 45', 'Rotterdam', 'Zuid-Holland', '3012BR'),
('Emma', 'Janssen', 'emma.janssen@email.nl', '06-34567890', 'Oudegracht 78', 'Utrecht', 'Utrecht', '3511AP'),
('Jasper', 'Bakker', 'jasper.bakker@email.nl', '06-45678901', 'Stratumseind 21', 'Eindhoven', 'Noord-Brabant', '5611HD');

-- Voorbeelddata huisdieren
INSERT INTO huisdieren (klant_id, naam, soort, ras, geboortedatum, geslacht, gewicht_kg, chipnummer) VALUES
(1, 'Bello', 'Hond', 'Golden Retriever', '2020-03-15', 'Mannelijk', 32.5, 'NL528140000123456'),
(1, 'Minou', 'Kat', 'Maine Coon', '2021-07-22', 'Vrouwelijk', 5.8, 'NL528140000123457'),
(2, 'Snoopy', 'Hond', 'Franse Buldog', '2019-11-08', 'Mannelijk', 12.3, 'NL528140000123458'),
(3, 'Rakker', 'Hond', 'Labrador Retriever', '2022-01-30', 'Vrouwelijk', 28.7, 'NL528140000123459'),
(4, 'Simba', 'Kat', 'Siamees', '2021-05-12', 'Mannelijk', 4.2, 'NL528140000123460'),
(2, 'Felix', 'Kat', 'Europese Korthaar', '2024-09-01', 'Mannelijk', 3.1, 'NL528140000123461');

-- Voorbeelddata polissen
INSERT INTO polissen (polisnummer, huisdier_id, dekkingstype_id, status, startdatum, maandpremie, resterend_eigen_risico, resterend_jaarlimiet) VALUES
('POL-2024-001', 1, 2, 'Actief', '2024-01-01', 65.00, 250.00, 15000.00),
('POL-2024-002', 2, 1, 'Actief', '2024-02-15', 25.00, 500.00, 5000.00),
('POL-2024-003', 3, 3, 'Actief', '2024-03-01', 95.00, 100.00, 25000.00),
('POL-2024-004', 4, 2, 'Actief', '2024-04-10', 65.00, 150.00, 14200.00),
('POL-2024-005', 5, 1, 'Actief', '2024-05-20', 25.00, 500.00, 5000.00);

-- Voorbeelddata schades
INSERT INTO schades (schadenummer, polis_id, schadedatum, incidentdatum, diagnose, behandeling_beschrijving, dierenkliniek, totale_kosten, goedgekeurd_bedrag, vergoedingsbedrag, status, verwerkt_op) VALUES
('SCH-2024-001', 1, '2024-06-15', '2024-06-14', 'Kruisbandscheur', 'Chirurgische reparatie van voorste kruisband', 'Dierenkliniek Amsterdam Centrum', 3500.00, 3200.00, 2560.00, 'Uitbetaald', '2024-06-20 14:30:00'),
('SCH-2024-002', 3, '2024-07-22', '2024-07-20', 'Maag-darmontsteking', 'Spoedeisende behandeling en infuus', 'Dierenartsenpraktijk Rotterdam Spoedpost', 850.00, 750.00, 675.00, 'Uitbetaald', '2024-07-25 09:15:00'),
('SCH-2024-003', 4, '2024-08-05', '2024-08-03', 'Oorontsteking', 'Onderzoek, medicatie en controle', 'Dierenkliniek Utrecht', 280.00, 280.00, 224.00, 'Goedgekeurd', '2024-08-08 11:00:00'),
('SCH-2024-004', 1, '2024-09-10', '2024-09-09', 'Gebitsverzorging', 'Routinematige tandsteenverwijdering', 'Dierenkliniek Amsterdam Centrum', 450.00, NULL, NULL, 'In Behandeling', NULL);

-- Voorbeelddata betalingsgeschiedenis
INSERT INTO betalingsgeschiedenis (polis_id, betalingsdatum, bedrag, betaalmethode, transactie_id, status) VALUES
(1, '2024-01-01', 65.00, 'Creditcard', 'TXN-20240101-001', 'Voltooid'),
(1, '2024-02-01', 65.00, 'Creditcard', 'TXN-20240201-001', 'Voltooid'),
(1, '2024-03-01', 65.00, 'Creditcard', 'TXN-20240301-001', 'Voltooid'),
(2, '2024-02-15', 25.00, 'Bankoverschrijving', 'TXN-20240215-001', 'Voltooid'),
(2, '2024-03-15', 25.00, 'Bankoverschrijving', 'TXN-20240315-001', 'Voltooid'),
(3, '2024-03-01', 95.00, 'PayPal', 'TXN-20240301-002', 'Voltooid'),
(3, '2024-04-01', 95.00, 'PayPal', 'TXN-20240401-001', 'Voltooid'),
(4, '2024-04-10', 65.00, 'Bankpas', 'TXN-20240410-001', 'Voltooid'),
(5, '2024-05-20', 25.00, 'Creditcard', 'TXN-20240520-001', 'Voltooid');

-- Handige indexes aanmaken
CREATE INDEX idx_huisdieren_klant_id ON huisdieren(klant_id);
CREATE INDEX idx_polissen_huisdier_id ON polissen(huisdier_id);
CREATE INDEX idx_polissen_status ON polissen(status);
CREATE INDEX idx_schades_polis_id ON schades(polis_id);
CREATE INDEX idx_schades_status ON schades(status);
CREATE INDEX idx_betalingsgeschiedenis_polis_id ON betalingsgeschiedenis(polis_id);
CREATE INDEX idx_schade_documenten_schade_id ON schade_documenten(schade_id);

-- View voor actieve polissen met huisdier en klant informatie
CREATE VIEW actieve_polissen_view AS
SELECT
    p.polisnummer,
    p.status,
    p.startdatum,
    p.maandpremie,
    h.naam AS huisdier_naam,
    h.soort,
    h.ras,
    k.voornaam || ' ' || k.achternaam AS klant_naam,
    k.email AS klant_email,
    dt.naam AS dekkingstype
FROM polissen p
JOIN huisdieren h ON p.huisdier_id = h.id
JOIN klanten k ON h.klant_id = k.id
JOIN dekkingstypes dt ON p.dekkingstype_id = dt.id
WHERE p.status = 'Actief';

-- View voor schade overzicht
CREATE VIEW schade_overzicht_view AS
SELECT
    s.schadenummer,
    s.status,
    s.schadedatum,
    s.totale_kosten,
    s.vergoedingsbedrag,
    p.polisnummer,
    h.naam AS huisdier_naam,
    k.voornaam || ' ' || k.achternaam AS klant_naam
FROM schades s
JOIN polissen p ON s.polis_id = p.id
JOIN huisdieren h ON p.huisdier_id = h.id
JOIN klanten k ON h.klant_id = k.id;
