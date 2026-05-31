# Fresh Clone LocalDB Fix

Use this checklist when a fresh clone fails with:

`Cannot open database ... App_Data\HackEdDB.mdf requested by the login. The login failed.`

1. Pull latest `main`.
2. Close the website and stop IIS Express.
3. Stop LocalDB:

```powershell
sqllocaldb stop MSSQLLocalDB
```

4. Confirm both files exist:

`src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\App_Data\HackEdDB.mdf`

`src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\App_Data\HackEdDB_log.ldf`

5. Open the solution in Visual Studio.
6. Open SQL Server Object Explorer.
7. Under `(localdb)\MSSQLLocalDB`, remove any stale `HackEdDB` attachment that points to a different folder. Do not delete the physical `.mdf`.
8. Attach the `HackEdDB.mdf` from this clone's `App_Data` folder.
9. Run the website.
10. If the website opens but challenge data/schema is missing, run these scripts against `HackEdDB.mdf`:

```text
database/repair/repair_challenge_schema.sql
database/schema/challenges_schema.sql
database/seed-data/challenges_seed.sql
```

11. Verify challenge data:

```sql
SELECT ChallengeID, Title, Category, Difficulty, Points, FileUrl, IsActive
FROM dbo.Challenges
ORDER BY ChallengeID;
```

Do not delete or recreate the database unless the whole group agrees. The `.mdf` contains shared users, training data, blog/news data, challenge records, and scores.

Optional path check:

```sql
SELECT DB_NAME(database_id) AS DatabaseName, name AS LogicalName, physical_name
FROM sys.master_files
WHERE physical_name LIKE '%HackEdDB%';
```

Optional detach command for a stale LocalDB attachment:

```sql
USE master;
ALTER DATABASE [HackEdDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
EXEC sp_detach_db N'HackEdDB';
```

This removes LocalDB's attachment registration. It does not delete the `.mdf` file.
