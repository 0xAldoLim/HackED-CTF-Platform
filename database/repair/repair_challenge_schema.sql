-- Safe CTF challenge schema repair for HackEdDB.
-- This script is idempotent and does not drop existing data.

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Challenges
    (
        ChallengeID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Challenges PRIMARY KEY,
        Title NVARCHAR(150) NOT NULL,
        Description NVARCHAR(MAX) NOT NULL,
        Category NVARCHAR(50) NOT NULL,
        Difficulty NVARCHAR(20) NOT NULL,
        Points INT NOT NULL,
        CorrectFlag NVARCHAR(255) NULL,
        Hint NVARCHAR(MAX) NULL,
        FileUrl NVARCHAR(500) NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Challenges_IsActive DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_Challenges_CreatedAt DEFAULT (GETDATE())
    );
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

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'Flag') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'CorrectFlag') IS NOT NULL
BEGIN
    UPDATE dbo.Challenges
    SET CorrectFlag = [Flag]
    WHERE CorrectFlag IS NULL
      AND [Flag] IS NOT NULL;
END;
GO

IF OBJECT_ID(N'dbo.Submissions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Submissions
    (
        SubmissionID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Submissions PRIMARY KEY,
        UserID INT NOT NULL,
        ChallengeID INT NOT NULL,
        SubmittedFlag NVARCHAR(255) NOT NULL,
        IsCorrect BIT NOT NULL,
        PointsAwarded INT NOT NULL CONSTRAINT DF_Submissions_PointsAwarded DEFAULT (0),
        SubmittedAt DATETIME NOT NULL CONSTRAINT DF_Submissions_SubmittedAt DEFAULT (GETDATE())
    );
END;
GO

IF OBJECT_ID(N'dbo.Submissions', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Submissions', 'PointsAwarded') IS NULL
BEGIN
    ALTER TABLE dbo.Submissions
    ADD PointsAwarded INT NOT NULL
        CONSTRAINT DF_Submissions_PointsAwarded DEFAULT (0)
        WITH VALUES;
END;
GO

IF OBJECT_ID(N'dbo.Submissions', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1
       FROM sys.indexes
       WHERE name = N'IX_Submissions_User_Challenge_Correct'
         AND object_id = OBJECT_ID(N'dbo.Submissions')
   )
BEGIN
    CREATE INDEX IX_Submissions_User_Challenge_Correct
        ON dbo.Submissions(UserID, ChallengeID, IsCorrect);
END;
GO

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Challenges'
ORDER BY ORDINAL_POSITION;

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Submissions'
ORDER BY ORDINAL_POSITION;

SELECT ChallengeID, Title, Category, Difficulty, Points, FileUrl, IsActive
FROM dbo.Challenges
ORDER BY ChallengeID;
GO
