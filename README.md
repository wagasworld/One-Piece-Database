# One-Piece-Database
Personal Project | Worlds' First One Piece Database

---

## Scope

My goal was to create the worlds' first One Piece database and this is it!
The One Piece Database is envisioned as the first comprehensive repository dedicated exclusively to the One Piece universe. The primary aim is to gather all available public data related to the series into a single, well-structured, and relational database. This project addresses the need for a centralized resource that allows fans, researchers, and enthusiasts to explore character profiles, narrative arcs, and intricate world details with ease.

The database's scope includes:

- **Characters Information:**
  Detailed profiles of characters including personal data (name, birth year, gender), narrative details (bounty, chapter/year revealed), and links to other aspects of the lore (race, affiliations, occupations, zodiac signs).

- **Narrative Structure:**
  Comprehensive coverage of the storyline through:
  - **Arcs:** Information on each story arc, including starting chapters, total chapters, and total pages.
  - **Chapters:** Detailed chapter data (chapter number, title, release date, pages) that anchors the narrative timeline.

- **Unique World Elements:**
  Entities that capture the essence of One Piece’s unique lore:
  - **Devil Fruits:** Data about Devil Fruits, including their types, status, and awakening details.
  - **Haki:** Binary indicators for the three types of haki abilities (Busoshoku, Kenbunshoku, Haoshoku).
  - **Weapons:** Information on characters’ primary weapons and their categorization by weapon type.

- **Geographical Hierarchy:**
  A multi-tiered mapping of locations that lets us track the origin of the characters:
  - **Towns, Islands, and Regions:** These tables establish a clear geographical context by linking towns to islands and islands to regions.

- **Reference Data:**
  Standardized lookup tables that ensure consistency across the database, including:
  - **Affiliations**
  - **Factions**
  - **Occupations**
  - **Races:** This data gives us a better view of the racial distinctions of the characters, as the anime alone sometimes makes it difficult to group characters into distinct races.
  - **Zodiacs**

*Out of scope* are non-canonical data, merchandise details, and any real-time or dynamic updates from ongoing episodes.

---

## Functional Requirements

This database is designed to support the following core functionalities:

- **CRUD Operations:**
  Full Create, Read, Update, and Delete operations for all primary entities (characters, arcs, chapters, and lookup tables).

- **Complex Querying:**
  Support for advanced SQL queries to analyze:
  - Character relationships and evolution over time.
  - Plot progression through arcs and chapters.
  - Distribution and categorization of unique elements (Devil Fruits, haki, weapons).

- **ETL Integration:**
  An established process for importing, cleaning, and transforming heterogeneous data from various online sources:
  - Temporary ETL tables are used to stage and normalize raw, unstructured data.
  - Data is then mapped into the main, fully normalized schema ensuring high-quality and consistent data.

- **Relationship Integrity:**
  Rigorous enforcement of referential integrity through foreign key constraints across all related tables to maintain data consistency.

- **Extensibility Constraints:**
  Due to the reliance on publicly available data, future extensions to the dataset are limited by the volume and quality of the public data available. If no additional data is released, extending or enriching the dataset further may not be feasible.

---

## Representation

Entities are represented as SQL tables with detailed schema definitions as outlined below.

### Entities

#### 1. Characters_Info

**Purpose:**
Stores detailed information about each character in the One Piece universe.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
  Unique identifier for each character.
- **`Name`** – VARCHAR(30)
  The character's name.
- **`Birth_Year`** – INT
  The character's year of birth.
- **`Gender`** – VARCHAR(12)
  Gender of the character.
- **`Bounty`** – BIGINT
  The current bounty value.
- **`Previous_Bounty`** – VARCHAR(30)
  Historical bounty details.
- **`Bounty_Type`** – VARCHAR(30)
  The type or category of bounty.
- **`Chapter_Revealed`** – VARCHAR(30)
  The chapter in which the character was first introduced.
- **`Year_Revealed`** – INT
  The year the character was revealed.
- **Foreign Keys:**
  - `Chapter_id` → References `chapters(Chapter_Number)`
  - `Race_id` → References `races(id)`
  - `Devil_Fruit_id` → References `devil_fruits(id)`
  - `Haki_id` → References `haki(id)`
  - `Faction_id` → References `factions(id)`
  - `Affiliation_id` → References `affiliations(id)`
  - `Occupation_id` → References `occupations(id)`
  - `Main_Weapon_id` → References `weapons(id)`
  - `Town_id` → References `towns(id)`
  - `Zodiac_id` → References `zodiacs(id)`

#### 2. Affiliations

**Purpose:**
Stores standardized affiliation names for characters.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Affiliation`** – VARCHAR(36)

#### 3. Arcs

**Purpose:**
Captures details about each story arc.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Arc`** – VARCHAR(23)
  Name of the arc.
- **`Starting_Chapter`** – INT
  The chapter number where the arc begins.
- **`Total_Chapters`** – INT
  The total number of chapters in the arc.
- **`Total_Pages`** – INT
  The total number of pages within the arc.
- **`Starting_Chapter_id`** – INT
  Foreign key linking to the starting chapter in `chapters`.

#### 4. Chapters

**Purpose:**
Holds detailed information about each chapter.

**Schema:**

- **`Chapter_Number`** – INT, PRIMARY KEY
- **`Title`** – VARCHAR(91)
- **`Release_Date`** – DATE
- **`Pages`** – VARCHAR(10)

#### 5. Devil Fruits

**Purpose:**
Stores data on Devil Fruits, which grant unique abilities to characters.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY
- **`Devil_Fruit`** – VARCHAR(50)
- **`Type_id`** – INT
  Foreign key linking to `devil_fruit_types(id)` with `ON UPDATE RESTRICT` and `ON DELETE RESTRICT`
- **`Status`** – VARCHAR(5)
- **`Awakened`** – VARCHAR(3)

*Note:*
An interesting edge case in the One Piece universe is that Marshall D. Teach is the only character known to possess two Devil Fruits. This unique anomaly initially resulted in duplicate primary key issues, and a specialized solution was implemented to handle this exception while preserving data integrity.

#### 6. Devil Fruit Types

**Purpose:**
Categorizes Devil Fruits (e.g., Paramecia, Zoan, Logia).

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY
- **`Type`** – VARCHAR(26)

#### 7. Factions

**Purpose:**
Stores faction names to which characters may belong.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Faction`** – VARCHAR(18)

#### 8. Haki

**Purpose:**
Captures the haki abilities of characters.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY
- **`Busoshoku_Haki_Armament`** – VARCHAR(1)
- **`Kenbunshoku_Haki_Observation`** – VARCHAR(1)
- **`Haoshoku_Haki_Conquerors`** – VARCHAR(1)

#### 9. Occupations

**Purpose:**
Stores job titles or roles held by characters.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Occupation`** – VARCHAR(58)

#### 10. Races

**Purpose:**
Defines the various races/species in the One Piece universe. This data gives us a better view of the racial distinctions among characters, as the anime alone sometimes makes it difficult to group characters effectively.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Race`** – VARCHAR(30)

#### 11. Towns

**Purpose:**
Stores information about towns and, together with islands and regions, lets us track the origin of the characters.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Town`** – VARCHAR(31)
- **`Island_id`** – INT
  Foreign key linking to `islands(id)`

#### 12. Islands

**Purpose:**
Stores island data, each linked to a broader region. This geographical information is key for tracking character origins and understanding the world’s layout.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Island`** – VARCHAR(21)
- **`Region_id`** – INT
  Foreign key linking to `regions(id)`

#### 13. Regions

**Purpose:**
Captures regional information, grouping multiple islands together. This layered geographical model enables a deeper understanding of character origins.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Region`** – VARCHAR(10)

#### 14. Weapon_Type

**Purpose:**
Stores various categories of weapons.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Weapon_Type`** – VARCHAR(10)

#### 15. Weapons

**Purpose:**
Stores data on characters' main weapons.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Main_Weapon`** – VARCHAR(17)
- **`Weapon_Type_id`** – INT
  Foreign key linking to `weapon_type(id)`

#### 16. Zodiacs

**Purpose:**
Captures the zodiac signs associated with characters.

**Schema:**

- **`id`** – INTEGER, PRIMARY KEY, AUTO-INCREMENT
- **`Zodiac`** – VARCHAR(11)

---

### Relationships

The following relationships are established to ensure data integrity and to facilitate rich querying capabilities:

- **Character Associations:**
  Each character in `characters_info` is associated with one record from each lookup table (affiliations, factions, occupations, races, zodiacs) and optionally linked to a town. These associations are enforced via foreign key constraints.

- **Narrative Structure:**
  - **Arcs and Chapters:**
    Each arc (in `arcs`) is anchored by its starting chapter (`Starting_Chapter_id`), which references a unique chapter in the `chapters` table.
  - **Chapters:**
    Serve as the timeline markers for the progression of the One Piece storyline.

- **Special Abilities and Elements:**
  - **Devil Fruits:**
    Each Devil Fruit references a type in `devil_fruit_types`, ensuring consistent categorization.
    *Special Case:* Marshall D. Teach's dual Devil Fruits required a custom solution to handle duplicate primary key issues.
  - **Haki:**
    Characters reference the `haki` table to indicate possession of each haki type.

- **Geographical Hierarchy:**
  - **Towns, Islands, Regions:**
    Towns are linked to islands, and islands are linked to regions. This layered model not only provides context for the One Piece world but also lets us track the origins of the characters.

- **Weapon Classification:**
  Weapons are linked to their type via the `Weapon_Type_id` in the `weapons` table.

---

## Optimizations

To enhance performance and ensure efficient querying:

- **Indexing:**
  Given that `characters_info` is the largest table and is central to nearly all views and queries, I indexed its main columns (e.g., `Name`, `Birth_Year`, and other frequently queried attributes). In all views, this table is used, so indexing greatly reduces processing time when someone runs a view.

- **Foreign Key Constraints:**
  The use of foreign keys throughout the schema enforces referential integrity and helps optimize join operations between related tables.

---

## Limitations

- **Data Quality and Public Availability:**
  The database is built entirely from publicly available data sourced from various online resources. As such:
  - The extent of the dataset is limited by the volume and quality of public data.
  - Further extension or enrichment of the dataset is contingent upon the release of additional public data.

- **Static Dataset:**
  The current design captures a static snapshot of the One Piece universe. Real-time updates or integration with dynamic data sources (e.g., live episode releases) are out of scope.

- **ETL Complexity:**
  The process of normalizing messy and unstructured data presented significant challenges. Although temporary ETL tables were used to clean and integrate the data, there remains the possibility of edge cases or inconsistencies that could require further manual review.

- **Unique Data Anomalies:**
  The One Piece universe includes unique cases such as Marshall D. Teach possessing two Devil Fruits, which required special handling to avoid duplicate primary key errors. This anomaly underscores the challenges of modeling complex fictional worlds in a relational schema.

