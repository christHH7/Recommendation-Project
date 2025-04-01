-- Create database
CREATE DATABASE IF NOT EXISTS Dplan;
USE Dplan;

-- Table for academic years
CREATE TABLE dsc_academic_years (
    year_id INT PRIMARY KEY AUTO_INCREMENT,
    year_name VARCHAR(20) NOT NULL UNIQUE -- Freshman, Sophomore, etc.
);

-- Table for semesters
CREATE TABLE dsc_semesters (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(20) NOT NULL UNIQUE, -- Fall, Spring, Summer
    year_id INT NOT NULL,
    FOREIGN KEY (year_id) REFERENCES dsc_academic_years(year_id)
);

-- Table for course categories
CREATE TABLE dsc_course_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE, -- Core, Program, Advanced, etc.
    description TEXT
);

-- Table for courses
CREATE TABLE dsc_course (
    course_code VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    category_id INT NOT NULL,
    description TEXT,
    FOREIGN KEY (category_id) REFERENCES dsc_course_categories(category_id)
);

-- Table for prerequisites
CREATE TABLE dsc_prerequisites (
    prerequisite_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    required_course_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (course_code) REFERENCES dsc_course(course_code),
    FOREIGN KEY (required_course_code) REFERENCES dsc_course(course_code),
    UNIQUE KEY (course_code, required_course_code)
);

-- Table for course offerings
CREATE TABLE dsc_course_offerings (
    offering_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    year_id INT NOT NULL,
    semester_id INT NOT NULL,
    is_elective BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (course_code) REFERENCES dsc_course(course_code),
    FOREIGN KEY (year_id) REFERENCES dsc_academic_years(year_id),
    FOREIGN KEY (semester_id) REFERENCES dsc_semesters(semester_id),
    UNIQUE KEY (course_code, year_id, semester_id)
);

-- Insert academic years
INSERT INTO dsc_academic_years (year_name) VALUES 
('Freshman'), ('Sophomore'), ('Junior'), ('Senior');

-- Insert semesters
INSERT INTO dsc_semesters (semester_name, year_id) VALUES
-- Freshman
('Fall', 1), ('Spring', 1),
-- Sophomore
('Fall', 2), ('Spring', 2),
-- Junior
('Fall', 3), ('Spring', 3),
-- Senior
('Fall', 4), ('Spring', 4), ('Summer', 4);

-- Insert course categories
INSERT INTO dsc_course_categories (category_name, description) VALUES
('University Core', 'General education requirements'),
('Program Requirements', 'Fundamental data science courses'),
('Major Requirements', 'Core data science curriculum'),
('Advanced Courses', 'Specialized upper-level courses'),
('Electives', 'Optional courses for specialization');

-- Insert courses (sample - would include all from your curriculum)
INSERT INTO dsc_course (course_code, course_name, credits, category_id) VALUES
-- University Core
('ENG 1301', 'English Composition I', 3, 1),
('ENG 1302', 'English Composition II', 3, 1),
('MTH 1401', 'Calculus I', 4, 1),
('PHY 1401', 'Principles of Physics I', 4, 1),
('PHY 1402', 'Principles of Physics II', 4, 1),
('HIS 1305', 'African & African-American History', 3, 1),
('HIS 2305', 'Survey of US History', 3, 1),
('ART 2305', 'Introduction to Theater', 3, 1),
('POL 1301', 'US Government', 3, 1),
('POL 2315', 'Global Issues', 3, 1),
('COM 2301', 'Technical Communication', 3, 1),

-- Program Requirements
('MTH 1402', 'Calculus II', 4, 2),
('MTH 2302', 'Intro to Linear Algebra', 3, 2),
('CSC 2300', 'Principles of Computer Science', 3, 2),
('CSC 3302', 'Data Structures', 3, 2),
('STA 3300', 'Exploratory Data Analysis & Graphics', 3, 2),
('STA 3301', 'Analysis of Variance & Design Experiments', 3, 2),

-- Major Requirements
('DSC 2301', 'Principles of Data Science (Python & SQL)', 3, 3),
('DSC 2302', 'R Programming for Data Science', 3, 3),
('DSC 3300', 'Data Warehousing', 3, 3),
('DSC 3301', 'Intro to Machine Learning', 3, 3),
('DSC 4305', 'Data Analytics', 3, 3),
('DSC 4311', 'Data Mining Techniques', 3, 3),
('DSC 4315', 'Intro to Artificial Intelligence', 3, 3),
('DSC 4320', 'Computer Graphics & Data Visualization', 3, 3),
('DSC 4333', 'Internship', 3, 3),
('DSC 4499', 'Capstone', 4, 3),

-- Advanced Courses
('DSC 4498', 'Special Topics in Data Science', 4, 4),
('CIS 4305', 'Intro to Business Intelligence', 3, 4),
('MTH 4311', 'Operations Research', 3, 4),
('STA 4300', 'Applied Regression Analysis', 3, 4),
('STA 4301', 'Applied Statistical Methods', 3, 4),
('STA 4302', 'Monte-Carlo Simulation & Resampling Methods', 3, 4),
('STA 4303', 'Non-Parametric Statistics', 3, 4);

-- Temporarily disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Insert prerequisites (sample)
INSERT INTO dsc_prerequisites (course_code, required_course_code) VALUES
('MTH 1402', 'MTH 1401'),
('CSC 3302', 'CSC 2300'),
('DSC 3301', 'STA 3300'),
('DSC 4305', 'DSC 2301'),
('DSC 4311', 'DSC 4305'),
('MTH 4311', 'MTH 1403'),
('CIS 4305', 'CSC 2300');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert course offerings (sample sequence)
INSERT INTO dsc_course_offerings (course_code, year_id, semester_id, is_elective) VALUES
-- Freshman Fall
('ENG 1301', 1, 1, FALSE),
('MTH 1401', 1, 1, FALSE),
('PHY 1401', 1, 1, FALSE),
('HIS 1305', 1, 1, FALSE),
('ART 2305', 1, 1, FALSE),

-- Freshman Spring
('ENG 1302', 1, 2, FALSE),
('MTH 1402', 1, 2, FALSE),
('PHY 1402', 1, 2, FALSE),
('HIS 2305', 1, 2, FALSE),
('POL 1301', 1, 2, FALSE),

-- Sophomore Fall
('MTH 2302', 2, 3, FALSE),
('CSC 2300', 2, 3, FALSE),
('STA 3300', 2, 3, FALSE),
('POL 2315', 2, 3, FALSE),
('COM 2301', 2, 3, FALSE),

-- Sophomore Spring
('CSC 3302', 2, 4, FALSE),
('STA 3301', 2, 4, FALSE),
('DSC 2302', 2, 4, FALSE),
('DSC 2301', 2, 4, FALSE),

-- Junior Fall
('DSC 3301', 3, 5, FALSE),
('DSC 3300', 3, 5, FALSE),
('DSC 4320', 3, 5, FALSE),
('DSC 4498', 3, 5, TRUE), -- Elective

-- Junior Spring
('DSC 4305', 3, 6, FALSE),
('DSC 4311', 3, 6, FALSE),
('DSC 4315', 3, 6, FALSE),
('STA 4300', 3, 6, TRUE), -- Elective

-- Senior Fall
('DSC 4333', 4, 7, FALSE),
('CIS 4305', 4, 7, TRUE), -- Elective
('MTH 4311', 4, 7, TRUE), -- Elective
('STA 4301', 4, 7, TRUE), -- Elective

-- Senior Spring
('DSC 4499', 4, 8, FALSE),
('STA 4302', 4, 8, TRUE), -- Elective
('STA 4303', 4, 8, TRUE), -- Elective

-- Senior Summer
('DSC 4499', 4, 9, FALSE); -- Capstone continuation if needed
select * from dsc_course_offerings ;