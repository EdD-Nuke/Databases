
# Databaser Labb
This databse is for a university. It's primary function is to store infromation about different sections of the university and its relations to one another

## ER - Diagram
![[Diagram1.png]]
## FD Diagram

	D(studentIdnr, studentName, login, branchName, programName, courseCode, courseName, credits, departmentName, capacity, classification, grade, position)

	person

	login -> studentIdnr
	
	studentIdnr -> studentName
	studentIdnr -> programName
	studentIdnr -> branchName
	studentIdnr -> login
	
	courseCode -> courseName
	courseCode -> credits
	courseCode -> departmentName
	courseCode -> capacity


	position courseCode -> studentIdnr
	studentIdnr courseCode -> grade
	studentIdnr courseCode -> position


### BCNF
After utilising the BCNF algorithm we get 3 seperate tables

	 1. Students
	 studentIdnr, studentName, login, programName, branchName
	Keys: studentIdnr or login
	with FDs  
	studentIdnr --> studentName, programName, branchName
	
	2. Courses
	courseCode, courseName, credits, departmentName, capacity
	Keys: courseCode
	with FDs  
	courseCode --> courseName, credits, departmentName, capacity
	
	3. Taken and waitinglist
	studentIdnr, courseCode, grade, position 
	Keys: courseCode stdentIdnr or courseCode position
	
	courseCode studentIdnr -> position grade
	courseCode position -> studentIdnr

### 4NF
After looking for multivalued dependancies we can see that student has 2 multivalued dependancies with the columns branchName and programName
These can be split into multiple tables

From: 

	Student(<u>studentIdnr</u>, studentName, login, branchName, programName)

To:

	students(<u>studentIdnr</u>, studentName, login)
	
	StudentBranches(<u>student</u>, branch)
		student -> studentIdnr
	
	studentInProgram(<u>student</u>, program)
		student -> studentIdnr
		

We can also see that

	courseCode studentIdnr -> position grade 
	courseCode position -> studentIdnr

gives us a multivalued dependancy. We can derive this to 2 different tables

From

	takenOrWaiting(<u>student</u>,  <u>course</u>, position, grade)

		
To:

	taken(<u>student</u>,  <u>course</u>, grade)

	waitingList(<u>position</u>,  <u>course</u>, student)
		


	
## Schema
#### Enitities

	students(<u>idnr</u>, name, login)
		login is uneque
	
	departments(<u>name</u>, abbr)
		abbr is uneque
	
	classifications(<u>name</u>)
	
	courses(<u>code</u>, name, credits, department)
		department -> departments.name
	
	program(<u>name</u>)

#### ISA
	limitedCourses(<u>course</u>, capacity)
		course -> courses.code

#### Weak entities

	Branches (<u>branchName</u>, <u>program</u>)
		programName -> program.name

#### Relations
	/*Lists of all taken courses by every student*/
	taken( <u>student</u>,  <u>course</u>, grade )
		student -> students.idnr
		course -> courses.code
	
	/*List of student waiting to take a course and their position to that course*/
	waitingList ( <u>position</u>,  <u>course</u>, student)
		student ->student.idnr
		course -> courses.code
		(course, position) UNEQUE

	/*registered students to a course*/
	registered(<u>student</u>,  <u>course</u>)
		student ->student.idnr
		course -> courses.code
	
	
	/*Mandatory courses in a given program*/
	mandatoryProgram(<u>program</u>,  <u>course</u>)
		program -> programs.name
		course -> course.name

	/*Mandatory courses for a given branch*/
	mandatoryBranch(<u>branch</u>,  <u>course</u>, <u>program</u>)
		branch -> branches.name
		program -> branches.program
		course -> course.name

	/*studentbranches*/
	studentBranches(<u>student</u>, branch, program)
		student -> Students.idnr
		branch -> branches.name
		program -> branches.program

	/*studentInProgram*/
	studentInProgram(<u>student</u>, program)
		student -> Student.idnr
		program -> programs.name
		
	/*departmentWork*/
	departmentWork(<u>department</u>, <u>program</u>)
		department -> departments.name
		program -> programs.name

	/*classified*/
	classified(<u>course</u>, classification)
		course -> courses.code
		classification -> classifications.name

	/*recommendedCourses*/
	rekommendedBranch(<u>branch</u>,<u>course</u>, <u>program</u>)
		course -> courses.code
		branch -> branches.name
		program -> branches.program

	/*Prerequisites*/
	Prerequisites(<u>course</u>, <u>prerequisit</u>)
		prerequisite -> courses.code
		course -> courses.code
	











