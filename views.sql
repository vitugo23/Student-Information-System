-- ================================================
-- Student Information System - Views
-- Author: Victor Torres
-- Description: Analytical views for reporting
-- ================================================

USE StudentInformationSystem;
GO

-- ================================================
-- View: Student Transcript
-- Description: Complete academic history for students
-- ================================================
CREATE OR ALTER VIEW vw_StudentTranscript AS
SELECT 
    s.StudentID,
    s.StudentNumber,
    s.FirstName + ' ' + s.LastName AS StudentName,
    t.TermName,
    c.CourseCode,
    c.CourseName,
    c.Credits,
    e.Grade,
    g.GradePoints,
    f.FirstName + ' ' + f.LastName AS Instructor,
    e.Status,
    s.CumulativeGPA,
    s.CreditsEarned
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Sections sec ON e.SectionID = sec.SectionID
INNER JOIN Courses c ON sec.CourseID = c.CourseID
INNER JOIN Terms t ON sec.TermID = t.TermID
LEFT JOIN Grades g ON e.Grade = g.LetterGrade
LEFT JOIN Faculty f ON sec.FacultyID = f.FacultyID;
GO

-- ================================================
-- View: Current Enrollments
-- Description: All current term enrollments
-- ================================================
CREATE OR ALTER VIEW vw_CurrentEnrollments AS
SELECT 
    s.StudentNumber,
    s.FirstName + ' ' + s.LastName AS StudentName,
    s.Email AS StudentEmail,
    c.CourseCode,
    c.CourseName,
    sec.SectionNumber,
    f.FirstName + ' ' + f.LastName AS Instructor,
    sec.MeetingDays,
    sec.StartTime,
    sec.EndTime,
    sec.Room,
    e.EnrollmentDate,
    e.Status
FROM Enrollments e
INNER JOIN Students s ON e.StudentID = s.StudentID
INNER JOIN Sections sec ON e.SectionID = sec.SectionID
INNER JOIN Courses c ON sec.CourseID = c.CourseID
INNER JOIN Terms t ON sec.TermID = t.TermID
LEFT JOIN Faculty f ON sec.FacultyID = f.FacultyID
WHERE t.IsCurrentTerm = 1
  AND e.Status = 'Enrolled';
GO

-- ================================================
-- View: Course Offerings
-- Description: Available courses by term
-- ================================================
CREATE OR ALTER VIEW vw_CourseOfferings AS
SELECT 
    t.TermName,
    d.DepartmentCode,
    c.CourseCode,
    c.CourseName,
    c.Credits,
    c.Description,
    sec.SectionNumber,
    f.FirstName + ' ' + f.LastName AS Instructor,
    sec.MeetingDays,
    CONVERT(VARCHAR(5), sec.StartTime, 108) AS StartTime,
    CONVERT(VARCHAR(5), sec.EndTime, 108) AS EndTime,
    sec.Room,
    sec.Capacity,
    sec.Enrolled,
    sec.Capacity - sec.Enrolled AS AvailableSeats,
    CASE 
        WHEN sec.Enrolled >= sec.Capacity THEN 'Full'
        WHEN CAST(sec.Enrolled AS FLOAT) / sec.Capacity >= 0.9 THEN 'Almost Full'
        ELSE 'Open'
    END AS EnrollmentStatus
FROM Sections sec
INNER JOIN Courses c ON sec.CourseID = c.CourseID
INNER JOIN Departments d ON c.DepartmentID = d.DepartmentID
INNER JOIN Terms t ON sec.TermID = t.TermID
LEFT JOIN Faculty f ON sec.FacultyID = f.FacultyID
WHERE c.IsActive = 1;
GO

-- ================================================
-- View: Faculty Schedule
-- Description: Teaching assignments for faculty
-- ================================================
CREATE OR ALTER VIEW vw_FacultySchedule AS
SELECT 
    f.FacultyID,
    f.FirstName + ' ' + f.LastName AS FacultyName,
    d.DepartmentName,
    t.TermName,
    c.CourseCode,
    c.CourseName,
    sec.SectionNumber,
    sec.MeetingDays,
    CONVERT(VARCHAR(5), sec.StartTime, 108) AS StartTime,
    CONVERT(VARCHAR(5), sec.EndTime, 108) AS EndTime,
    sec.Room,
    sec.Enrolled AS StudentsEnrolled,
    sec.Capacity
FROM Faculty f
INNER JOIN Departments d ON f.DepartmentID = d.DepartmentID
LEFT JOIN Sections sec ON f.FacultyID = sec.FacultyID
LEFT JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Terms t ON sec.TermID = t.TermID
WHERE f.IsActive = 1;
GO

-- ================================================
-- View: Student Performance
-- Description: Academic performance metrics
-- ================================================
CREATE OR ALTER VIEW vw_StudentPerformance AS
SELECT 
    s.StudentID,
    s.StudentNumber,
    s.FirstName + ' ' + s.LastName AS StudentName,
    m.MajorName,
    s.CumulativeGPA,
    s.CreditsAttempted,
    s.CreditsEarned,
    CAST(s.CreditsEarned * 100.0 / NULLIF(s.CreditsAttempted, 0) AS DECIMAL(5,2)) AS CompletionRate,
    s.AcademicStanding,
    f.FirstName + ' ' + f.LastName AS Advisor,
    s.ExpectedGraduation,
    CASE 
        WHEN s.CumulativeGPA >= 3.5 THEN 'Honors'
        WHEN s.CumulativeGPA >= 3.0 THEN 'Good'
        WHEN s.CumulativeGPA >= 2.0 THEN 'Satisfactory'
        ELSE 'At Risk'
    END AS PerformanceLevel
FROM Students s
LEFT JOIN Majors m ON s.MajorID = m.MajorID
LEFT JOIN Faculty f ON s.AdvisorID = f.FacultyID
WHERE s.IsActive = 1;
GO

-- ================================================
-- View: Department Statistics
-- Description: Enrollment and performance by department
-- ================================================
CREATE OR ALTER VIEW vw_DepartmentStatistics AS
SELECT 
    d.DepartmentCode,
    d.DepartmentName,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    COUNT(DISTINCT f.FacultyID) AS TotalFaculty,
    COUNT(DISTINCT c.CourseID) AS TotalCourses,
    COUNT(DISTINCT m.MajorID) AS TotalMajors,
    AVG(s.CumulativeGPA) AS AvgGPA,
    SUM(CASE WHEN s.AcademicStanding = 'Dean''s List' THEN 1 ELSE 0 END) AS DeansListCount,
    SUM(CASE WHEN s.AcademicStanding = 'Academic Probation' THEN 1 ELSE 0 END) AS ProbationCount
FROM Departments d
LEFT JOIN Majors m ON d.DepartmentID = m.DepartmentID
LEFT JOIN Students s ON m.MajorID = s.MajorID AND s.IsActive = 1
LEFT JOIN Faculty f ON d.DepartmentID = f.DepartmentID AND f.IsActive = 1
LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID AND c.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentCode, d.DepartmentName;
GO

-- ================================================
-- View: Course Grade Distribution
-- Description: Grade statistics by course
-- ================================================
CREATE OR ALTER VIEW vw_CourseGradeDistribution AS
WITH CourseGrades AS (
    SELECT 
        c.CourseID,
        c.CourseCode,
        c.CourseName,
        t.TermID,
        t.TermName,
        e.Grade,
        g.GradePoints,
        COUNT(*) AS StudentCount
    FROM Enrollments e
    INNER JOIN Sections sec ON e.SectionID = sec.SectionID
    INNER JOIN Courses c ON sec.CourseID = c.CourseID
    INNER JOIN Terms t ON sec.TermID = t.TermID
    LEFT JOIN Grades g ON e.Grade = g.LetterGrade
    WHERE e.Status = 'Completed'
      AND e.Grade IS NOT NULL
    GROUP BY c.CourseID, c.CourseCode, c.CourseName, t.TermID, t.TermName, e.Grade, g.GradePoints
),
CourseAvgGPA AS (
    SELECT 
        c.CourseID,
        t.TermID,
        AVG(g.GradePoints) AS AvgCourseGPA
    FROM Enrollments e
    INNER JOIN Sections sec ON e.SectionID = sec.SectionID
    INNER JOIN Courses c ON sec.CourseID = c.CourseID
    INNER JOIN Terms t ON sec.TermID = t.TermID
    LEFT JOIN Grades g ON e.Grade = g.LetterGrade
    WHERE e.Status = 'Completed'
      AND e.Grade IS NOT NULL
      AND g.GradePoints IS NOT NULL
    GROUP BY c.CourseID, t.TermID
)
SELECT 
    cg.CourseCode,
    cg.CourseName,
    cg.TermName,
    cg.Grade,
    cg.StudentCount,
    CAST(cg.StudentCount * 100.0 / SUM(cg.StudentCount) OVER (PARTITION BY cg.CourseID, cg.TermID) AS DECIMAL(5,2)) AS Percentage,
    CAST(ca.AvgCourseGPA AS DECIMAL(3,2)) AS AvgCourseGPA
FROM CourseGrades cg
LEFT JOIN CourseAvgGPA ca ON cg.CourseID = ca.CourseID AND cg.TermID = ca.TermID;
GO

-- ================================================
-- View: At-Risk Students
-- Description: Students needing academic support
-- ================================================
CREATE OR ALTER VIEW vw_AtRiskStudents AS
SELECT 
    s.StudentID,
    s.StudentNumber,
    s.FirstName + ' ' + s.LastName AS StudentName,
    s.Email,
    m.MajorName,
    s.CumulativeGPA,
    s.AcademicStanding,
    f.FirstName + ' ' + f.LastName AS Advisor,
    f.Email AS AdvisorEmail,
    CASE 
        WHEN s.CumulativeGPA < 2.0 THEN 'Critical'
        WHEN s.CumulativeGPA < 2.5 THEN 'High'
        ELSE 'Moderate'
    END AS RiskLevel
FROM Students s
LEFT JOIN Majors m ON s.MajorID = m.MajorID
LEFT JOIN Faculty f ON s.AdvisorID = f.FacultyID
WHERE s.IsActive = 1
  AND (s.CumulativeGPA < 2.5 OR s.AcademicStanding = 'Academic Probation')
  AND s.CreditsAttempted > 0;
GO

PRINT 'Views created successfully!';
GO
