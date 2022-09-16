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

INSERT INTO LimitedCourses VALUES('WID003', 8);


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


INSERT INTO Registered VALUES ('1111111116', 'MIR001');
INSERT INTO Registered VALUES ('1111111116', 'WID002');
INSERT INTO Registered VALUES ('1111111114', 'MAD002');
INSERT INTO Registered VALUES ('1111111112', 'WID001');
INSERT INTO Registered VALUES ('1111111118', 'MAD222');
INSERT INTO Registered VALUES ('1111111112', 'MAD222');
INSERT INTO Registered VALUES ('1111111113', 'MAD222');


INSERT INTO Taken VALUES ('1111111114', 'MAD001', 4);
INSERT INTO Taken VALUES ('1111111112', 'WID001', 5);
INSERT INTO Taken VALUES ('1111111113', 'MAD222', 3);
INSERT INTO Taken VALUES ('1111111113', 'MAD001', 5);
INSERT INTO Taken VALUES ('1111111121', 'MIR001', 5);

INSERT INTO WaitingList VALUES( '1111111114','MAD222', 0);
INSERT INTO WaitingList VALUES( '1111111115','MAD222', 1);



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
