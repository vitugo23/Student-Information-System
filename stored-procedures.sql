-- ================================================
-- Student Information System - Stored Procedures
-- Author: Victor Torres
-- Description: Business logic for academic operations
-- ================================================

USE StudentInformationSystem;
GO

-- ================================================
-- SP: Enroll Student in Section
-- Description: Enrolls student with validation
-- ================================================
CREATE OR ALTER PROCEDURE sp_EnrollStudent
    @StudentID INT,
    @SectionID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if student exists and is active
        IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID AND IsActive = 1)
        BEGIN
            THROW 50001, 'Student not found or inactive', 1;
        END
        
        -- Check if section exists
        IF NOT EXISTS (SELECT 1 FROM Sections WHERE SectionID = @SectionID)
        BEGIN
            THROW 50002, 'Section not found', 1;
        END
        
        -- Check if already enrolled
        IF EXISTS (SELECT 1 FROM Enrollments WHERE StudentID = @StudentID AND SectionID = @SectionID)
        BEGIN
            THROW 50003, 'Student already enrolled in this section', 1;
        END
        
        -- Check section capacity
        DECLARE @Capacity INT, @Enrolled INT;
        SELECT @Capacity = Capacity, @Enrolled = Enrolled 
        FROM Sections 
        WHERE SectionID = @SectionID;
        
        IF @Enrolled >= @Capacity
        BEGIN
            THROW 50004, 'Section is full', 1;
        END
        
        -- Insert enrollment
        INSERT INTO Enrollments (StudentID, SectionID, Status)
        VALUES (@StudentID, @SectionID, 'Enrolled');
        
        -- Update section enrollment count
        UPDATE Sections
        SET Enrolled = Enrolled + 1
        WHERE SectionID = @SectionID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Student enrolled successfully' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO

-- ================================================
-- SP: Drop Course
-- Description: Allows student to drop a course
-- ================================================
CREATE OR ALTER PROCEDURE sp_DropCourse
    @EnrollmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check if enrollment exists
        IF NOT EXISTS (SELECT 1 FROM Enrollments WHERE EnrollmentID = @EnrollmentID)
        BEGIN
            THROW 50005, 'Enrollment not found', 1;
        END
        
        -- Get section ID
        DECLARE @SectionID INT;
        SELECT @SectionID = SectionID 
        FROM Enrollments 
        WHERE EnrollmentID = @EnrollmentID;
        
        -- Update enrollment status
        UPDATE Enrollments
        SET Status = 'Dropped',
            Grade = 'W'
        WHERE EnrollmentID = @EnrollmentID;
        
        -- Update section enrollment count
        UPDATE Sections
        SET Enrolled = Enrolled - 1
        WHERE SectionID = @SectionID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Course dropped successfully' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO

-- ================================================
-- SP: Assign Grade
-- Description: Assigns or updates a grade
-- ================================================
CREATE OR ALTER PROCEDURE sp_AssignGrade
    @EnrollmentID INT,
    @Grade NVARCHAR(2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validate grade exists
        IF NOT EXISTS (SELECT 1 FROM Grades WHERE LetterGrade = @Grade)
        BEGIN
            THROW 50006, 'Invalid grade', 1;
        END
        
        -- Update enrollment
        UPDATE Enrollments
        SET Grade = @Grade,
            Status = 'Completed'
        WHERE EnrollmentID = @EnrollmentID;
        
        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50007, 'Enrollment not found', 1;
        END
        
        -- Recalculate GPA for the student
        DECLARE @StudentID INT;
        SELECT @StudentID = StudentID FROM Enrollments WHERE EnrollmentID = @EnrollmentID;
        
        EXEC sp_CalculateGPA @StudentID;
        
        SELECT 'Grade assigned successfully' AS Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- ================================================
-- SP: Calculate Student GPA
-- Description: Recalculates cumulative GPA
-- ================================================
CREATE OR ALTER PROCEDURE sp_CalculateGPA
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @GPA DECIMAL(3,2);
    DECLARE @CreditsAttempted INT;
    DECLARE @CreditsEarned INT;
    
    -- Calculate GPA
    SELECT 
        @GPA = CAST(SUM(c.Credits * g.GradePoints) / NULLIF(SUM(c.Credits), 0) AS DECIMAL(3,2)),
        @CreditsAttempted = SUM(c.Credits),
        @CreditsEarned = SUM(CASE WHEN g.GradePoints >= 1.0 THEN c.Credits ELSE 0 END)
    FROM Enrollments e
    INNER JOIN Sections s ON e.SectionID = s.SectionID
    INNER JOIN Courses c ON s.CourseID = c.CourseID
    LEFT JOIN Grades g ON e.Grade = g.LetterGrade
    WHERE e.StudentID = @StudentID
      AND e.Status = 'Completed'
      AND e.Grade IS NOT NULL
      AND g.GradePoints IS NOT NULL;
    
    -- Update student record
    UPDATE Students
    SET CumulativeGPA = ISNULL(@GPA, 0.00),
        CreditsAttempted = ISNULL(@CreditsAttempted, 0),
        CreditsEarned = ISNULL(@CreditsEarned, 0),
        AcademicStanding = CASE 
            WHEN ISNULL(@GPA, 0) >= 3.5 THEN 'Dean''s List'
            WHEN ISNULL(@GPA, 0) >= 2.0 THEN 'Good Standing'
            WHEN ISNULL(@CreditsAttempted, 0) = 0 THEN 'Good Standing'
            ELSE 'Academic Probation'
        END
    WHERE StudentID = @StudentID;
    
    SELECT 
        @StudentID AS StudentID,
        ISNULL(@GPA, 0.00) AS CumulativeGPA,
        ISNULL(@CreditsAttempted, 0) AS CreditsAttempted,
        ISNULL(@CreditsEarned, 0) AS CreditsEarned;
END;
GO

-- ================================================
-- SP: Check Prerequisites
-- Description: Validates if student has met prerequisites
-- ================================================
CREATE OR ALTER PROCEDURE sp_CheckPrerequisites
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get all prerequisites
    CREATE TABLE #Prerequisites (
        PrerequisiteCourseID INT,
        MinimumGrade NVARCHAR(2)
    );
    
    INSERT INTO #Prerequisites
    SELECT PrerequisiteCourseID, MinimumGrade
    FROM CoursePrerequisites
    WHERE CourseID = @CourseID;
    
    -- Check if student has completed prerequisites
    CREATE TABLE #MissingPrereqs (
        CourseCode NVARCHAR(20),
        CourseName NVARCHAR(200),
        RequiredGrade NVARCHAR(2),
        StudentGrade NVARCHAR(2)
    );
    
    INSERT INTO #MissingPrereqs
    SELECT 
        c.CourseCode,
        c.CourseName,
        p.MinimumGrade,
        e.Grade
    FROM #Prerequisites p
    INNER JOIN Courses c ON p.PrerequisiteCourseID = c.CourseID
    LEFT JOIN (
        SELECT e.StudentID, s.CourseID, e.Grade, g.GradePoints
        FROM Enrollments e
        INNER JOIN Sections s ON e.SectionID = s.SectionID
        LEFT JOIN Grades g ON e.Grade = g.LetterGrade
        WHERE e.StudentID = @StudentID
          AND e.Status = 'Completed'
    ) e ON p.PrerequisiteCourseID = e.CourseID
    LEFT JOIN Grades gReq ON p.MinimumGrade = gReq.LetterGrade
    LEFT JOIN Grades gStud ON e.Grade = gStud.LetterGrade
    WHERE e.CourseID IS NULL 
       OR gStud.GradePoints IS NULL
       OR gStud.GradePoints < gReq.GradePoints;
    
    -- Return results
    IF EXISTS (SELECT 1 FROM #MissingPrereqs)
    BEGIN
        SELECT 
            'Missing Prerequisites' AS Status,
            CourseCode,
            CourseName,
            RequiredGrade,
            ISNULL(StudentGrade, 'Not Taken') AS StudentGrade
        FROM #MissingPrereqs;
    END
    ELSE
    BEGIN
        SELECT 'Prerequisites Met' AS Status;
    END
    
    DROP TABLE #Prerequisites;
    DROP TABLE #MissingPrereqs;
END;
GO

-- ================================================
-- SP: Generate Transcript
-- Description: Generates official transcript
-- ================================================
CREATE OR ALTER PROCEDURE sp_GenerateTranscript
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Student Information
    SELECT 
        s.StudentNumber,
        s.FirstName + ' ' + s.LastName AS StudentName,
        s.Email,
        m.MajorName,
        d.DepartmentName,
        s.CumulativeGPA,
        s.CreditsAttempted,
        s.CreditsEarned,
        s.AcademicStanding,
        s.EnrollmentDate,
        s.ExpectedGraduation
    FROM Students s
    LEFT JOIN Majors m ON s.MajorID = m.MajorID
    LEFT JOIN Departments d ON m.DepartmentID = d.DepartmentID
    WHERE s.StudentID = @StudentID;
    
    -- Course History by Term
    SELECT 
        t.TermName,
        c.CourseCode,
        c.CourseName,
        c.Credits,
        e.Grade,
        g.GradePoints,
        f.FirstName + ' ' + f.LastName AS Instructor
    FROM Enrollments e
    INNER JOIN Sections sec ON e.SectionID = sec.SectionID
    INNER JOIN Courses c ON sec.CourseID = c.CourseID
    INNER JOIN Terms t ON sec.TermID = t.TermID
    LEFT JOIN Grades g ON e.Grade = g.LetterGrade
    LEFT JOIN Faculty f ON sec.FacultyID = f.FacultyID
    WHERE e.StudentID = @StudentID
      AND e.Status IN ('Completed', 'Enrolled')
    ORDER BY t.StartDate, c.CourseCode;
END;
GO

-- ================================================
-- SP: Generate Dean's List
-- Description: Generates Dean's List for a term
-- ================================================
CREATE OR ALTER PROCEDURE sp_GenerateDeansList
    @TermID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        s.StudentNumber,
        s.FirstName + ' ' + s.LastName AS StudentName,
        m.MajorName,
        CAST(AVG(g.GradePoints) AS DECIMAL(3,2)) AS TermGPA,
        s.CumulativeGPA,
        SUM(c.Credits) AS CreditsThisTerm
    FROM Students s
    INNER JOIN Majors m ON s.MajorID = m.MajorID
    INNER JOIN Enrollments e ON s.StudentID = e.StudentID
    INNER JOIN Sections sec ON e.SectionID = sec.SectionID
    INNER JOIN Courses c ON sec.CourseID = c.CourseID
    INNER JOIN Grades g ON e.Grade = g.LetterGrade
    WHERE sec.TermID = @TermID
      AND e.Status = 'Completed'
      AND g.GradePoints IS NOT NULL
    GROUP BY s.StudentID, s.StudentNumber, s.FirstName, s.LastName, m.MajorName, s.CumulativeGPA
    HAVING AVG(g.GradePoints) >= 3.5 AND SUM(c.Credits) >= 12
    ORDER BY AVG(g.GradePoints) DESC;
END;
GO

-- ================================================
-- SP: Get Course Availability
-- Description: Returns available sections for enrollment
-- ================================================
CREATE OR ALTER PROCEDURE sp_GetCourseAvailability
    @TermID INT,
    @DepartmentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.CourseCode,
        c.CourseName,
        c.Credits,
        d.DepartmentCode,
        sec.SectionNumber,
        f.FirstName + ' ' + f.LastName AS Instructor,
        sec.MeetingDays,
        CONVERT(VARCHAR(5), sec.StartTime, 108) AS StartTime,
        CONVERT(VARCHAR(5), sec.EndTime, 108) AS EndTime,
        sec.Room,
        sec.Capacity,
        sec.Enrolled,
        sec.Capacity - sec.Enrolled AS Available,
        CASE 
            WHEN sec.Enrolled >= sec.Capacity THEN 'Full'
            WHEN sec.Capacity - sec.Enrolled <= 5 THEN 'Almost Full'
            ELSE 'Open'
        END AS Status
    FROM Sections sec
    INNER JOIN Courses c ON sec.CourseID = c.CourseID
    INNER JOIN Departments d ON c.DepartmentID = d.DepartmentID
    LEFT JOIN Faculty f ON sec.FacultyID = f.FacultyID
    WHERE sec.TermID = @TermID
      AND c.IsActive = 1
      AND (@DepartmentID IS NULL OR c.DepartmentID = @DepartmentID)
    ORDER BY c.CourseCode, sec.SectionNumber;
END;
GO

PRINT 'Stored procedures created successfully!';
GO
