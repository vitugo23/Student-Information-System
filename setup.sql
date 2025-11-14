-- ================================================
-- Student Information System - Master Setup Script
-- Author: Victor Torres
-- Description: Complete database setup in one script
-- ================================================

PRINT '================================================';
PRINT 'Student Information System Setup';
PRINT 'Author: Victor Torres';
PRINT '================================================';
PRINT '';

-- Execute Schema Creation
PRINT 'Step 1: Creating database schema...';
:r schema.sql
PRINT 'Schema created successfully!';
PRINT '';

-- Execute Sample Data
PRINT 'Step 2: Inserting sample data...';
:r sample-data.sql
PRINT 'Sample data inserted successfully!';
PRINT '';

-- Execute Stored Procedures
PRINT 'Step 3: Creating stored procedures...';
:r stored-procedures.sql
PRINT 'Stored procedures created successfully!';
PRINT '';

-- Execute Views
PRINT 'Step 4: Creating views...';
:r views.sql
PRINT 'Views created successfully!';
PRINT '';

PRINT '================================================';
PRINT 'Database setup completed successfully!';
PRINT '================================================';
PRINT '';
PRINT 'You can now:';
PRINT '1. Query the views (SELECT * FROM vw_StudentTranscript WHERE StudentID = 1)';
PRINT '2. Execute stored procedures (EXEC sp_GenerateTranscript @StudentID = 1)';
PRINT '3. Explore student and course data';
PRINT '';
PRINT 'Sample queries to try:';
PRINT '  - SELECT * FROM vw_StudentPerformance ORDER BY CumulativeGPA DESC;';
PRINT '  - SELECT * FROM vw_CourseOfferings WHERE TermName = ''Fall 2024'';';
PRINT '  - EXEC sp_GenerateDeansList @TermID = 4;';
PRINT '';
