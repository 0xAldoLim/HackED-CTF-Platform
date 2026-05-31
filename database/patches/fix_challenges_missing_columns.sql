-- Fix existing HackEdDB Challenge table missing CTF challenge columns.
-- Safe to run multiple times against the HackEdDB LocalDB database.

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NULL
BEGIN
    PRINT 'dbo.Challenges table does not exist. Run database/schema/challenges_schema.sql first.';
END;
GO

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'CorrectFlag') IS NULL
BEGIN
    ALTER TABLE dbo.Challenges
    ADD CorrectFlag NVARCHAR(255) NULL;
END;
GO

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'Hint') IS NULL
BEGIN
    ALTER TABLE dbo.Challenges
    ADD Hint NVARCHAR(MAX) NULL;
END;
GO

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'FileUrl') IS NULL
BEGIN
    ALTER TABLE dbo.Challenges
    ADD FileUrl NVARCHAR(500) NULL;
END;
GO

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'IsActive') IS NULL
BEGIN
    ALTER TABLE dbo.Challenges
    ADD IsActive BIT NOT NULL
        CONSTRAINT DF_Challenges_IsActive DEFAULT (1)
        WITH VALUES;
END;
GO

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'CreatedAt') IS NULL
BEGIN
    ALTER TABLE dbo.Challenges
    ADD CreatedAt DATETIME NOT NULL
        CONSTRAINT DF_Challenges_CreatedAt DEFAULT (GETDATE())
        WITH VALUES;
END;
GO

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Challenges'
ORDER BY ORDINAL_POSITION;
GO
