
/*
"required": [
    "student",          Student id
    "name",             Student name
    "login",            login
    "program",          program
    "branch",           branch
    "finished",         Array of finished courses
    "registered",       Array of courses that the student is registered to
    "seminarCourses",   Credits of seminar courses
    "mathCredits",      Creatids
    "researchCredits",  creaidts
    "totalCredits",     total credits
    "canGraduate"       Can graduate
  ],
*/

SELECT jsonb_build_object ('student', BasicInformation.idnr,'name', BasicInformation.name,'login', BasicInformation.login,'program', BasicInformation.program,'branch', BasicInformation.branch,'Finished', jsonb_agg(jsonb_build_object( 'course', c1.name,'code', FinishedCourses.course, 'grade', FinishedCourses.grade, 'credits', FinishedCourses.credits)),'Registered',Array_agg(jsonb_build_object( 'course', c2.name, 'code', Registrations.course, 'status', Registrations.status  )), 'seminarCourses', PathToGraduation.seminarCourses, 'mathCredits', PathToGraduation.mathCredits, 'researchCredits', PathToGraduation.researchCredits, 'totalCredits', PathToGraduation.totalCredits, 'canGraduate', PathToGraduation.qualified ) AS jsondata FROM BasicInformation JOIN FinishedCourses ON FinishedCourses.student = BasicInformation.idnr JOIN Courses AS c1 ON c1.code = FinishedCourses.course JOIN Registrations ON Registrations.student = BasicInformation.idnr JOIN Courses AS c2 ON c2.code = Registrations.course JOIN PathToGraduation ON BasicInformation.idnr = PathToGraduation.student WHERE BasicInformation.idnr = '1111111114' GROUP BY BasicInformation.idnr, BasicInformation.name,  BasicInformation.login,  BasicInformation.branch, BasicInformation.program, PathToGraduation.seminarCourses,  PathToGraduation.mathCredits, PathToGraduation.researchCredits, PathToGraduation.totalCredits, PathToGraduation.qualified;









SELECT jsonb_build_object (
  'student', BasicInformation.idnr,
  'name', BasicInformation.name,
  'login', BasicInformation.login,
  'program', BasicInformation.program,
  'branch', BasicInformation.branch,
  'finished', jsonb_agg(jsonb_build_object(
  'code',
    FinishedCourses.course, 'grade',
    FinishedCourses.grade, 'credits',
    FinishedCourses.credits)),
  'registered',Array_agg(jsonb_build_object(
    'code', Registrations.course,
    'status', Registrations.status, 
    'position', 2
     )),
  'seminarCourses', PathToGraduation.seminarCourses,
  'mathCredits', PathToGraduation.mathCredits,
  'researchCredits', PathToGraduation.researchCredits,
  'totalCredits', PathToGraduation.totalCredits,
  'canGraduate', PathToGraduation.qualified
    )
 AS jsondata FROM BasicInformation
LEFT JOIN Registrations
ON Registrations.student = BasicInformation.idnr
RIGHT JOIN FinishedCourses
ON FinishedCourses.student = BasicInformation.idnr
Full JOIN PathToGraduation
ON BasicInformation.idnr = PathToGraduation.student
WHERE BasicInformation.idnr = '1111111114'
GROUP BY BasicInformation.idnr,
  BasicInformation.name,
  BasicInformation.login,
  BasicInformation.branch,
  BasicInformation.program,
  PathToGraduation.seminarCourses,
  PathToGraduation.mathCredits,
  PathToGraduation.researchCredits,
  PathToGraduation.totalCredits,
  PathToGraduation.qualified;

--------------------------------------
SELECT jsonb_build_object (
  'student', BasicInformation.idnr,
  'name', BasicInformation.name,
  'login', BasicInformation.login,
  'program', BasicInformation.program,
  'branch', BasicInformation.branch,
  'finished', jsonb_agg(jsonb_build_object(
    'code', FinishedCourses.course, 
    'grade', FinishedCourses.grade,
    'credits', FinishedCourses.credits
  )),
  'registered', jsonb_agg(jsonb_build_object(
    'code', Registrations.course,
    'status', Registrations.status, 
    'position', 2
  )),
  'seminarCourses', PathToGraduation.seminarCourses,
  'mathCredits', PathToGraduation.mathCredits,
  'researchCredits', PathToGraduation.researchCredits,
  'totalCredits', PathToGraduation.totalCredits,
  'canGraduate', PathToGraduation.qualified
    )
 AS jsondata FROM BasicInformation
LEFT JOIN Registrations
ON Registrations.student = BasicInformation.idnr
RIGHT JOIN FinishedCourses
ON FinishedCourses.student = BasicInformation.idnr
Full JOIN PathToGraduation
ON BasicInformation.idnr = PathToGraduation.student
WHERE BasicInformation.idnr = '1111111114'
GROUP BY BasicInformation.idnr,
  BasicInformation.name,
  BasicInformation.login,
  BasicInformation.branch,
  BasicInformation.program,
  PathToGraduation.seminarCourses,
  PathToGraduation.mathCredits,
  PathToGraduation.researchCredits,
  PathToGraduation.totalCredits,
  PathToGraduation.qualified;
 



-------------------------------------------


SELECT jsonb_build_object (
  'student', BasicInformation.idnr,
  'name', BasicInformation.name,
  'login', BasicInformation.login,
  'program', BasicInformation.program,
  'branch', BasicInformation.branch,

  'finished', jsonb_agg(jsonb_build_object(
    'course', c1.name,'code',
    FinishedCourses.course, 'grade',
    FinishedCourses.grade, 'credits',
    FinishedCourses.credits))
    )
 AS jsondata 
FROM BasicInformation
LEFT JOIN FinishedCourses
ON FinishedCourses.student = BasicInformation.idnr
LEFT JOIN Courses AS c1
ON c1.code = FinishedCourses.course
WHERE BasicInformation.idnr = '1111111112'
GROUP BY BasicInformation.idnr,
   BasicInformation.name,
   BasicInformation.login,
   BasicInformation.program,
   BasicInformation.branch
UNION
SELECT jsonb_build_object (
  'student', BasicInformation.idnr,
  'name', BasicInformation.name,
  'login', BasicInformation.login,
  'program', BasicInformation.program,
  'branch', BasicInformation.branch,


  'registered',Array_agg(jsonb_build_object(
    'course', Courses.name,
    'code', Registrations.course,
    'status', Registrations.status, 
    'position', 2
     ))
    ) AS jsondata 
FROM BasicInformation
LEFT JOIN Registrations
ON Registrations.student = BasicInformation.idnr
LEFT JOIN Courses 
ON Courses.code = Registrations.course
WHERE BasicInformation.idnr = '1111111112'
GROUP BY BasicInformation.idnr,
   BasicInformation.name,
   BasicInformation.login,
   BasicInformation.program,
   BasicInformation.branch;


--- Basic infor and more
SELECT jsonb_build_object (
  'student', BasicInformation.idnr,
  'name', BasicInformation.name,
  'login', BasicInformation.login,
  'program', BasicInformation.program,
  'branch', BasicInformation.branch,
  'finished', null,
  'registered', null,
  'seminarCourses', PathToGraduation.seminarCourses,
  'mathCredits', PathToGraduation.mathCredits,
  'researchCredits', PathToGraduation.researchCredits,
  'totalCredits', PathToGraduation.totalCredits,
  'canGraduate', PathToGraduation.qualified
  
  ) AS jsondata
  FROM BasicInformation
  LEFT JOIN PathToGraduation
  ON PathToGraduation.student = BasicInformation.idnr
  WHERE BasicInformation.idnr = '1111111116';

---- Registered
SELECT jsonb_agg(jsonb_build_object(
    'course', Courses.name,
    'code', Registrations.course,
    'status', Registrations.status, 
    'position', COALESCE(CourseQueuePositions.place, null)
     )) AS jsondata
     FROM  Registrations
     LEFT JOIN Courses
     ON Courses.code = Registrations.course
     LEFT JOIN CourseQueuePositions
     ON CourseQueuePositions.course = Registrations.course AND CourseQueuePositions.student = Registrations.student
     WHERE Registrations.student =  '1111111122';

----- Finished
SELECT jsonb_agg(jsonb_build_object(
    'course', Courses.name,
    'code', FinishedCourses.course,
    'grade', FinishedCourses.grade, 
    'credits', FinishedCourses.credits 
     )) AS jsondata
     FROM  FinishedCourses
     LEFT JOIN Courses
     ON Courses.code = FinishedCourses.course
     WHERE FinishedCourses.student =  '1111111112';







SELECT * FROM BasicInformation natural JOIN FinishedCourses ON Finishedcourses.student = BasicInformation.idnr
where BasicInformation.idnr = '1111111115';



--Finished Array:
--GetInfo Query:n
--SELECT BasicInformation.idnr, BasicInformation.name, BasicInformation.login, BasicInformation.program ,BasicInformation.branch,  pathtograduation.totalCredits AS finished,COUNT(Registrations.status) AS Registered, pathtograduation.mathCredits, pathtograduation.researchCredits, pathtograduation.seminarCourses, pathtograduation.mandatoryLeft, pathtograduation.qualified AS canGraduate
SELECT jsonb_build_object ('course', BasicInformation.course, 'code', BasicInformation.course, 'credits',pathtograduation.totalCredits, 'grade',Taken.grade, 'student', pathtograduation.student) AS jsondata
FROM BasicInformation 
LEFT JOIN pathtograduation
ON BasicInformation.course = pathtograduation.student
LEFT JOiN Taken
ON Taken.grade = BasicInformation.course



-- LEFT JOIN FinishedCourses
-- ON BasicInformation.idnr = FinishedCourses.student
--WHERE  BasicInformation.idnr = '1111111114'
GROUP BY BasicInformation.course, pathtograduation.totalCredits,  Taken.grade, pathtograduation.student;

--Registered Array:
SELECT jsonb_build_object ('course', Courses.name, 'code', Registrations.course, 'status', Registrations.status ) AS jsondata
FROM Registrations 
LEFT JOIN Courses
ON Courses.code = Registrations.course

-- Finished Array
SELECT jsonb_build_object('course', Courses.name, 'code', FinishedCourses.course,'credits', FinishedCourses.credits, 'grade', FinishedCourses.grade)
FROM FinishedCourses
LEFT JOIN Courses
ON Courses.code = FinishedCourses.course

