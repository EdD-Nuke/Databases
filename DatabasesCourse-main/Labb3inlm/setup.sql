-- TABLES

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

-- VIEWS

-- The view syntax looks something like this
--CREATE [TEMP | TEMPORARY] VIEW view_name AS
--SELECT column1, column2.....
--FROM table_name
--WHERE [condition];
--

--ID num, name, login, program --> Student and branch
CREATE VIEW BasicInformation AS 
(SELECT idnr, name, login, Students.program, branch
FROM Students LEFT OUTER JOIN StudentBranches ON idnr = student);

--Student, course, grade, credits --> Courses.credits
CREATE VIEW FinishedCourses AS
SELECT student, course, grade, Courses.credits
FROM Taken LEFT OUTER JOIN Courses ON code = course 
ORDER BY grade ASC, student ASC, course ASC;

--Student, course, credits
CREATE VIEW PassedCourses AS
SELECT student, course, credits
FROM FinishedCourses WHERE grade !='U';   

--student, course, status
CREATE VIEW Registrations AS
SELECT student, course, 'waiting' AS status FROM WaitingList
UNION
SELECT student, course, 'registered' AS status FROM Registered 
ORDER BY status;


--Student, course
CREATE VIEW UnreadMandatory AS
((SELECT student, course FROM StudentBranches JOIN MandatoryBranch USING(branch,program))
UNION
(SELECT idnr AS student, course FROM Students JOIN MandatoryProgram USING(program)))
EXCEPT 
SELECT student, course FROM PassedCourses;

--Student, totalCredits, mandatoriLeft, mathCredits
CREATE VIEW totalCredits AS 
SELECT student, SUM(credits) AS totalCredits FROM PassedCourses 
GROUP BY student;

CREATE VIEW mandatoryLeft AS
SELECT student, COUNT(course) AS mandatoryLeft FROM UnreadMandatory 
GROUP BY student;

CREATE VIEW mathCredits AS
SELECT student, SUM(credits) AS mathCredits FROM PassedCourses JOIN Classified USING(course) WHERE classification='math' 
GROUP BY student;

CREATE VIEW researchCredits AS
SELECT student, SUM(credits) AS researchCredits FROM PassedCourses JOIN Classified USING(course) WHERE classification='research' GROUP BY student;

CREATE VIEW seminarCourses AS
SELECT student, COUNT(course) AS seminarCourses FROM PassedCourses JOIN Classified USING(course) WHERE classification='seminar' GROUP BY student;

CREATE VIEW qualified AS
SELECT student, (mandatoryLeft = 0) AS qualified --False if not meet zero
FROM mandatoryLeft;

CREATE VIEW recommendedCourses AS 
SELECT PassedCourses.student, SUM(credits) AS recommendedCredits 
FROM PassedCourses JOIN (RecommendedBranch JOIN StudentBranches USING(branch, program)) USING(student, course) 
GROUP BY PassedCourses.student;
-- END --


--Incorporate all above to pathtograd
CREATE VIEW PathToGraduation AS
SELECT 	idnr AS student, 
		COALESCE(totalCredits, 0) AS totalCredits,
		COALESCE(mathCredits, 0) AS mathCredits, 
		COALESCE(researchCredits, 0) AS researchCredits, 
		COALESCE(seminarCourses,0) AS seminarCourses, 
		COALESCE(mandatoryLeft, 0) AS mandatoryLeft, 
		(COALESCE(mandatoryLeft,0) = 0 AND
		COALESCE(researchCredits,0) >= 10 AND 
		 COALESCE(seminarCourses,0) >= 1 AND 
		 COALESCE(recommendedCredits,0) >= 10 AND
		 COALESCE(mathCredits,0) >= 20) AS qualified
FROM Students 	LEFT OUTER JOIN totalCredits ON idnr=student
				LEFT OUTER JOIN mathCredits ON idnr=mathCredits.student
				LEFT OUTER JOIN researchCredits ON idnr=researchCredits.student
				LEFT OUTER JOIN seminarCourses ON idnr=seminarCourses.student
				LEFT OUTER JOIN mandatoryLeft ON idnr=mandatoryLeft.student
				LEFT OUTER JOIN recommendedCourses ON idnr=recommendedCourses.student;

CREATE VIEW CourseQueuePositions  AS
SELECT A.course, A.student, COUNT(B.student) AS place 
FROM WaitingList A, WaitingList B 
WHERE A.course=B.course AND A.position >= B.position 
GROUP BY A.student, A.course ORDER BY A.course, place;


-- INSERTS

INSERT INTO Programs VALUES ('IT');
INSERT INTO Programs VALUES ('Data');
INSERT INTO Programs VALUES ('Electro');
INSERT INTO Programs VALUES ('Industriel Ekonomi');

INSERT INTO Students VALUES ('1111111112', 'Snövit', '111333', 'Industriel Ekonomi');
INSERT INTO Students VALUES ('1111111113', 'Kloker', '111444', 'IT');
INSERT INTO Students VALUES ('1111111114', 'Butter', '111555', 'Data');
INSERT INTO Students VALUES ('1111111115', 'Glader', '111666', 'IT');
INSERT INTO Students VALUES ('1111111116', 'Trötter', '111777', 'Electro');
INSERT INTO Students VALUES ('1111111117', 'Blyger', '111888', 'IT');
INSERT INTO Students VALUES ('1111111118', 'Prosit', '111999', 'Data');
INSERT INTO Students VALUES ('1111111119', 'Toker', '222111', 'Data');
INSERT INTO Students VALUES ('1111111121', 'Jägaren', '222222', 'Electro');
INSERT INTO Students VALUES ('1111111122', 'Prinsen', '222333', 'IT');

INSERT INTO Departments VALUES ('Department of witch beheadings', 'DWB');
INSERT INTO Departments VALUES ('Department of magic', 'DM');
INSERT INTO Departments VALUES ('Department of mirrors', 'DR');
INSERT INTO Departments VALUES ('Department of ghosts', 'DG');

INSERT INTO DepartmentWork VALUES ('Department of magic', 'Data');
INSERT INTO DepartmentWork VALUES ('Department of magic', 'IT');
INSERT INTO DepartmentWork VALUES ('Department of mirrors', 'Electro');
INSERT INTO DepartmentWork VALUES ('Department of witch beheadings', 'Industriel Ekonomi');
INSERT INTO DepartmentWork VALUES ('Department of ghosts', 'IT');

INSERT INTO Courses VALUES ('MAD222', 'Mirrors', 7.5, 'Department of mirrors');
INSERT INTO Courses VALUES ('MAD001', 'Magic Basics', 3.0, 'Department of magic');
INSERT INTO Courses VALUES ('MAD002', 'Magic Intermediate', 5.5, 'Department of magic');
INSERT INTO Courses VALUES ('MAD003', 'Magic advanced', 7.5, 'Department of magic');
INSERT INTO Courses VALUES ('MIR001', 'Mirrors Reflection', 7.5, 'Department of mirrors');
INSERT INTO Courses VALUES ('BED001', 'Beheadings101', 7.5, 'Department of mirrors');
INSERT INTO Courses VALUES ('GOD001', 'Phantasm', 7.5, 'Department of ghosts');
INSERT INTO Courses VALUES ('WID001', 'Cults', 7.5, 'Department of witch beheadings');
INSERT INTO Courses VALUES ('WID002', 'Witches101', 7.5, 'Department of witch beheadings');
INSERT INTO Courses VALUES ('WID003', 'Reincarnation', 7.5, 'Department of witch beheadings');
INSERT INTO Courses VALUES ('PRO001', 'Protal', 7.5, 'Department of mirrors');
INSERT INTO Courses VALUES ('PRO002', 'Protal Math', 7.5, 'Department of mirrors');

INSERT INTO Branches VALUES ('IT','Extensive mirror analysis');
INSERT INTO Branches VALUES ('IT', 'Ghost sightings analysis and extensive ghost research');
INSERT INTO Branches VALUES ('Electro', 'Extensive mirror analysis');
INSERT INTO Branches VALUES ('Electro', 'Electric magic');
INSERT INTO Branches VALUES ('Data', 'Magic Theory');
INSERT INTO Branches VALUES ('Data', 'Magic Research');
INSERT INTO Branches VALUES ('Industriel Ekonomi', 'Witch beheadings effect on the economy');
INSERT INTO Branches VALUES ('Industriel Ekonomi', 'Cults');

INSERT INTO Classifications VALUES('math');
INSERT INTO Classifications VALUES('research');
INSERT INTO Classifications VALUES('seminar');

INSERT INTO LimitedCourses VALUES('MAD222', 3);
INSERT INTO LimitedCourses VALUES('MAD003', 6);
INSERT INTO LimitedCourses VALUES('GOD001', 3);
INSERT INTO LimitedCourses VALUES('WID003', 4);
INSERT INTO LimitedCourses VALUES('PRO001', 3);
INSERT INTO LimitedCourses VALUES('PRO002', 3);

insert into StudentBranches VALUES ('1111111116','Electro', 'Extensive mirror analysis');
insert into StudentBranches VALUES ('1111111113','IT', 'Ghost sightings analysis and extensive ghost research');
insert into StudentBranches VALUES ('1111111114','Data', 'Magic Theory');
insert into StudentBranches VALUES ('1111111112','Industriel Ekonomi', 'Cults');
insert into StudentBranches VALUES ('1111111121','Electro', 'Extensive mirror analysis');

INSERT INTO MandatoryBranch VALUES ('Electro', 'Extensive mirror analysis','MIR001' );
INSERT INTO MandatoryBranch VALUES ('Data', 'Magic Theory','MAD002' );
INSERT INTO MandatoryBranch VALUES ('Data', 'Magic Theory','MAD003' );
INSERT INTO MandatoryBranch VALUES ('Industriel Ekonomi', 'Cults','WID001');

INSERT INTO MandatoryProgram VALUES ('IT','MAD001');
INSERT INTO MandatoryProgram VALUES ('Data','MAD001');
INSERT INTO MandatoryProgram VALUES ('Electro','MAD222');
INSERT INTO MandatoryProgram VALUES ('Industriel Ekonomi','WID002');

INSERT INTO RecommendedBranch VALUES ('Industriel Ekonomi', 'Cults', 'WID003');

INSERT INTO Taken VALUES ('1111111114', 'MAD001', 4);
INSERT INTO Taken VALUES ('1111111112', 'WID001', 5);
INSERT INTO Taken VALUES ('1111111113', 'MAD222', 3);
INSERT INTO Taken VALUES ('1111111113', 'MAD001', 5);
INSERT INTO Taken VALUES ('1111111121', 'MIR001', 5);

INSERT INTO Registered VALUES ('1111111113', 'WID003');
INSERT INTO Registered VALUES ('1111111114', 'WID003');
INSERT INTO Registered VALUES ('1111111115', 'WID003');

INSERT INTO Registered VALUES ('1111111118', 'MAD222');
INSERT INTO Registered VALUES ('1111111112', 'MAD222');
INSERT INTO Registered VALUES ('1111111117', 'MAD222');

INSERT INTO Registered VALUES ('1111111118', 'GOD001');
INSERT INTO Registered VALUES ('1111111112', 'GOD001');
INSERT INTO Registered VALUES ('1111111117', 'GOD001');
INSERT INTO Registered VALUES ('1111111115', 'GOD001');

INSERT INTO Registered VALUES ('1111111115', 'PRO001');
INSERT INTO Registered VALUES ('1111111116', 'PRO001');
INSERT INTO Registered VALUES ('1111111117', 'PRO001');
INSERT INTO Registered VALUES ('1111111118', 'PRO001');

INSERT INTO Registered VALUES ('1111111112', 'PRO002');
INSERT INTO Registered VALUES ('1111111113', 'PRO002');
INSERT INTO Registered VALUES ('1111111114', 'PRO002');

INSERT INTO WaitingList VALUES ('1111111119', 'MAD222', 1);
INSERT INTO WaitingList VALUES ('1111111121', 'MAD222', 2);
INSERT INTO WaitingList VALUES ('1111111122', 'MAD222', 3);
INSERT INTO WaitingList VALUES ('1111111116', 'MAD222', 4);
INSERT INTO WaitingList VALUES ('1111111122', 'GOD001', 1);

INSERT INTO Prerequisites VALUES ('MAD002', 'MAD001');
INSERT INTO Prerequisites VALUES ('MAD003', 'MAD002');

INSERT INTO Classified VALUES ('MAD222', 'seminar');
INSERT INTO Classified VALUES ('MIR001', 'seminar');
INSERT INTO Classified VALUES ('MAD001', 'math');
INSERT INTO Classified VALUES ('MAD002', 'math');
INSERT INTO Classified VALUES ('MAD003', 'math');
INSERT INTO Classified VALUES ('MAD003', 'research');
INSERT INTO Classified VALUES ('BED001', 'seminar');
INSERT INTO Classified VALUES ('WID003', 'research');

