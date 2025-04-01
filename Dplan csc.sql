-- Create database
USE Dplan;

-- Table for academic years
CREATE TABLE csc_academic_years (
    year_id INT PRIMARY KEY AUTO_INCREMENT,
    year_name VARCHAR(20) NOT NULL UNIQUE
);

-- Table for semesters
CREATE TABLE csc_semesters (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(20) NOT NULL UNIQUE,
    year_id INT NOT NULL,
    FOREIGN KEY (year_id) REFERENCES csc_academic_years(year_id)
);
alter table  csc_semesters add column csc_semester_id int  ;
-- Table for course categories
CREATE TABLE csc_course_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Table for courses
CREATE TABLE csc_courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    credit_hours INT NOT NULL,
    description TEXT,
    FOREIGN KEY (category_id) REFERENCES csc_course_categories(category_id)
);

-- Table for prerequisites
CREATE TABLE csc_prerequisites (
    prerequisite_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    required_course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES csc_courses(course_id),
    FOREIGN KEY (required_course_id) REFERENCES csc_courses(course_id),
    UNIQUE KEY (course_id, required_course_id)
);

-- Table for course offerings
CREATE TABLE csc_course_offerings (
    offering_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    year_id INT NOT NULL,
    is_elective BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (course_id) REFERENCES csc_courses(course_id),
    FOREIGN KEY (semester_id) REFERENCES csc_semesters(semester_id),
    FOREIGN KEY (year_id) REFERENCES csc_academic_years(year_id),
    UNIQUE KEY (course_id, semester_id, year_id)
);

-- Insert academic years
INSERT INTO csc_academic_years (year_name) VALUES 
('Freshman'), ('Sophomore'), ('Junior'), ('Senior');
alter table  csc_semesters add column csc_semester_id int  ;
alter table  csc_semesters add column csc_semester_name varchar;
-- Rename the existing column (more logical than adding a new one)
ALTER TABLE csc_semesters 
CHANGE COLUMN semester_name csc_semester_name VARCHAR(50) NOT NULL UNIQUE;
-- Insert semesters
INSERT ignore INTO csc_semesters (csc_semester_name, year_id) VALUES
-- Freshman
('Fall', 1), ('Spring', 1),
-- Sophomore
('Fall', 2), ('Spring', 2),
-- Junior
('Fall', 3), ('Spring', 3),
-- Senior
('Fall', 4), ('Spring', 4), ('Summer', 4);
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
-- Insert course categories
INSERT IGNORE INTO csc_course_categories (category_name, description) VALUES
('CSC Core', 'Required computer science courses'),
('MTH/PHY Required', 'Required mathematics and physics courses'),
('General Education', 'University core requirements'),
('Advanced CSC', 'Upper-level computer science electives'),
('Free Electives', 'General elective courses');

-- Insert courses
INSERT IGNORE INTO csc_courses (course_code, course_name, category_id, credit_hours, description) VALUES
-- Freshman Year
('CSC 2300', 'Principles of Computer Science', 1, 3, 'Introduction to computer science concepts'),
('CSC 2301', 'Principles of Computer Programming', 1, 3, 'Fundamentals of programming'),
('MTI 1401', 'Calculus I', 2, 4, 'Differential calculus and applications'),
('MTI 1402', 'Calculus II', 2, 4, 'Integral calculus and applications'),
('ART 2305', 'Introduction to Theater', 3, 3, 'Fundamentals of theater arts'),
('HIS 1305', 'African & African-American History', 3, 3, 'Historical survey course'),
('HIS 2205', 'Survey of U.S. History', 3, 3, 'American history overview'),
('ENG 1301', 'English Composition I', 3, 3, 'College-level writing'),
('ENG 1302', 'English Composition II', 3, 3, 'Advanced composition'),
('PNT 1401', 'Principles of Physics I', 2, 4, 'Mechanics and thermodynamics'),

-- Sophomore Year
('CSC 2303', 'Theoretical Foundation of Computer Science', 1, 3, 'Discrete math for CS'),
('MTN2300', 'Theoretical Foundation of Computer Science', 1, 3, 'Alternative course code'),
('CSC 3300', 'Computer Organization & Programming', 1, 3, 'Computer architecture'),
('CSC 3301', 'Operating Systems & Networking', 1, 3, 'OS fundamentals'),
('MTI 1403', 'Calculus III', 2, 4, 'Multivariable calculus'),
('PNT 1403', 'Principles of Physics II', 2, 4, 'Electricity and magnetism'),
('ENG 2201', 'Technical Communication', 3, 3, 'Writing for technical fields'),
('POL 1301', 'U.S. Government', 3, 3, 'American political systems'),
('PNT 3300', 'Electronics', 2, 3, 'Basic electronic circuits'),

-- Junior Year
('CSC 3302', 'Data Structures', 1, 3, 'Data organization and algorithms'),
('CSC 4300', 'Computer Architecture', 1, 3, 'Hardware system design'),
('CSC 4302', 'Wireless Network Systems Administration', 1, 3, 'Networking technologies'),
('MTI 1302', 'Introduction to Linear Algebra', 2, 3, 'Matrix algebra'),
('CSC 4303', 'Programming Language Concepts', 1, 3, 'Language paradigms'),
('CSC 4306', 'Design & Analysis of Algorithms', 1, 3, 'Algorithm efficiency'),
('POL 2315', 'Global Issues', 3, 3, 'International relations'),

-- Senior Year
('CSC 4305', 'Software Engineering', 1, 3, 'Software development lifecycle'),
('CSC 4307', 'Database Systems', 1, 3, 'Database design and implementation'),
('CSC 4493', 'Senior Capstone Project', 1, 3, 'Final year project'),
('CSC 4398', 'Internship', 1, 3, 'Professional work experience'),
-- Advanced electives
('CSC 43XX', 'Advanced Computer Science Elective', 4, 3, 'Specialized CS topic');

-- Insert prerequisites
INSERT IGNORE INTO csc_prerequisites (course_id, required_course_id) VALUES
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2301'), (SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2300')),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3300'), (SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2301')),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3301'), (SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2301')),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3302'), (SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2301')),
((SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1402'), (SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1401')),
((SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1403'), (SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1402')),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4300'), (SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3300')),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4306'), (SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3302'));

SET UNIQUE_CHECKS = 0;
-- Your insert statement
SET UNIQUE_CHECKS = 1;

INSERT IGNORE INTO csc_course_offerings 
(course_id, semester_id, year_id, is_elective) 
VALUES 
(31, 6, 3, 0);


INSERT INTO csc_course_offerings 
(course_id, semester_id, year_id, is_elective) 
VALUES 
(31, 6, 3, 0)
ON DUPLICATE KEY UPDATE is_elective = VALUES(is_elective);

INSERT INTO csc_course_offerings (course_id, semester_id, year_id, is_elective)
SELECT 31, 6, 3, 0
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM csc_course_offerings 
    WHERE course_id = 31 AND semester_id = 6 AND year_id = 3
);

SELECT * FROM csc_course_offerings 
WHERE course_id = 31 AND semester_id = 6 AND year_id = 3;
-- Insert course offerings
INSERT IGNORE INTO csc_course_offerings (course_id, semester_id, year_id, is_elective) VALUES
-- Freshman Fall
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2300'), 1, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1401'), 1, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'ART 2305'), 1, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'HIS 1305'), 1, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'ENG 1301'), 1, 1, 0),

-- Freshman Spring
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2301'), 2, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1402'), 2, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'PNT 1401'), 2, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'HIS 2205'), 2, 1, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'ENG 1302'), 2, 1, 0),

-- Sophomore Fall
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 2303'), 3, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1403'), 3, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'PNT 1403'), 3, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'ENG 2201'), 3, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'POL 1301'), 3, 2, 0),

-- Sophomore Spring
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3300'), 4, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3301'), 4, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'PNT 3300'), 4, 2, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'POL 2315'), 4, 2, 0),

-- Junior Fall
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 3302'), 5, 3, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4300'), 5, 3, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'MTI 1302'), 5, 3, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4302'), 5, 3, 0),

-- Junior Spring
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4303'), 6, 3, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4306'), 6, 3, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 43XX'), 6, 3, 1), -- Elective
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 43XX'), 6, 3, 1), -- Elective

-- Senior Fall
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4305'), 7, 4, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4307'), 7, 4, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 43XX'), 7, 4, 1), -- Elective
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 43XX'), 7, 4, 1), -- Elective

-- Senior Spring
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4493'), 8, 4, 0),
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 43XX'), 8, 4, 1), -- Elective
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 43XX'), 8, 4, 1), -- Elective

-- Senior Summer
((SELECT course_id FROM csc_courses WHERE course_code = 'CSC 4398'), 9, 4, 0);

select course_id as course.name , semester_id as semester.name* from csc_course_offerings;