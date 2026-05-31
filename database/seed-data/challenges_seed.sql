-- Sample HackEd CTF challenges for local testing.
-- Run after database/schema/challenges_schema.sql.

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'Inspect the Source')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'Inspect the Source',
         N'The first flag is hidden in plain sight. Practice checking page source and comments.',
         N'Web',
         N'Easy',
         100,
         N'HackEd{view_source}',
         N'Browser developer tools are part of the web testing workflow.',
         NULL,
         1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'Caesar Classroom')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'Caesar Classroom',
         N'Decode this message: KdfnHg{vkliw_wkuhh}.',
         N'Cryptography',
         N'Easy',
         150,
         N'HackEd{shift_three}',
         N'Try shifting letters backward by three.',
         NULL,
         1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'Quiet Metadata')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'Quiet Metadata',
         N'A file can say more than its visible contents. Inspect metadata carefully.',
         N'Forensics',
         N'Medium',
         250,
         N'HackEd{metadata_matters}',
         N'Look for author, comment, and tool fields.',
         NULL,
         1);
END;
