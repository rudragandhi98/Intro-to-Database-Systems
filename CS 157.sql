connect to cs157a^



CREATE table hw3.student(Id varchar(5) NOT NULL PRIMARY KEY, first varchar(10), last varchar(10))^

CREATE TABLE hw3.class (ClassId varchar(5) NOT NULL PRIMARY KEY, Name varchar(10), Desc varchar(20))^

CREATE TABLE hw3.classreq (ClassId varchar(5)  , PrereqId varchar(5) NOT NULL, Coreq char(1),CONSTRAINT FOK FOREIGN KEY (ClassId) REFERENCES HW3.CLASS(ClassId) on delete cascade)^

CREATE table hw3.schedule(StudentId varchar(5), ClassId varchar(5), Semester char(1), Year int,CONSTRAINT FOKC FOREIGN KEY (ClassId) REFERENCES HW3.CLASS(ClassId) on delete cascade ,CONSTRAINT FOKS FOREIGN KEY (StudentId) REFERENCES HW3.student(Id))^


CREATE TRIGGER TRIG
BEFORE INSERT ON HW3.SCHEDULE
REFERENCING NEW AS N_ROW
FOR EACH ROW MODE DB2SQL
BEGIN ATOMIC

DECLARE a_rcount INTEGER;
DECLARE b_rcount INTEGER;



IF(N_ROW.SEMESTER = 'F')
THEN

SET a_rcount = (SELECT count(*) FROM hw3.classreq where prereqid is not null and classid = N_ROW.classid and coreq = 'F') ;
SET b_rcount = (SELECT COUNT(*) FROM (((SELECT CLASSID FROM hw3.SCHEDULE where studentid = N_ROW.studentid and year<N_ROW.year) 
											UNION (SELECT CLASSID FROM hw3.SCHEDULE where studentid =N_ROW.studentid and year =N_ROW.year and SEMESTER = 'S'))
											  INTERSECT  SELECT PREREQID from hw3.classreq where classid = N_ROW.classid  and coreq = 'F')) ;


IF (a_rcount <> b_rcount)
THEN SIGNAL SQLSTATE '75001'
         SET MESSAGE_TEXT = 'Missing Prereq';
         END IF;

  END IF; 



  IF(N_ROW.SEMESTER = 'S')
THEN

SET a_rcount = (SELECT count(*) FROM hw3.classreq where prereqid is not null and classid = N_ROW.classid and coreq = 'F') ;
SET b_rcount = (SELECT COUNT(*) FROM ((SELECT CLASSID FROM hw3.SCHEDULE where studentid = N_ROW.studentid and year<N_ROW.year) 
											  INTERSECT (SELECT PREREQID from hw3.classreq where classid = N_ROW.classid  and coreq = 'F'))) ;


IF (a_rcount <> b_rcount)
THEN SIGNAL SQLSTATE '75001'
         SET MESSAGE_TEXT = 'Missing Prereq';
         END IF;

  END IF; 




  IF(N_ROW.SEMESTER = 'F')
THEN

SET a_rcount = (SELECT count(*) FROM hw3.classreq where prereqid is not null and classid = N_ROW.classid and coreq = 'T') ;
SET b_rcount = (SELECT COUNT(*) FROM (((SELECT CLASSID FROM hw3.SCHEDULE where studentid = N_ROW.studentid and year<=N_ROW.year) 
											  INTERSECT  SELECT PREREQID from hw3.classreq where classid = N_ROW.classid and coreq = 'T' ))) ;


IF (a_rcount <> b_rcount)
THEN SIGNAL SQLSTATE '75001'
         SET MESSAGE_TEXT = 'Missing Coreq';
         END IF;

  END IF;      


   IF(N_ROW.SEMESTER = 'S')
THEN



SET a_rcount = (SELECT count(*) FROM hw3.classreq where prereqid is not null and classid = N_ROW.classid and coreq = 'T') ;
SET b_rcount = (SELECT COUNT(*) FROM (((SELECT CLASSID FROM hw3.SCHEDULE where studentid = N_ROW.studentid and year<N_ROW.year) 
											UNION (SELECT CLASSID FROM hw3.SCHEDULE where studentid =N_ROW.studentid and year =N_ROW.year and SEMESTER = 'S'))
											  INTERSECT  SELECT PREREQID from hw3.classreq where classid = N_ROW.classid and coreq = 'T' )) ;


IF (a_rcount <> b_rcount)
THEN SIGNAL SQLSTATE '75001'
         SET MESSAGE_TEXT = 'Missing Coreq';
         END IF;

  END IF;          



END^




































