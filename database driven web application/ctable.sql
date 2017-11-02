CREATE TABLE people(
NAME VARCHAR(256) PRIMARY KEY NOT NULL,
HOUSE_OR_SENATE VARCHAR(256) NOT NULL,
STATE VARCHAR(256),
PARTY VARCHAR(256),
SINCE VARCHAR(256),
GENDER VARCHAR(256),
IS_ACTIVE BOOLEAN
);

CREATE TABLE COMMITTEE(
HOUSE_OR_SENATE VARCHAR(256) NOT NULL,
SECTOR_NAME VARCHAR(256) NOT NULL,
NUM_OF_REP INTEGER NOT NULL,
NUM_OF_DEM INTEGER NOT NULL,
NUM_OF_IND INTEGER NOT NULL,
PRIMARY KEY (HOUSE_OR_SENATE,SECTOR_NAME)
);

CREATE TABLE IS_MEMBER_OF(
HOUSE_OR_SENATE VARCHAR(256) NOT NULL,
SECTOR_NAME VARCHAR(256) NOT NULL,
NAME VARCHAR(256) NOT NULL,
IS_CHAIR VARCHAR(256) NOT NULL,
PRIMARY KEY (HOUSE_OR_SENATE,SECTOR_NAME,NAME)
--FOREIGN KEY (HOS,SNAME) REFERENCES COMMITTEE(HOUSE_OR_SENATE,SECTOR_NAME)
);

CREATE TABLE BILL(
BILL_ID VARCHAR(256) PRIMARY KEY NOT NULL,
INTRODUCTION_DATE VARCHAR(256) NOT NULL,
TITLE VARCHAR(256) NOT NULL,
STATUS VARCHAR(256) NOT NULL
);

CREATE TABLE IS_SPONSOR_OF(
NAME VARCHAR(256) NOT NULL,
BILL_ID VARCHAR(256),-- REFERENCES BILL(BID) NOT NULL,
IS_PRIMARY_SPONSOR BOOLEAN NOT NULL,
PRIMARY KEY (NAME,BILL_ID)
);

CREATE TABLE IS_ASSIGNED_TO(
HOUSE_OR_SENATE VARCHAR(256) NOT NULL,
SECTOR_NAME VARCHAR(256) NOT NULL,
BILL_ID VARCHAR(256)NOT NULL, --reference other bill_id
PRIMARY KEY (BILL_ID,HOUSE_OR_SENATE,SECTOR_NAME)
--FOREIGN KEY (HSTATUS VARCHAR(256) NOT NULLOS,SNAME) REFERENCES COMMITTEE(HOUSE_OR_SENATE,SECTOR_NAME)
);

CREATE TABLE VOTED_BILL(
BILL_ID VARCHAR(256) NOT NULL,-- REFERENCES BILL(BID) NOT NULL PRIMARY KEY,
TOTAL_YES INTEGER NOT NULL CONSTRAINT TOTAL_YES_CHECK CHECK(TOTAL_YES >= REP_YES + DEM_YES),
TOTAL_NO INTEGER NOT NULL CONSTRAINT TOTAL_NO_CHECK CHECK(TOTAL_NO >= REP_NO + DEM_NO),
REP_YES INTEGER NOT NULL,
DEM_YES INTEGER NOT NULL,
REP_NO INTEGER NOT NULL,
DEM_NO INTEGER NOT NULL,
ABSTAIN INTEGER NOT NULL,
DATE_OF_VOTE VARCHAR(256) NOT NULL,
HOUSE_OR_SENATE VARCHAR(256) NOT NULL,
PRIMARY KEY(BILL_ID, HOUSE_OR_SENATE)
);

CREATE TABLE VOTE(
BILL_ID VARCHAR(256) NOT NULL,
choice VARCHAR(256),
NAME VARCHAR(256),
PRIMARY KEY (BILL_ID,NAME)
);


CREATE FUNCTION TF_CHECK_ONE_CHAIR() RETURNS TRIGGER AS $$
BEGIN
  IF ((SELECT COUNT(IS_CHAIR)
	FROM IS_MEMBER_OF
	WHERE HOUSE_OR_SENATE=NEW.HOUSE_OR_SENATE AND SECTOR_NAME=NEW.SECTOR_NAME)<1) THEN
     RAISE EXCEPTION 'CHAIR NUMBER IS GREATER THAN ONE';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER TG_CHECK_ONE_CHAIR
  AFTER UPDATE OR DELETE OR INSERT ON IS_MEMBER_OF
  FOR EACH ROW
  EXECUTE PROCEDURE TF_CHECK_ONE_CHAIR();



--here we insert the data through the copy query.
--the data is stored in the CSV file


COPY PEOPLE FROM '/home/zhiyong_zhao001/people.csv' with csv header;
COPY COMMITTEE FROM '/home/zhiyong_zhao001/committee.csv' with csv header;

COPY BILL FROM '/home/zhiyong_zhao001/bill.csv' with csv header;
COPY IS_SPONSOR_OF FROM '/home/zhiyong_zhao001/is_sponsor_of.csv' with csv header;
COPY IS_ASSIGNED_TO FROM '/home/zhiyong_zhao001/is_assigned_to.csv' with csv header;
COPY VOTED_BILL FROM '/home/zhiyong_zhao001/voted_bill.csv' with csv header;
COPY VOTE FROM '/home/zhiyong_zhao001/vote.csv' with csv header;
COPY IS_MEMBER_OF FROM '/home/zhiyong_zhao001/is_member_of.csv' with csv header;


--INSERT INTO PEOPLE VALUES(1,'GREG WALDEN','H',TRUE,'M','OR','R',NULL);
--INSERT INTO COMMITTEE VALUES('H','ENERGY',11,9,2);
--INSERT INTO IS_MEMBER_OF VALUES(1,'H','ENERGY',TRUE);
--INSERT INTO BILL VALUES('H.R.306','ENERGY EFFICIENT GOVERNMENT TECHNOLOGY ACT','PASSED');
--INSERT INTO IS_SPONSOR_OF VALUES(1,'H.R.306',TRUE);
--INSERT INTO IS_ASSIGNED_TO VALUES('H.R.306','H','ENERGY');
--INSERT INTO VOTED_BILL VALUES('H.R.306','KKK',2,3,2,3,5,7,'2017');

SELECT NAME
FROM PEOPLE
WHERE NAME = 'Greg Walden';

SELECT NUM_OF_REP
FROM COMMITTEE
WHERE HOUSE_OR_SENATE = 'H'
GROUP BY NUM_OF_REP
HAVING COUNT(*) > 1;


--SELECT *
--FROM BILL;

SELECT BILL_ID
FROM VOTED_BILL
WHERE REP_YES - DEM_YES >10;




--show bill passed with no republican vote
SELECT bill.title
FROM voted_bill, bill
WHERE voted_bill.rep_yes=0 AND voted_bill.bill_id = bill.bill_id;
--show bill passed with no dem vote
SELECT bill.bill_id
FROM voted_bill, bill
WHERE voted_bill.dem_yes=0 AND voted_bill.bill_id = bill.bill_id;


--sector with most bills
SELECT sector_name
FROM Bill, is_Assigned_To
WHERE Bill.bill_id = is_Assigned_To.bill_id
GROUP BY sector_name LIMIT 5;

--Sectors with highest passed bill
--Otherwise
SELECT sector_name
FROM Bill, is_Assigned_To
WHERE Bill.bill_id = is_Assigned_To.bill_id
AND Bill.status LIKE '%Enacted%'
OR Bill.status LIKE '%SIgned By President%'
GROUP BY sector_name LIMIT 5;

--create the view for a useful query
--which committee is assigned most bills
CREATE VIEW COMMITTEEMOSTBILL AS
 SELECT C.HOUSE_OR_SENATE,C.SECTOR_NAME,COUNT(*) AS count
 FROM VOTED_BILL V,IS_ASSIGNED_TO A,COMMITTEE C
 WHERE V.BILL_ID=A.BILL_ID AND A.HOUSE_OR_SENATE=C.HOUSE_OR_SENATE AND A.SECTOR_NAME=C.SECTOR_NAME
 GROUP BY C.HOUSE_OR_SENATE,C.SECTOR_NAME
 ORDER BY count DESC;
 
--create index on gender of committee
CREATE INDEX GenderIndex ON People(name, gender);

 --the number of sponsor for the top 10 bills
 SELECT BILL_ID,COUNT(*)
 FROM IS_SPONSOR_OF
 GROUP BY BILL_ID
 LIMIT 10;
   
 --the top 10 in the list of chairman with their party affiliation
 SELECT M.NAME,M.HOUSE_OR_SENATE,M.SECTOR_NAME,P.PARTY
 FROM IS_MEMBER_OF M,PEOPLE P
 WHERE M.IS_CHAIR='Chairman' AND M.NAME=P.NAME
 LIMIT 10;


--suppose the input people name = X, house_or_senate =Y,sector_name = Z
SELECT is_sponsor_of.bill_id,status,title
FROM is_sponsor_of,bill,is_assigned_to
WHERE is_sponsor_of.name = 'Tom Cotton' AND is_sponsor_of.bill_id = is_assigned_to.bill_id 
      AND bill.bill_id = is_assigned_to.bill_id
	  AND house_or_senate = 'S' AND sector_name= 'Environment and Public Works';

--suppose the input people name = X, house_or_senate =Y,sector_name = Z
SELECT is_sponsor_of.bill_id,is_primary_sponsor
FROM is_sponsor_of,is_assigned_to
WHERE is_sponsor_of.name='Tom Cotton' AND is_sponsor_of.bill_id = is_assigned_to.bill_id 
		AND house_or_senate='S' AND sector_name='Environment and Public Works';

--suppose the input name of the tile is X
SELECT * 
FROM BILL
WHERE bill_id in (
	SELECT bill_id
  	FROM BILL
  	WHERE title LIKE '%Public Health%'
  	);
