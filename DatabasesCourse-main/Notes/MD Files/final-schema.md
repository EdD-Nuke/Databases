Departments(<u>name</u>, abbr)
	Unique abbr
	

Programs(<u>name</u>)

Students(<u>idnr</u> , name, login, program)
	program -> programs.name
	Unique login
	Unique (idnr, program)

Courses(<u>code</u>, name, credits, department)
	department -> Departments.name
	credits >= 0

Branches(<u>program</u>, <u>name</u>)
	program -> Programs.name

Classifications(<u>name</u>)

LimitedCourses(<u>code</u>, capacity)
	code -> Courses.code
	capacity > 0
	
DepartmentWork(<u>department</u>, <u>program</u>)
	department -> Departments.name
	program -> Programs.name

StudentBranches(<u>student</u>, program, branch)
	student -> Students.idnr 
	(branch, program) -> Branches(name, program)
	program -> Students.program
	

MandatoryBranch(<u>branch</u>, <u>program</u>, <u>course</u>)
	(branch, program) -> Branches(name, program)
	course -> Courses.code

MandatoryProgram(<u>program</u>, <u>course</u>)
	program -> Programs.name
	course -> Courses.code

RecommendedBranch(<u>branch</u>, <u>program</u>, <u>course</u>)
	(branch, program) -> Branches(name, program)
	course -> Courses.code

Registered(<u>student</u>, <u>course</u>)
	student -> Students.idnr
	course -> Courses.code

Taken(<u>student</u>, <u>course</u>, grade)
	student -> Student.indr
	course -> Courses.code
	grade = {'U', '3', '4', '5'}

WaitingList(<u>course</u>, <u>student</u>, position )
	student -> Student.idnr
	course -> Courses.code
	unique(course, position)
	position >= 0

Prerequisites(<u>course</u>, <u>prerequisite</u>)
	course -> Courses.code
	prerequisite -> Courses.code
	course != prerequisite

Classified(<u>course</u>, <u>classification</u>)
	course -> Courses.code
	classification -> Classifications.name