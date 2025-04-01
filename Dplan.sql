-- Create database
CREATE DATABASE Dplan;
USE Dplan;

-- Table: Course Categories (MET, Math, Physics, Core, Electives)
CREATE TABLE course_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(255) UNIQUE NOT NULL
);

-- Table: Semesters (Fall, Spring, Summer)
CREATE TABLE semester (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: Year Levels (Freshman, Sophomore, Junior, Senior)
CREATE TABLE year_level (
    year_id INT PRIMARY KEY AUTO_INCREMENT,
    year_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: Courses
CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT, 
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    category_id INT,
    credit_hours INT,
    FOREIGN KEY (category_id) REFERENCES course_category(category_id) ON DELETE CASCADE
);

-- Table: Course Schedule (Links course to semester & year level)
CREATE TABLE course_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    semester_id INT,
    year_id INT,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semester(semester_id) ON DELETE CASCADE,
    FOREIGN KEY (year_id) REFERENCES year_level(year_id) ON DELETE CASCADE
);

-- Insert Course Categories
INSERT INTO course_category (category_name) VALUES
('MET Courses'), 
('Required MTH/PHY Courses'), 
('Core and Electives');

-- Insert Semesters
INSERT INTO semester (semester_name) VALUES
('Fall'), 
('Spring'), 
('Summer');

-- Insert Year Levels
INSERT INTO year_level (year_name) VALUES
('Freshman'), 
('Sophomore'), 
('Junior'), 
('Senior');

-- Insert Courses
INSERT INTO course (course_code, course_name, category_id, credit_hours) VALUES
('CSC 2300', 'Principles of Computer Science', 2, 3),
('MET 1364', 'Materials & Processes', 1, 3),
('MET 2354', 'Introduction to Mechanics', 1, 3),
('MET 3340', 'Engineering Graphics & CAD', 1, 3),
('MET 3355', 'Strength of Materials/Lab', 1, 3),
('MET 3365', 'Computer-Aided Design I', 1, 3),
('MET 3331', 'Applied Thermodynamics', 1, 3),
('MET 4372', 'Materials Technology/Lab', 1, 3),
('MET 4188', 'Ethics in Engineering Technology', 1, 3),
('MET 3360', 'Auto-Manufacturing Systems', 1, 3),
('MET 3367', 'Quality Control Technology', 1, 3),
('MET 4493', 'Senior Capstone Project', 1, 3),
('MET 4398', 'Internship', 1, 3),
('MTH 1401', 'Calculus I', 2, 4),
('MTH 1402', 'Calculus II', 2, 4),
('MTH 1403', 'Calculus III', 2, 4),
('MTH 2302', 'Introduction to Linear Algebra', 2, 3),
('PHY 1401', 'Principles of Physics I', 2, 4),
('PHY 1402', 'Principles of Physics II', 2, 4),
('CSC 2301', 'Principles of Computer Programming', 2, 3),
('CHE 1401', 'Principles of Chemistry', 2, 3),
('ART 2305', 'Introduction to Theater', 3, 3),
('HIS 1305', 'African & African-American History', 3, 3),
('HIS 2305', 'Survey of U.S. History', 3, 3),
('ENG 1301', 'English Composition I', 3, 3),
('ENG 1302', 'English Composition II', 3, 3),
('ENG 2301', 'Technical Communication', 3, 3),
('POL 1301', 'U.S. Government', 3, 3),
('POL 2315', 'Global Issues', 3, 3),
('PHY 3300', 'Electronics', 3, 3);
-- Check if all referenced courses exist
SELECT * FROM course 
WHERE course_id IN (1, 2, 14, 15, 22, 19, 24, 25, 26, 27, 3, 4, 16, 20, 28, 30, 29, 31, 5, 6, 7, 17, 21, 32, 33, 8, 9, 10, 11, 12, 13);

-- Check if all referenced semesters exist
SELECT * FROM semester WHERE semester_id IN (1, 2, 3);

-- Check if all referenced year levels exist
SELECT * FROM year_level WHERE year_id IN (1, 2, 3, 4);
-- Drop the existing table (only if needed)
DROP TABLE IF EXISTS course_schedule;

-- Create course_schedule with proper foreign keys
CREATE TABLE course_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    year_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semester(semester_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (year_id) REFERENCES year_level(year_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE course AUTO_INCREMENT = 1;
ALTER TABLE semester AUTO_INCREMENT = 1;
SHOW VARIABLES LIKE 'foreign_key_checks';
SET FOREIGN_KEY_CHECKS = 0;

-- Insert Course Schedule
INSERT INTO course_schedule (course_id, semester_id, year_id) VALUES
(1, 1, 1), (2, 2, 1), (14, 1, 1), (15, 2, 1), 
(22, 1, 1), (19, 2, 1), (24, 1, 1), (25, 2, 1), 
(26, 1, 1), (27, 2, 1),
(3, 1, 2), (4, 2, 2), (16, 1, 2), (20, 2, 2), 
(28, 1, 2), (30, 2, 2), (29, 1, 2), (31, 2, 2)
,(5, 1, 3), (6, 2, 3), (7, 1, 3), (17, 2, 3), 
(21, 1, 3), (32, 1, 3), (33, 2, 3),

-- Senior Year
(8, 1, 4), (9, 2, 4), (10, 1, 4), (11, 2, 4), 
(12, 3, 4), (13, 3, 4) ;

-- Query: Retrieve Course Schedule
SELECT c.course_code, c.course_name, cat.category_name, s.semester_name, y.year_name
FROM course_schedule cs
JOIN course c ON cs.course_id = c.course_id
JOIN semester s ON cs.semester_id = s.semester_id
JOIN year_level y ON cs.year_id = y.year_id
JOIN course_category cat ON c.category_id = cat.category_id
ORDER BY y.year_id, s.semester_id;

select * from course_id;


use Dplan;

-- Table for academic year levels
CREATE TABLE math_year_level (
    year_id INT PRIMARY KEY AUTO_INCREMENT,
    year_name VARCHAR(50) NOT NULL UNIQUE
);

-- Table for semesters
CREATE TABLE math_semester (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(20) NOT NULL UNIQUE
);

-- Table for courses
CREATE TABLE math_courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    category ENUM('Math Major', 'CSC/PHY Required', 'Core & Elective') NOT NULL,
    credit_hours INT NOT NULL
);

-- Table for course schedule (mapping courses to semesters and year levels)
CREATE TABLE math_course_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    year_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES math_courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES math_semester(semester_id) ON DELETE CASCADE,
    FOREIGN KEY (year_id) REFERENCES math_year_level(year_id) ON DELETE CASCADE
);

INSERT INTO math_year_level (year_name) VALUES
('Freshman'), ('Sophomore'), ('Junior'), ('Senior');

INSERT INTO math_semester (semester_name) VALUES
('Fall'), ('Spring'), ('summer');
alter math_semster (semester_name) values ('Fall'), ('Spring'), ('summer')

INSERT INTO math_courses (course_code, course_name, category, credit_hours) VALUES
('MTH 1401', 'Calculus I', 'Math Major', 4),
('MTH 1402', 'Calculus II', 'Math Major', 4),
('CSC 2300', 'Principles of Computer Science', 'CSC/PHY Required', 3),
('CSC 2301', 'Principles of Computer Programming', 'CSC/PHY Required', 3),
('PHY 1401', 'Principles of Physics I', 'CSC/PHY Required', 4),
('PHY 1402', 'Principles of Physics II', 'CSC/PHY Required', 4),
('MTH 2300', 'Discrete Mathematics', 'Math Major', 3),
('MTH 2302', 'Introduction to Linear Algebra', 'Math Major', 3),
('MTH 3300', 'Differential Equations', 'Math Major', 3),
('MTH 3303', 'Intermediate Analysis', 'Math Major', 3),
('MTH 3304', 'Numerical Analysis I', 'Math Major', 3),
('MTH 4301', 'Transforms in Applied Mathematics', 'Math Major', 3),
('MTH 4302', 'Introduction to Stochastic Processes', 'Math Major', 3),
('MTH 4303', 'Linear Algebra', 'Math Major', 3),
('MTH 4305', 'Real Analysis I', 'Math Major', 3),
('MTH 4306', 'Real Analysis II', 'Math Major', 3),
('MTH 4333', 'Internship Course', 'Math Major', 3),
('MTH 4499', 'Senior Capstone Project', 'Math Major', 3),
('MTH 43XX', 'Concentration Course', 'Math Major', 3),
('ART 2305', 'Introduction to Theater', 'Core & Elective', 3),
('HIS 2305', 'African & African-American History', 'Core & Elective', 3),
('ENG 1301', 'English Composition I', 'Core & Elective', 3),
('ENG 1302', 'English Composition II', 'Core & Elective', 3),
('ENG 2301', 'Technical Communication', 'Core & Elective', 3),
('POL 1301', 'U.S. Government', 'Core & Elective', 3),
('POL 2315', 'Global Issues', 'Core & Elective', 3),
('Social Sciences', 'Social Sciences Course', 'Core & Elective', 3),
('Humanities', 'Humanities Course', 'Core & Elective', 3),
('Elective', 'Elective Course', 'Core & Elective', 3);

INSERT INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 1401'), 1, 1),  -- Fall
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 1402'), 2, 1),  -- Spring
((SELECT course_id FROM math_courses WHERE course_code = 'CSC 2300'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'CSC 2301'), 2, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'PHY 1401'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'PHY 1402'), 2, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'ART 2305'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'ENG 1301'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'ENG 1302'), 2, 1);

-- Sophomore Year
INSERT INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 2300'), 1, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3300'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3303'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 2302'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'POL 1301'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'POL 2315'), 2, 2);

-- Junior Year
INSERT INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4305'), 1, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4306'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4301'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4302'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4303'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'Humanities'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'Elective'), 2, 3);

-- Senior Year
INSERT INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 43XX'), 1, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 43XX'), 2, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4333'), 2, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4499'), 2, 4);

select * from math_course_schedule

SELECT c.course_code, c.course_name, cat.category_name AS Category, math_semester.semester_name AS Semester, 
math_year_level.year_name AS Year_Level FROM math_course_schedule cs
JOIN math_courses c ON cs.course_id = c.course_id
JOIN math_semester s ON cs.semester_id = s.semester_id
JOIN math_year_level y ON cs.year_id = y.year_id
JOIN math_course_category cat ON c.category_id = cat.category_id
ORDER BY y.year_id, s.semester_id;
