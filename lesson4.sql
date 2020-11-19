DROP DATABASE IF EXISTS snet2910_4;
CREATE DATABASE snet2910_4;
use snet2910_4;

drop table if exists users;
CREATE TABLE users(
	id serial primary key, 
	name varchar(50),
	created_at datetime default now(),
	updated_at datetime default current_timestamp on update current_timestamp
);
/* 1 Пусть в таблице users поля created_at и updated_at оказались незаполненными.
Заполните их текущими датой и временем.*/

INSERT INTO users (name, created_at, updated_at) VALUES 
('Дарья',now(),now())
,('Ирина',now(),now())
,('Марина',now(),now())
;

/* 2 Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время 
помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
сохранив введённые ранее значения.*/

drop table if exists users2;
CREATE TABLE users2(
	id serial primary key, 
	name varchar(50),
	created_at varchar(150),
	updated_at varchar(150)
);

INSERT INTO users2 (name, created_at, updated_at) VALUES 
('Дарья','20.10.2017 8:10','20.10.2017 8:10')

ALTER TABLE users2 ADD new_created_at DATETIME;
ALTER TABLE users2 ADD new_updated_at DATETIME;
UPDATE users2
SET new_created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
    new_updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
ALTER TABLE users2 
    DROP created_at, 
    DROP updated_at, 
    RENAME COLUMN new_created_at TO created_at, 
   	RENAME COLUMN new_updated_at TO updated_at;
   
/* 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
 чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.*/

drop table if exists storehouses_products;
CREATE TABLE storehouses_products(
	id serial primary key, 
	name varchar(30),
	value int UNSIGNED
);
   
INSERT INTO storehouses_products (name, value) VALUES 
	('name_1',0),
	('name_2',2500),
	('name_3',0),
	('name_4',30),
	('name_5',500),
	('name_6',1)
;

SELECT value FROM storehouses_products
  ORDER BY 
  CASE 
  	WHEN value = 0 THEN 2147483647 
  	ELSE value 
  END

-- Агрегация данных

/* 1. Подсчитайте средний возраст пользователей в таблице users.*/
  
drop table if exists users3;
CREATE TABLE users3(
	id serial primary key, 
	name varchar(50),
	birthday date
);

INSERT INTO users3 (name,birthday) VALUES 
('Дарья','1984-11-28'),
('Ирина','1984-08-24'),
('Марина','1981-04-16'),
('Елена','1980-04-24');

SELECT avg(timestampdiff(year, birthday, now())) as avg_age from users3


  
