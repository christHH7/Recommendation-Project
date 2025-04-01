-- Create database schema for IUGB BS CIS program
 
USE DPlan;

-- Create tables for program structure with CIS-specific naming
CREATE TABLE IF NOT EXISTS cis_University_Core (
    core_id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    alternatives VARCHAR(255),
    semester_available VARCHAR(50),
    CONSTRAINT uc_cis_core_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS cis_Major_Requirements (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_core BOOLEAN DEFAULT TRUE,
    is_business BOOLEAN DEFAULT FALSE,
    prerequisites VARCHAR(100),
    recommended_year ENUM('Freshman','Sophomore','Junior','Senior'),
    recommended_semester ENUM('Fall','Spring','Summer'),
    CONSTRAINT uc_cis_major_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS cis_BSS_Requirements (
    bss_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    semester_available VARCHAR(50),
    CONSTRAINT uc_cis_bss_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS cis_Business_Requirements (
    business_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    is_mandatory BOOLEAN DEFAULT FALSE,
    semester_available VARCHAR(50),
    CONSTRAINT uc_cis_business_course UNIQUE (course_code)
);

CREATE TABLE IF NOT EXISTS cis_Degree_Plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year INT NOT NULL,
    semester ENUM('Fall','Spring','Summer') NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    requirement_type ENUM('University Core','Major Core','Business','BSS','Elective') NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completion_date DATE,
    grade VARCHAR(2),
    FOREIGN KEY (course_code) REFERENCES cis_University_Core(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES cis_Major_Requirements(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES cis_BSS_Requirements(course_code) ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES cis_Business_Requirements(course_code) ON UPDATE CASCADE,
    INDEX idx_cis_degree_plan (academic_year, semester)
);

-- Insert University Core Requirements with CIS focus
INSERT INTO cis_University_Core (category, course_code, course_name, credits, is_required, alternatives, semester_available)
VALUES
-- Technical cores first
('Mathematics', 'MTH 1301', 'College Algebra', 3, FALSE, 'MTH 1303 or MTH 1401', 'Fall,Spring'),
('Mathematics', 'MTH 1303', 'Pre-Calculus', 3, FALSE, 'MTH 1301 or MTH 1401', 'Fall,Spring'),
('Mathematics', 'MTH 1401', 'Calculus I', 4, FALSE, 'MTH 1301 or MTH 1303', 'Fall,Spring'),
('Mathematics Reasoning', 'MTH 1300', 'Statistics I', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Natural Sciences', 'PHY 1401', 'Principles of Physics I', 4, FALSE, 'BIO 1401 or CHE 1401 or ENV 1401', 'Fall'),
('Natural Sciences', 'PHY 1402', 'Principles of Physics II', 4, FALSE, NULL, 'Spring'),

-- Other cores
('Communications', 'ENG 1301', 'English Composition I', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Communications', 'ENG 1302', 'English Composition II', 3, TRUE, 'ENG 1301', 'Fall,Spring,Summer'),
('Government', 'POL 1301', 'Intro to American Gov''t', 3, TRUE, NULL, 'Fall,Spring'),
('Government', 'POL 2315', 'Global Issues', 3, TRUE, NULL, 'Fall,Spring,Summer'),
('Writing', 'COM 2301', 'Technical communication', 3, TRUE, NULL, 'Fall,Spring,Summer');

-- Insert BSS Requirements with CIS relevance
INSERT INTO cis_BSS_Requirements (course_code, course_name, credits, semester_available)
VALUES
('CIS 2301', 'Intro to Comp-based Inf Syst.', 3, 'Fall,Spring'),
('BUS 3300', 'Global Business Practices', 3, 'Fall,Spring'),
('BUS 3320', 'Business Ethics', 3, 'Spring'),
('MGS 4315', 'Principles of Leadership', 3, 'Fall');

-- Insert Major Requirements with CIS focus
INSERT INTO cis_Major_Requirements (course_code, course_name, credits, is_core, is_business, prerequisites, recommended_year, recommended_semester)
VALUES
-- Core CIS Requirements
('CSC 2301', 'Principle of Computer Programming', 3, TRUE, FALSE, NULL, 'Freshman', 'Spring'),
('CIS 3301', 'Managing Inform Tech Projects', 3, TRUE, FALSE, 'CSC 2301', 'Sophomore', 'Fall'),
('CIS 3305', 'Advanced Spreadsheet', 3, TRUE, FALSE, NULL, 'Sophomore', 'Spring'),
('CIS 3310', 'System Analysis', 3, TRUE, FALSE, 'CIS 3301', 'Junior', 'Fall'),
('CIS 3315', 'Telecom for Business', 3, TRUE, FALSE, 'CIS 3301', 'Junior', 'Spring'),
('CIS 3322', 'Mgmt of Inform Services', 3, TRUE, FALSE, 'CIS 3310', 'Junior', 'Fall'),
('CIS 3325', 'Database Mgmt Systems', 3, TRUE, FALSE, 'CSC 2301', 'Sophomore', 'Spring'),
('CIS 3326', 'Internet Application Devpt', 3, TRUE, FALSE, 'CSC 2301', 'Junior', 'Fall'),
('CIS 4301', 'Inform Syst Infrstrc & Ntwk', 3, TRUE, FALSE, 'CIS 3315', 'Senior', 'Fall'),
('CIS 4305', 'Intro to Business Intelligence', 3, TRUE, FALSE, 'CIS 3325', 'Senior', 'Spring'),
('CIS 4310', 'Enterprise Application Devpt', 3, TRUE, FALSE, 'CIS 3326', 'Senior', 'Fall'),
('CIS 4398', 'Internship', 3, TRUE, FALSE, 'Junior standing', 'Senior', 'Spring'),
('CIS 4499', 'Capstone', 4, TRUE, FALSE, 'Senior standing', 'Senior', 'Spring');

-- Insert Business Requirements
INSERT INTO cis_Business_Requirements (course_code, course_name, credits, is_mandatory, semester_available)
VALUES
-- Mandatory Business Courses
('ACT 2301', 'Principles of Accounting I', 3, TRUE, 'Fall,Spring'),
('FIN 3305', 'Corporate Finance', 3, TRUE, 'Fall,Spring'),
('MGS 3301', 'Principles of Management', 3, TRUE, 'Fall,Spring'),
('MKT 3301', 'Principles of Marketing', 3, TRUE, 'Fall,Spring'),

-- Optional Business Courses
('ACT 2302', 'Principles of Accounting II', 3, FALSE, 'Fall,Spring'),
('MGS 3305', 'Business Entrepreneurship', 3, FALSE, 'Fall'),
('MGS 3310', 'Business Analysis', 3, FALSE, 'Spring'),
('MGS 3315', 'Organizational Behavior', 3, FALSE, 'Fall,Spring');

-- Create optimized 4-year degree plan in cis_Degree_Plan
-- Year 1 (Freshman)
INSERT INTO cis_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(1, 'Fall', 'ENG 1301', 'English Composition I', 3, 'University Core'),
(1, 'Fall', 'MTH 1401', 'Calculus I', 4, 'University Core'),
(1, 'Fall', 'PHY 1401', 'Principles of Physics I', 4, 'University Core'),
(1, 'Fall', 'CIS 2301', 'Intro to Comp-based Inf Syst.', 3, 'BSS'),

(1, 'Spring', 'ENG 1302', 'English Composition II', 3, 'University Core'),
(1, 'Spring', 'CSC 2301', 'Principle of Computer Programming', 3, 'Major Core'),
(1, 'Spring', 'POL 1301', 'Intro to American Gov''t', 3, 'University Core'),
(1, 'Spring', 'MTH 1300', 'Statistics I', 3, 'University Core'),

(1, 'Summer', 'COM 2301', 'Technical communication', 3, 'University Core');

-- Year 2 (Sophomore)
INSERT INTO cis_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(2, 'Fall', 'CIS 3301', 'Managing Inform Tech Projects', 3, 'Major Core'),
(2, 'Fall', 'CIS 3325', 'Database Mgmt Systems', 3, 'Major Core'),
(2, 'Fall', 'ACT 2301', 'Principles of Accounting I', 3, 'Business'),
(2, 'Fall', 'PHY 1402', 'Principles of Physics II', 4, 'University Core'),

(2, 'Spring', 'CIS 3305', 'Advanced Spreadsheet', 3, 'Major Core'),
(2, 'Spring', 'MGS 3301', 'Principles of Management', 3, 'Business'),
(2, 'Spring', 'POL 2315', 'Global Issues', 3, 'University Core'),
(2, 'Spring', 'BUS 3300', 'Global Business Practices', 3, 'BSS'),

(2, 'Summer', 'ART 2301', 'Contemporary African Art', 3, 'University Core');

-- Year 3 (Junior)
INSERT INTO cis_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(3, 'Fall', 'CIS 3310', 'System Analysis', 3, 'Major Core'),
(3, 'Fall', 'CIS 3326', 'Internet Application Devpt', 3, 'Major Core'),
(3, 'Fall', 'FIN 3305', 'Corporate Finance', 3, 'Business'),
(3, 'Fall', 'MKT 3301', 'Principles of Marketing', 3, 'Business'),

(3, 'Spring', 'CIS 3315', 'Telecom for Business', 3, 'Major Core'),
(3, 'Spring', 'CIS 3322', 'Mgmt of Inform Services', 3, 'Major Core'),
(3, 'Spring', 'MGS 3310', 'Business Analysis', 3, 'Business'),
(3, 'Spring', 'BUS 3320', 'Business Ethics', 3, 'BSS'),

(3, 'Summer', 'HIS 2305', 'Survey of US History', 3, 'University Core');

-- Year 4 (Senior)
INSERT INTO cis_Degree_Plan (academic_year, semester, course_code, course_name, credits, requirement_type)
VALUES
(4, 'Fall', 'CIS 4301', 'Inform Syst Infrstrc & Ntwk', 3, 'Major Core'),
(4, 'Fall', 'CIS 4310', 'Enterprise Application Devpt', 3, 'Major Core'),
(4, 'Fall', 'MGS 4315', 'Principles of Leadership', 3, 'BSS'),
(4, 'Fall', 'ELECT 101', 'General Elective', 3, 'Elective'),

(4, 'Spring', 'CIS 4499', 'Capstone', 4, 'Major Core'),
(4, 'Spring', 'CIS 4305', 'Intro to Business Intelligence', 3, 'Major Core'),
(4, 'Spring', 'CIS 4398', 'Internship', 3, 'Major Core'),
(4, 'Spring', 'ELECT 102', 'General Elective', 3, 'Elective'),

(4, 'Summer', 'ELECT 103', 'General Elective', 3, 'Elective');
select * from cis_Degree_plan;