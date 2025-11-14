# 📚 Student Information System (SIS)

> A comprehensive academic database management system for educational institutions

[![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![Database Design](https://img.shields.io/badge/Database-Design-blue)](https://github.com/vitugo23/Student-Information-System)
[![Academic](https://img.shields.io/badge/Domain-Education-green)](https://github.com/vitugo23/Student-Information-System)

## Table of Contents

- [Overview](#overview)
- [My Contributions](#my-contributions)
- [Features](#features)
- [Database Schema](#database-schema)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Setup Instructions](#setup-instructions)
- [Sample Queries](#sample-queries)
- [Stored Procedures](#stored-procedures)
- [Views](#views)
- [Technologies Used](#technologies-used)

## Overview

The Student Information System is a complete relational database designed for managing academic operations in educational institutions. It handles student enrollment, course management, grade tracking, GPA calculations, and comprehensive academic reporting.

This project demonstrates advanced SQL concepts including recursive queries for prerequisites, computed columns for GPA, temporal data tracking, and complex academic business logic.

### Key Highlights

- **Complete Academic Management** - Students, courses, enrollments, grades
- **Automated GPA Calculation** - Real-time GPA tracking with triggers
- **Course Prerequisites** - Hierarchical prerequisite system
- **Transcript Generation** - Official transcript with cumulative GPA
- **Academic Analytics** - Performance tracking, dean's list, probation alerts
- **Department Management** - Faculty assignments, course offerings
- **Enrollment Validation** - Prerequisite checking, capacity limits
- **Grade Distribution** - Statistical analysis and reports

## My Contributions

**Role**: Database Architect & SQL Developer

### Core Responsibilities

#### 🗄️ Database Design & Architecture
- Designed normalized database schema following 3NF principles
- Created comprehensive **Entity-Relationship model** for academic domain
- Implemented **referential integrity** with cascading updates
- Designed temporal tables for grade change tracking
- Established **naming conventions** and documentation standards

#### Complex Business Logic Implementation
- Built **GPA calculation engine** using triggers and computed columns
- Implemented **course prerequisite validation** with recursive queries
- Created **enrollment capacity management** system
- Developed **academic standing determination** (Dean's List, Probation)
- Automated **transcript generation** with cumulative statistics

#### 🔧 Advanced SQL Features
- **Triggers**: Automatic GPA recalculation on grade changes
- **Computed Columns**: Real-time GPA calculations
- **CTEs & Recursion**: Prerequisites chain validation
- **Window Functions**: Class rankings, percentiles
- **Temporal Queries**: Grade history tracking
- **Transactions**: Enrollment with validation

#### Academic Analytics & Reporting
- **Student Performance Dashboards**: GPA trends, credit tracking
- **Course Analytics**: Pass rates, grade distributions
- **Faculty Reports**: Teaching load, student evaluations
- **Department Metrics**: Enrollment statistics, program health
- **Predictive Analysis**: At-risk student identification

#### 🛡️ Data Integrity & Validation
- Implemented **check constraints** for grade validation
- Created **unique indexes** for student/course identification
- Built **enrollment validation** stored procedures
- Established **audit trails** for grade changes
- Designed **soft delete** patterns for historical data

### Technical Skills Demonstrated

```
✓ Advanced Database Design         ✓ Recursive CTEs
✓ Trigger Development              ✓ Window Functions (RANK, DENSE_RANK)
✓ Complex JOINs (5+ tables)        ✓ Aggregate Functions
✓ Stored Procedures                ✓ Transaction Management
✓ Views & Materialized Views       ✓ Performance Optimization
✓ Computed Columns                 ✓ Temporal Data Tracking
✓ Constraint Design                ✓ Academic Domain Modeling
```

### Code Samples

**Automatic GPA Calculation Trigger**:
```sql
CREATE TRIGGER trg_UpdateGPA
ON Enrollments
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Students
    SET CumulativeGPA = (
        SELECT SUM(c.Credits * g.GradePoints) / SUM(c.Credits)
        FROM Enrollments e
        INNER JOIN Courses c ON e.CourseID = c.CourseID
        INNER JOIN Grades g ON e.Grade = g.LetterGrade
        WHERE e.StudentID = Students.StudentID
        AND e.Grade IS NOT NULL
    )
    WHERE StudentID IN (
        SELECT DISTINCT StudentID FROM inserted
        UNION
        SELECT DISTINCT StudentID FROM deleted
    );
END;
```

**Prerequisite Validation with Recursive CTE**:
```sql
WITH PrerequisiteChain AS (
    SELECT CourseID, PrerequisiteID, 1 AS Level
    FROM CoursePrerequisites
    WHERE CourseID = @TargetCourse
    
    UNION ALL
    
    SELECT cp.CourseID, cp.PrerequisiteID, pc.Level + 1
    FROM CoursePrerequisites cp
    INNER JOIN PrerequisiteChain pc ON cp.CourseID = pc.PrerequisiteID
)
SELECT * FROM PrerequisiteChain;
```

**Class Ranking with Window Functions**:
```sql
SELECT 
    StudentID,
    StudentName,
    CumulativeGPA,
    RANK() OVER (PARTITION BY Major ORDER BY CumulativeGPA DESC) AS MajorRank,
    PERCENT_RANK() OVER (ORDER BY CumulativeGPA DESC) AS Percentile
FROM Students;
```

---

## Features

### Student Management
- Student registration and profile management
- Academic standing tracking (Good Standing, Probation, Dean's List)
- Cumulative GPA calculation
- Credit hour tracking (attempted, earned)
- Major and advisor assignment
- Student contact information

### Course Management
- Course catalog with descriptions
- Course prerequisites hierarchy
- Course capacity and enrollment limits
- Section management (multiple sections per course)
- Course scheduling (day, time, location)
- Department and faculty assignment

### Enrollment System
- Online course enrollment
- Prerequisite validation
- Capacity checking
- Waitlist management
- Drop/Add functionality
- Enrollment history

### Grading System
- Letter grade assignment (A, B, C, D, F)
- Grade point scale (4.0)
- Plus/minus grading (+/-)
- Incomplete and Withdrawal grades
- Grade change tracking
- Academic probation alerts

### Academic Analytics
- Student transcripts
- GPA calculations (term and cumulative)
- Dean's List generation
- Course grade distributions
- Faculty teaching reports
- Department enrollment statistics
- At-risk student identification

## 🗄️ Database Schema

### Core Tables

1. **Students** - Student demographic and academic information
2. **Departments** - Academic departments
3. **Majors** - Degree programs
4. **Faculty** - Instructors and advisors
5. **Courses** - Course catalog
6. **CoursePrerequisites** - Course dependencies
7. **Sections** - Course sections with schedule
8. **Enrollments** - Student course registrations
9. **Grades** - Grade scale definitions
10. **Terms** - Academic terms (Fall, Spring, Summer)
11. **ClassSchedule** - Meeting times and locations
12. **AcademicStanding** - Student status history

### Database Statistics

- **12 Core Tables** with normalized relationships
- **100+ Sample Records** representing realistic academic data
- **20+ Complex Queries** demonstrating SQL proficiency
- **10 Stored Procedures** for business operations
- **8 Views** for reporting and analytics
- **5 Triggers** for automated calculations
- **Multiple Indexes** for query optimization

## Entity Relationship Diagram

```
┌─────────────────┐          ┌─────────────────┐
│   Departments   │          │     Terms       │
├─────────────────┤          ├─────────────────┤
│ DepartmentID PK │          │ TermID PK       │
│ DepartmentName  │          │ TermName        │
│ DepartmentCode  │          │ StartDate       │
└─────────────────┘          │ EndDate         │
        │                    └─────────────────┘
        │ 1:N                        │
        ▼                            │ 1:N
┌─────────────────┐                  │
│     Majors      │                  │
├─────────────────┤                  │
│ MajorID PK      │                  │
│ MajorName       │                  │
│ DepartmentID FK │                  │
└─────────────────┘                  │
        │                            │
        │ 1:N                        │
        ▼                            ▼
┌─────────────────┐          ┌─────────────────┐
│    Students     │          │    Sections     │
├─────────────────┤          ├─────────────────┤
│ StudentID PK    │          │ SectionID PK    │
│ FirstName       │          │ CourseID FK     │
│ LastName        │          │ TermID FK       │
│ Email           │          │ FacultyID FK    │
│ MajorID FK      │          │ Capacity        │
│ AdvisorID FK    │          │ Enrolled        │
│ CumulativeGPA   │          │ Schedule        │
│ CreditsEarned   │          └─────────────────┘
│ AcademicStanding│                  │
└─────────────────┘                  │
        │                            │
        │ N:M                        │
        ▼                            │
┌─────────────────┐                  │
│  Enrollments    │◄─────────────────┘
├─────────────────┤
│ EnrollmentID PK │
│ StudentID FK    │
│ SectionID FK    │
│ Grade           │
│ EnrollmentDate  │
│ Status          │
└─────────────────┘

┌─────────────────┐          ┌─────────────────┐
│    Courses      │          │     Faculty     │
├─────────────────┤          ├─────────────────┤
│ CourseID PK     │          │ FacultyID PK    │
│ CourseCode      │          │ FirstName       │
│ CourseName      │          │ LastName        │
│ Credits         │          │ DepartmentID FK │
│ DepartmentID FK │          │ Email           │
│ Description     │          │ Title           │
└─────────────────┘          └─────────────────┘
        │
        │ Self-Referencing
        ▼
┌──────────────────────┐
│ CoursePrerequisites  │
├──────────────────────┤
│ CourseID FK          │
│ PrerequisiteID FK    │
└──────────────────────┘

┌─────────────────┐
│     Grades      │
├─────────────────┤
│ GradeID PK      │
│ LetterGrade     │
│ GradePoints     │
│ Description     │
└─────────────────┘
```

## Setup Instructions

### Prerequisites

- **SQL Server** 2019 or later (Express, Developer, or Enterprise)
- **SQL Server Management Studio (SSMS)** or **Azure Data Studio**
- Basic SQL knowledge

### Installation Steps

#### 1. Clone or Download the Repository

```bash
git clone https://github.com/vitugo23/Student-Information-System.git
cd Student-Information-System
```

#### 2. Execute SQL Scripts in Order

**Option A: Run Master Setup Script**
```sql
-- Open SSMS or Azure Data Studio
-- Connect to your SQL Server
-- Open and execute setup.sql
-- This will run all scripts in the correct order
```

**Option B: Run Scripts Individually**
```sql
-- 1. Create database and schema
:r schema.sql

-- 2. Insert sample data
:r sample-data.sql

-- 3. Create stored procedures
:r stored-procedures.sql

-- 4. Create views
:r views.sql

-- 5. Create triggers
:r triggers.sql

-- 6. Create indexes
:r indexes.sql
```

#### 3. Verify Installation

```sql
USE StudentInformationSystem;
GO

-- Check tables
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Verify data
SELECT 
    (SELECT COUNT(*) FROM Students) AS Students,
    (SELECT COUNT(*) FROM Courses) AS Courses,
    (SELECT COUNT(*) FROM Enrollments) AS Enrollments,
    (SELECT COUNT(*) FROM Faculty) AS Faculty;

-- Test a view
SELECT * FROM vw_StudentTranscript WHERE StudentID = 1;
```

## Sample Queries

### Basic Queries

#### Get Student Information with Major
```sql
SELECT 
    s.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    s.Email,
    m.MajorName,
    d.DepartmentName,
    s.CumulativeGPA,
    s.CreditsEarned,
    s.AcademicStanding
FROM Students s
INNER JOIN Majors m ON s.MajorID = m.MajorID
INNER JOIN Departments d ON m.DepartmentID = d.DepartmentID
ORDER BY s.LastName, s.FirstName;
```

#### Current Course Enrollments
```sql
SELECT 
    c.CourseCode,
    c.CourseName,
    COUNT(e.EnrollmentID) AS EnrolledStudents,
    s.Capacity,
    s.Capacity - COUNT(e.EnrollmentID) AS AvailableSeats
FROM Sections s
INNER JOIN Courses c ON s.CourseID = c.CourseID
LEFT JOIN Enrollments e ON s.SectionID = e.SectionID
WHERE s.TermID = (SELECT TermID FROM Terms WHERE TermName = 'Fall 2024')
GROUP BY c.CourseCode, c.CourseName, s.Capacity
ORDER BY c.CourseCode;
```

### Intermediate Queries

#### Student GPA Calculation with Rankings
```sql
SELECT 
    s.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    m.MajorName,
    CAST(s.CumulativeGPA AS DECIMAL(3,2)) AS GPA,
    s.CreditsEarned,
    RANK() OVER (ORDER BY s.CumulativeGPA DESC) AS OverallRank,
    RANK() OVER (PARTITION BY s.MajorID ORDER BY s.CumulativeGPA DESC) AS MajorRank,
    CASE 
        WHEN s.CumulativeGPA >= 3.5 THEN 'Dean''s List'
        WHEN s.CumulativeGPA >= 2.0 THEN 'Good Standing'
        ELSE 'Academic Probation'
    END AS Status
FROM Students s
INNER JOIN Majors m ON s.MajorID = m.MajorID
WHERE s.CreditsEarned > 0
ORDER BY s.CumulativeGPA DESC;
```

#### Course Grade Distribution
```sql
SELECT 
    c.CourseCode,
    c.CourseName,
    e.Grade,
    COUNT(*) AS StudentCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY c.CourseID) AS DECIMAL(5,2)) AS Percentage
FROM Courses c
INNER JOIN Sections s ON c.CourseID = s.CourseID
INNER JOIN Enrollments e ON s.SectionID = e.SectionID
WHERE e.Grade IS NOT NULL
  AND s.TermID = (SELECT TermID FROM Terms WHERE TermName = 'Fall 2024')
GROUP BY c.CourseID, c.CourseCode, c.CourseName, e.Grade
ORDER BY c.CourseCode, e.Grade;
```

### Advanced Queries

#### Prerequisite Chain Validation (Recursive CTE)
```sql
WITH RECURSIVE PrerequisiteChain AS (
    -- Base case: direct prerequisites
    SELECT 
        c.CourseID,
        c.CourseCode,
        c.CourseName,
        cp.PrerequisiteID,
        p.CourseCode AS PrereqCode,
        p.CourseName AS PrereqName,
        1 AS Level
    FROM Courses c
    INNER JOIN CoursePrerequisites cp ON c.CourseID = cp.CourseID
    INNER JOIN Courses p ON cp.PrerequisiteID = p.CourseID
    WHERE c.CourseCode = 'CS301'
    
    UNION ALL
    
    -- Recursive case: prerequisites of prerequisites
    SELECT 
        pc.CourseID,
        pc.CourseCode,
        pc.CourseName,
        cp.PrerequisiteID,
        p.CourseCode,
        p.CourseName,
        pc.Level + 1
    FROM PrerequisiteChain pc
    INNER JOIN CoursePrerequisites cp ON pc.PrerequisiteID = cp.CourseID
    INNER JOIN Courses p ON cp.PrerequisiteID = p.CourseID
)
SELECT 
    Level,
    PrereqCode,
    PrereqName,
    'Required for: ' + CourseCode AS Requirement
FROM PrerequisiteChain
ORDER BY Level, PrereqCode;
```

#### At-Risk Student Identification
```sql
WITH StudentPerformance AS (
    SELECT 
        s.StudentID,
        s.FirstName + ' ' + s.LastName AS StudentName,
        s.Email,
        s.CumulativeGPA,
        s.CreditsEarned,
        COUNT(e.EnrollmentID) AS CurrentCourses,
        AVG(CASE 
            WHEN g.GradePoints < 2.0 THEN 1.0 
            ELSE 0.0 
        END) AS FailingRate,
        SUM(CASE 
            WHEN e.Grade IN ('D', 'F', 'W') THEN 1 
            ELSE 0 
        END) AS ProblematicGrades
    FROM Students s
    LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
    LEFT JOIN Sections sec ON e.SectionID = sec.SectionID
    LEFT JOIN Terms t ON sec.TermID = t.TermID
    LEFT JOIN Grades g ON e.Grade = g.LetterGrade
    WHERE t.TermName = 'Fall 2024'
    GROUP BY s.StudentID, s.FirstName, s.LastName, s.Email, s.CumulativeGPA, s.CreditsEarned
)
SELECT 
    StudentID,
    StudentName,
    Email,
    CAST(CumulativeGPA AS DECIMAL(3,2)) AS GPA,
    CreditsEarned,
    CurrentCourses,
    ProblematicGrades,
    CASE 
        WHEN CumulativeGPA < 2.0 THEN 'Critical - Probation'
        WHEN FailingRate > 0.3 THEN 'High Risk - Current Performance'
        WHEN ProblematicGrades >= 2 THEN 'Moderate Risk - Multiple Issues'
        ELSE 'Low Risk'
    END AS RiskLevel
FROM StudentPerformance
WHERE CumulativeGPA < 2.5 OR FailingRate > 0.2 OR ProblematicGrades >= 2
ORDER BY CumulativeGPA ASC, FailingRate DESC;
```

#### Faculty Teaching Load Analysis
```sql
SELECT 
    f.FacultyID,
    f.FirstName + ' ' + f.LastName AS FacultyName,
    d.DepartmentName,
    COUNT(DISTINCT s.SectionID) AS SectionsTeaching,
    SUM(c.Credits) AS TotalCredits,
    SUM(s.Enrolled) AS TotalStudents,
    AVG(CAST(s.Enrolled AS FLOAT) / s.Capacity) AS AvgClassCapacityUsage
FROM Faculty f
INNER JOIN Departments d ON f.DepartmentID = d.DepartmentID
LEFT JOIN Sections s ON f.FacultyID = s.FacultyID
LEFT JOIN Courses c ON s.CourseID = c.CourseID
LEFT JOIN Terms t ON s.TermID = t.TermID
WHERE t.TermName = 'Fall 2024'
GROUP BY f.FacultyID, f.FirstName, f.LastName, d.DepartmentName
ORDER BY TotalCredits DESC;
```

## Stored Procedures

### sp_EnrollStudent
Enrolls a student in a course section with validation

```sql
EXEC sp_EnrollStudent 
    @StudentID = 1, 
    @SectionID = 5;
```

### sp_AssignGrade
Assigns or updates a grade for a student enrollment

```sql
EXEC sp_AssignGrade 
    @EnrollmentID = 10, 
    @Grade = 'A';
```

### sp_GenerateTranscript
Generates official transcript for a student

```sql
EXEC sp_GenerateTranscript @StudentID = 1;
```

### sp_CheckPrerequisites
Validates if student has completed prerequisites

```sql
EXEC sp_CheckPrerequisites 
    @StudentID = 1, 
    @CourseID = 15;
```

### sp_CalculateGPA
Recalculates cumulative GPA for a student

```sql
EXEC sp_CalculateGPA @StudentID = 1;
```

### sp_GenerateDeansList
Generates Dean's List for a term

```sql
EXEC sp_GenerateDeansList @TermID = 1;
```

## Views

### vw_StudentTranscript
Complete academic transcript with all courses and grades
```sql
SELECT * FROM vw_StudentTranscript WHERE StudentID = 1;
```

### vw_CurrentEnrollments
Current term enrollments across all students
```sql
SELECT * FROM vw_CurrentEnrollments;
```

### vw_CourseOfferings
Available courses with enrollment status
```sql
SELECT * FROM vw_CourseOfferings WHERE TermName = 'Fall 2024';
```

### vw_FacultySchedule
Faculty teaching assignments and schedules
```sql
SELECT * FROM vw_FacultySchedule WHERE FacultyID = 1;
```

### vw_DepartmentStatistics
Enrollment and performance metrics by department
```sql
SELECT * FROM vw_DepartmentStatistics;
```

### vw_StudentPerformance
Student performance metrics and academic standing
```sql
SELECT * FROM vw_StudentPerformance ORDER BY CumulativeGPA DESC;
```

## Technologies Used

- **SQL Server** - Relational database management system
- **T-SQL** - Transact-SQL for queries and procedures
- **Database Design** - Normalization, ERD, relationships
- **Triggers** - Automated GPA calculations
- **Computed Columns** - Real-time calculations
- **Recursive CTEs** - Prerequisite chain analysis
- **Window Functions** - Rankings and analytics
- **Indexes** - Performance optimization

## Skills Demonstrated

```
✓ Academic Domain Modeling          ✓ Recursive Queries (CTEs)
✓ Normalized Database Design        ✓ Window Functions
✓ Trigger Development               ✓ Computed Columns
✓ Complex Business Logic            ✓ Transaction Management
✓ GPA Calculation Algorithms        ✓ Data Validation
✓ Constraint Design                 ✓ Temporal Data Tracking
✓ Stored Procedures                 ✓ Performance Tuning
✓ Analytical Views                  ✓ Report Generation
```
---

