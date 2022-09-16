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
