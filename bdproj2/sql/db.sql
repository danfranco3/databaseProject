/*
 * Projeto de Base de Dados
 * Luis G. S. Xavier, Daniel S. Franco, DCC/FCUP
 *
 * BD para gerenciamento de partidas simples baseado no universo de Rainbow Six Siege.
 * Esquema e dados iniciais.
 */
CREATE DATABASE IF NOT EXISTS RAINBOW_SIX;

USE RAINBOW_SIX;

DROP TABLE IF EXISTS OPERATOR, MATCH_R6, MAP, RD, SELECTED, GADGET, ORGANIZATION, WEAPON, ATTACHMENTS;

CREATE TABLE MAP(
    IdMap       INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(32) NOT NULL
);

CREATE TABLE GADGET(
    IdGad       INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(32) NOT NULL
);

CREATE TABLE ORGANIZATION(
    IdOrg       INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(64) NOT NULL
);

CREATE TABLE WEAPON(
    IdWp        INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(64) UNIQUE NOT NULL,
    Mag_Size    INT NOT NULL,
    Type        VARCHAR(32) NOT NULL  
);

CREATE TABLE ATTACHMENTS(
    IdWp        INT NOT NULL,
    Name        VARCHAR(64) NOT NULL,
    FOREIGN KEY(IdWp) REFERENCES WEAPON(IdWp) ON DELETE CASCADE
);

CREATE TABLE OPERATOR(
    IdOper      INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(32) UNIQUE NOT NULL,
    Type        ENUM('A', 'D') NOT NULL,
    Device      VARCHAR(64) UNIQUE NOT NULL,
    IdOrg       INT NOT NULL,
    IdWp        INT NOT NULL,
    IdGad       INT NOT NULL,
    FOREIGN KEY(IdOrg) REFERENCES ORGANIZATION(IdOrg),
    FOREIGN KEY(IdGad) REFERENCES GADGET(IdGad),
    FOREIGN KEY(IdWp)  REFERENCES WEAPON(IdWp)
);

CREATE TABLE MATCH_R6(
    IdMatch     INT PRIMARY KEY AUTO_INCREMENT,
    Start       DATETIME NOT NULL,
    End         DATETIME DEFAULT NULL,
    Status      ENUM('ON GOING', 'FINISHED') NOT NULL,
    MVP         INT NOT NULL,
    MVPPOINTS   INT NOT NULL,
    IdMap       INT NOT NULL,
    FOREIGN KEY(IdMap) REFERENCES MAP(IdMap),
    FOREIGN KEY(MVP) REFERENCES OPERATOR(IdOper)
);

CREATE TABLE RD(
    IdRound     INT PRIMARY KEY AUTO_INCREMENT,
    RoundWinner ENUM('A','D') NOT NULL,
    IdMatch     INT NOT NULL,
    FOREIGN KEY(IdMatch) REFERENCES MATCH_R6(IdMatch) ON DELETE CASCADE
);

CREATE TABLE SELECTED(
    IdOper      INT NOT NULL,
    IdRound     INT NOT NULL,
    K           INT NOT NULL,
    D           INT NOT NULL,
    A           INT NOT NULL,
    PRIMARY KEY(IdOper,IdRound),
    FOREIGN KEY(IdOper) REFERENCES OPERATOR(IdOper) ON DELETE CASCADE,
    FOREIGN KEY(IdRound) REFERENCES RD(IdRound) ON DELETE CASCADE
);

INSERT INTO WEAPON(Name, Type, Mag_Size) VALUES
    ("556xi", "Assault Rifle", 31),
    ("G36C", "Assault Rifle", 31),
    ("L85A2", "Assault Rifle", 31),
    ("AUG A2", "Assault Rifle", 31),
    ("P12", "Handgun", 16),
    ("P9", "Handgun", 17),
    ("MP5", "Submachine Gun", 31),
    ("MPX", "Submachine Gun", 31),
    ("SPAS-15", "Shotgun", 7),
    ("AR33", "Assault Rifle", 26),
    ("Type-89", "Assault Rifle", 21),
    ("C7E", "Assault Rifle", 26),
    ("9×19VSN", "Submachine Gun", 31),
    ("Commando 9", "Assault Rifle", 26),
    ("ALDA 5.56", "Light Machine Gun", 81);

INSERT INTO ATTACHMENTS(IdWp, Name) VALUES
    (1, "Supressor"),
    (1, "Red Dot Sight"),
    (2, "Supressor"),
    (2, "Red Dot Sight"),
    (3, "Supressor"),
    (3, "Red Dot Sight"),
    (4, "Supressor"),
    (4, "Red Dot Sight"),
    (5, "Supressor"),
    (5, "Red Dot Sight"),
    (6, "Supressor"),
    (6, "Red Dot Sight"),
    (7, "Supressor"),
    (7, "Red Dot Sight"),
    (8, "Supressor"),
    (8, "Red Dot Sight"),
    (9, "Supressor"),
    (9, "Red Dot Sight"),
    (10, "Supressor"),
    (10, "Red Dot Sight"),
    (11, "Supressor"),
    (11, "Red Dot Sight"),
    (12, "Supressor"),
    (12, "Red Dot Sight"),
    (13, "Supressor"),
    (13, "Red Dot Sight"),
    (14, "Supressor"),
    (14, "Red Dot Sight"),
    (15, "Supressor"),
    (15, "Red Dot Sight");



INSERT INTO GADGET(Name) VALUES
    ("Smoke Grenade"),
    ("Stun Grenade"),
    ("Frag Grenade"),
    ("Claymore"),
    ("Breach Charge"),
    ("Impact Grenade"),
    ("Proximity Alarm"),
    ("Nitro Cell"),
    ("Barbed Wire");

INSERT INTO ORGANIZATION(Name) VALUES
    ("FBI SWAT"),
    ("SAS"),
    ("FBI"),
    ("GIGN"),
    ("NIGHTHAVEN"),
    ("Inkaba Task Force"),
    ("GSG 9"),
    ("Navy SEALs"),
    ("BOPE"),
    ("SAT"),
    ("GEO"),
    ("Spetsnaz"),
    ("SASR"),
    ("GIS"),
    ("CBRN Threat Unit");   

INSERT INTO OPERATOR(Name, Type, Device, IdOrg, IdWp, IdGad) VALUES
    ("Thermite", 'A', "Exothermic Charges", 1, 1, 2),
    ("IQ", 'A', "Electronics Detector", 7, 4, 4),
    ("Montagne", 'A', "Extendable Shield", 4, 6, 1),
    ("Flores", 'A', "RCE-Ratero Charge", 3, 10, 2),
    ("Sledge", 'A', "Tactical Breaching Hammer", 2, 3, 3),
    ("Hibana", 'A', "X-KAIROS", 10, 11, 2),
    ("Jackal", 'A', "Eyenox Model III", 11, 12, 1),
    ("Wamai", 'D', "Mag-NET", 5, 4, 7),
    ("Melusi", 'D', "Banshee Sonic Defense", 6, 7, 6),
    ("Valkyrie", 'D', "Black Eye", 8, 8, 8),
    ("Caveira", 'D', "Silent Step", 9, 9, 6),
    ("Kapkan", 'D', "Entry Denial Device", 12, 13, 8),
    ("Mozzie", 'D', "Pest Launcher", 13, 14, 8),
    ("Maestro", 'D', "Evil Eye", 14, 15, 9);

INSERT INTO MAP(Name) VALUES
    ("Villa"),
    ("Clubhouse"),
    ("Border"),
    ("Bank"),
    ("Favela");

INSERT INTO MATCH_R6(IdMap, Start, End, Status, MVP, MVPPoints) VALUES
    (2, '2020-11-17 20:30:45', '2020-11-17 20:47:02', 'FINISHED', 1, 5200),
    (4, '2020-11-19 15:35:52', '2020-11-19 16:00:14', 'FINISHED', 8, 4870),
    (3, '2020-11-25 02:32:15', NULL, 'ON GOING', 13, 6350);

INSERT INTO RD(RoundWinner, IdMatch) VALUES
    ('A', 1),
    ('A', 1),
    ('A', 1),
    ('D', 2),
    ('D', 2),
    ('D', 2),
    ('D', 3),
    ('D', 3),
    ('A', 3),
    ('A', 3),
    ('D', 3);

INSERT INTO SELECTED(IdOper, IdRound, K, D, A) VALUES
    (1, 1, 3, 1, 1),
    (2, 1, 0, 1, 2),
    (4, 1, 1, 0, 1),
    (5, 1, 1, 0, 2),
    (3, 1, 0, 0, 1),
    (8, 1, 1, 1, 1),
    (11, 1, 1, 1, 1),
    (13, 1, 0, 1, 0),
    (12, 1, 0, 1, 0),
    (10, 1, 0, 1, 0),
    (1, 2, 3, 1, 1),
    (2, 2, 0, 1, 2),
    (4, 2, 1, 0, 1),
    (5, 2, 1, 0, 2),
    (3, 2, 0, 0, 1),
    (8, 2, 1, 1, 1),
    (11, 2, 1, 1, 1),
    (13, 2, 0, 1, 0),
    (12, 2, 0, 1, 0),
    (10, 2, 0, 1, 0),
    (1, 3, 3, 1, 1),
    (2, 3, 0, 1, 2),
    (4, 3, 1, 0, 1),
    (5, 3, 1, 0, 2),
    (3, 3, 0, 0, 1),
    (8, 3, 1, 1, 1),
    (11, 3, 1, 1, 1),
    (13, 3, 0, 1, 0),
    (12, 3, 0, 1, 0),
    (10, 3, 0, 1, 0),
    (8, 4, 3, 1, 1),
    (9, 4, 0, 1, 2),
    (13, 4, 1, 0, 1),
    (12, 4, 1, 0, 2),
    (10, 4, 0, 0, 1),
    (1, 4, 1, 1, 1),
    (2, 4, 1, 1, 1),
    (4, 4, 0, 1, 0),
    (5, 4, 0, 1, 0),
    (3, 4, 0, 1, 0),
    (8, 5, 3, 1, 1),
    (9, 5, 0, 1, 2),
    (13, 5, 1, 0, 1),
    (12, 5, 1, 0, 2),
    (10, 5, 0, 0, 1),
    (1, 5, 1, 1, 1),
    (2, 5, 1, 1, 1),
    (4, 5, 0, 1, 0),
    (5, 5, 0, 1, 0),
    (3, 5, 0, 1, 0),
    (8, 6, 3, 1, 1),
    (9, 6, 0, 1, 2),
    (13, 6, 1, 0, 1),
    (12, 6, 1, 0, 2),
    (10, 6, 0, 0, 1),
    (1, 6, 1, 1, 1),
    (2, 6, 1, 1, 1),
    (4, 6, 0, 1, 0),
    (5, 6, 0, 1, 0),
    (3, 6, 0, 1, 0),
    (8, 7, 3, 1, 1),
    (9, 7, 0, 1, 2),
    (13, 7, 1, 0, 1),
    (12, 7, 1, 0, 2),
    (10, 7, 0, 0, 1),
    (1, 7, 1, 1, 1),
    (2, 7, 1, 1, 1),
    (4, 7, 0, 1, 0),
    (5, 7, 0, 1, 0),
    (3, 7, 0, 1, 0),
    (8, 8, 3, 1, 1),
    (9, 8, 0, 1, 2),
    (13, 8, 1, 0, 1),
    (12, 8, 1, 0, 2),
    (10, 8, 0, 0, 1),
    (1, 8, 1, 1, 1),
    (2, 8, 1, 1, 1),
    (4, 8, 0, 1, 0),
    (5, 8, 0, 1, 0),
    (3, 8, 0, 1, 0),
    (1, 9, 3, 1, 1),
    (2, 9, 0, 1, 2),
    (4, 9, 1, 0, 1),
    (5, 9, 1, 0, 2),
    (3, 9, 0, 0, 1),
    (8, 9, 1, 1, 1),
    (11, 9, 1, 1, 1),
    (13, 9, 0, 1, 0),
    (12, 9, 0, 1, 0),
    (10, 9, 0, 1, 0),
    (1, 10, 3, 1, 1),
    (2, 10, 0, 1, 2),
    (4, 10, 1, 0, 1),
    (5, 10, 1, 0, 2),
    (3, 10, 0, 0, 1),
    (8, 10, 1, 1, 1),
    (11, 10, 1, 1, 1),
    (13, 10, 0, 1, 0),
    (12, 10, 0, 1, 0),
    (10, 10, 0, 1, 0),
    (8, 11, 3, 1, 1),
    (9, 11, 0, 1, 2),
    (13, 11, 1, 0, 1),
    (12, 11, 1, 0, 2),
    (10, 11, 0, 0, 1),
    (1, 11, 1, 1, 1),
    (2, 11, 1, 1, 1),
    (4, 11, 0, 1, 0),
    (5, 11, 0, 1, 0),
    (3, 11, 0, 1, 0);   

