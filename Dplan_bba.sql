 
USE DPlan ;

-- Create tables for program structure with business-specific naming
CREATE TABLE IF NOT EXISTS bba_University_Core (
    core_id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    alternatives VARCHAR(255),
    semester_available VARCHAR(50),
    CONSTRAINT uc_bba_core_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS bba_Major_Requirements (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_core BOOLEAN DEFAULT TRUE,
    is_concentration BOOLEAN DEFAULT FALSE,
    concentration_area VARCHAR(50),
    prerequisites VARCHAR(100),
    recommended_year ENUM('Freshman','Sophomore','Junior','Senior'),
    recommended_semester ENUM('Fall','Spring','Summer'),
    CONSTRAINT uc_bba_major_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS bba_BSS_Requirements (
    bss_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    semester_available VARCHAR(50),
    CONSTRAINT uc_bba_bss_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS bba_Concentrations (
    concentration_id INT PRIMARY KEY AUTO_INCREMENT,
    concentration_name VARCHAR(50) NOT NULL,
    required_credits INT NOT NULL DEFAULT 12,
    mandatory_courses VARCHAR(255),
    CONSTRAINT uc_bba_concentration UNIQUE (concentration_name)
);

CREATE TABLE IF NOT EXISTS bba_Degree_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year INT NOT NULL,
    semester ENUM('Fall','Spring','Summer') NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    requirement_type ENUM('University Core','Major Core','Concentration','BSS','Elective') NOT NULL,
    concentration_area VARCHAR(50),
    is_completed BOOLEAN DEFAULT FALSE,
    completion_date DATE,
    grade VARCHAR(2),
    FOREIGN KEY (course_code) REFERENCES bba_University_Core(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES bba_Major_Requirements(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES bba_BSS_Requirements(course_code) ON UPDATE CASCADE,
    INDEX idx_bba_degree_plan (academic_year, semester)
);

-- Insert University Core Requirements with business focus
INSERT INTO bba_University_Core (category, course_code, course_name, credits, is_required, alternatives, semester_available)
VALUES
-- Business-relevant cores first
('Mathematics', 'MTH 1301', 'College Algebra', 3, FALSE, 'MTH 1303 or MTH 1401', 'Fall,Spring'),
('Mathematics', 'MTH 1303', 'Pre-Calculus', 3, FALSE, 'MTH 1301 or MTH 1401', 'Fall,Spring'),
('Mathematics', 'MTH 1401', 'Calculus I', 4, FALSE, 'MTH 1301 or MTH 1303', 'Fall,Spring'),
('Mathematics Reasoning', 'MTH 1300', 'Statistics I', 3, TRUE, NULL, 'Fall,Spring,Summer'),

-- Other cores
('Communications', 'ENG 1301', 'English Composition I', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Communications', 'ENG 1302', 'English Composition II', 3, TRUE, 'ENG 1301', 'Fall,Spring,Summer'),
('Government', 'POL 1301', 'Intro to American Gov''t', 3, TRUE, NULL, 'Fall,Spring'),
('Government', 'POL 2315', 'Global Issues', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Writing', 'COM 2301', 'Technical communication', 3, TRUE, NULL, 'Fall,Spring,Summer');

-- Insert BSS Requirements with business relevance
INSERT IGNORE INTO bba_BSS_Requirements (course_code, course_name, credits, semester_available)
VALUES
('CIS 2301', 'Intro to Comp-based Inf Syst.', 3, 'Fall,Spring'),
('BUS 3300', 'Global Business Practices', 3, 'Fall,Spring'),
('BUS 3320', 'Business Ethics', 3, 'Spring'),
('MGS 4315', 'Principles of Leadership', 3, 'Fall');

-- Insert Major Requirements with business focus
 -- Corrected INSERT statement for bba_Major_Requirements
INSERT INTO bba_Major_Requirements (course_code, course_name, credits, is_core, is_concentration, concentration_area, prerequisites, recommended_year, recommended_semester)
VALUES
-- Core Business Requirements
('ACT 2301', 'Principles of Accounting I', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Fall'),
('ACT 2302', 'Principles of Accounting II', 3, TRUE, FALSE, NULL, 'ACT 2301', 'Sophomore', 'Spring'),
('BUS 3305', 'Business Law', 3, TRUE, FALSE, NULL, 'Junior standing', 'Junior', 'Fall'),
('ECO 2306', 'Principles of Macro Econ', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Fall'),
('ECO 2106', 'Principles of Micro Econ', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Spring'),
('FIN 3305', 'Corporate Finance', 3, TRUE, FALSE, NULL, 'ACT 2301, ACT 2302', 'Junior', 'Spring'),
('MGS 3301', 'Principles of Management', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Fall'),
('MGS 3302', 'Business & Entrepreneurship', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Spring'),
('MGS 3310', 'Business Analysis', 3, TRUE, FALSE, NULL, 'MTH 1300', 'Junior', 'Fall'),
('MGS 3313', 'Organizational Behavior', 3, TRUE, FALSE, NULL, 'MGS 3301', 'Junior', 'Spring'),
('MKT 3301', 'Principles of Marketing', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Spring'),
('MGS 4310', 'Managing Human Resources', 3, TRUE, FALSE, NULL, 'MGS 3301', 'Senior', 'Fall'),
('MGS 4325', 'Operations Management', 3, TRUE, FALSE, NULL, 'MGS 3301', 'Senior', 'Spring'),
('BUS 4398', 'Internship', 3, TRUE, FALSE, NULL, 'Senior standing', 'Senior', 'Fall'),
('MGS 4499', 'Capstone', 4, TRUE, FALSE, NULL, 'Senior standing', 'Senior', 'Spring'),

-- Accounting Concentration
('ACT 4301', 'Intermediate Accounting I', 3, FALSE, TRUE, 'Accounting', 'ACT 2302', 'Senior', 'Fall'),
('ACT 4302', 'Intermediate Accounting II', 3, FALSE, TRUE, 'Accounting', 'ACT 4301', 'Senior', 'Spring'),
('ACT 4310', 'Cost/Managerial Accounting', 3, FALSE, TRUE, 'Accounting', 'ACT 2302', 'Junior', 'Fall'),
('ACT 4323', 'Auditing', 3, FALSE, TRUE, 'Accounting', 'ACT 4301', 'Senior', 'Spring'),

-- Finance Concentration
('FIN 4301', 'Fundamentals of Valuation I', 3, FALSE, TRUE, 'Finance', 'FIN 3305', 'Junior', 'Fall'),
('FIN 4305', 'Fin. Statement Analysis', 3, FALSE, TRUE, 'Finance', 'ACT 2302', 'Junior', 'Spring'),
('FIN 4315', 'Advanced Corporate Finance', 3, FALSE, TRUE, 'Finance', 'FIN 3305', 'Senior', 'Fall'),

-- Marketing Concentration
('MKT 3305', 'Consumer/Buyer Behavior', 3, FALSE, TRUE, 'Marketing', 'MKT 3301', 'Junior', 'Fall'),
('MKT 3315', 'Sales Management', 3, FALSE, TRUE, 'Marketing', 'MKT 3301', 'Junior', 'Spring'),
('MKT 4315', 'International Marketing', 3, FALSE, TRUE, 'Marketing', 'MKT 3301', 'Senior', 'Fall');
-- Insert Concentration Options
INSERT INTO bba_Concentrations (concentration_name, required_credits, mandatory_courses)
VALUES
('Accounting', 12, 'ACT 4301, ACT 4302'),
('Finance', 12, 'FIN 4301, FIN 4305'),
('Marketing', 12, 'MKT 3305, MKT 3315'),
('Management', 12, 'MGS 4301, MGS 4330'),
('Entrepreneurship', 12, 'FIN 4317, MGS 4317, MKT 4318'),
('Economics', 12, 'ECO 3301, ECO 3302');

-- Create optimized 4-year degree plan in bba_Degree_Plan with Finance concentration example
-- Year 1 (Freshman)
INSERT INTO bba_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(1, 'Fall', 'ENG 1301', 'English Composition I', 3, 'University Core', NULL),
(1, 'Fall', 'MTH 1301', 'College Algebra', 3, 'University Core', NULL),
(1, 'Fall', 'POL 1301', 'Intro to American Gov''t', 3, 'University Core', NULL),
(1, 'Fall', 'CIS 2301', 'Intro to Comp-based Inf Syst.', 3, 'BSS', NULL),

(1, 'Spring', 'ENG 1302', 'English Composition II', 3, 'University Core', NULL),
(1, 'Spring', 'MTH 1300', 'Statistics I', 3, 'University Core', NULL),
(1, 'Spring', 'POL 2315', 'Global Issues', 3, 'University Core', NULL),
(1, 'Spring', 'BUS 3300', 'Global Business Practices', 3, 'BSS', NULL),

(1, 'Summer', 'COM 2301', 'Technical communication', 3, 'University Core', NULL);

-- Year 2 (Sophomore)
INSERT INTO bba_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(2, 'Fall', 'ACT 2301', 'Principles of Accounting I', 3, 'Major Core', NULL),
(2, 'Fall', 'ECO 2306', 'Principles of Macro Econ', 3, 'Major Core', NULL),
(2, 'Fall', 'MGS 3301', 'Principles of Management', 3, 'Major Core', NULL),
(2, 'Fall', 'ART 2301', 'Contemporary African Art', 3, 'University Core', NULL),

(2, 'Spring', 'ACT 2302', 'Principles of Accounting II', 3, 'Major Core', NULL),
(2, 'Spring', 'ECO 2106', 'Principles of Micro Econ', 3, 'Major Core', NULL),
(2, 'Spring', 'MKT 3301', 'Principles of Marketing', 3, 'Major Core', NULL),
(2, 'Spring', 'MGS 3302', 'Business & Entrepreneurship', 3, 'Major Core', NULL),

(2, 'Summer', 'BUS 3320', 'Business Ethics', 3, 'BSS', NULL);

-- Year 3 (Junior)
INSERT INTO bba_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(3, 'Fall', 'FIN 3305', 'Corporate Finance', 3, 'Major Core', NULL),
(3, 'Fall', 'MGS 3310', 'Business Analysis', 3, 'Major Core', NULL),
(3, 'Fall', 'FIN 4301', 'Fundamentals of Valuation I', 3, 'Concentration', 'Finance'),
(3, 'Fall', 'BUS 3305', 'Business Law', 3, 'Major Core', NULL),

(3, 'Spring', 'MGS 3313', 'Organizational Behavior', 3, 'Major Core', NULL),
(3, 'Spring', 'FIN 4305', 'Fin. Statement Analysis', 3, 'Concentration', 'Finance'),
(3, 'Spring', 'MGS 4315', 'Principles of Leadership', 3, 'BSS', NULL),
(3, 'Spring', 'HIS 2305', 'Survey of US History', 3, 'University Core', NULL),

(3, 'Summer', 'ELECT 101', 'General Elective', 3, 'Elective', NULL);

-- Year 4 (Senior)
INSERT INTO bba_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(4, 'Fall', 'MGS 4310', 'Managing Human Resources', 3, 'Major Core', NULL),
(4, 'Fall', 'FIN 4315', 'Advanced Corporate Finance', 3, 'Concentration', 'Finance'),
(4, 'Fall', 'BUS 4398', 'Internship', 3, 'Major Core', NULL),
(4, 'Fall', 'ELECT 102', 'General Elective', 3, 'Elective', NULL),

(4, 'Spring', 'MGS 4499', 'Capstone', 4, 'Major Core', NULL),
(4, 'Spring', 'MGS 4325', 'Operations Management', 3, 'Major Core', NULL),
(4, 'Spring', 'ELECT 103', 'General Elective', 3, 'Elective', NULL);