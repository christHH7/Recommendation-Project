
```{r}
majors <- data.frame(
  major_code = c('CSC', 'DSC', 'BBA', 'ECO'),
  major_name = c('Computer Science', 'Data Science', 
                'Business Administration', 'Economics'),
  department = c('School of Computing', 'School of Computing', 
                'Business School', 'School of Social Sciences')
)
```
```{r}
# Complete Degree Plan API with Real Data
library(plumber)
library(DBI)
library(RMySQL)
library(dplyr)
library(jsonlite)

# Database Connection
connect_db <- function() {
  dbConnect(
    RMySQL::MySQL(),
    dbname = "Dplan",
    host = "localhost",
    port = 3306,
    user = "root",
    password = "iugb"
  )
}

# Initialize with Real Majors and Plans
initialize_db <- function() {
  conn <- connect_db()
  on.exit(dbDisconnect(conn))
  
  # Create tables with constraints
  dbExecute(conn, "
    CREATE TABLE IF NOT EXISTS majors (
      major_code VARCHAR(4) PRIMARY KEY,
      major_name VARCHAR(50) NOT NULL,
      department VARCHAR(50) NOT NULL
    )
  ")
  
  dbExecute(conn, "
    CREATE TABLE IF NOT EXISTS degree_plan (
      plan_id INT AUTO_INCREMENT PRIMARY KEY,
      major_code VARCHAR(4) NOT NULL,
      academic_year INT NOT NULL CHECK (academic_year BETWEEN 1 AND 4),
      semester ENUM('Fall', 'Spring', 'Summer') NOT NULL,
      course_code VARCHAR(8) NOT NULL,
      course_name VARCHAR(100) NOT NULL,
      credits INT NOT NULL CHECK (credits BETWEEN 1 AND 5),
      requirement_type ENUM('University Core', 'Major Core', 'Concentration', 'Elective') NOT NULL,
      FOREIGN KEY (major_code) REFERENCES majors(major_code)
    )
  ")
  
  # Insert real majors
  dbExecute(conn, "
    INSERT IGNORE INTO majors (major_code, major_name, department) VALUES
    ('CSC', 'Computer Science', 'School of Computing'),
    ('DSC', 'Data Science', 'School of Computing'),
    ('BBA', 'Business Administration', 'Business School'),
    ('ECO', 'Economics', 'School of Social Sciences')
  ")
}

# API Endpoints
#* @apiTitle University Degree Plan API
#* @apiDescription Manage degree plans for CSC, DSC, BBA, and ECO majors

### Majors ###
#* Get all available majors
#* @get /majors
function() {
  conn <- connect_db()
  on.exit(dbDisconnect(conn))
  dbGetQuery(conn, "SELECT * FROM majors")
}

### Degree Plans ###
#* Get full degree plan for a major
#* @param major_code CSC|DSC|BBA|ECO
#* @get /degree-plans/<major_code>
function(major_code) {
  conn <- connect_db()
  on.exit(dbDisconnect(conn))
  
  dbGetQuery(conn, "
    SELECT academic_year, semester, course_code, course_name, 
           credits, requirement_type
    FROM degree_plan
    WHERE major_code = ?
    ORDER BY academic_year, 
             CASE semester 
               WHEN 'Fall' THEN 1 
               WHEN 'Spring' THEN 2 
               WHEN 'Summer' THEN 3 
             END
  ", params = list(major_code))
}

#* Add courses to a degree plan (Admin only)
#* @param major_code Major code
#* @param courses JSON array of courses
#* @post /degree-plans/<major_code>/courses
function(req, res, major_code, courses) {
  conn <- connect_db()
  on.exit(dbDisconnect(conn))
  
  tryCatch({
    courses_df <- fromJSON(courses) %>%
      mutate(major_code = major_code)
    
    dbWriteTable(conn, "degree_plan", courses_df, append = TRUE, row.names = FALSE)
    res$status <- 201
    list(added = nrow(courses_df), major = major_code)
  }, error = function(e) {
    res$status <- 400
    list(error = "Invalid course data or duplicate entries")
  })
}

### Preloaded Degree Plans ###
#* Load Computer Science (CSC) plan
#* @post /degree-plans/load-csc
function(req, res) {
  conn <- connect_db()
  on.exit(dbDisconnect(conn))
  
  csc_plan <- data.frame(
    major_code = 'CSC',
    academic_year = c(1,1,1,1,1, 1,1,1,1,1, 2,2,2,2,2, 2,2,2,2,2),
    semester = c(rep('Fall',5), rep('Spring',5), rep('Fall',5), rep('Spring',5)),
    course_code = c('ENG1301','MTH1401','CSC1300','HIS1305','ART1200',
                   'ENG1302','MTH1402','CSC1301','POL1301','PHY1401',
                   'CSC2300','MTH2302','CSC2301','ECO2301','PHY1402',
                   'CSC3300','CSC3301','STA3300','CSC2302','MTH3300'),
    course_name = c('English Composition I','Calculus I','Intro to Programming',
                   'African History','Art Appreciation',
                   'English Composition II','Calculus II','Data Structures',
                   'American Government','Physics I',
                   'Computer Organization','Discrete Math','Algorithms',
                   'Principles of Economics','Physics II',
                   'Operating Systems','Database Systems','Probability',
                   'Computer Networks','Linear Algebra'),
    credits = c(3,4,3,3,2, 3,4,3,3,4, 3,3,3,3,4, 3,3,3,3,3),
    requirement_type = c(rep('University Core',5), rep('University Core',3),
                       'University Core','Major Core', rep('Major Core',8))
  )
  
  dbWriteTable(conn, "degree_plan", csc_plan, overwrite = TRUE)
  res$status <- 201
  list(status = "CSC degree plan loaded")
}

#* Load Business (BBA) plan
#* @post /degree-plans/load-bba
function(req, res) {
  conn <- connect_db()
  on.exit(dbDisconnect(conn))
  
  bba_plan <- data.frame(
    major_code = 'BBA',
    academic_year = c(1,1,1,1,1, 1,1,1,1,1, 2,2,2,2,2, 2,2,2,2,2),
    semester = c(rep('Fall',5), rep('Spring',5), rep('Fall',5), rep('Spring',5)),
    course_code = c('ENG1301','MTH1301','ACC2301','HIS1305','COM1301',
                   'ENG1302','MTH1300','ACC2302','POL1301','ECO2301',
                   'FIN3300','MKT3301','MGT3301','STA3300','LAW2301',
                   'MGT3302','MKT3302','FIN3301','BUS3300','MGT4301'),
    course_name = c('English Comp I','College Algebra','Accounting I',
                   'African History','Communication',
                   'English Comp II','Statistics','Accounting II',
                   'American Government','Macroeconomics',
                   'Corporate Finance','Marketing Principles',
                   'Management Theory','Business Statistics','Business Law',
                   'Organizational Behavior','Consumer Behavior',
                   'Investments','Global Business','Strategic Management'),
    credits = rep(3, 20),
    requirement_type = c(rep('University Core',9), 'Major Core', rep('Major Core',9), 'Concentration')
  )
  
  dbWriteTable(conn, "degree_plan", bba_plan, overwrite = TRUE)
  res$status <- 201
  list(status = "BBA degree plan loaded")
}

# Run API
initialize_db()
```


```{r}
# Use forward slashes and specify filename
# Set working directory first (optional)
setwd("C:/Users/UTC/OneDrive/Bureau/database")

# Then run with just filename
pr("degree_api.Rmd") %>% pr_run(port = 8000)
```
```{r}
# This should return TRUE if file exists
file.exists("C:/Users/UTC/OneDrive/Bureau/database/degree_api")
```
 
 
