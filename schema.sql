

-- --------------- ETL-Tables (Temporary Tables) ----------------------
CREATE TABLE arcs_etl(
   id INT PRIMARY KEY AUTO_INCREMENT
  ,Arc  VARCHAR(23) NOT NULL
  ,Starting_Chapter INT  NOT NULL
  ,Total_Chapters INT  NOT NULL
  ,Total_Pages    INT  NOT NULL
);

CREATE TABLE birth_year_etl(
   Birth_Year  INT  NOT NULL
  ,Character_Name VARCHAR(22) NOT NULL
);

CREATE TABLE bounties_etl(
   Character_Name  VARCHAR(42) NOT NULL
  ,Bounty  BIGINT  NOT NULL
  ,Previous_Bounty BIGINT 
);

CREATE TABLE cross_guild_bounties_etl(
   Character_Name VARCHAR(14) NOT NULL
  ,Occupation VARCHAR(15) NOT NULL
  ,Cross_Guild_Bounty BIGINT  NOT NULL
);

CREATE TABLE chapters_etl(
   Chapter_Number INTEGER  NOT NULL
  ,Title  VARCHAR(91) NOT NULL
  ,Release_Date   DATE  NOT NULL
  ,Pages  VARCHAR(10) NOT NULL
);

CREATE TABLE characters_etl (
   id          INTEGER  NOT NULL PRIMARY KEY 
  ,P         VARCHAR(29)
  ,name VARCHAR(30) NOT NULL
  ,Revealed  VARCHAR(30) NOT NULL
  ,Year      INTEGER  NOT NULL
);

CREATE TABLE devil_fruit_Types_etl(
   id INT PRIMARY KEY AUTO_INCREMENT,
   Type VARCHAR(26) NOT NULL
);

CREATE TABLE devil_fruits_etl(
   Character_Name     VARCHAR(22) NOT NULL
  ,Devil_Fruit VARCHAR(50) NOT NULL
  ,Class VARCHAR(26) NOT NULL
  ,Status         VARCHAR(5) NOT NULL
  ,Awakened        VARCHAR(3) NOT NULL
);

CREATE TABLE factions_etl(
   Character_name   VARCHAR(29) NOT NULL PRIMARY KEY
  ,Faction     VARCHAR(18)
  ,Affiliation VARCHAR(36)
  ,Occupation  VARCHAR(58)
);

CREATE TABLE genders_etl(
   Character_name VARCHAR(29) NOT NULL PRIMARY KEY
  ,Gender    VARCHAR(12) NOT NULL
);

CREATE TABLE haki_etl(
   Character_Name                 VARCHAR(22) NOT NULL
  ,Busoshoku_Haki_Armament      VARCHAR(1)
  ,Kenbunshoku_Haki_Observation VARCHAR(1)
  ,Haoshoku_Haki_Conquerors     VARCHAR(1)
);

CREATE TABLE hometowns_etl(
   Character_Name VARCHAR(25) NOT NULL
  ,Region  VARCHAR(10)
  ,Island  VARCHAR(21)
  ,Town  VARCHAR(31)
);

CREATE TABLE race_etl(
   Character_Name VARCHAR(28) NOT NULL
  ,Race VARCHAR(30) NOT NULL
);

CREATE TABLE weapons_etl(
   Character_Name VARCHAR(25) NOT NULL 
  ,Weapon_Type    VARCHAR(10) NOT NULL
  ,Main_Weapon    VARCHAR(17) NOT NULL
);

CREATE TABLE zodiacs_etl(
   Astrological_Sign VARCHAR(11) NOT NULL
  ,Character_Name    VARCHAR(24) NOT NULL
);



-- ---------------------------- CREATING MAIN TABLES ---------------------------------

-- Creating Main Bounties Table
DROP TABLE IF EXISTS bounties;
CREATE TABLE Bounties AS 
	SELECT *
    FROM bounties_etl
    UNION ALL
    SELECT Character_Name,
		   Bounty,
           Previous_Bounty,
           Bounty_Type
    FROM cross_guild_bounties_etl;
    
    
-- Creating Main Affiliations Table (DISTINCT CREWS)
CREATE TABLE Affiliations AS
	SELECT DISTINCT(Affiliation)
    FROM factions_etl;
    
    
-- Creating Main Factions Table (DISTINCT Factions)
CREATE TABLE Factions AS
	SELECT DISTINCT(Faction)
    FROM factions_etl;
    

-- Creating Main Occupations Table (DISTINCT Occupations)
CREATE TABLE Occupations AS
	SELECT DISTINCT(Occupation)
    FROM factions_etl;


-- Creating Main Races Table (DISTINCT Races)
CREATE TABLE Races AS
	SELECT DISTINCT(Race)
    FROM races_etl;
    
 
-- Creating Main Zodiacs Table (DISTINCT Astrological_signs) 
CREATE TABLE Zodiacs AS
	SELECT DISTINCT(Astrological_sign)
    FROM zodiacs_etl;
    
    
-- Creating Main Weapons Table (DISTINCT Main_Weapon) 
CREATE TABLE Weapons AS
	SELECT DISTINCT(Main_Weapon)
    FROM weapons_etl;
    
    
-- Creating Main Weapon_Type Table (DISTINCT Weapon_Types) 
CREATE TABLE Weapon_Type AS
	SELECT DISTINCT(Weapon_Type)
    FROM weapons_etl;
    

-- Creating Main Races Table (DISTINCT Regions)
CREATE TABLE Regions AS
	SELECT DISTINCT(Region)
    FROM hometowns_etl;
    
    
-- Creating Main Islands Table (DISTINCT Islands)
CREATE TABLE Islands AS
	SELECT DISTINCT(Island)
    FROM hometowns_etl;
    
    
-- Creating Main Towns Table (DISTINCT Towns)
CREATE TABLE Towns AS
	SELECT DISTINCT(Town)
    FROM hometowns_etl;
    
-- Creating Main Haki Table    
CREATE TABLE Haki AS
	SELECT id,
		   Busoshoku_Haki_Armament,
           Kenbunshoku_Haki_Observation,
           Haoshoku_Haki_Conquerors
    FROM haki_etl;
    
    
-- Creating Main Devil_Fruits Table    
    CREATE TABLE Devil_Fruits AS 
		SELECT id,
			   Devil_Fruit,
			   Type_id,
               Status,
               Awakened
        FROM devil_fruits_etl;
        
-- Creating Main Devil_Fruit_Types Table              
CREATE TABLE Devil_Fruit_Types AS 
	SELECT id, Type
    FROM devil_fruit_types_etl;
    

-- Creating Characters_Info Table
-- Use MAX() to only return 1 UNIQUE value for each id EXEPT for Marshall D. Teach (id 144)
	-- Make use of the ETL-tables to have an easy connection throug Character_id
    
DROP TABLE IF EXISTS Characters_Info;
CREATE TABLE Characters_Info AS
(
    -- For all characters except Marshall D. Teach (id 144)
    SELECT c.id,
           c.Name,
           MAX(b.Birth_Year) AS Birth_Year,
           MAX(g.Gender) AS Gender,
           MAX(bo.Bounty) AS Bounty,
           MAX(bo.Previous_Bounty) AS Previous_Bounty,
           MAX(bo.Bounty_Type) AS Bounty_Type,
           MAX(c.Chapter_Revealed) AS Chapter_Revealed,
           MAX(c.Year_Revealed) AS Year_Revealed,
           MAX(c.Chapter_id) AS Chapter_id,
           MAX(r.Race_id) AS Race_id,
           MAX(d.id) AS Devil_Fruit_id,  -- Normal aggregation for Devil Fruit
           MAX(d.Type_id) AS Type_id,
           MAX(h.id) AS Haki_id,
           MAX(f.Faction_id) AS Faction_id,
           MAX(f.Affiliation_id) AS Affiliation_id,
           MAX(f.Occupation_id) AS Occupation_id,
           MAX(w.Main_Weapon_id) AS Main_Weapon_id,
           MAX(w.Weapon_Type_id) AS Weapon_Type_id,
           MAX(ho.Region_id) AS Region_id,
           MAX(ho.Island_id) AS Island_id,
           MAX(ho.Town_id) AS Town_id,
           MAX(z.Zodiac_id) AS Zodiac_id
    FROM characters_etl c
    LEFT JOIN birth_year_etl b ON c.id = b.Character_id
    LEFT JOIN genders_etl g ON c.Name = g.Character_name
    LEFT JOIN races_etl r ON c.id = r.Character_id
    LEFT JOIN devil_fruits_etl d ON c.id = d.Character_id
    LEFT JOIN haki_etl h ON c.id = h.Character_id
    LEFT JOIN factions_etl f ON c.id = f.Character_id
    LEFT JOIN bounties bo ON c.id = bo.Character_id
    LEFT JOIN weapons_etl w ON c.id = w.Character_id
    LEFT JOIN hometowns_etl ho ON c.id = ho.Character_id
    LEFT JOIN zodiacs_etl z ON c.id = z.Character_id
    WHERE c.id != 144
    GROUP BY c.id
    
    UNION ALL

    -- For Marshall D. Teach (id 144), get separate rows for each Devil Fruit ID
    SELECT c.id,
           c.Name,
           MAX(b.Birth_Year) AS Birth_Year,
           MAX(g.Gender) AS Gender,
           MAX(bo.Bounty) AS Bounty,
           MAX(bo.Previous_Bounty) AS Previous_Bounty,
           MAX(bo.Bounty_Type) AS Bounty_Type,
           MAX(c.Chapter_Revealed) AS Chapter_Revealed,
           MAX(c.Year_Revealed) AS Year_Revealed,
           MAX(c.Chapter_id) AS Chapter_id,
           MAX(r.Race_id) AS Race_id,
           d.id AS Devil_Fruit_id,  -- Get each Devil Fruit ID separately for id 144
           MAX(d.Type_id) AS Type_id,
           MAX(h.id) AS Haki_id,
           MAX(f.Faction_id) AS Faction_id,
           MAX(f.Affiliation_id) AS Affiliation_id,
           MAX(f.Occupation_id) AS Occupation_id,
           MAX(w.Main_Weapon_id) AS Main_Weapon_id,
           MAX(w.Weapon_Type_id) AS Weapon_Type_id,
           MAX(ho.Region_id) AS Region_id,
           MAX(ho.Island_id) AS Island_id,
           MAX(ho.Town_id) AS Town_id,
           MAX(z.Zodiac_id) AS Zodiac_id
    FROM characters_etl c
    LEFT JOIN birth_year_etl b ON c.id = b.Character_id
    LEFT JOIN genders_etl g ON c.Name = g.Character_name
    LEFT JOIN races_etl r ON c.id = r.Character_id
    LEFT JOIN devil_fruits_etl d ON c.id = d.Character_id
    LEFT JOIN haki_etl h ON c.id = h.Character_id
    LEFT JOIN factions_etl f ON c.id = f.Character_id
    LEFT JOIN bounties bo ON c.id = bo.Character_id
    LEFT JOIN weapons_etl w ON c.id = w.Character_id
    LEFT JOIN hometowns_etl ho ON c.id = ho.Character_id
    LEFT JOIN zodiacs_etl z ON c.id = z.Character_id
    WHERE c.id = 144
    GROUP BY c.id, d.id
);


-- ----------------------- CREATING VIEWS OF ALL INFORMATION ON CHARACTERS ----------------------------

-- Create VIEW Characters + Bounties
DROP VIEW IF EXISTS Character_Bounties;
CREATE VIEW Character_Bounties AS
	SELECT Name,
		   Bounty,
           Previous_Bounty,
           Bounty_Type
	FROM characters_info;
    

-- Create VIEW Characters + Devil_Fruits + Devil_Fruit_Types
DROP VIEW IF EXISTS Character_DevilFruits;
CREATE VIEW Character_DevilFruits AS
	SELECT c.Name,
		   df.Devil_Fruit,
           dft.Type,
           df.Status,
           df.Awakened
    FROM characters_info c
    INNER JOIN devil_fruits df
    ON c.Devil_Fruit_id = df.id
    LEFT JOIN devil_fruit_types dft
    ON df.Type_id = dft.id
    ORDER BY c.Name;

-- Create VIEW Characters + Factions + Occupations
DROP VIEW IF EXISTS Character_Faction_Affiliation_Occupation;
CREATE VIEW Character_Faction_Affiliation_Occupation AS
	SELECT c.Name,
		   f.Faction,
           a.Affiliation,
           o.Occupation
    FROM characters_info c
    RIGHT JOIN factions f
    ON c.Faction_id = f.id
    LEFT JOIN affiliations a
    ON c.Affiliation_id = a.id
    LEFT JOIN occupations o
    ON c.Occupation_id = o.id
    ORDER BY f.Faction, a.Affiliation, c.Name;

-- Create VIEW Characters + Haki
DROP VIEW IF EXISTS Character_Haki;
CREATE VIEW Character_Haki AS
	SELECT c.Name,
		   h.*
    FROM characters_info c
    RIGHT JOIN haki h
    ON c.Haki_id = h.id
    ORDER BY c.Name;

-- Create VIEW Characters + Towns + Islands + Regions
DROP VIEW IF EXISTS Character_Origin;
CREATE VIEW Character_Origin AS
	SELECT c.Name,
		   r.Region,
           i.Island,
           t.Town
    FROM characters_info c
    INNER JOIN towns t
    ON c.Town_id = t.id
    LEFT JOIN islands i
    ON t.Island_id = i.id
    LEFT JOIN regions r
    ON i.Region_id = r.id 
    ORDER BY Region, Island, Town, c.Name;

-- Create VIEW Characters + Races
DROP VIEW IF EXISTS Character_Race;
CREATE VIEW Character_Race AS
	SELECT c.Name,
		   r.Race
    FROM characters_info c
    INNER JOIN races r
    ON c.Race_id = r.id;

-- Create VIEW Characters + Weapons + Weapon_Types
DROP VIEW IF EXISTS Character_Weapon;
CREATE VIEW Character_Weapon AS 
	SELECT c.Name,
		   wt.Weapon_Type,
           w.Main_Weapon
    FROM characters_info c
    INNER JOIN weapons w
    ON c.Main_Weapon_id = w.id
    LEFT JOIN weapon_type wt
    ON w.Weapon_Type_id = wt.id
    ORDER BY wt.Weapon_Type, w.Main_Weapon, c.Name;
    

-- Create VIEW Characters + Zodiacs
DROP VIEW IF EXISTS Character_Zodiac;
CREATE VIEW Character_Zodiac AS
	SELECT c.Name,
		   z.Zodiac
    FROM characters_info c
    RIGHT JOIN zodiacs z
    ON c.Zodiac_id = z.id
    ORDER BY z.Zodiac;


-- ------------------------- CREATING INDEXES -----------------------------------
CREATE INDEX idx_Name ON characters_info(Name);
CREATE INDEX idx_Birth_Year ON characters_info(Birth_Year);
CREATE INDEX idx_Gender ON characters_info(Gender);
CREATE INDEX idx_Bounty ON characters_info(Bounty);
CREATE INDEX idx_Previous_Bounty ON characters_info(Previous_Bounty);
CREATE INDEX idx_Bounty_Type ON characters_info(Bounty_Type);
CREATE INDEX idx_Chapter_Revealed ON characters_info(Chapter_Revealed);
CREATE INDEX idx_Year_Revealed ON characters_info(Year_Revealed);

