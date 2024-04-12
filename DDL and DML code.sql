-- DDL AND DML CODE


CREATE TABLE patient (
patno VARCHAR(3), -- patient number (3 digits)
gender VARCHAR(1), -- gender ('M' or 'F')
visit VARCHAR(10), -- visit date (MM/DD/YYYY)
hr NUMERIC(3,0), -- heart rate (40,100)
sbp NUMERIC(3,0), -- systolic blood pressure (80,200)
dbp NUMERIC(3,0), -- diastolic blood pressure (60,120)
dx VARCHAR(3), -- diagnosis code (1 to 3 digits)
ae VARCHAR(1)); -- adverse event ('0' or '1')


INSERT INTO patient VALUES ('001','m','11/11/1998',88,140,80,'1','0');
INSERT INTO patient VALUES ('002','f','11/13/1998',84,120,78,'X','0');
INSERT INTO patient VALUES ('003','1','10/21/1998',68,190,100,'3','1');
INSERT INTO patient VALUES ('004','F','01/01/1999',101,200,120,'5','A');
INSERT INTO patient VALUES ('XX5','M','05/07/1998',68,120,80,'1','0');
INSERT INTO patient VALUES ('006',null,'06/15/1999',72,102,68,'6','1');
INSERT INTO patient VALUES ('007','M','08/32/1998',88,148,102,null,'0');
INSERT INTO patient VALUES ('008','F','08/08/1998',210,null,null,'7','0');
INSERT INTO patient VALUES ('009','M','09/25/1999',86,240,180,'4','1');
INSERT INTO patient VALUES ('X10','F','10/19/1999',null,40,120,'1','0');
INSERT INTO patient VALUES ('011','M','13/13/1998',68,300,20,'4','1');
INSERT INTO patient VALUES ('012','M','10/12/98',60,122,74,null,'0');
INSERT INTO patient VALUES ('013','2','08/23/1999',74,108,64,'1',null);
INSERT INTO patient VALUES ('014','M','02/02/1999',22,130,90,null,'1');
INSERT INTO patient VALUES ('002','F','11/13/1998',84,120,78,'X','0'); -- duplicate
INSERT INTO patient VALUES ('003','M','11/12/1999',58,112,74,null,'0'); -- another 003
INSERT INTO patient VALUES ('015','F',null,82,148,88,'3','1');
INSERT INTO patient VALUES ('017','F','04/05/1999',208,null,84,'2','0');
INSERT INTO patient VALUES ('019','M','06/07/1999',58,118,70,null,'0');
INSERT INTO patient VALUES ('123','M','15/12/1999',60,null,null,'1','0');
INSERT INTO patient VALUES ('321','F',null,900,400,200,'5','1');
INSERT INTO patient VALUES ('020','F','99/99/9999',10,20,8,null,'0');
INSERT INTO patient VALUES ('022','M','10/10/1999',48,114,82,'2','1');
INSERT INTO patient VALUES ('023','F','12/31/1998',22,34,78,null,'0');
INSERT INTO patient VALUES ('024','F','11/09/1998',76,120,80,'1','0');
INSERT INTO patient VALUES ('025','M','01/01/1999',74,102,68,'5','1');
INSERT INTO patient VALUES ('027','F','NOTAVAIL',999,166,106,'7','0');
INSERT INTO patient VALUES ('028','F','03/28/1998',66,150,90,'3','0');
INSERT INTO patient VALUES ('029','M','05/15/1998',null,null,null,'4','1');
INSERT INTO patient VALUES ('006','F','07/07/1999',82,148,84,'1','0'); -- another 006

SHOW VARIABLES LIKE 'sql_mode';
SET sql_mode = '';