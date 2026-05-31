-- HackEd CTF Challenge System schema
-- Run this against the HackEdDB LocalDB database if these tables/columns do not already exist.

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
        CorrectFlag NVARCHAR(255) NOT NULL,
        Hint NVARCHAR(MAX) NULL,
        FileUrl NVARCHAR(500) NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Challenges_IsActive DEFAULT (1),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_Challenges_CreatedAt DEFAULT (GETDATE()),
        CONSTRAINT CK_Challenges_Points_Positive CHECK (Points > 0),
        CONSTRAINT CK_Challenges_Difficulty CHECK (Difficulty IN ('Easy', 'Medium', 'Hard'))
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

IF OBJECT_ID(N'dbo.Challenges', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Challenges', 'Flag') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1
       FROM sys.default_constraints dc
       INNER JOIN sys.columns c
           ON c.object_id = dc.parent_object_id
          AND c.column_id = dc.parent_column_id
       WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Challenges')
         AND c.name = N'Flag'
   )
BEGIN
    ALTER TABLE dbo.Challenges
    ADD CONSTRAINT DF_Challenges_Flag DEFAULT ('') FOR [Flag];
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

IF COL_LENGTH('dbo.Submissions', 'PointsAwarded') IS NULL
BEGIN
    ALTER TABLE dbo.Submissions
    ADD PointsAwarded INT NOT NULL CONSTRAINT DF_Submissions_PointsAwarded DEFAULT (0);
END;
GO

IF OBJECT_ID(N'dbo.FK_Submissions_Users', N'F') IS NULL
   AND OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.Submissions
    ADD CONSTRAINT FK_Submissions_Users
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID);
END;
GO

IF OBJECT_ID(N'dbo.FK_Submissions_Challenges', N'F') IS NULL
BEGIN
    ALTER TABLE dbo.Submissions
    ADD CONSTRAINT FK_Submissions_Challenges
        FOREIGN KEY (ChallengeID) REFERENCES dbo.Challenges(ChallengeID);
END;
GO

IF NOT EXISTS (
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
