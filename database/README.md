# Database Setup

This project uses SQL Server LocalDB with the database files in:

`src/HackEdCTF.Web/HackEdCTF.Web/HackEdCTF.Web/App_Data/`

The application connection string in `Web.config` uses:

`AttachDbFilename=|DataDirectory|\HackEdDB.mdf`

That keeps the path relative to the Web Forms application instead of hardcoding one teammate's Windows user folder.

## Fix Cannot Open Database Requested By Login

On a fresh clone, SQL Server LocalDB can fail to open a committed `.mdf` if the file is already attached under a stale path, the previous LocalDB instance cached the database name, or Visual Studio/IIS Express still has the file locked.

Use this reset flow. It does not delete the physical database file.

1. Close the website and stop IIS Express.
2. Open PowerShell or Developer Command Prompt.
3. Stop LocalDB:

```powershell
sqllocaldb stop MSSQLLocalDB
```

4. Start Visual Studio again.
5. Open SQL Server Object Explorer.
6. Expand `(localdb)\MSSQLLocalDB`.
7. If an old `HackEdDB` database is listed and points to another clone path, detach/remove that database registration only. Do not delete the `.mdf` file from the repo.
8. Attach the current database file:

`src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\App_Data\HackEdDB.mdf`

9. Run the website again.

To check whether LocalDB is attached to an old clone path, run this against `(localdb)\MSSQLLocalDB`:

```sql
SELECT DB_NAME(database_id) AS DatabaseName, name AS LogicalName, physical_name
FROM sys.master_files
WHERE physical_name LIKE '%HackEdDB%';
```

If `HackEdDB` points to a stale folder, detach the LocalDB registration without deleting the physical file:

```sql
USE master;
ALTER DATABASE [HackEdDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
EXEC sp_detach_db N'HackEdDB';
```

Then attach the `HackEdDB.mdf` from the current clone's `App_Data` folder.

## Schema Repair

If the database opens but CTF tables or columns are missing, run:

1. `database/repair/repair_challenge_schema.sql`
2. `database/schema/challenges_schema.sql`
3. `database/schema/team_scoreboard_schema.sql`
4. `database/seed-data/challenges_seed.sql`

The repair and schema scripts are idempotent. They add missing CTF challenge, team, and scoreboard tables/columns without dropping existing data.

## Verify Tables

Run these checks in SQL Server Object Explorer or SSMS:

```sql
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT ChallengeID, Title, Category, Difficulty, Points, FileUrl, IsActive
FROM dbo.Challenges
ORDER BY ChallengeID;
```

## Notes

`.mdf` and `.ldf` files are binary SQL Server files and are fragile in Git. They can carry machine-specific attachment history and can be locked by Visual Studio, IIS Express, or LocalDB. Prefer SQL scripts for schema changes, and only commit database binaries when the group intentionally wants shared sample data.
