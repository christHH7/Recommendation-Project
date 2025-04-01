use Dplan;
DELIMITER //
CREATE FUNCTION table_exists(tbl_name VARCHAR(100)) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result INT;
    SELECT COUNT(*) INTO result FROM information_schema.tables 
    WHERE table_schema = DATABASE() AND table_name = tbl_name;
    RETURN result > 0;
END //
DELIMITER ;

    DECLARE table_check BOOLEAN;
    
    -- Check if the table exists
SET table_check = table_exists('cis_courses');
    
    -- If the table doesn't exist, create it
 
CREATE TABLE cis_courses (
            course_id INT PRIMARY KEY AUTO_INCREMENT,
            course_code VARCHAR(10) UNIQUE NOT NULL,
            course_name VARCHAR(255) NOT NULL,
            category_id INT,
            credit_hours INT,
            FOREIGN KEY (category_id) REFERENCES course_category(category_id) ON DELETE CASCADE
        );

CREATE TABLE cis_course_schedule (
            schedule_id INT PRIMARY KEY AUTO_INCREMENT,
            course_id INT,
            semester_id INT,
            year_id INT,
            FOREIGN KEY (course_id) REFERENCES cis_courses(course_id) ON DELETE CASCADE,
            FOREIGN KEY (semester_id) REFERENCES semester(semester_id),
            FOREIGN KEY (year_id) REFERENCES year_level(year_id)
        );
    END IF;

    -- Insert missing courses (Prevents duplicates)
INSERT IGNORE INTO cis_courses (course_code, course_name, category_id, credit_hours)
    VALUES 
    ('ENG 1301', 'English Composition I', (SELECT category_id FROM course_category WHERE category_name='University Core'), 3),
    ('CIS 2301', 'Intro to Comp-based Inf Syst.', (SELECT category_id FROM course_category WHERE category_name='Program Requirements'), 3),
    ('CSC 2301', 'Principle of Computer Progr', (SELECT category_id FROM course_category WHERE category_name='Major Requirements'), 3),
    ('GEN ELEC1', 'General Elective 1', (SELECT category_id FROM course_category WHERE category_name='General Electives'), 3);
END //
DELIMITER ;

INSERT INTO cis_courses (course_code, course_name, category_id, credit_hours) VALUES
('ENG 1301', 'English Composition I', 1, 3),
INSERT INTO cis_courses (course_code, course_name, category_id, credit_hours) VALUES
('ENG 1301', 'English Composition I', 1, 3),
-- rest of your values...
ON DUPLICATE KEY UPDATE 
    course_name = VALUES(course_name),
    category_id = VALUES(category_id),
    credit_hours = VALUES(credit_hours);
-- For each course you want to insert
INSERT INTO cis_courses (course_code, course_name, category_id, credit_hours)
SELECT * FROM (SELECT 'ENG 1301', 'English Composition I', 1, 3) AS tmp
WHERE NOT EXISTS (
    SELECT course_code FROM cis_courses WHERE course_code = 'ENG 1301'
) LIMIT 1;

-- rest of your values...
ON DUPLICATE KEY UPDATE course_name = VALUES('English Composition I'),category_id = VALUES('Core & Elective'),
credit_hours = VALUES(3);
INSERT IGNORE INTO cis_courses (course_code, course_name, category_id, credit_hours) VALUES
('ENG 1301', 'English Composition I', 1, 3);


INSERT IGNORE INTO cis_courses (course_code, course_name, category_id, credit_hours) VALUES
        -- University Core Requirements
        ('ENG 1301', 'English Composition I', 1, 3),
        ('ENG 1302', 'English Composition II', 1, 3),
        ('MTH 1301', 'College Algebra', 1, 3),
        ('MTH 1303', 'Pre-Calculus', 1, 3),
        ('MTH 1401', 'Calculus I', 1, 4),
        ('MTH 1300', 'Statistics I', 1, 3),
        ('BIO 1401', 'Principles of Biology I', 1, 4),
        ('BIO 1402', 'Principles of Biology II', 1, 4),
        ('CHE 1401', 'Principles of Chemistry I', 1, 4),
        ('CHE 1402', 'Principles of Chemistry II', 1, 4),
        ('ENV 1401', 'Principles of Env. Science I', 1, 4),
        ('ENV 1402', 'Principles of Env. Science II', 1, 4),
        ('PHY 1401', 'Principles of Physics I', 1, 4),
        ('PHY 1402', 'Principles of Physics II', 1, 4),
        ('POL 1301', 'Intro to American Gov''t', 1, 3),
        ('POL 2315', 'Global Issues', 1, 3),
        ('HIS 1305', 'Introduction to African & African-American History', 1, 3),
        ('HIS 2305', 'Survey of US History', 1, 3),
        ('ART 1302', 'History of Western Art', 1, 3),
        ('ART 1303', 'Art of Africa, Oceania and Americas', 1, 3),
        ('ART 2301', 'Contemporary African Art', 1, 3),
        ('ART 2305', 'Introduction to Theater', 1, 3),
        ('COM 2301', 'Technical communication', 1, 3),

        -- BSS Requirements (Select three)
        ('CIS 2301', 'Intro to Comp-based Inf Syst.', 2, 3),
        ('BUS 3300', 'Glob and Business Practices', 2, 3),
        ('BUS 3320', 'Business Ethics', 2, 3),
        ('PHL 3310', 'Contemporary Moral Probl', 2, 3),
        ('POL 3325', 'Global Ethics', 2, 3),
        ('MGS 4315', 'Principles of Leadership', 2, 3),

        -- Major Requirements
        ('CSC 2301', 'Principle of Computer Progr', 3, 3),
        ('CIS 3301', 'Managing Inform Tech Pijts', 3, 3),
        ('CIS 3305', 'Advanced Spreadsheet', 3, 3),
        ('CIS 3310', 'System Analysis', 3, 3),
        ('CIS 3315', 'Telecom for Business', 3, 3),
        ('CIS 3322', 'Mgmt of Inform Services', 3, 3),
        ('CIS 3325', 'Database Mgmt Systems', 3, 3),
        ('CIS 3326', 'Internet Application Devpt', 3, 3),
        ('CIS 4301', 'Inform Syst Infrstrc & Ntwik', 3, 3),
        ('CIS 4305', 'Intro to Business Intelligence', 3, 3),
        ('CIS 4310', 'Enterprise Application Devpt', 3, 3),
        ('CIS 4398', 'Internship', 3, 3),
        ('CIS 4499', 'Capstone', 3, 4),

        -- Business Requirements
        ('ACT 2301', 'Principles of Accounting I', 2, 3),
        ('FIN 3305', 'Corporate Finance', 2, 3),
        ('MGS 3301', 'Principles of Management', 2, 3),
        ('MKT 3301', 'Principles of Marketing', 2, 3),
        ('ACT 2302', 'Principles of Accounting II', 2, 3),
        ('MGS 3305', 'Business Entrepreneurship', 2, 3),
        ('MGS 3310', 'Business Analysis', 2, 3),
        ('MGS 3315', 'Organizational Behavior', 2, 3),

        -- General Electives
        ('GEN ELEC1', 'General Elective 1', 6, 3),
        ('GEN ELEC2', 'General Elective 2', 6, 3),
        ('GEN ELEC3', 'General Elective 3', 6, 3);
-- BS DSC (Data Science)
CREATE TABLE dsc_courses (
            course_id INT PRIMARY KEY AUTO_INCREMENT,
            course_code VARCHAR(10) UNIQUE NOT NULL,
            course_name VARCHAR(255) NOT NULL,
            category_id INT,
            credit_hours INT,
            FOREIGN KEY (category_id) REFERENCES course_category(category_id)
        );
        
CREATE TABLE dsc_course_schedule (
            schedule_id INT PRIMARY KEY AUTO_INCREMENT,
            course_id INT,
            semester_id INT,
            year_id INT,
            FOREIGN KEY (course_id) REFERENCES dsc_courses(course_id),
            FOREIGN KEY (semester_id) REFERENCES semester(semester_id),
            FOREIGN KEY (year_id) REFERENCES year_level(year_id)
        );
-- Alter your foreign key constraint
ALTER TABLE dsc_courses
DROP FOREIGN KEY fk_category;  -- First drop existing constraint

ALTER TABLE dsc_courses
ADD CONSTRAINT fk_category 
FOREIGN KEY (category_id) 
REFERENCES course_category(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE;
        
        -- Insert BS DSC courses
INSERT INTO dsc_courses (course_code, course_name, category_id, credit_hours) VALUES
        -- University Core Requirements
        ('ENG 1301', 'English Composition I', 1, 3),
        ('ENG 1302', 'English Composition II', 1, 3),
        ('MTH 1401', 'Calculus I', 1, 4),
        ('MTH 2300', 'Discrete Mathematics', 1, 3),
        ('PHY 1401', 'Principles of Physics I', 1, 4),
        ('PHY 1402', 'Principles of Physics II', 1, 4),
		('POL 1301', 'Intro to American Gov''t', 1, 3),
        ('POL 2315', 'Global Issues', 1, 3),
        ('HIS 1305', 'Introduction to African & African-American History', 1, 3),
        ('HIS 2305', 'Survey of US History', 1, 3),
        ('ART 1302', 'History of Western Art', 1, 3),
        ('ART 1303', 'Art of Africa, Oceania and Americas', 1, 3),
        ('ART 2301', 'Contemporary African Art', 1, 3),
        ('ART 2305', 'Introduction to Theater', 1, 3),
        ('COM 2301', 'Technical communication', 1, 3),
         -- Program Requirements
        ('MTH 1402', 'Calculus II', 2, 4),
        ('MTH 2302', 'Intro to Linear Algebra', 2, 3),
        ('CSC 2300', 'Princ. of Computer Science', 2, 3),
        ('CSC 3302', 'Data Structures', 2, 3),
        ('STA 3300', 'Exploratory Data Analysis & Graphics', 2, 3),
        ('STA 3301', 'Analysis of Variance of Design Experiments', 2, 3),

        -- Major Requirements
        ('DSC 2301', 'Principles of Data Science with Python and SQL', 3, 3),
        ('DSC 2302', 'R Programming for Data Science', 3, 3),
        ('DSC 3300', 'Data Warehousing', 3, 3),
        ('DSC 3301', 'Intro to Machine Learning Relational and No-SQL Databases', 3, 3),
        ('DSC 4305', 'Data Analytics', 3, 3),
        ('DSC 4311', 'Data Mining Techniques', 3, 3),
        ('DSC 4315', 'Intro to Artificial Intelligence', 3, 3),
        ('DSC 4320', 'Computer Graphics and Data Visualization', 3, 3),
        ('DSC 4333', 'Internship', 3, 3),
        ('DSC 4499', 'Capstone', 3, 4),
          -- Advanced Courses
        ('DSC 4498', 'Special Topics in Data Science', 4, 4),
        ('CIS 4305', 'Intro to Bus. Intelligence', 4, 3),
        ('MTH 4311', 'Operations Research', 4, 3),
        ('STA 4300', 'Applied Regression Analysis', 4, 3),
        ('STA 4301', 'Applied Statistical Methods', 4, 3),
        ('STA 4302', 'Monte-Carlo Simulation and Resampling Methods', 4, 3),
        ('STA 4303', 'Non-Parametric Statistics', 4, 3),

        -- General Electives
        ('GEN ELEC1', 'General Elective 1', 6, 3),
        ('GEN ELEC2', 'General Elective 2', 6, 3);
	-- First ensure the category exists
INSERT IGNORE INTO course_category (category_name) VALUES 
('University Core'), ('Program Requirements'), ('Major Requirements'),
('Advanced Courses'), ('General Electives');

-- Then create the DSC tables with proper constraints
CREATE TABLE IF NOT EXISTS dsc_courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    category_id INT,
    credit_hours INT,
    CONSTRAINT fk_dsc_category FOREIGN KEY (category_id) 
    REFERENCES course_category(category_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Insert DSC courses with proper category references
INSERT INTO dsc_courses (course_code, course_name, category_id, credit_hours)
SELECT tmp.code, tmp.name, cc.category_id, tmp.hours
FROM (
    SELECT 'ENG 1301' AS code, 'English Composition I' AS name, 'University Core' AS cat, 3 AS hours
    UNION SELECT 'MTH 1401', 'Calculus I', 'University Core', 4
    UNION SELECT 'DSC 2301', 'Principles of Data Science', 'Program Requirements', 3
    -- Add all other courses...
) AS tmp
JOIN course_category cc ON tmp.cat = cc.category_name
LEFT JOIN dsc_courses dc ON tmp.code = dc.course_code
WHERE dc.course_code IS NULL;
-- For CIS courses
INSERT INTO cis_courses (course_code, course_name, category_id, credit_hours)
SELECT tmp.code, tmp.name, cc.category_id, tmp.hours
FROM (
    SELECT 'ENG 1301' AS code, 'English Composition I' AS name, 'University Core' AS cat, 3 AS hours
    UNION SELECT 'ENG 1302', 'English Composition II', 'University Core', 3
    UNION SELECT 'CIS 2301', 'Intro to Comp-based Inf Syst.', 'Program Requirements', 3
    -- Add all other courses...
) AS tmp
JOIN course_category cc ON tmp.cat = cc.category_name
LEFT JOIN cis_courses c ON tmp.code = c.course_code
WHERE c.course_code IS NULL
ON DUPLICATE KEY UPDATE 
    course_name = VALUES(course_name),
    category_id = VALUES(category_id),
    credit_hours = VALUES(credit_hours);
START TRANSACTION;
-- Your insert statements here
COMMIT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'Error occurred, transaction rolled back' AS message;
END;