-- ================================================
-- Student Information System - Database Schema
-- Author: Victor Torres
-- Description: Academic database for educational institutions
-- ================================================

USE master;
GO

-- Drop database if exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'StudentInformationSystem')
BEGIN
    ALTER DATABASE StudentInformationSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE StudentInformationSystem;
END
GO

-- Create database
CREATE DATABASE StudentInformationSystem;
GO

USE StudentInformationSystem;
GO

-- ================================================
-- Table: Departments
-- Description: Academic departments
-- ================================================
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentCode NVARCHAR(10) UNIQUE NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    DepartmentHead NVARCHAR(100),
    Building NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ================================================
-- Table: Majors
-- Description: Degree programs offered
-- ================================================
CREATE TABLE Majors (
    MajorID INT IDENTITY(1,1) PRIMARY KEY,
    MajorCode NVARCHAR(10) UNIQUE NOT NULL,
    MajorName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    DegreeType NVARCHAR(20) CHECK (DegreeType IN ('Associate', 'Bachelor', 'Master', 'Doctorate')),
    RequiredCredits INT NOT NULL,
    Description NVARCHAR(MAX),
    CONSTRAINT FK_Majors_Department FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
);
GO

-- ================================================
-- Table: Faculty
-- Description: Instructors and advisors
-- ================================================
CREATE TABLE Faculty (
    FacultyID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    DepartmentID INT NOT NULL,
    Title NVARCHAR(50) CHECK (Title IN ('Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer', 'Instructor')),
    HireDate DATE DEFAULT GETDATE(),
    Office NVARCHAR(50),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Faculty_Department FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
);
GO

-- ================================================
-- Table: Students
-- Description: Student demographic and academic information
-- ================================================
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentNumber NVARCHAR(20) UNIQUE NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    DateOfBirth DATE,
    MajorID INT,
    AdvisorID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    ExpectedGraduation DATE,
    CumulativeGPA DECIMAL(3,2) DEFAULT 0.00 CHECK (CumulativeGPA BETWEEN 0.00 AND 4.00),
    CreditsAttempted INT DEFAULT 0,
    CreditsEarned INT DEFAULT 0,
    AcademicStanding NVARCHAR(20) DEFAULT 'Good Standing' 
        CHECK (AcademicStanding IN ('Good Standing', 'Dean''s List', 'Academic Probation', 'Academic Suspension')),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Students_Major FOREIGN KEY (MajorID) 
        REFERENCES Majors(MajorID),
    CONSTRAINT FK_Students_Advisor FOREIGN KEY (AdvisorID) 
        REFERENCES Faculty(FacultyID)
);
GO

-- ================================================
-- Table: Terms
-- Description: Academic terms/semesters
-- ================================================
CREATE TABLE Terms (
    TermID INT IDENTITY(1,1) PRIMARY KEY,
    TermName NVARCHAR(50) NOT NULL,
    TermYear INT NOT NULL,
    TermType NVARCHAR(20) CHECK (TermType IN ('Fall', 'Spring', 'Summer', 'Winter')),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsCurrentTerm BIT DEFAULT 0,
    CONSTRAINT CHK_Term_Dates CHECK (EndDate > StartDate)
);
GO

-- ================================================
-- Table: Courses
-- Description: Course catalog
-- ================================================
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode NVARCHAR(20) UNIQUE NOT NULL,
    CourseName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    Credits INT NOT NULL CHECK (Credits BETWEEN 1 AND 6),
    DepartmentID INT NOT NULL,
    CourseLevel INT CHECK (CourseLevel IN (100, 200, 300, 400, 500, 600)),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Courses_Department FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
);
GO

-- ================================================
-- Table: CoursePrerequisites
-- Description: Course prerequisite relationships
-- ================================================
CREATE TABLE CoursePrerequisites (
    PrerequisiteID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    PrerequisiteCourseID INT NOT NULL,
    MinimumGrade NVARCHAR(2) DEFAULT 'D',
    CONSTRAINT FK_Prerequisites_Course FOREIGN KEY (CourseID) 
        REFERENCES Courses(CourseID),
    CONSTRAINT FK_Prerequisites_PrereqCourse FOREIGN KEY (PrerequisiteCourseID) 
        REFERENCES Courses(CourseID),
    CONSTRAINT CHK_No_Self_Prerequisite CHECK (CourseID <> PrerequisiteCourseID),
    CONSTRAINT UQ_Prerequisite UNIQUE (CourseID, PrerequisiteCourseID)
);
GO

-- ================================================
-- Table: Sections
-- Description: Course sections offered in specific terms
-- ================================================
CREATE TABLE Sections (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    TermID INT NOT NULL,
    SectionNumber NVARCHAR(10) NOT NULL,
    FacultyID INT,
    Capacity INT NOT NULL DEFAULT 30 CHECK (Capacity > 0),
    Enrolled INT DEFAULT 0 CHECK (Enrolled >= 0),
    Room NVARCHAR(50),
    MeetingDays NVARCHAR(20),
    StartTime TIME,
    EndTime TIME,
    CONSTRAINT FK_Sections_Course FOREIGN KEY (CourseID) 
        REFERENCES Courses(CourseID),
    CONSTRAINT FK_Sections_Term FOREIGN KEY (TermID) 
        REFERENCES Terms(TermID),
    CONSTRAINT FK_Sections_Faculty FOREIGN KEY (FacultyID) 
        REFERENCES Faculty(FacultyID),
    CONSTRAINT CHK_Capacity CHECK (Enrolled <= Capacity),
    CONSTRAINT UQ_Section UNIQUE (CourseID, TermID, SectionNumber)
);
GO

-- ================================================
-- Table: Grades
-- Description: Grade scale definitions
-- ================================================
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    LetterGrade NVARCHAR(2) UNIQUE NOT NULL,
    GradePoints DECIMAL(3,2) NULL,  -- NULL for grades like W, I, P
    Description NVARCHAR(50)
);
GO

-- Insert grade scale
INSERT INTO Grades (LetterGrade, GradePoints, Description) VALUES
('A+', 4.00, 'Excellent'),
('A', 4.00, 'Excellent'),
('A-', 3.70, 'Excellent'),
('B+', 3.30, 'Good'),
('B', 3.00, 'Good'),
('B-', 2.70, 'Good'),
('C+', 2.30, 'Satisfactory'),
('C', 2.00, 'Satisfactory'),
('C-', 1.70, 'Satisfactory'),
('D+', 1.30, 'Poor'),
('D', 1.00, 'Poor'),
('F', 0.00, 'Fail'),
('W', NULL, 'Withdraw'),
('I', NULL, 'Incomplete'),
('P', NULL, 'Pass'),
('NP', NULL, 'No Pass');
GO

-- ================================================
-- Table: Enrollments
-- Description: Student course registrations
-- ================================================
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATETIME DEFAULT GETDATE(),
    Grade NVARCHAR(2),
    Status NVARCHAR(20) DEFAULT 'Enrolled' 
        CHECK (Status IN ('Enrolled', 'Dropped', 'Completed', 'Withdrawn')),
    CONSTRAINT FK_Enrollments_Student FOREIGN KEY (StudentID) 
        REFERENCES Students(StudentID),
    CONSTRAINT FK_Enrollments_Section FOREIGN KEY (SectionID) 
        REFERENCES Sections(SectionID),
    CONSTRAINT FK_Enrollments_Grade FOREIGN KEY (Grade) 
        REFERENCES Grades(LetterGrade),
    CONSTRAINT UQ_Enrollment UNIQUE (StudentID, SectionID)
);
GO

-- ================================================
-- Table: AcademicStandingHistory
-- Description: Track changes in student academic standing
-- ================================================
CREATE TABLE AcademicStandingHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    TermID INT NOT NULL,
    AcademicStanding NVARCHAR(20) NOT NULL,
    GPA DECIMAL(3,2),
    ChangeDate DATETIME DEFAULT GETDATE(),
    Notes NVARCHAR(500),
    CONSTRAINT FK_History_Student FOREIGN KEY (StudentID) 
        REFERENCES Students(StudentID),
    CONSTRAINT FK_History_Term FOREIGN KEY (TermID) 
        REFERENCES Terms(TermID)
);
GO

-- ================================================
-- Create Indexes for Performance
-- ================================================

-- Student indexes
CREATE INDEX IX_Students_Major ON Students(MajorID);
CREATE INDEX IX_Students_Advisor ON Students(AdvisorID);
CREATE INDEX IX_Students_GPA ON Students(CumulativeGPA DESC);
CREATE INDEX IX_Students_Active ON Students(IsActive);

-- Enrollment indexes
CREATE INDEX IX_Enrollments_Student ON Enrollments(StudentID);
CREATE INDEX IX_Enrollments_Section ON Enrollments(SectionID);
CREATE INDEX IX_Enrollments_Status ON Enrollments(Status);
CREATE INDEX IX_Enrollments_Grade ON Enrollments(Grade);

-- Section indexes
CREATE INDEX IX_Sections_Course ON Sections(CourseID);
CREATE INDEX IX_Sections_Term ON Sections(TermID);
CREATE INDEX IX_Sections_Faculty ON Sections(FacultyID);

-- Course indexes
CREATE INDEX IX_Courses_Department ON Courses(DepartmentID);
CREATE INDEX IX_Courses_Level ON Courses(CourseLevel);
CREATE INDEX IX_Courses_Active ON Courses(IsActive);

-- Composite indexes for common queries
CREATE INDEX IX_Sections_CourseTerm ON Sections(CourseID, TermID);
CREATE INDEX IX_Students_Major_GPA ON Students(MajorID, CumulativeGPA DESC);

PRINT 'Database schema created successfully!';
GO
