use Dplan;

-- Create database schema for IUGB BA Political Science program
CREATE DATABASE IF NOT EXISTS DPlan_IUGB_BA_POL;
 

-- Create tables for program structure with precise naming
CREATE TABLE IF NOT EXISTS pol_University_Core (
    core_id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    alternatives VARCHAR(255),
    semester_available VARCHAR(50),
    CONSTRAINT uc_pol_core_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS pol_Major_Requirements (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_core BOOLEAN DEFAULT TRUE,
    is_advanced BOOLEAN DEFAULT FALSE,
    prerequisites VARCHAR(100),
    recommended_year ENUM('Freshman','Sophomore','Junior','Senior'),
    recommended_semester ENUM('Fall','Spring','Summer'),
    CONSTRAINT uc_pol_major_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS pol_BSS_Requirements (
    bss_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    semester_available VARCHAR(50),
    CONSTRAINT uc_pol_bss_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS pol_Minor_Options (
    minor_id INT PRIMARY KEY AUTO_INCREMENT,
    minor_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    total_credits INT NOT NULL,
    CONSTRAINT uc_pol_minor UNIQUE (minor_name)
);

CREATE TABLE IF NOT EXISTS pol_Degree_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year INT NOT NULL,
    semester ENUM('Fall','Spring','Summer') NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    requirement_type ENUM('University Core','Major Core','Major Advanced','BSS','Minor','Elective') NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completion_date DATE,
    grade VARCHAR(2),
    FOREIGN KEY (course_code) REFERENCES pol_University_Core(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES pol_Major_Requirements(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES pol_BSS_Requirements(course_code) ON UPDATE CASCADE,
    INDEX idx_pol_degree_plan (academic_year, semester)
);

-- Insert University Core Requirements with political science focus
INSERT INTO pol_University_Core (category, course_code, course_name, credits, is_required, alternatives, semester_available)
VALUES
-- Government and Political Science related cores first
('Government', 'POL 1301', 'Intro to American Gov''t', 3, TRUE, NULL, 'Fall,Spring'),
('Government', 'POL 2315', 'Global Issues', 3, TRUE, NULL, 'Fall,Spring,Summer'),

-- Other cores
('Communications', 'ENG 1301', 'English Composition I', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Communications', 'ENG 1302', 'English Composition II', 3, TRUE, 'ENG 1301', 'Fall,Spring,Summer'),
('Mathematics', 'MTH 1301', 'College Algebra', 3, FALSE, 'MTH 1303 or MTH 1401', 'Fall,Spring'),
('Mathematics', 'MTH 1303', 'Pre-Calculus', 3, FALSE, 'MTH 1301 or MTH 1401', 'Fall,Spring'),
('Mathematics', 'MTH 1401', 'Calculus I', 4, FALSE, 'MTH 1301 or MTH 1303', 'Fall,Spring'),
('Mathematics Reasoning', 'MTH 1300', 'Statistics I', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Natural Sciences', 'BIO 1401', 'Principles of Biology I', 4, FALSE, 'CHE 1401 or ENV 1401 or PHY 1401', 'Fall'),
('Natural Sciences', 'BIO 1402', 'Principles of Biology II', 4, FALSE, NULL, 'Spring'),
('History', 'HIS 1305', 'Introduction to African & African-American History', 3, FALSE, 'HIS 2305', 'Fall,Spring'),
('History', 'HIS 2305', 'Survey of US History', 3, FALSE, 'HIS 1305', 'Fall,Spring'),
('Arts', 'ART 2301', 'Contemporary African Art', 3, FALSE, 'ART 1302 or ART 1303 or ART 2305', 'Fall'),
('Writing', 'COM 2301', 'Technical communication', 3, TRUE, NULL, 'Fall,Spring,Summer');

-- Insert BSS Requirements with political science relevance
INSERT INTO pol_BSS_Requirements (course_code, course_name, credits, semester_available)
VALUES
('CIS 2301', 'Intro to Comp-based Inf Syst.', 3, 'Fall,Spring'),
('BUS 3300', 'Global Business Practices', 3, 'Fall,Spring'),
('POL 3325', 'Global Ethics', 3, 'Spring'),
('MGS 4315', 'Principles of Leadership', 3, 'Fall');

-- Insert Major Requirements with precise sequencing
INSERT INTO pol_Major_Requirements (course_code, course_name, credits, is_core, is_advanced, prerequisites, recommended_year, recommended_semester)
VALUES
-- Core Political Science Sequence
('POL 2301', 'Intro to Political Science', 3, TRUE, FALSE, NULL, 'Freshman', 'Spring'),
('POL 3310', 'Comparative Politics', 3, TRUE, FALSE, 'POL 2301', 'Sophomore', 'Fall'),
('POL 3315', 'Political Theory', 3, TRUE, FALSE, 'POL 2301', 'Sophomore', 'Spring'),
('POL 3320', 'International Relations', 3, TRUE, FALSE, 'POL 2301', 'Junior', 'Fall'),
('POL 3330', 'Intro. to Political Research', 3, TRUE, FALSE, 'MTH 1300', 'Junior', 'Spring'),

-- Advanced Political Science Courses
('POL 4311', 'African Politics', 3, FALSE, TRUE, 'POL 3310', 'Junior', 'Fall'),
('POL 4326', 'International Organizations', 3, FALSE, TRUE, 'POL 3320', 'Junior', 'Spring'),
('POL 4322', 'International Political Econ', 3, FALSE, TRUE, 'POL 3320', 'Senior', 'Fall'),
('POL 4350', 'Diplomatic Simulations', 3, FALSE, TRUE, 'POL 3320', 'Senior', 'Spring'),

-- Capstone and Internship
('POL 4398', 'Internship', 3, TRUE, FALSE, 'Junior standing', 'Senior', 'Fall'),
('POL 4499', 'Capstone', 4, TRUE, FALSE, 'Senior standing', 'Senior', 'Spring');

-- Insert Minor Options common for Political Science students
INSERT INTO pol_Minor_Options (minor_name, department, total_credits)
VALUES
('International Relations', 'Political Science', 18),
('Public Administration', 'Political Science', 18),
('Economics', 'Business', 18),
('African Studies', 'History', 18);

-- Create optimized 4-year degree plan in pol_Degree_Plan
-- Year 1 (Freshman)
INSERT INTO pol_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(1, 'Fall', 'ENG 1301', 'English Composition I', 3, 'University Core'),
(1, 'Fall', 'POL 1301', 'Intro to American Gov''t', 3, 'University Core'),
(1, 'Fall', 'HIS 1305', 'African & African-American History', 3, 'University Core'),
(1, 'Fall', 'MTH 1301', 'College Algebra', 3, 'University Core'),

(1, 'Spring', 'ENG 1302', 'English Composition II', 3, 'University Core'),
(1, 'Spring', 'POL 2301', 'Intro to Political Science', 3, 'Major Core'),
(1, 'Spring', 'ART 2301', 'Contemporary African Art', 3, 'University Core'),
(1, 'Spring', 'MTH 1300', 'Statistics I', 3, 'University Core'),

(1, 'Summer', 'COM 2301', 'Technical communication', 3, 'University Core'),
(1, 'Summer', 'BIO 1401', 'Principles of Biology I', 4, 'University Core');

-- Year 2 (Sophomore)
INSERT INTO pol_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(2, 'Fall', 'POL 3310', 'Comparative Politics', 3, 'Major Core'),
(2, 'Fall', 'POL 2315', 'Global Issues', 3, 'University Core'),
(2, 'Fall', 'CIS 2301', 'Intro to Comp-based Inf Syst.', 3, 'BSS'),
(2, 'Fall', 'HIS 2305', 'Survey of US History', 3, 'University Core'),

(2, 'Spring', 'POL 3315', 'Political Theory', 3, 'Major Core'),
(2, 'Spring', 'BUS 3300', 'Global Business Practices', 3, 'BSS'),
(2, 'Spring', 'BIO 1402', 'Principles of Biology II', 4, 'University Core'),

(2, 'Summer', 'POL 3325', 'Global Ethics', 3, 'BSS');

-- Year 3 (Junior)
INSERT INTO pol_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(3, 'Fall', 'POL 3320', 'International Relations', 3, 'Major Core'),
(3, 'Fall', 'POL 4311', 'African Politics', 3, 'Major Advanced'),
(3, 'Fall', 'POL 3330', 'Intro. to Political Research', 3, 'Major Core'),

(3, 'Spring', 'POL 4326', 'International Organizations', 3, 'Major Advanced'),
(3, 'Spring', 'MGS 4315', 'Principles of Leadership', 3, 'BSS'),
(3, 'Spring', 'MINOR 101', 'Minor Course 1', 3, 'Minor'),

(3, 'Summer', 'MINOR 102', 'Minor Course 2', 3, 'Minor');

-- Year 4 (Senior)
INSERT INTO pol_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(4, 'Fall', 'POL 4398', 'Internship', 3, 'Major Core'),
(4, 'Fall', 'POL 4322', 'International Political Econ', 3, 'Major Advanced'),
(4, 'Fall', 'MINOR 103', 'Minor Course 3', 3, 'Minor'),

(4, 'Spring', 'POL 4499', 'Capstone', 4, 'Major Core'),
(4, 'Spring', 'POL 4350', 'Diplomatic Simulations', 3, 'Major Advanced'),
(4, 'Spring', 'MINOR 104', 'Minor Course 4', 3, 'Minor'),

(4, 'Summer', 'ELECT 101', 'General Elective', 3, 'Elective'),
(4, 'Summer', 'ELECT 102', 'General Elective', 3, 'Elective');