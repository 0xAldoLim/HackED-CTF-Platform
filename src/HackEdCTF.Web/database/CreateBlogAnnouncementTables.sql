-- =============================================================
-- HackEd CTF - Blog & Announcement tables
-- Run this against HackEdDB.mdf (Visual Studio: open the .mdf in
-- Server Explorer, right-click > New Query, paste, and Execute).
-- These tables reference the existing Users table (UserID).
-- =============================================================

-- ---------- Blog / News posts ----------
CREATE TABLE [dbo].[BlogPosts] (
    [PostID]        INT             IDENTITY (1, 1) NOT NULL,
    [Title]         NVARCHAR (200)  NOT NULL,
    [PostType]      NVARCHAR (20)   NOT NULL DEFAULT ('Blog'),   -- 'Blog' or 'News'
    [Category]      NVARCHAR (50)   NULL,                        -- e.g. Security, CTF, Platform
    [Content]       NVARCHAR (MAX)  NOT NULL,
    [AuthorID]      INT             NOT NULL,
    [Status]        NVARCHAR (20)   NOT NULL DEFAULT ('Draft'),  -- 'Draft', 'Published', 'Archived'
    [IsFeatured]    BIT             NOT NULL DEFAULT (0),
    [CreatedAt]     DATETIME        NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT [PK_BlogPosts] PRIMARY KEY CLUSTERED ([PostID] ASC),
    CONSTRAINT [FK_BlogPosts_Users] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Users] ([UserID])
);
GO

-- ---------- Announcements ----------
CREATE TABLE [dbo].[Announcements] (
    [AnnouncementID] INT            IDENTITY (1, 1) NOT NULL,
    [Title]          NVARCHAR (200) NOT NULL,
    [Content]        NVARCHAR (MAX) NOT NULL,
    [Priority]       NVARCHAR (20)  NOT NULL DEFAULT ('Info'),    -- 'Important', 'Event', 'Maintenance', 'Info'
    [AuthorID]       INT            NOT NULL,
    [IsPinned]       BIT            NOT NULL DEFAULT (0),
    [Status]         NVARCHAR (20)  NOT NULL DEFAULT ('Published'),-- 'Draft', 'Published', 'Archived'
    [CreatedAt]      DATETIME       NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT [PK_Announcements] PRIMARY KEY CLUSTERED ([AnnouncementID] ASC),
    CONSTRAINT [FK_Announcements_Users] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Users] ([UserID])
);
GO

-- ---------- Optional sample data (uses AuthorID = 1; change if needed) ----------
INSERT INTO [dbo].[BlogPosts] ([Title], [PostType], [Category], [Content], [AuthorID], [Status], [IsFeatured])
VALUES
(N'How to Start Practicing CTFs', N'Blog', N'CTF',
 N'A beginner roadmap for your first flags. Start small, read writeups, and build momentum one category at a time.',
 1, N'Published', 1),
(N'Password Hygiene', N'Blog', N'Security',
 N'Practical habits that stop the most common account takeovers, from unique passwords to multi-factor authentication.',
 1, N'Published', 0),
(N'New Web Challenges', N'News', N'CTF',
 N'A fresh set of web exploitation challenges has been added to the platform. Try them out on the Challenges page.',
 1, N'Published', 0),
(N'ASP.NET Core Security', N'Blog', N'Security',
 N'Common web pitfalls and how the framework helps you avoid them, with notes on validation and safe data access.',
 1, N'Published', 0);
GO

INSERT INTO [dbo].[Announcements] ([Title], [Content], [Priority], [AuthorID], [IsPinned], [Status])
VALUES
(N'Scoreboard reset this weekend', N'Individual and team scores will reset on Sunday. Solve history is preserved.', N'Important', 1, 1, N'Published'),
(N'Maintenance window Friday', N'The platform will be briefly unavailable Friday evening for scheduled maintenance.', N'Maintenance', 1, 0, N'Published'),
(N'New OSINT event', N'A timed OSINT event opens next week. Form a team and get ready.', N'Event', 1, 0, N'Published'),
(N'Blog posting guidelines', N'Please review the updated guidelines before submitting community writeups.', N'Info', 1, 0, N'Published');
GO
