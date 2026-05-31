-- HackEd Team and Scoreboard schema support.
-- Safe to run multiple times. This script does not drop existing data.

IF OBJECT_ID(N'dbo.Teams', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Teams
    (
        TeamID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Teams PRIMARY KEY,
        TeamName NVARCHAR(100) NOT NULL,
        LeaderUserID INT NULL,
        InviteCode NVARCHAR(20) NULL,
        TeamScore INT NOT NULL CONSTRAINT DF_Teams_TeamScore DEFAULT (0),
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_Teams_CreatedAt DEFAULT (GETDATE())
    );
END;
GO

IF OBJECT_ID(N'dbo.Teams', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Teams', 'LeaderUserID') IS NULL
BEGIN
    ALTER TABLE dbo.Teams
    ADD LeaderUserID INT NULL;
END;
GO

IF OBJECT_ID(N'dbo.Teams', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Teams', 'InviteCode') IS NULL
BEGIN
    ALTER TABLE dbo.Teams
    ADD InviteCode NVARCHAR(20) NULL;
END;
GO

IF OBJECT_ID(N'dbo.Teams', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Teams', 'TeamScore') IS NULL
BEGIN
    ALTER TABLE dbo.Teams
    ADD TeamScore INT NOT NULL
        CONSTRAINT DF_Teams_TeamScore DEFAULT (0)
        WITH VALUES;
END;
GO

IF OBJECT_ID(N'dbo.Teams', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.Teams', 'CreatedAt') IS NULL
BEGIN
    ALTER TABLE dbo.Teams
    ADD CreatedAt DATETIME NOT NULL
        CONSTRAINT DF_Teams_CreatedAt DEFAULT (GETDATE())
        WITH VALUES;
END;
GO

IF OBJECT_ID(N'dbo.TeamMembers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TeamMembers
    (
        TeamMemberID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TeamMembers PRIMARY KEY,
        TeamID INT NOT NULL,
        UserID INT NOT NULL,
        JoinedAt DATETIME NOT NULL CONSTRAINT DF_TeamMembers_JoinedAt DEFAULT (GETDATE())
    );
END;
GO

IF OBJECT_ID(N'dbo.TeamMembers', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.TeamMembers', 'TeamID') IS NULL
BEGIN
    ALTER TABLE dbo.TeamMembers
    ADD TeamID INT NULL;
END;
GO

IF OBJECT_ID(N'dbo.TeamMembers', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.TeamMembers', 'UserID') IS NULL
BEGIN
    ALTER TABLE dbo.TeamMembers
    ADD UserID INT NULL;
END;
GO

IF OBJECT_ID(N'dbo.TeamMembers', N'U') IS NOT NULL
   AND COL_LENGTH('dbo.TeamMembers', 'JoinedAt') IS NULL
BEGIN
    ALTER TABLE dbo.TeamMembers
    ADD JoinedAt DATETIME NOT NULL
        CONSTRAINT DF_TeamMembers_JoinedAt DEFAULT (GETDATE())
        WITH VALUES;
END;
GO

IF OBJECT_ID(N'dbo.TeamMembers', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1
       FROM sys.indexes
       WHERE name = N'IX_TeamMembers_UserID'
         AND object_id = OBJECT_ID(N'dbo.TeamMembers')
   )
BEGIN
    CREATE INDEX IX_TeamMembers_UserID
        ON dbo.TeamMembers(UserID);
END;
GO

IF OBJECT_ID(N'dbo.TeamMembers', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1
       FROM sys.indexes
       WHERE name = N'IX_TeamMembers_TeamID_UserID'
         AND object_id = OBJECT_ID(N'dbo.TeamMembers')
   )
BEGIN
    CREATE INDEX IX_TeamMembers_TeamID_UserID
        ON dbo.TeamMembers(TeamID, UserID)
        WHERE TeamID IS NOT NULL AND UserID IS NOT NULL;
END;
GO

IF OBJECT_ID(N'dbo.Teams', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1
       FROM sys.indexes
       WHERE name = N'IX_Teams_TeamName'
         AND object_id = OBJECT_ID(N'dbo.Teams')
   )
BEGIN
    CREATE INDEX IX_Teams_TeamName
        ON dbo.Teams(TeamName);
END;
GO

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Teams'
ORDER BY ORDINAL_POSITION;

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TeamMembers'
ORDER BY ORDINAL_POSITION;
GO
