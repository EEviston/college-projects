CREATE TABLE Truck(Reg_no VARCHAR(15) not null,
						Mileage INTEGER not null,
						Year INTEGER not null,
						PRIMARY KEY(Reg_no));

CREATE TABLE Driver(Id INTEGER not null,
						Address VARCHAR(30) not null,
						DOB DATE not null,
						Salary INTEGER not null,
						Pen_Points INTEGER not null,
						Name VARCHAR(30) not null,
						Phone_no INTEGER not null,
						Truck_reg VARCHAR(15) not null,
						PRIMARY KEY(Id),
						FOREIGN KEY(Truck_reg) REFERENCES Truck(Reg_no),
						CONSTRAINT check_pen_points CHECK(Pen_Points < 12));

						
INSERT INTO Truck VALUES('05-KY-12345', 42000, 2005);
INSERT INTO Driver VALUES(1331, 'Black Mesa, Co.Kerry', '16-MAY-73', 150000, 0, 'Gordon Freeman', 0953489283, '05-KY-12345');

INSERT INTO Truck VALUES('03-D-54321', 4000, 2003);
INSERT INTO Driver VALUES(1332, 'Trim, Co.Meath', '12-DEC-83', 35000, 10, 'GLaDOS', 0953459383, '03-D-54321');

INSERT INTO Truck VALUES('05-SO-12545', 60000, 2005);
INSERT INTO Driver VALUES(1333, 'Tamriel, Skyrim', '23-JUN-88', 40700, 5, 'Wheatly', 0853489283, '05-SO-12545');

INSERT INTO Truck VALUES('07-C-14345', 8000, 2007);
INSERT INTO Driver VALUES(1334, 'Killarney, Co.Kerry','3-FEB-89', 40000, 2, 'Alyx Vance', 0953489254, '07-C-14345');

CREATE TABLE Warehouse(Num INTEGER not null,
						Address VARCHAR(50) not null,
						Capacity INTEGER not null,
						PRIMARY KEY(Num));

INSERT INTO Warehouse VALUES(47, 'Munster', 50000);
INSERT INTO Warehouse VALUES(52, 'Leinster', 70000);
INSERT INTO Warehouse VALUES(67, 'Ulster', 65000);
INSERT INTO Warehouse VALUES(24, 'Connacht', 45000);

CREATE TABLE Product(Id INTEGER not null,
						Model VARCHAR(50) not null,
						Price INTEGER not null,
						Brand VARCHAR(30) not null,
						PRIMARY KEY(Id));

INSERT INTO Product VALUES(4875, '2600', 200, 'Intel');
INSERT INTO Product VALUES(52867, '2600k', 250, 'Intel');
INSERT INTO Product VALUES(38675, '6700k', 450, 'Intel');
INSERT INTO Product VALUES(435, '5820z', 475, 'Samsung');

CREATE TABLE Transfer(Transfer_num INTEGER not null,
						Product_Id INTEGER not null,
						Address VARCHAR(50) not null,
						Warehouse_num INTEGER not null,
						Arrival_time INTEGER not null,
						PRIMARY KEY(Transfer_num),
						FOREIGN KEY(Product_Id) REFERENCES Product(Id));

INSERT INTO Transfer VALUES(00124, 4875, 'Wright st, Co.Cork', 47, 4);
INSERT INTO Transfer VALUES(00123, 52867, 'Dame st, Co.Dublin', 52, 5);
INSERT INTO Transfer VALUES(00126, 38675, 'Upper st, Co.Down', 67, 3);
INSERT INTO Transfer VALUES(00125, 435, 'Fake st, Co.Galway', 24, 3);

CREATE TABLE Customer(Address VARCHAR(50),
						Id INTEGER not null,
						Name VARCHAR(30) not null,
						Phone_no INTEGER not null,						
						PRIMARY KEY(Address));

INSERT INTO Customer VALUES('Farranfore', 808, 'Fred P', 0876593082);
INSERT INTO Customer VALUES('Ranelagh', 303, 'Levon Vincent', 0879096063);
INSERT INTO Customer VALUES('Coolwood', 707, 'Axel Boman', 0851398372);
INSERT INTO Customer VALUES('Newry', 909, 'Ben Klock', 0861339584);

CREATE TABLE Delivery(Del_num INTEGER not null,
						Cus_address VARCHAR(50),
						Driver_id INTEGER not null,
						Departure_time INTEGER not null,
						Arrival_time INTEGER not null,
						County VARCHAR(20) not null,
						Product_id INTEGER not null,
						PRIMARY KEY(Del_num),
						FOREIGN KEY(Cus_address) REFERENCES Customer(Address),
						FOREIGN KEY(Driver_id) REFERENCES Driver(Id),
						FOREIGN KEY(Product_id) REFERENCES Product(Id));

INSERT INTO Delivery VALUES(10124, 'Farranfore', 1331, 12, 2, 'Kerry', 4875);
INSERT INTO Delivery VALUES(10123, 'Ranelagh', 1332, 11, 1, 'Dublin', 52867);
INSERT INTO Delivery VALUES(10126, 'Coolwood', 1333, 11, 4, 'Cork', 38675);
INSERT INTO Delivery VALUES(10125, 'Newry', 1334, 1, 5, 'Down', 435);

--This trigger will delete a delivery if an order has been cancelled (i.e when a customer has been deleted).
--The reason for this trigger is because a delivery cannot exist if the cutomer of whom the delivery is for, does not exist.
CREATE OR REPLACE TRIGGER Cancel_order
		BEFORE DELETE ON Customer
		FOR EACH ROW
		WHEN(OLD.Address IS NOT NULL)
DECLARE 
		Customer_address VARCHAR(50);
BEGIN
		Customer_address := :OLD.Address;
		DELETE Delivery
		WHERE Cus_address = Customer_address;
END Cancel_order;
.
RUN;

CREATE USER Staff
CREATE USER Manager

CREATE VIEW Staff_view_of_drivers
AS SELECT Id, Name, Phone_no, Truck_reg
FROM Driver;

CREATE VIEW Manager_view_of_drivers
AS SELECT Id, DOB, Salary, Pen_Points, Name, Phone_no, Truck_reg
FROM Driver;

CREATE VIEW Intel_products
AS SELECT Id, Model, Price, Brand
FROM Product
WHERE Brand = 'Intel';

CREATE VIEW Dublin_deliveries
AS SELECT Del_num, Cus_address, Driver_id, Departure_time, Arrival_time, County, Product_id
FROM Delivery
WHERE County = 'Dublin';

GRANT SELECT ON Staff_view_of_drivers TO Staff
GRANT SELECT, DELETE, UPDATE ON Manager_view_of_drivers TO Manager

--Below is my creation of a PL/SQL sequence which notifies the user that there is only
--1 samsung product left. I used PL/SQL variables for this and I thought this would be a
--creative way of showing that I know how to use them.
DECLARE
	p_id Product.Id%type;
	p_brand Product.Brand%type := 'Samsung';
	p_price Product.Price%type;
BEGIN
	SELECT Id, Brand, Price INTO p_id, p_brand, p_price
	FROM Product
	WHERE Brand = p_brand;

	dbms_output.put_line
	('***ALERT***');
	dbms_output.put_line
	('There is only 1 ' || p_brand || ' product(id: ' || p_id || ') remaining. Valued at ' || p_price || ' euro.');
END;
/	

	