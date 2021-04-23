create database identity;
Use identity; 
CREATE TABLE PERSON (
person_id numeric(10) NOT NULL,
first_name VARCHAR(100),
preferred_first_name VARCHAR(100),
last_name VARCHAR(100) NOT NULL,
date_of_birth DATE,
hire_date DATE,
occupation VARCHAR(1),
PRIMARY KEY (person_id)
);

create table ADDRESS (
address_id numeric(10) NOT NULL,
person_id numeric(10) NOT NULL,
address_type VARCHAR(4) NOT NULL,
street_line_1 VARCHAR(100),
city VARCHAR(100),
state VARCHAR(100),
zip_code VARCHAR(30),
PRIMARY KEY (address_id),
FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);


INSERT INTO PERSON VALUES (1,"jhon","jhon","doe",'1991-01-12','2021-04-01','Y');
INSERT INTO PERSON VALUES (2,"","Jose","santos",'1990-01-06','2021-02-01','Y');
INSERT INTO PERSON VALUES (3,"","Rose","jones",'2000-01-04','2021-01-01','N');
INSERT INTO PERSON VALUES (4,"","Ian","smith",'1999-10-05','2020-04-01','Y');
INSERT INTO PERSON VALUES (5,"Calvin","Calvin","chen",'1995-03-20','2019-04-01',null);
INSERT INTO PERSON VALUES (6,"Tarun","Tarun","Mogra",'1989-01-02','2018-04-01',null);
INSERT INTO PERSON VALUES (7,"Nan","Nancy","Smith",'1989-01-02','2021-03-01',null);
select * from PERSON;

INSERT INTO ADDRESS VALUES(1,1,"home","1550 NW 128th Dr","sunrise","FL","33323");
INSERT INTO ADDRESS VALUES(2,6,"bill","1550 NW 128th Dr APT 302","sunrise","FL","33323");
INSERT INTO ADDRESS VALUES(3,2,"work","1220 weston blvd","Weston","FL","33333");
INSERT INTO ADDRESS VALUES(4,3,"bill","1220 Valley Ranch","Devie","NY","445001");
INSERT INTO ADDRESS VALUES(5,4,"home","Ave 12th Bldg 12","Edison","NJ","888088");
INSERT INTO ADDRESS VALUES(6,5,"bill","129 NE sunrise blvd","tamarac","CA","25541");
INSERT INTO ADDRESS VALUES(7,5,"home","130 NE sunrise blvd","tamarac","CA","25541");

select * from ADDRESS;

-- question 1
select *, case when preferred_first_name is not null or trim(preferred_first_name)!= '' then preferred_first_name else
first_name end as REPORTING_NAME from PERSON; 

-- question 2
select * from person where occupation is null or trim(occupation) = '';

-- question 3
select * from person where date_of_birth < '1990-08-07';

-- question 4
SELECT * from person where DATEDIFF( CURDATE() , hire_date) < 100;


-- question 5
select t1.* from person t1 left join address t2 on t1.person_id = t2.person_id where t2.person_id is not null and t2.address_type = 'home'; 	


-- question 6
select 
a.person_id,   
a.first_name, 
a.preferred_first_name, 
a.last_name, 
a.date_of_birth, 
a.hire_date,
a.occupation,
a.address_id,
a.street_line_1,
a.city,
a.state,
a.zip_code, 
case when count > 1 or address_type is null then address_type else 'NONE' end as address_type 
from
(
	select 
	t1.person_id,   
	t1.first_name, 
	t1.preferred_first_name, 
	t1.last_name, 
	t1.date_of_birth, 
	t1.hire_date,
	t1.occupation,
	t2.address_id,
	t2.street_line_1,
	t2.city,
	t2.state,
	t2.zip_code,
	t2.address_type,
	concat(street_line_1,",",city,",",state," ",zip_code) as complete_address
	from person t1 left outer join (select * from address where address_type = 'bill') t2 on t1.person_id = t2.person_id
)a
left join
(
	select complete_address,count(*) as count from (select concat(street_line_1,",",city,",",state," ",zip_code) as complete_address from address)a group by complete_address
)b
on b.complete_address = a.complete_address;


-- question 7
select address_type, count(*) from ADDRESS group by address_type;

-- question 8
select last_name, 
case when lower(min(address_type)) = 'bill' then address else null end as billing_address,
case when lower(max(address_type)) = 'home' then address else null end as home_address
from(
select t1.last_name, t2.address_type, concat(t2.street_line_1,",",t2.city,",",t2.state," ",t2.zip_code) as address
from person t1 left outer join address t2 on t1.person_id = t2.person_id)t group by last_name;


-- question 9
update person as a 
left join address as b on a.person_id = b.person_id
set a.occupation = 'X'
where lower(b.address_type) = 'bill';





























    
    
    
    



