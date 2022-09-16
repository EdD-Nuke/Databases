--Cerate View for Position in certain coruse
--course, student and student count (stuent) as place abbrv
--Create waitinglist A and B
--WHERE course in A is same as course in B and position of A is higher or same as in B
--Group by student, course infromation and order it by course, place
CREATE VIEW CourseQPos AS
SELECT A.course, A.student, COUNT(B.student) AS place 
FROM WaitingList A, WaitingList B 
WHERE A.course=B.course AND A.position >= B.position 
GROUP BY A.student, A.course ORDER BY A.course, place;


--Function register checks if the student:
--1,Had the course, 2.has the prereq for the course and 3.if the course is already limited.
--If course is not:
--Full and the student is not already in waiting list THEN register the student.
CREATE FUNCTION registerFunction() RETURNS TRIGGER AS $$
DECLARE next_in_linereg INT;
BEGIN
    -- Check if the student already read the course
    IF (EXISTS(SELECT student, course FROM PassedCourses WHERE (student, course)=(NEW.student, NEW.course))) THEN
        RAISE EXCEPTION 'Student has already taken this course no need to put in waiting list';    
    END IF;

    -- Check the prerequiremnts for the course
    IF ((SELECT COUNT(prerequisite) 
        FROM (SELECT prerequisite FROM Prerequisites WHERE course=NEW.course
        EXCEPT SELECT course FROM PassedCourses WHERE student=NEW.student) AS prereqcourse)
        !=0) THEN
        RAISE EXCEPTION 'Student has not passed all prerequisite courses';
    END IF;

    -- Check if course is limited
    IF (EXISTS(SELECT code FROM LimitedCourses WHERE code = NEW.course)) THEN
        IF ((SELECT COUNT(student) FROM Registered WHERE course = NEW.course) >=
            (SELECT capacity FROM LimitedCourses WHERE code = NEW.course)) THEN
            
            IF (EXISTS(SELECT student FROM WaitingList WHERE (student, course)=(NEW.student, NEW.course))) THEN
                RAISE EXCEPTION 'Student already in waiting list for this course'; 
            END IF;

            next_in_linereg := (SELECT MAX(position) FROM WaitingList WHERE course = NEW.course) + 1;
            IF (next_in_linereg IS NULL) THEN 
                next_in_linereg := 1;
            END IF;

            INSERT INTO WaitingList VALUES (NEW.student, NEW.course, next_in_linereg);
            RAISE NOTICE 'Course is full, student added to waiting list';
            RETURN NULL;
        END IF;
    END IF;

    -- Register the student
    INSERT INTO Registered VALUES (NEW.student, NEW.course);
    RAISE NOTICE 'Student is now registered';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER register INSTEAD OF INSERT OR UPDATE ON Registrations
FOR EACH ROW EXECUTE FUNCTION registerFunction();



CREATE FUNCTION unregister() RETURNS TRIGGER AS $$
DECLARE next_in_line INT; --next pos moved up to stack
DECLARE next_student CHAR(10); --next_student to be registered in that course line/stack
BEGIN
    --remove old student
    DELETE FROM Registered where (student, course) = (OLD.student, OLD.course);
    DELETE FROM WaitingList where (student, course) = (OLD.student, OLD.course);
    RAISE NOTICE 'Student unregistered';
    --If there exsts old records of old student records replace with new student records and register new student
    IF (EXISTS(SELECT code FROM LimitedCourses WHERE code = OLD.course)) THEN
        IF ((SELECT COUNT(student) FROM Registered WHERE course = OLD.course) <
            (SELECT capacity FROM LimitedCourses WHERE code = OLD.course)) THEN
            IF (EXISTS(SELECT student FROM WaitingList WHERE course = OLD.course)) THEN
                next_in_line := (SELECT MIN(position) FROM WaitingList WHERE course = OLD.course);
                next_student := (SELECT student FROM WaitingList WHERE (course, position) = (OLD.course, next_in_line));
                INSERT INTO Registered VALUES (next_student, OLD.course);
                DELETE FROM WaitingList where (student, course) = (next_student, OLD.course);
                RAISE NOTICE 'New student registered to course';
            END IF;
        END IF;
        
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unregister INSTEAD OF DELETE ON Registrations
FOR EACH ROW EXECUTE FUNCTION unregister();