 USE Dplan;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Table for academic year levels
CREATE TABLE IF NOT EXISTS math_year_level (
    year_id INT PRIMARY KEY AUTO_INCREMENT,
    year_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for semesters
CREATE TABLE IF NOT EXISTS math_semester (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for course categories
CREATE TABLE IF NOT EXISTS math_course_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for courses
CREATE TABLE IF NOT EXISTS math_courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    credit_hours INT NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES math_course_category(category_id)
);
ALTER TABLE math_courses
ADD COLUMN category_id INT ;
ALTER TABLE math_courses
ADD COLUMN description text ;

-- Table for prerequisites
CREATE TABLE IF NOT EXISTS math_prerequisites (
    prerequisite_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    required_course_id INT NOT NULL,
    is_strict BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES math_courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (required_course_id) REFERENCES math_courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY (course_id, required_course_id)
);

-- Table for course schedule (mapping courses to semesters and year levels)
CREATE TABLE IF NOT EXISTS math_course_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    year_id INT NOT NULL,
    is_elective BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES math_courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES math_semester(semester_id) ON DELETE CASCADE,
    FOREIGN KEY (year_id) REFERENCES math_year_level(year_id) ON DELETE CASCADE,
    UNIQUE KEY (course_id, semester_id, year_id)
);

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert year levels
INSERT IGNORE INTO math_year_level (year_name) VALUES
('Freshman'), ('Sophomore'), ('Junior'), ('Senior');

-- Insert semesters
INSERT IGNORE INTO math_semester (semester_name) VALUES
('Fall'), ('Spring'), ('Summer');

-- Insert course categories
INSERT IGNORE INTO math_course_category (category_name, description) VALUES
('Math Major', 'Core mathematics courses required for the major'),
('CSC/PHY Required', 'Required computer science and physics courses'),
('Core & Elective', 'General education and elective courses');

-- Insert courses with proper category references
INSERT IGNORE INTO math_courses (course_code, course_name, category_id, credit_hours, description) VALUES
-- Math Major courses
('MTH 1401', 'Calculus I', 1, 4, 'Introduction to differential and integral calculus'),
('MTH 1402', 'Calculus II', 1, 4, 'Continuation of Calculus I with integration techniques and applications'),
('MTH 2300', 'Discrete Mathematics', 1, 3, 'Fundamentals of discrete structures and proof techniques'),
('MTH 2302', 'Introduction to Linear Algebra', 1, 3, 'Matrix algebra and vector spaces'),
('MTH 3300', 'Differential Equations', 1, 3, 'Ordinary differential equations and applications'),
('MTH 3303', 'Intermediate Analysis', 1, 3, 'Rigorous treatment of calculus concepts'),
('MTH 3304', 'Numerical Analysis I', 1, 3, 'Numerical methods for mathematical problems'),
('MTH 4301', 'Transforms in Applied Mathematics', 1, 3, 'Fourier and Laplace transforms with applications'),
('MTH 4302', 'Introduction to Stochastic Processes', 1, 3, 'Probability models for random processes'),
('MTH 4303', 'Linear Algebra', 1, 3, 'Advanced treatment of vector spaces and linear transformations'),
('MTH 4305', 'Real Analysis I', 1, 3, 'Rigorous study of real numbers and functions'),
('MTH 4306', 'Real Analysis II', 1, 3, 'Continuation of Real Analysis I'),
('MTH 4333', 'Internship Course', 1, 3, 'Practical experience in mathematical applications'),
('MTH 4499', 'Senior Capstone Project', 1, 3, 'Final research or applied project'),
('MTH 43XX', 'Concentration Course', 1, 3, 'Specialized course in student\'s concentration area'),

-- CSC/PHY Required courses
('CSC 2300', 'Principles of Computer Science', 2, 3, 'Fundamentals of computer science and programming'),
('CSC 2301', 'Principles of Computer Programming', 2, 3, 'Programming concepts and problem solving'),
('PHY 1401', 'Principles of Physics I', 2, 4, 'Mechanics, heat, and waves'),
('PHY 1402', 'Principles of Physics II', 2, 4, 'Electricity, magnetism, and optics'),

-- Core & Elective courses
('ART 2305', 'Introduction to Theater', 3, 3, 'Fundamentals of theater arts'),
('HIS 2305', 'African & African-American History', 3, 3, 'Survey of African and African-American history'),
('ENG 1301', 'English Composition I', 3, 3, 'College-level writing and rhetoric'),
('ENG 1302', 'English Composition II', 3, 3, 'Advanced composition and research writing'),
('ENG 2301', 'Technical Communication', 3, 3, 'Writing for technical and professional contexts'),
('POL 1301', 'U.S. Government', 3, 3, 'Structure and function of American government'),
('POL 2315', 'Global Issues', 3, 3, 'Analysis of contemporary international problems'),
('SOC 1301', 'Social Sciences Course', 3, 3, 'General social science elective'),
('HUM 1301', 'Humanities Course', 3, 3, 'General humanities elective'),
('ELE 1301', 'Elective Course', 3, 3, 'General elective course');

-- Insert prerequisites (after all courses are inserted)
INSERT IGNORE INTO math_prerequisites (course_id, required_course_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 1402'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 1401')),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 2300'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 1401')),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 2302'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 1402')),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3300'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 1402')),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3303'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 1402')),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4305'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 3303')),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4306'), (SELECT course_id FROM math_courses WHERE course_code = 'MTH 4305')),
((SELECT course_id FROM math_courses WHERE course_code = 'CSC 2301'), (SELECT course_id FROM math_courses WHERE course_code = 'CSC 2300')),
((SELECT course_id FROM math_courses WHERE course_code = 'PHY 1402'), (SELECT course_id FROM math_courses WHERE course_code = 'PHY 1401'));

-- Insert course schedule (using transactions for safety)
START TRANSACTION;

-- Freshman Year
INSERT IGNORE INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 1401'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'CSC 2300'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'PHY 1401'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'ART 2305'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'ENG 1301'), 1, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 1402'), 2, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'CSC 2301'), 2, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'PHY 1402'), 2, 1),
((SELECT course_id FROM math_courses WHERE course_code = 'ENG 1302'), 2, 1);

-- Sophomore Year
INSERT IGNORE INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 2300'), 1, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 2302'), 1, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'HIS 2305'), 1, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3300'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3303'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'POL 1301'), 2, 2),
((SELECT course_id FROM math_courses WHERE course_code = 'POL 2315'), 2, 2);

-- Junior Year
INSERT IGNORE INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4305'), 1, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 3304'), 1, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'ENG 2301'), 1, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4306'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4301'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4302'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'HUM 1301'), 2, 3),
((SELECT course_id FROM math_courses WHERE course_code = 'ELE 1301'), 2, 3);

-- Senior Year
INSERT IGNORE INTO math_course_schedule (course_id, semester_id, year_id) VALUES
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 43XX'), 1, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4303'), 1, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'SOC 1301'), 1, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 43XX'), 2, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4333'), 2, 4),
((SELECT course_id FROM math_courses WHERE course_code = 'MTH 4499'), 2, 4);

COMMIT;

-- Query to view the complete schedule
SELECT 
    math_year_level AS 'Year',
    s.semester_name AS 'Semester',
    c.course_code,
    c.course_name,
    cat.category_name AS 'Category',
    c.credit_hours
FROM 
    math_course_schedule , math_year_level , math_semester where semester_id=1;
select * from math_course_schedule;