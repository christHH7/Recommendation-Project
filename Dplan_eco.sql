-- Create database schema for IUGB BS Economics program
 
USE DPlan ;

-- Create tables for program structure with economics-specific naming
CREATE TABLE IF NOT EXISTS eco_University_Core (
    core_id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    alternatives VARCHAR(255),
    semester_available VARCHAR(50),
    CONSTRAINT uc_eco_core_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS eco_Program_Requirements (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    prerequisites VARCHAR(100),
    recommended_year ENUM('Freshman','Sophomore','Junior','Senior'),
    recommended_semester ENUM('Fall','Spring','Summer'),
    CONSTRAINT uc_eco_program_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS eco_Major_Requirements (
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
    CONSTRAINT uc_eco_major_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS eco_Concentrations (
    concentration_id INT PRIMARY KEY AUTO_INCREMENT,
    concentration_name VARCHAR(50) NOT NULL,
    required_credits INT NOT NULL DEFAULT 12,
    mandatory_courses VARCHAR(255),
    CONSTRAINT uc_eco_concentration UNIQUE (concentration_name)
);

CREATE TABLE IF NOT EXISTS eco_Degree_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year INT NOT NULL,
    semester ENUM('Fall','Spring','Summer') NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    requirement_type ENUM('University Core','Program','Major Core','Concentration','Elective') NOT NULL,
    concentration_area VARCHAR(50),
    is_completed BOOLEAN DEFAULT FALSE,
    completion_date DATE,
    grade VARCHAR(2),
    FOREIGN KEY (course_code) REFERENCES eco_University_Core(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES eco_Program_Requirements(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES eco_Major_Requirements(course_code) ON UPDATE CASCADE,
    INDEX idx_eco_degree_plan (academic_year, semester)
);

-- Insert University Core Requirements with economics focus
INSERT INTO eco_University_Core (category, course_code, course_name, credits, is_required, alternatives, semester_available)
VALUES
-- Math and stats first
('Mathematics', 'MTH 4300', 'Mathematical Statistics I', 3, TRUE, NULL, 'Fall,Spring'),
('Mathematics Reasoning', 'MTH 1300', 'Statistics I', 3, TRUE, NULL, 'Fall,Spring,Summer'),

-- Economics-related cores
('History', 'ECO 1302', 'Hist. of Economic Thought', 3, FALSE, 'ECO 1305 or HIS 1305 or HIS 2305', 'Fall,Spring'),
('History', 'ECO 1305', 'The Econ. Hist. of Africa', 3, FALSE, 'ECO 1302 or HIS 1305 or HIS 2305', 'Fall,Spring'),

-- Other cores
('Communications', 'ENG 1301', 'English Composition I', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Communications', 'ENG 1302', 'English Composition II', 3, TRUE, 'ENG 1301', 'Fall,Spring,Summer'),
('Government', 'POL 1301', 'Intro to American Gov''t', 3, TRUE, NULL, 'Fall,Spring'),
('Government', 'POL 2315', 'Global Issues', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Writing', 'COM 2301', 'Technical communication', 3, TRUE, NULL, 'Fall,Spring,Summer');

-- Insert Program Requirements (Math foundation)
INSERT INTO eco_Program_Requirements (course_code, course_name, credits, prerequisites, recommended_year, recommended_semester)
VALUES
('MTH 1402', 'Calculus II', 4, 'MTH 1401', 'Freshman', 'Spring'),
('MTH 1403', 'Calculus III', 4, 'MTH 1402', 'Sophomore', 'Fall'),
('MTH 2302', 'Intro to Linear Algebra', 3, 'MTH 1402', 'Sophomore', 'Spring'),
('ECO 2301', 'Principles of Macro Econ.', 3, NULL, 'Freshman', 'Fall'),
('ECO 2302', 'Principles of Micro Econ.', 3, NULL, 'Freshman', 'Spring');

-- Insert Major Requirements
 -- Corrected INSERT for eco_Major_Requirements with all columns
INSERT INTO eco_Major_Requirements (
    course_code, 
    course_name, 
    credits, 
    is_core, 
    is_concentration, 
    concentration_area, 
    prerequisites, 
    recommended_year, 
    recommended_semester
)
VALUES
-- Core Economics Requirements
('CSC 2300', 'Principles of Comp. Science', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Fall'),
('DSC 2301', 'Principles of Data Science', 3, TRUE, FALSE, NULL, NULL, 'Sophomore', 'Spring'),
('MTH 3300', 'Differential Equations', 3, TRUE, FALSE, NULL, 'MTH 1403', 'Junior', 'Fall'),
('ECO 3301', 'Intermediate Macro Econ.', 3, TRUE, FALSE, NULL, 'ECO 2301', 'Junior', 'Fall'),
('ECO 3302', 'Intermediate Micro Econ.', 3, TRUE, FALSE, NULL, 'ECO 2302', 'Junior', 'Spring'),
('ECO 3310', 'Game Theory and Economic Behavior', 3, TRUE, FALSE, NULL, 'ECO 2302', 'Junior', 'Spring'),
('MTH 4310', 'Mathematical Statistics II', 3, TRUE, FALSE, NULL, 'MTH 4300', 'Senior', 'Fall'),
('ECO 4326', 'Economic Devpt of Africa', 3, TRUE, FALSE, NULL, 'ECO 3301', 'Senior', 'Spring'),
('ECO 4345', 'Introductory Econometrics', 3, TRUE, FALSE, NULL, 'MTH 4310', 'Senior', 'Fall'),
('ECO 4347', 'Research Methodology', 3, TRUE, FALSE, NULL, 'ECO 4345', 'Senior', 'Spring'),
('ECO 4398', 'Internship', 3, TRUE, FALSE, NULL, 'Junior standing', 'Senior', 'Fall'),
('ECO 4499', 'Capstone', 4, TRUE, FALSE, NULL, 'Senior standing', 'Senior', 'Spring'),

-- Econometric Data Science Concentration
('CSC 4311', 'Data Mining', 3, FALSE, TRUE, 'Econometric Data Science', 'DSC 2301', 'Senior', 'Fall'),
('DSC 4301', 'Data Warehousing', 3, FALSE, TRUE, 'Econometric Data Science', 'DSC 2301', 'Senior', 'Spring'),
('ECO 4350', 'Econometrics Theory and Practices', 3, FALSE, TRUE, 'Econometric Data Science', 'ECO 4345', 'Senior', 'Fall'),

-- Financial Economics Concentration
('FIN 3305', 'Corporate Finance', 3, FALSE, TRUE, 'Financial Economics', 'ECO 2302', 'Junior', 'Fall'),
('ECO 3305', 'Financial Markets in the Macro Econ.', 3, FALSE, TRUE, 'Financial Economics', 'ECO 3301', 'Senior', 'Spring'),
('ECO 4320', 'Money and Banking', 3, FALSE, TRUE, 'Financial Economics', 'ECO 3301', 'Senior', 'Fall');
-- Insert Concentration Options
INSERT INTO eco_Concentrations (concentration_name, required_credits, mandatory_courses)
VALUES
('Econometric Data Science', 12, 'ECO 4350, CSC 4311'),
('Financial Economics', 12, 'FIN 3305, ECO 4320');

-- Create optimized 4-year degree plan in eco_Degree_Plan with Econometric Data Science concentration
-- Year 1 (Freshman)
INSERT INTO eco_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(1, 'Fall', 'ENG 1301', 'English Composition I', 3, 'University Core', NULL),
(1, 'Fall', 'MTH 1401', 'Calculus I', 4, 'University Core', NULL),
(1, 'Fall', 'ECO 2301', 'Principles of Macro Econ.', 3, 'Program', NULL),
(1, 'Fall', 'POL 1301', 'Intro to American Gov''t', 3, 'University Core', NULL),

(1, 'Spring', 'ENG 1302', 'English Composition II', 3, 'University Core', NULL),
(1, 'Spring', 'MTH 1402', 'Calculus II', 4, 'Program', NULL),
(1, 'Spring', 'ECO 2302', 'Principles of Micro Econ.', 3, 'Program', NULL),
(1, 'Spring', 'MTH 1300', 'Statistics I', 3, 'University Core', NULL),

(1, 'Summer', 'COM 2301', 'Technical communication', 3, 'University Core', NULL);

-- Year 2 (Sophomore)
INSERT INTO eco_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(2, 'Fall', 'MTH 1403', 'Calculus III', 4, 'Program', NULL),
(2, 'Fall', 'CSC 2300', 'Principles of Comp. Science', 3, 'Major Core', NULL),
(2, 'Fall', 'MTH 4300', 'Mathematical Statistics I', 3, 'University Core', NULL),
(2, 'Fall', 'ECO 1302', 'Hist. of Economic Thought', 3, 'University Core', NULL),

(2, 'Spring', 'MTH 2302', 'Intro to Linear Algebra', 3, 'Program', NULL),
(2, 'Spring', 'DSC 2301', 'Principles of Data Science', 3, 'Major Core', NULL),
(2, 'Spring', 'POL 2315', 'Global Issues', 3, 'University Core', NULL),
(2, 'Spring', 'ART 2301', 'Contemporary African Art', 3, 'University Core', NULL);

-- Year 3 (Junior)
INSERT INTO eco_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(3, 'Fall', 'ECO 3301', 'Intermediate Macro Econ.', 3, 'Major Core', NULL),
(3, 'Fall', 'MTH 3300', 'Differential Equations', 3, 'Major Core', NULL),
(3, 'Fall', 'ECO 3310', 'Game Theory and Economic Behavior', 3, 'Major Core', NULL),
(3, 'Fall', 'PHY 1401', 'Principles of Physics I', 4, 'University Core', NULL),

(3, 'Spring', 'ECO 3302', 'Intermediate Micro Econ.', 3, 'Major Core', NULL),
(3, 'Spring', 'MTH 4310', 'Mathematical Statistics II', 3, 'Major Core', NULL),
(3, 'Spring', 'CSC 4311', 'Data Mining', 3, 'Concentration', 'Econometric Data Science'),
(3, 'Spring', 'HIS 2305', 'Survey of US History', 3, 'University Core', NULL);

-- Year 4 (Senior)
INSERT INTO eco_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type, concentration_area)
VALUES
(4, 'Fall', 'ECO 4345', 'Introductory Econometrics', 3, 'Major Core', NULL),
(4, 'Fall', 'ECO 4350', 'Econometrics Theory and Practices', 3, 'Concentration', 'Econometric Data Science'),
(4, 'Fall', 'DSC 4301', 'Data Warehousing', 3, 'Concentration', 'Econometric Data Science'),
(4, 'Fall', 'ECO 4398', 'Internship', 3, 'Major Core', NULL),

(4, 'Spring', 'ECO 4499', 'Capstone', 4, 'Major Core', NULL),
(4, 'Spring', 'ECO 4347', 'Research Methodology', 3, 'Major Core', NULL),
(4, 'Spring', 'ECO 4326', 'Economic Devpt of Africa', 3, 'Major Core', NULL),
(4, 'Spring', 'ELECT 101', 'General Elective', 3, 'Elective', NULL);