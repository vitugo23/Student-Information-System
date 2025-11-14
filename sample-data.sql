-- ================================================
-- Student Information System - Sample Data
-- Author: Victor Torres
-- Description: Realistic academic data for testing
-- ================================================

USE StudentInformationSystem;
GO

PRINT 'Inserting sample data...';
GO

-- ================================================
-- Insert Departments
-- ================================================
INSERT INTO Departments (DepartmentCode, DepartmentName, DepartmentHead, Building, Phone, Email) VALUES
('CS', 'Computer Science', 'Dr. Alan Turing', 'Tech Building', '555-0101', 'cs@university.edu'),
('MATH', 'Mathematics', 'Dr. Ada Lovelace', 'Science Hall', '555-0102', 'math@university.edu'),
('ENG', 'English', 'Dr. William Shakespeare', 'Liberal Arts', '555-0103', 'english@university.edu'),
('BUS', 'Business Administration', 'Dr. Peter Drucker', 'Business Center', '555-0104', 'business@university.edu'),
('BIOL', 'Biology', 'Dr. Jane Goodall', 'Science Hall', '555-0105', 'biology@university.edu'),
('HIST', 'History', 'Dr. Howard Zinn', 'Liberal Arts', '555-0106', 'history@university.edu');
GO

-- ================================================
-- Insert Majors
-- ================================================
INSERT INTO Majors (MajorCode, MajorName, DepartmentID, DegreeType, RequiredCredits, Description) VALUES
('CS-BS', 'Computer Science', 1, 'Bachelor', 120, 'Bachelor of Science in Computer Science'),
('CS-MS', 'Computer Science', 1, 'Master', 30, 'Master of Science in Computer Science'),
('MATH-BS', 'Mathematics', 2, 'Bachelor', 120, 'Bachelor of Science in Mathematics'),
('ENG-BA', 'English Literature', 3, 'Bachelor', 120, 'Bachelor of Arts in English'),
('BUS-BS', 'Business Administration', 4, 'Bachelor', 120, 'Bachelor of Science in Business'),
('BUS-MBA', 'Business Administration', 4, 'Master', 36, 'Master of Business Administration'),
('BIOL-BS', 'Biology', 5, 'Bachelor', 120, 'Bachelor of Science in Biology'),
('HIST-BA', 'History', 6, 'Bachelor', 120, 'Bachelor of Arts in History');
GO

-- ================================================
-- Insert Faculty
-- ================================================
INSERT INTO Faculty (FirstName, LastName, Email, Phone, DepartmentID, Title, Office) VALUES
('Robert', 'Martin', 'robert.martin@university.edu', '555-1001', 1, 'Professor', 'Tech 301'),
('Grace', 'Hopper', 'grace.hopper@university.edu', '555-1002', 1, 'Professor', 'Tech 302'),
('Donald', 'Knuth', 'donald.knuth@university.edu', '555-1003', 1, 'Professor', 'Tech 303'),
('Barbara', 'Liskov', 'barbara.liskov@university.edu', '555-1004', 1, 'Associate Professor', 'Tech 304'),
('Edsger', 'Dijkstra', 'edsger.dijkstra@university.edu', '555-1005', 1, 'Assistant Professor', 'Tech 305'),
('Emmy', 'Noether', 'emmy.noether@university.edu', '555-1006', 2, 'Professor', 'Sci 201'),
('Carl', 'Gauss', 'carl.gauss@university.edu', '555-1007', 2, 'Professor', 'Sci 202'),
('Jane', 'Austen', 'jane.austen@university.edu', '555-1008', 3, 'Professor', 'LA 101'),
('Mark', 'Twain', 'mark.twain@university.edu', '555-1009', 3, 'Associate Professor', 'LA 102'),
('Warren', 'Buffett', 'warren.buffett@university.edu', '555-1010', 4, 'Professor', 'BC 401');
GO

-- ================================================
-- Insert Students
-- ================================================
INSERT INTO Students (StudentNumber, FirstName, LastName, Email, Phone, DateOfBirth, MajorID, AdvisorID, EnrollmentDate, ExpectedGraduation, CreditsAttempted, CreditsEarned) VALUES
('S2021001', 'Emma', 'Johnson', 'emma.j@student.edu', '555-2001', '2003-05-15', 1, 1, '2021-09-01', '2025-05-15', 60, 57),
('S2021002', 'Liam', 'Smith', 'liam.s@student.edu', '555-2002', '2003-07-22', 1, 1, '2021-09-01', '2025-05-15', 60, 60),
('S2021003', 'Olivia', 'Williams', 'olivia.w@student.edu', '555-2003', '2003-03-10', 3, 6, '2021-09-01', '2025-05-15', 63, 63),
('S2021004', 'Noah', 'Brown', 'noah.b@student.edu', '555-2004', '2003-11-28', 5, 10, '2021-09-01', '2025-05-15', 60, 54),
('S2022001', 'Ava', 'Davis', 'ava.d@student.edu', '555-2005', '2004-01-14', 1, 2, '2022-09-01', '2026-05-15', 30, 30),
('S2022002', 'Ethan', 'Garcia', 'ethan.g@student.edu', '555-2006', '2004-09-05', 1, 2, '2022-09-01', '2026-05-15', 33, 30),
('S2022003', 'Sophia', 'Martinez', 'sophia.m@student.edu', '555-2007', '2004-06-18', 4, 8, '2022-09-01', '2026-05-15', 30, 30),
('S2022004', 'Mason', 'Rodriguez', 'mason.r@student.edu', '555-2008', '2004-04-25', 7, NULL, '2022-09-01', '2026-05-15', 30, 27),
('S2023001', 'Isabella', 'Hernandez', 'isabella.h@student.edu', '555-2009', '2005-02-12', 1, 3, '2023-09-01', '2027-05-15', 15, 15),
('S2023002', 'James', 'Lopez', 'james.l@student.edu', '555-2010', '2005-08-30', 5, 10, '2023-09-01', '2027-05-15', 18, 15),
('S2023003', 'Mia', 'Gonzalez', 'mia.g@student.edu', '555-2011', '2005-12-07', 3, 6, '2023-09-01', '2027-05-15', 15, 15),
('S2023004', 'Benjamin', 'Wilson', 'ben.w@student.edu', '555-2012', '2005-10-19', 1, 3, '2023-09-01', '2027-05-15', 15, 12),
('S2024001', 'Charlotte', 'Anderson', 'charlotte.a@student.edu', '555-2013', '2006-03-22', 1, 4, '2024-09-01', '2028-05-15', 0, 0),
('S2024002', 'Lucas', 'Thomas', 'lucas.t@student.edu', '555-2014', '2006-07-08', 5, 10, '2024-09-01', '2028-05-15', 0, 0),
('S2024003', 'Amelia', 'Taylor', 'amelia.t@student.edu', '555-2015', '2006-11-14', 1, 4, '2024-09-01', '2028-05-15', 0, 0);
GO

-- ================================================
-- Insert Terms
-- ================================================
INSERT INTO Terms (TermName, TermYear, TermType, StartDate, EndDate, IsCurrentTerm) VALUES
('Fall 2023', 2023, 'Fall', '2023-09-01', '2023-12-15', 0),
('Spring 2024', 2024, 'Spring', '2024-01-15', '2024-05-15', 0),
('Summer 2024', 2024, 'Summer', '2024-06-01', '2024-08-15', 0),
('Fall 2024', 2024, 'Fall', '2024-09-01', '2024-12-15', 1),
('Spring 2025', 2025, 'Spring', '2025-01-15', '2025-05-15', 0);
GO

-- ================================================
-- Insert Courses
-- ================================================
INSERT INTO Courses (CourseCode, CourseName, Description, Credits, DepartmentID, CourseLevel) VALUES
-- Computer Science
('CS101', 'Introduction to Programming', 'Fundamentals of programming using Python', 3, 1, 100),
('CS102', 'Data Structures', 'Introduction to data structures and algorithms', 3, 1, 100),
('CS201', 'Object-Oriented Programming', 'OOP principles using Java', 3, 1, 200),
('CS202', 'Database Systems', 'Relational database design and SQL', 3, 1, 200),
('CS301', 'Algorithms', 'Algorithm design and analysis', 3, 1, 300),
('CS302', 'Operating Systems', 'Operating system concepts and implementation', 3, 1, 300),
('CS401', 'Software Engineering', 'Software development methodologies', 3, 1, 400),
('CS402', 'Artificial Intelligence', 'AI concepts and machine learning', 3, 1, 400),

-- Mathematics
('MATH101', 'Calculus I', 'Differential calculus', 4, 2, 100),
('MATH102', 'Calculus II', 'Integral calculus', 4, 2, 100),
('MATH201', 'Linear Algebra', 'Vector spaces and matrices', 3, 2, 200),
('MATH202', 'Discrete Mathematics', 'Logic, sets, and combinatorics', 3, 2, 200),

-- English
('ENG101', 'English Composition', 'Writing fundamentals', 3, 3, 100),
('ENG201', 'American Literature', 'Survey of American literature', 3, 3, 200),
('ENG301', 'Shakespeare', 'Works of William Shakespeare', 3, 3, 300),

-- Business
('BUS101', 'Introduction to Business', 'Business fundamentals', 3, 4, 100),
('BUS201', 'Accounting I', 'Financial accounting principles', 3, 4, 200),
('BUS301', 'Marketing', 'Marketing strategies and management', 3, 4, 300),

-- Biology
('BIOL101', 'General Biology', 'Introduction to biological concepts', 4, 5, 100),
('BIOL201', 'Genetics', 'Principles of heredity', 4, 5, 200);
GO

-- ================================================
-- Insert Course Prerequisites
-- ================================================
INSERT INTO CoursePrerequisites (CourseID, PrerequisiteCourseID, MinimumGrade) VALUES
-- CS Prerequisites
(3, 1, 'C'),   -- CS201 requires CS101
(4, 1, 'C'),   -- CS202 requires CS101
(5, 2, 'C'),   -- CS301 requires CS102
(5, 3, 'C'),   -- CS301 requires CS201
(6, 2, 'C'),   -- CS302 requires CS102
(7, 3, 'C'),   -- CS401 requires CS201
(7, 5, 'C'),   -- CS401 requires CS301
(8, 5, 'C'),   -- CS402 requires CS301

-- MATH Prerequisites
(10, 9, 'C'),  -- MATH102 requires MATH101
(11, 10, 'C'), -- MATH201 requires MATH102

-- ENG Prerequisites
(14, 13, 'C'); -- ENG201 requires ENG101
GO

-- ================================================
-- Insert Sections (Fall 2024)
-- ================================================
INSERT INTO Sections (CourseID, TermID, SectionNumber, FacultyID, Capacity, Enrolled, Room, MeetingDays, StartTime, EndTime) VALUES
-- CS Courses
(1, 4, '001', 1, 30, 25, 'Tech 101', 'MWF', '09:00', '09:50'),
(1, 4, '002', 2, 30, 28, 'Tech 102', 'MWF', '10:00', '10:50'),
(2, 4, '001', 1, 25, 20, 'Tech 101', 'TTh', '11:00', '12:15'),
(3, 4, '001', 3, 30, 22, 'Tech 201', 'MWF', '13:00', '13:50'),
(4, 4, '001', 4, 25, 18, 'Tech 202', 'TTh', '14:00', '15:15'),
(5, 4, '001', 5, 20, 15, 'Tech 301', 'MWF', '15:00', '15:50'),
(6, 4, '001', 1, 20, 12, 'Tech 101', 'TTh', '16:00', '17:15'),
(7, 4, '001', 3, 15, 8, 'Tech 201', 'MW', '18:00', '19:15'),

-- MATH Courses
(9, 4, '001', 6, 35, 30, 'Sci 101', 'MWF', '09:00', '09:50'),
(9, 4, '002', 7, 35, 32, 'Sci 102', 'MWF', '11:00', '11:50'),
(10, 4, '001', 6, 30, 25, 'Sci 101', 'TTh', '09:30', '10:45'),
(11, 4, '001', 7, 25, 20, 'Sci 201', 'MWF', '14:00', '14:50'),
(12, 4, '001', 6, 30, 28, 'Sci 102', 'TTh', '13:00', '14:15'),

-- ENG Courses
(13, 4, '001', 8, 25, 22, 'LA 201', 'MWF', '10:00', '10:50'),
(13, 4, '002', 9, 25, 20, 'LA 202', 'TTh', '11:00', '12:15'),
(14, 4, '001', 8, 20, 15, 'LA 201', 'MW', '15:00', '16:15'),

-- BUS Courses
(16, 4, '001', 10, 40, 35, 'BC 301', 'MWF', '09:00', '09:50'),
(17, 4, '001', 10, 30, 28, 'BC 302', 'TTh', '14:00', '15:15'),

-- BIOL Courses
(19, 4, '001', NULL, 30, 25, 'Sci 301', 'MW', '10:00', '11:50');
GO

-- ================================================
-- Insert Enrollments with Grades (Past Terms)
-- ================================================
-- Student 1 (Emma Johnson - Junior, CS)
INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Grade, Status) VALUES
-- Fall 2023 (completed)
(1, 1, '2023-08-25', 'A', 'Completed'),
(1, 9, '2023-08-25', 'B+', 'Completed'),
(1, 13, '2023-08-25', 'A-', 'Completed');

-- Student 2 (Liam Smith - Junior, CS)
INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Grade, Status) VALUES
(2, 1, '2023-08-25', 'A', 'Completed'),
(2, 9, '2023-08-25', 'A', 'Completed'),
(2, 13, '2023-08-25', 'B', 'Completed');

-- Student 3 (Olivia Williams - Junior, MATH)
INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Grade, Status) VALUES
(3, 9, '2023-08-25', 'A+', 'Completed'),
(3, 13, '2023-08-25', 'A', 'Completed');

-- Student 4 (Noah Brown - Junior, BUS)
INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Grade, Status) VALUES
(4, 16, '2023-08-25', 'B-', 'Completed'),
(4, 13, '2023-08-25', 'C+', 'Completed');

-- Current Term Enrollments (Fall 2024 - No grades yet)
INSERT INTO Enrollments (StudentID, SectionID, EnrollmentDate, Status) VALUES
(1, 3, '2024-08-20', 'Enrolled'),
(1, 4, '2024-08-20', 'Enrolled'),
(2, 3, '2024-08-20', 'Enrolled'),
(2, 5, '2024-08-20', 'Enrolled'),
(5, 1, '2024-08-20', 'Enrolled'),
(5, 9, '2024-08-20', 'Enrolled'),
(6, 1, '2024-08-20', 'Enrolled'),
(6, 9, '2024-08-20', 'Enrolled'),
(9, 1, '2024-08-20', 'Enrolled'),
(9, 9, '2024-08-20', 'Enrolled'),
(13, 1, '2024-08-20', 'Enrolled'),
(13, 9, '2024-08-20', 'Enrolled');
GO

-- Update student GPAs based on completed courses
UPDATE Students SET CumulativeGPA = 3.70 WHERE StudentID = 1;
UPDATE Students SET CumulativeGPA = 3.67 WHERE StudentID = 2;
UPDATE Students SET CumulativeGPA = 4.00 WHERE StudentID = 3;
UPDATE Students SET CumulativeGPA = 2.50 WHERE StudentID = 4;
GO

-- Update academic standing
UPDATE Students 
SET AcademicStanding = CASE 
    WHEN CumulativeGPA >= 3.5 THEN 'Dean''s List'
    WHEN CumulativeGPA >= 2.0 THEN 'Good Standing'
    ELSE 'Academic Probation'
END
WHERE CreditsEarned > 0;
GO

PRINT 'Sample data inserted successfully!';
PRINT '';
PRINT 'Database Statistics:';

DECLARE @Stats NVARCHAR(MAX);

SELECT @Stats = '- Departments: ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Departments;
PRINT @Stats;

SELECT @Stats = '- Majors: ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Majors;
PRINT @Stats;

SELECT @Stats = '- Faculty: ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Faculty;
PRINT @Stats;

SELECT @Stats = '- Students: ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Students;
PRINT @Stats;

SELECT @Stats = '- Courses: ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Courses;
PRINT @Stats;

SELECT @Stats = '- Sections (Fall 2024): ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Sections WHERE TermID = 4;
PRINT @Stats;

SELECT @Stats = '- Enrollments: ' + CAST(COUNT(*) AS VARCHAR(10)) FROM Enrollments;
PRINT @Stats;

GO
