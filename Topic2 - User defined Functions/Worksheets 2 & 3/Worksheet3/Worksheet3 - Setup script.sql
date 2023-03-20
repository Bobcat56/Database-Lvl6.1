/*
	IICT6203 - Database Programming II
	Topic 2 - User Defined Functions
	Worksheet 03 - Setup Script

*/
USE master;
GO

if exists (select * from sys.databases where name='companyDb')
begin
	DROP DATABASE CompanyDb;
end

CREATE DATABASE CompanyDb;
GO

USE CompanyDb;
GO

CREATE TABLE Region
( 
  regionId INTEGER PRIMARY KEY,
  regionName VARCHAR(35) NOT NULL
);

CREATE TABLE Country 
( 
  countryId CHAR(2)PRIMARY KEY,
  countryName VARCHAR(40) NOT NULL, 
  regionId INTEGER NOT NULL REFERENCES Region(regionId)   
); 


CREATE TABLE [Location]
( 
  locationId INTEGER PRIMARY KEY,
  streetAddress VARCHAR(40) NOT NULL,
  postalCode VARCHAR(12),
  City VARCHAR(30) NOT NULL,
  stateProvince VARCHAR(25),
  countryId CHAR(2) NOT NULL REFERENCES Country(countryId) 
);

 CREATE TABLE Job
( 
  jobId CHAR(10) PRIMARY KEY, 
  jobTitle VARCHAR(35) NOT NULL, 
  minSalary NUMERIC(6), 
  maxSalary NUMERIC(6)
);

CREATE TABLE Department
( 
  departmentId  INTEGER PRIMARY KEY,
  departmentName  VARCHAR(30) NOT NULL,
  locationId INTEGER NOT NULL REFERENCES [Location] (locationId)
);

CREATE TABLE Employee
( 
  employeeId  INTEGER PRIMARY KEY, 
  firstName VARCHAR(35) NOT NULL, 
  lastName  VARCHAR(35) NOT NULL, 
  email VARCHAR(35) NOT NULL UNIQUE, 
  phoneNumber   VARCHAR(35), 
  hireDate DATE NOT NULL, 
  jobId   ChAR(10) NOT NULL REFERENCES Job(jobId), 
  Salary   NUMERIC(8,2) NOT NULL CHECK (Salary > 0), 
  commissionPct NUMERIC(3,2), 
  managerId INTEGER REFERENCES Employee(employeeId),
  departmentId INTEGER REFERENCES Department(departmentId)
) ;

CREATE TABLE jobHistory
( employeeId   INTEGER NOT NULL REFERENCES Employee(employeeId),
  startDate  DATE NOT NULL, 
  endDate  DATE NOT NULL, 
  jobId  CHAR(10) NOT NULL REFERENCES Job (jobId), 
  departmentId INTEGER REFERENCES Department(departmentId), 
  PRIMARY KEY (employeeId, startDate),
  CHECK (endDate > startDate),
) ;

CREATE TABLE jobGrade
(
  gradeLevel CHAR(1) NOT NULL PRIMARY KEY,
  lowestSal NUMERIC(9) NOT NULL,
  highestSal NUMERIC(9) NOT NULL
);

CREATE SEQUENCE seq_Location
 START WITH 3300
 INCREMENT BY 100
 MAXVALUE 9900
 NO CACHE
 NO CYCLE;

CREATE SEQUENCE seq_Department
 START WITH 280
 INCREMENT BY   10
 MAXVALUE   9990
 NO CACHE
 NO CYCLE;

CREATE SEQUENCE seq_Employee
 START WITH 207
 INCREMENT BY 1
 NO CYCLE
 NO CACHE;


INSERT INTO Region VALUES ( 1, 'Europe');
INSERT INTO Region VALUES ( 2, 'Americas');
INSERT INTO Region VALUES ( 3, 'Asia');
INSERT INTO Region VALUES ( 4, 'Middle East and Africa');

INSERT INTO Country VALUES ( 'IT', 'Italy', 1);
INSERT INTO Country VALUES ( 'JP', 'Japan', 3);
INSERT INTO Country VALUES ( 'US', 'United States of America', 2);
INSERT INTO Country VALUES ( 'CA', 'Canada', 2);
INSERT INTO Country VALUES ( 'CN', 'China', 3);
INSERT INTO Country VALUES ( 'IN', 'India', 3);
INSERT INTO Country VALUES ( 'AU', 'Australia', 3);
INSERT INTO Country VALUES ( 'ZW', 'Zimbabwe', 4);
INSERT INTO Country VALUES ( 'SG', 'Singapore', 3);
INSERT INTO Country VALUES ( 'UK', 'United Kingdom', 1);
INSERT INTO Country VALUES ( 'FR', 'France', 1);
INSERT INTO Country VALUES ( 'DE', 'Germany', 1);
INSERT INTO Country VALUES ( 'ZM', 'Zambia', 4);
INSERT INTO Country VALUES ( 'EG', 'Egypt', 4);
INSERT INTO Country VALUES ( 'BR', 'Brazil', 2);
INSERT INTO Country VALUES ( 'CH', 'Switzerland', 1);
INSERT INTO Country VALUES ( 'NL', 'Netherlands', 1);
INSERT INTO Country VALUES ( 'MX', 'Mexico', 2);
INSERT INTO Country VALUES ( 'KW', 'Kuwait', 4);
INSERT INTO Country VALUES ( 'IL', 'Israel', 4);
INSERT INTO Country VALUES ( 'DK', 'Denmark', 1);
INSERT INTO Country VALUES ( 'HK', 'HongKong', 3);
INSERT INTO Country VALUES ( 'NG', 'Nigeria', 4);
INSERT INTO Country VALUES ( 'AR', 'Argentina', 2);
INSERT INTO Country VALUES ( 'BE', 'Belgium', 1);

INSERT INTO [Location] VALUES ( 1000 , '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'IT');
INSERT INTO [Location] VALUES ( 1100 , '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT');
INSERT INTO [Location] VALUES ( 1200 , '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO [Location] VALUES ( 1300 , '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP');
INSERT INTO [Location] VALUES ( 1400 , '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO [Location] VALUES ( 1500 , '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO [Location] VALUES ( 1600 , '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
INSERT INTO [Location] VALUES ( 1700 , '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO [Location] VALUES ( 1800 , '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO [Location] VALUES ( 1900 , '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');
INSERT INTO [Location] VALUES ( 2000 , '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN');
INSERT INTO [Location] VALUES ( 2100 , '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN');
INSERT INTO [Location] VALUES ( 2200 , '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU');
INSERT INTO [Location] VALUES ( 2300 , '198 Clementi North', '540198', 'Singapore', NULL, 'SG');
INSERT INTO [Location] VALUES ( 2400 , '8204 Arthur St', NULL, 'London', NULL, 'UK');
INSERT INTO [Location] VALUES ( 2500 , 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
INSERT INTO [Location] VALUES ( 2600 , '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK');
INSERT INTO [Location] VALUES ( 2700 , 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');
INSERT INTO [Location] VALUES ( 2800 , 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR');
INSERT INTO [Location] VALUES ( 2900 , '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH');
INSERT INTO [Location] VALUES ( 3000 , 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH');
INSERT INTO [Location] VALUES ( 3100 , 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL');
INSERT INTO [Location] VALUES ( 3200 , 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');

INSERT INTO Department VALUES ( 10, 'Administration', 1700);
INSERT INTO Department VALUES ( 20, 'Marketing',  1800);                        
INSERT INTO Department VALUES ( 30, 'Purchasing', 1700);        
INSERT INTO Department VALUES ( 40, 'Human Resources', 2400);
INSERT INTO Department VALUES ( 50, 'Shipping', 1500);        
INSERT INTO Department VALUES ( 60 , 'IT', 1400);        
INSERT INTO Department VALUES ( 70 , 'Public Relations', 2700);        
INSERT INTO Department VALUES ( 80 , 'Sales', 2500);        
INSERT INTO Department VALUES ( 90 , 'Executive', 1700);
INSERT INTO Department VALUES ( 100 , 'Finance', 1700);        
INSERT INTO Department VALUES ( 110 , 'Accounting', 1700);
INSERT INTO Department VALUES ( 120 , 'Treasury', 1700);
INSERT INTO Department VALUES ( 130 , 'Corporate Tax', 1700);
INSERT INTO Department VALUES ( 140 , 'Control And Credit', 1700);
INSERT INTO Department VALUES ( 150 , 'Shareholder Services', 1700);
INSERT INTO Department VALUES ( 160 , 'Benefits', 1700);
INSERT INTO Department VALUES ( 170 , 'Manufacturing', 1700);
INSERT INTO Department VALUES ( 180 , 'Construction', 1700);
INSERT INTO Department VALUES ( 190 , 'Contracting', 1700);
INSERT INTO Department VALUES ( 200 , 'Operations', 1700);
INSERT INTO Department VALUES ( 210 , 'IT Support', 1700);
INSERT INTO Department VALUES ( 220 , 'NOC', 1700);
INSERT INTO Department VALUES ( 230 , 'IT Helpdesk', 1700);
INSERT INTO Department VALUES ( 240 , 'Government Sales', 1700);
INSERT INTO Department VALUES ( 250 , 'Retail Sales', 1700);
INSERT INTO Department VALUES ( 260 , 'Recruiting', 1700);
INSERT INTO Department VALUES ( 270 , 'Payroll', 1700);

INSERT INTO Job VALUES ( 'AD_PRES', 'President', 20000, 40000);
INSERT INTO Job VALUES ( 'AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO Job VALUES ( 'AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO Job VALUES ( 'FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO Job VALUES ( 'FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO Job VALUES ( 'AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO Job VALUES ( 'AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO Job VALUES ( 'SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO Job VALUES ( 'SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO Job VALUES ( 'PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO Job VALUES ( 'PU_CLERK', 'Purchasing Clerk', 2500, 5500);
INSERT INTO Job VALUES ( 'ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO Job VALUES ( 'ST_CLERK', 'Stock Clerk', 2000, 5000);
INSERT INTO Job VALUES ( 'SH_CLERK', 'Shipping Clerk', 2500, 5500);
INSERT INTO Job VALUES ( 'IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO Job VALUES ( 'MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO Job VALUES ( 'MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO Job VALUES ( 'HR_REP', 'Human Resources Representative', 4000, 9000);
INSERT INTO Job VALUES ( 'PR_REP', 'Public Relations Representative', 4500, 10500);

INSERT INTO Employee VALUES ( 100, 'Steven', 'King', 'SKING', '515.123.4567', '17-JUN-1987', 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO Employee VALUES ( 101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '21-SEP-1989', 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO Employee VALUES ( 102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '13-JAN-1993', 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO Employee VALUES ( 103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '03-JAN-1990', 'IT_PROG', 9000, NULL, 102, 60);
INSERT INTO Employee VALUES ( 104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '21-MAY-1991', 'IT_PROG', 6000, NULL, 103, 60);
INSERT INTO Employee VALUES ( 105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', '25-JUN-1997', 'IT_PROG', 4800, NULL, 103, 60);
INSERT INTO Employee VALUES ( 106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '05-FEB-1998', 'IT_PROG', 4800, NULL, 103, 60);
INSERT INTO Employee VALUES ( 107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '07-FEB-1999', 'IT_PROG', 4200, NULL, 103, 60);
INSERT INTO Employee VALUES ( 108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '17-AUG-1994', 'FI_MGR', 12000, NULL, 101, 100);
INSERT INTO Employee VALUES ( 109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '16-AUG-1994', 'FI_ACCOUNT', 9000, NULL, 108, 100);
INSERT INTO Employee VALUES ( 110, 'John', 'Chen', 'JCHEN', '515.124.4269', '28-SEP-1997', 'FI_ACCOUNT', 8200, NULL, 108, 100);
INSERT INTO Employee VALUES ( 111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '30-SEP-1997', 'FI_ACCOUNT', 7700, NULL, 108, 100);
INSERT INTO Employee VALUES ( 112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', '07-MAR-1998', 'FI_ACCOUNT', 7800, NULL, 108, 100);
INSERT INTO Employee VALUES ( 113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', '07-DEC-1999', 'FI_ACCOUNT', 6900, NULL, 108, 100);
INSERT INTO Employee VALUES ( 114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '07-DEC-1994', 'PU_MAN', 11000, NULL, 100, 30);
INSERT INTO Employee VALUES ( 115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '18-MAY-1995', 'PU_CLERK', 3100, NULL, 114, 30);
INSERT INTO Employee VALUES ( 116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '24-DEC-1997', 'PU_CLERK', 2900, NULL, 114, 30);
INSERT INTO Employee VALUES ( 117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', '24-JUL-1997', 'PU_CLERK', 2800, NULL, 114, 30);
INSERT INTO Employee VALUES ( 118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', '15-NOV-1998', 'PU_CLERK', 2600, NULL, 114, 30);
INSERT INTO Employee VALUES ( 119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', '10-AUG-1999', 'PU_CLERK', 2500, NULL, 114, 30);
INSERT INTO Employee VALUES ( 120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', '18-JUL-1996', 'ST_MAN', 8000, NULL, 100, 50);
INSERT INTO Employee VALUES ( 121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', '10-APR-1997', 'ST_MAN', 8200, NULL, 100, 50);
INSERT INTO Employee VALUES ( 122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', '01-MAY-1995', 'ST_MAN', 7900, NULL, 100, 50);
INSERT INTO Employee VALUES ( 123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', '10-OCT-1997', 'ST_MAN', 6500, NULL, 100, 50);
INSERT INTO Employee VALUES ( 124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', '16-NOV-1999', 'ST_MAN', 5800, NULL, 100, 50);
INSERT INTO Employee VALUES ( 125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', '16-JUL-1997', 'ST_CLERK', 3200, NULL, 120, 50);
INSERT INTO Employee VALUES ( 126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', '28-SEP-1998', 'ST_CLERK', 2700, NULL, 120, 50);
INSERT INTO Employee VALUES ( 127, 'James', 'Landry', 'JLANDRY', '650.124.1334', '14-JAN-1999', 'ST_CLERK', 2400, NULL, 120, 50);
INSERT INTO Employee VALUES ( 128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', '08-MAR-2000', 'ST_CLERK', 2200, NULL, 120, 50);
INSERT INTO Employee VALUES ( 129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', '20-AUG-1997', 'ST_CLERK', 3300, NULL, 121, 50);
INSERT INTO Employee VALUES ( 130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', '30-OCT-1997', 'ST_CLERK', 2800, NULL, 121, 50);
INSERT INTO Employee VALUES ( 131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', '16-FEB-1997', 'ST_CLERK', 2500, NULL, 121, 50);
INSERT INTO Employee VALUES ( 132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', '10-APR-1999', 'ST_CLERK', 2100, NULL, 121, 50);
INSERT INTO Employee VALUES ( 133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', '14-JUN-1996', 'ST_CLERK', 3300, NULL, 122, 50);
INSERT INTO Employee VALUES ( 134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', '26-AUG-1998', 'ST_CLERK', 2900, NULL, 122, 50);
INSERT INTO Employee VALUES ( 135, 'Ki', 'Gee', 'KGEE', '650.127.1734', '12-DEC-1999', 'ST_CLERK', 2400, NULL, 122, 50);
INSERT INTO Employee VALUES ( 136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', '06-FEB-2000', 'ST_CLERK', 2200, NULL, 122, 50);
INSERT INTO Employee VALUES ( 137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', '14-JUL-1995', 'ST_CLERK', 3600, NULL, 123, 50);
INSERT INTO Employee VALUES ( 138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', '26-OCT-1997', 'ST_CLERK', 3200, NULL, 123, 50);
INSERT INTO Employee VALUES ( 139, 'John', 'Seo', 'JSEO', '650.121.2019', '12-FEB-1998', 'ST_CLERK', 2700, NULL, 123, 50);
INSERT INTO Employee VALUES ( 140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', '06-APR-1998', 'ST_CLERK', 2500, NULL, 123, 50);
INSERT INTO Employee VALUES ( 141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', '17-OCT-1995', 'ST_CLERK', 3500, NULL, 124, 50);
INSERT INTO Employee VALUES ( 142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', '29-JAN-1997', 'ST_CLERK', 3100, NULL, 124, 50);
INSERT INTO Employee VALUES ( 143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', '15-MAR-1998', 'ST_CLERK', 2600, NULL, 124, 50);
INSERT INTO Employee VALUES ( 144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', '09-JUL-1998', 'ST_CLERK', 2500, NULL, 124, 50);
INSERT INTO Employee VALUES ( 145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', '01-OCT-1996', 'SA_MAN', 14000, .4, 100, 80);
INSERT INTO Employee VALUES ( 146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', '05-JAN-1997', 'SA_MAN', 13500, .3, 100, 80);
INSERT INTO Employee VALUES ( 147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', '10-MAR-1997', 'SA_MAN', 12000, .3, 100, 80);
INSERT INTO Employee VALUES ( 148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', '15-OCT-1999', 'SA_MAN', 11000, .3, 100, 80);
INSERT INTO Employee VALUES ( 149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '29-JAN-2000', 'SA_MAN', 10500, .2, 100, 80);
INSERT INTO Employee VALUES ( 150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', '30-JAN-1997', 'SA_REP', 10000, .3, 145, 80);
INSERT INTO Employee VALUES ( 151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', '24-MAR-1997', 'SA_REP', 9500, .25, 145, 80);
INSERT INTO Employee VALUES ( 152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', '20-AUG-1997', 'SA_REP', 9000, .25, 145, 80);
INSERT INTO Employee VALUES ( 153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', '30-MAR-1998', 'SA_REP', 8000, .2, 145, 80);
INSERT INTO Employee VALUES ( 154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', '09-DEC-1998', 'SA_REP', 7500, .2, 145, 80);
INSERT INTO Employee VALUES ( 155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', '23-NOV-1999', 'SA_REP', 7000, .15, 145, 80);
INSERT INTO Employee VALUES ( 156, 'Janette', 'King', 'JKING', '011.44.1345.429268', '30-JAN-1996', 'SA_REP', 10000, .35, 146, 80);
INSERT INTO Employee VALUES ( 157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', '04-MAR-1996', 'SA_REP', 9500, .35, 146, 80);
INSERT INTO Employee VALUES ( 158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', '01-AUG-1996', 'SA_REP', 9000, .35, 146, 80);
INSERT INTO Employee VALUES ( 159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', '10-MAR-1997', 'SA_REP', 8000, .3, 146, 80);
INSERT INTO Employee VALUES ( 160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', '15-DEC-1997', 'SA_REP', 7500, .3, 146, 80);
INSERT INTO Employee VALUES ( 161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', '03-NOV-1998', 'SA_REP', 7000, .25, 146, 80);
INSERT INTO Employee VALUES ( 162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', '11-NOV-1997', 'SA_REP', 10500, .25, 147, 80);
INSERT INTO Employee VALUES ( 163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', '19-MAR-1999', 'SA_REP', 9500, .15, 147, 80);
INSERT INTO Employee VALUES ( 164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', '24-JAN-2000', 'SA_REP', 7200, .10, 147, 80);
INSERT INTO Employee VALUES ( 165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', '23-FEB-2000', 'SA_REP', 6800, .1, 147, 80);
INSERT INTO Employee VALUES ( 166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', '24-MAR-2000', 'SA_REP', 6400, .10, 147, 80);
INSERT INTO Employee VALUES ( 167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', '21-APR-2000', 'SA_REP', 6200, .10, 147, 80);
INSERT INTO Employee VALUES ( 168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', '11-MAR-1997', 'SA_REP', 11500, .25, 148, 80);
INSERT INTO Employee VALUES ( 169  , 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', '23-MAR-1998', 'SA_REP', 10000, .20, 148, 80);
INSERT INTO Employee VALUES ( 170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', '24-JAN-1998', 'SA_REP', 9600, .20, 148, 80);
INSERT INTO Employee VALUES ( 171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', '23-FEB-1999', 'SA_REP', 7400, .15, 148, 80);
INSERT INTO Employee VALUES ( 172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', '24-MAR-1999', 'SA_REP', 7300, .15, 148, 80);
INSERT INTO Employee VALUES ( 173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', '21-APR-2000', 'SA_REP', 6100, .10, 148, 80);
INSERT INTO Employee VALUES ( 174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', '11-MAY-1996', 'SA_REP', 11000, .30, 149, 80);
INSERT INTO Employee VALUES ( 175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', '19-MAR-1997', 'SA_REP', 8800, .25, 149, 80);
INSERT INTO Employee VALUES ( 176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', '24-MAR-1998', 'SA_REP', 8600, .20, 149, 80);
INSERT INTO Employee VALUES ( 177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', '23-APR-1998', 'SA_REP', 8400, .20, 149, 80);
INSERT INTO Employee VALUES ( 178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', '24-MAY-1999', 'SA_REP', 7000, .15, 149, NULL);
INSERT INTO Employee VALUES ( 179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', '04-JAN-2000', 'SA_REP', 6200, .10, 149, 80);
INSERT INTO Employee VALUES ( 180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', '24-JAN-1998', 'SH_CLERK', 3200, NULL, 120, 50);
INSERT INTO Employee VALUES ( 181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', '23-FEB-1998', 'SH_CLERK', 3100, NULL, 120, 50);
INSERT INTO Employee VALUES ( 182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', '21-JUN-1999', 'SH_CLERK', 2500, NULL, 120, 50);
INSERT INTO Employee VALUES ( 183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', '03-FEB-2000', 'SH_CLERK', 2800, NULL, 120, 50);
INSERT INTO Employee VALUES ( 184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', '27-JAN-1996', 'SH_CLERK', 4200, NULL, 121, 50);
INSERT INTO Employee VALUES ( 185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', '20-FEB-1997', 'SH_CLERK', 4100, NULL, 121, 50);
INSERT INTO Employee VALUES ( 186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', '24-JUN-1998', 'SH_CLERK', 3400, NULL, 121, 50);
INSERT INTO Employee VALUES ( 187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', '07-FEB-1999', 'SH_CLERK', 3000, NULL, 121, 50);
INSERT INTO Employee VALUES ( 188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', '14-JUN-1997', 'SH_CLERK', 3800, NULL, 122, 50);
INSERT INTO Employee VALUES ( 189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', '13-AUG-1997', 'SH_CLERK', 3600, NULL, 122, 50);
INSERT INTO Employee VALUES ( 190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', '11-JUL-1998', 'SH_CLERK', 2900, NULL, 122, 50);
INSERT INTO Employee VALUES ( 191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', '19-DEC-1999', 'SH_CLERK', 2500, NULL, 122, 50);
INSERT INTO Employee VALUES ( 192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', '04-FEB-1996', 'SH_CLERK', 4000, NULL, 123, 50);
INSERT INTO Employee VALUES ( 193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', '03-MAR-1997', 'SH_CLERK', 3900, NULL, 123, 50);
INSERT INTO Employee VALUES ( 194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', '01-JUL-1998', 'SH_CLERK', 3200, NULL, 123, 50);
INSERT INTO Employee VALUES ( 195, 'Vance', 'Jones', 'VJONES', '650.501.4876', '17-MAR-1999', 'SH_CLERK', 2800, NULL, 123, 50);
INSERT INTO Employee VALUES ( 196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', '24-APR-1998', 'SH_CLERK', 3100, NULL, 124, 50);
INSERT INTO Employee VALUES ( 197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', '23-MAY-1998', 'SH_CLERK', 3000, NULL, 124, 50);
INSERT INTO Employee VALUES ( 198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', '21-JUN-1999', 'SH_CLERK', 2600, NULL, 124, 50);
INSERT INTO Employee VALUES ( 199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', '13-JAN-2000', 'SH_CLERK', 2600, NULL, 124, 50);
INSERT INTO Employee VALUES ( 200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '17-SEP-1987', 'AD_ASST', 4400, NULL, 101, 10);
INSERT INTO Employee VALUES ( 201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '17-FEB-1996', 'MK_MAN', 13000, NULL, 100, 20);
INSERT INTO Employee VALUES ( 202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '17-AUG-1997', 'MK_REP', 6000, NULL, 201, 20);
INSERT INTO Employee VALUES ( 203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', '07-JUN-1994', 'HR_REP', 6500, NULL, 101, 40);
INSERT INTO Employee VALUES ( 204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', '07-JUN-1994', 'PR_REP', 10000, NULL, 101, 70);
INSERT INTO Employee VALUES ( 205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', '07-JUN-1994', 'AC_MGR', 12000, NULL, 101, 110);
INSERT INTO Employee VALUES ( 206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', '07-JUN-1994', 'AC_ACCOUNT', 8300, NULL, 205, 110);

INSERT INTO jobHistory VALUES (102, '13-JAN-1993', '24-JUL-1998', 'IT_PROG', 60);
INSERT INTO jobHistory VALUES (101, '21-SEP-1989', '27-OCT-1993', 'AC_ACCOUNT', 110);
INSERT INTO jobHistory VALUES (101, '28-OCT-1993', '15-MAR-1997', 'AC_MGR', 110);
INSERT INTO jobHistory VALUES (201, '17-FEB-1996', '19-DEC-1999', 'MK_REP', 20);
INSERT INTO jobHistory VALUES  (114, '24-MAR-1998', '31-DEC-1999', 'ST_CLERK', 50);
INSERT INTO jobHistory VALUES  (122, '01-JAN-1999', '31-DEC-1999', 'ST_CLERK', 50);
INSERT INTO jobHistory VALUES  (200, '17-SEP-1987', '17-JUN-1993', 'AD_ASST', 90);
INSERT INTO jobHistory VALUES  (176, '24-MAR-1998', '31-DEC-1998', 'SA_REP', 80);
INSERT INTO jobHistory VALUES  (176, '01-JAN-1999', '31-DEC-1999', 'SA_MAN', 80);
INSERT INTO jobHistory VALUES  (200, '01-JUL-1994', '31-DEC-1998', 'AC_ACCOUNT', 90);

INSERT INTO jobGrade (gradeLevel, lowestSal, highestSal) VALUES ('A', 1000, 2999);
INSERT INTO jobGrade (gradeLevel, lowestSal, highestSal) VALUES ('B', 3000, 5999);
INSERT INTO jobGrade (gradeLevel, lowestSal, highestSal) VALUES ('C', 6000, 9999);
INSERT INTO jobGrade (gradeLevel, lowestSal, highestSal) VALUES ('D', 10000, 14999);
INSERT INTO jobGrade (gradeLevel, lowestSal, highestSal) VALUES ('E', 15000, 24999);
INSERT INTO jobGrade (gradeLevel, lowestSal, highestSal) VALUES ('F', 25000, 40000);
