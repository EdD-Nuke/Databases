

-- TEST #1: Register for an unlimited course.
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('1111111122','WID001');

-- TEST #2: Register to course where student is already registered.
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('1111111122', 'WID001'); 

-- TEST #3: Unregister from unlimited course. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111122' and course = 'WID001';

-- TEST #4: Register to a limited course. 
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('1111111112', 'WID003');

-- TEST #5: Register for a full limited course with a waiting list. 
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('1111111114', 'MAD222');

-- TEST #6: Removed from waitinglist . 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111114' and course = 'MAD222';

-- TEST #7: Unregistered from a limited course without a waiting list. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111112' and course = 'WID003';

-- TEST #8: Unregistered from a limited course with a waiting list, when the student is registered. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111112' and course = 'MAD222';

-- TEST #9: Unregistered from a limited course with a waiting list, when the student is in the middle of the waiting list. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111122' and course = 'MAD222';

-- TEST #10: Unregistered from an overfull course with a waiting list. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111115' and course = 'GOD001';

-- TEST #11: Unregistered an unregistered student. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111115' and course = 'GOD001';

-- TEST #12: Register to full limited course without waitinglist
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('1111111115', 'PRO002');

-- TEST #13: Unregister from empty course
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '1111111114' and course = 'MAD002';

-- TEST #14: Register to empty course
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('1111111114', 'MAD002');

-- TEST #15: Register to course where student is already in waitinglist
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('1111111122', 'GOD001');

-- TEST #16: Register to an overfull course
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('1111111122', 'PRO001');

-- TEST #17: Register to full course where student is already registered
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('1111111118', 'GOD001');



