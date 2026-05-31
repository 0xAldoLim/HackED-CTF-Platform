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

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'I Think We Can Cook This Blob')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'I Think We Can Cook This Blob',
         N'Work out what the blob is hiding and recover the flag.',
         N'Miscellaneous',
         N'Easy',
         100,
         N'hacked{congrats_on_your_first_chall}',
         N'64 or 67?',
         NULL,
         1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'Stage Name')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'Stage Name',
         N'Be careful, this guy has multiple personalities.',
         N'OSINT',
         N'Easy',
         150,
         N'hacked{joji}',
         N'hacked{stagename}',
         N'https://drive.google.com/file/d/1x29ppRhVjF0ixSasYZXC6jE0x4_JKOKr/view?usp=sharing',
         1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'Why is the pokemon game so weird?')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'Why is the pokemon game so weird?',
         N'Try to play, my friend said this game have virus.. but is it?
Flag format: hacked{all_the_weird_pieces}',
         N'Reverse Engineering',
         N'Hard',
         500,
         N'hacked{9bdca6ea-8277-45c2-ac72-c873b2f92b0b}',
         N'Seriously, you have to play.',
         N'https://drive.google.com/file/d/1SkPxYs9lGcaCTfHw4qCBIoncTnGEWq35/view?usp=sharing',
         1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Challenges WHERE Title = N'Bytes')
BEGIN
    INSERT INTO dbo.Challenges
        (Title, Description, Category, Difficulty, Points, CorrectFlag, Hint, FileUrl, IsActive)
    VALUES
        (N'Bytes',
         N'Analyze the pcap file and try to figure out what was written?',
         N'Forensics',
         N'Medium',
         250,
         N'hacked{9fd0b137-cfc7-49e6-95c0-4fcc7822a274}',
         N'c+v? and bin',
         N'https://drive.google.com/file/d/1UcdxG64RwQJZgtSkocX-_ui-QKz36m91/view?usp=sharing',
         1);
END;
