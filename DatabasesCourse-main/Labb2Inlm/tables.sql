CREATE TABLE Departments(
    name TEXT PRIMARY KEY,
    abbr CHAR(4) NOT NULL UNIQUE
);

CREATE TABLE Programs(
    name TEXT PRIMARY KEY
);

CREATE TABLE Students(
    idnr CHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT UNIQUE,
    program TEXT REFERENCES Programs,
    UNIQUE(idnr, program)
);

CREATE TABLE Courses(
    code CHAR(6) PRIMARY KEY,
    name TEXT NOT NULL,
    credits FLOAT CHECK (credits > 0) NOT NULL,
    department TEXT REFERENCES Departments
);

CREATE TABLE Branches(
    program TEXT REFERENCES Programs,
    name TEXT NOT NULL,
    PRIMARY KEY(program, name)
);

CREATE TABLE Classifications(
    name TEXT PRIMARY KEY
);

CREATE TABLE LimitedCourses(
    code CHAR(6) REFERENCES Courses PRIMARY KEY,
    capacity INT CHECK(capacity >= 0) NOT NULL
);

CREATE TABLE DepartmentWork(
    department TEXT REFERENCES Departments,
    program TEXT REFERENCES Programs,
    PRIMARY KEY(department, program)
);

CREATE TABLE StudentBranches(
    student CHAR(10) PRIMARY KEY,
    program TEXT NOT NULL,
    branch TEXT NOT NULL,
    FOREIGN KEY (student, program) REFERENCES Students(idnr, program),
    FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
   
);

CREATE TABLE MandatoryBranch(
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    course CHAR(6) REFERENCES Courses,
    FOREIGN KEY(branch, program) REFERENCES Branches, 
    PRIMARY KEY(branch, program, course)
);

CREATE TABLE RecommendedBranch(
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    course CHAR(6) REFERENCES Courses,
    FOREIGN KEY(branch, program) REFERENCES Branches,
    PRIMARY KEY(branch, program, course)
);

CREATE TABLE MandatoryProgram(
    program TEXT REFERENCES Programs,
    course CHAR(6) REFERENCES Courses,
    PRIMARY KEY(program, course)
);

CREATE TABLE Registered(
    student CHAR(10) REFERENCES Students,
    course CHAR(6) REFERENCES Courses,
    PRIMARY KEY(student, course)
);

CREATE TABLE Taken(
    student CHAR(10) REFERENCES Students,
    course CHAR(6) REFERENCES Courses,
    grade CHAR(1) NOT NULL CHECK (grade IN ('U','3','4','5')),
    PRIMARY KEY(student, course)
);

CREATE TABLE WaitingList(
    student CHAR(10) REFERENCES Students,
    course CHAR(6) REFERENCES Courses,
    position INT CHECK(position >= 0) NOT NULL,
    UNIQUE(course, position),
    PRIMARY KEY(course, student)
);

CREATE TABLE Prerequisites(
    course CHAR(6) REFERENCES Courses,
    prerequisite CHAR(6) REFERENCES Courses,
    CHECK(course != prerequisite),
    PRIMARY KEY(course, prerequisite)
);

CREATE TABLE Classified(
    course CHAR(6) REFERENCES Courses,
    classification TEXT REFERENCES Classifications,
    PRIMARY KEY(course, classification)
);