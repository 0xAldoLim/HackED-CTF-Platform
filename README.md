# HackEd CTF Platform

HackEd CTF is a university WAPP group assignment project. It is a web-based cybersecurity learning platform with user authentication, training modules, CTF challenges, admin management pages, blog/announcement content, teams, and scoreboard features.

## How To Run The Website

This project is an ASP.NET Web Forms application using .NET Framework 4.8 and SQL Server LocalDB.

Use Visual Studio on Windows.

1. Clone or download this repository.
2. Open this solution file in Visual Studio:

```text
src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web.sln
```

3. Restore NuGet packages if Visual Studio prompts for it.
4. Build the solution.
5. Run the project with IIS Express.

The main web project is:

```text
src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web
```

The LocalDB database files are stored in:

```text
src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\App_Data\HackEdDB.mdf
src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\App_Data\HackEdDB_log.ldf
```

## If The Database Cannot Open

If Visual Studio shows an error similar to:

```text
Cannot open database ... App_Data\HackEdDB.mdf requested by the login. The login failed.
```

do not delete the database and do not create a new empty database. The `.mdf` file contains project data.

Try this safe LocalDB reset:

1. Stop the website and close IIS Express.
2. Open PowerShell or Developer Command Prompt.
3. Stop LocalDB:

```powershell
sqllocaldb stop MSSQLLocalDB
```

4. Reopen Visual Studio.
5. Open SQL Server Object Explorer.
6. Connect to:

```text
(localdb)\MSSQLLocalDB
```

7. If an old `HackEdDB` database is listed and points to a different clone folder, detach/remove that database registration only.
8. Do not delete the physical `.mdf` file.
9. Attach the database from this clone:

```text
src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\App_Data\HackEdDB.mdf
```

10. Run the website again.

To check whether LocalDB is attached to the wrong folder, run this in SQL Server Object Explorer:

```sql
SELECT DB_NAME(database_id) AS DatabaseName, name AS LogicalName, physical_name
FROM sys.master_files
WHERE physical_name LIKE '%HackEdDB%';
```

If needed, detach the stale LocalDB registration without deleting the file:

```sql
USE master;
ALTER DATABASE [HackEdDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
EXEC sp_detach_db N'HackEdDB';
```

Then attach the `HackEdDB.mdf` file from this repository's `App_Data` folder.

If there is any error with SQL Database or Building the website delete these folders:
	~\HackED-CTF-Platform\src\HackEdCTF.Web\HackEdCTF.Web\.vs
	~\HackED-CTF-Platform\src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\obj 
	~\HackED-CTF-Platform\src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web\bin

Next open the .sln file ~\HackED-CTF-Platform\src\HackEdCTF.Web\HackEdCTF.Web\HackEdCTF.Web.sln
and then rebuild the solution and then launch.


## Optional Database Repair Scripts

If the website opens but challenge tables or sample challenges are missing, run these scripts against `HackEdDB.mdf`:

```text
database\repair\repair_challenge_schema.sql
database\schema\challenges_schema.sql
database\seed-data\challenges_seed.sql
```

These scripts are intended to be safe to run more than once. They add missing CTF challenge tables/columns and sample challenge rows without dropping existing data.

## What Not To Do

- Do not delete `HackEdDB.mdf`.
- Do not replace the database with a blank database.
- Do not drop tables.
- Do not delete users, roles, teams, training content, blog/news data, CTF challenges, submissions, or scoreboard data.
- Do not run destructive SQL unless the group has agreed to reset the database.

## Main Features

- User registration and login
- Member dashboard
- Training module listing and detail pages
- CTF challenge listing, filtering, detail view, flag submission, and score update
- Admin challenge management
- Admin training/content management
- Blog and announcement pages
- Team and scoreboard features

## Project Structure

- `src/HackEdCTF.Web/HackEdCTF.Web/HackEdCTF.Web.sln` - Visual Studio solution file
- `src/HackEdCTF.Web/HackEdCTF.Web/HackEdCTF.Web/` - Main ASP.NET Web Forms application
- `src/HackEdCTF.Web/HackEdCTF.Web/HackEdCTF.Web/Web.config` - Application configuration and LocalDB connection string
- `src/HackEdCTF.Web/HackEdCTF.Web/HackEdCTF.Web/App_Data/` - SQL Server LocalDB database files
- `src/HackEdCTF.Web/HackEdCTF.Web/HackEdCTF.Web/css/site.css` - Shared HackEd styling
- `database/` - Database setup, repair, schema, and seed scripts

## Team Members

- Aldo
- Hansen
- Archie
- Darren
