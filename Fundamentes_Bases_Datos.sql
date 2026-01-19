CREATE TABLE clients(
  clientId INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone_number varchar(15) NOT NULL,
  created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
  updated_at DATETIME2 NULL
);

CREATE TABLE products(
 productId INT IDENTITY(1,1) PRIMARY KEY,
 name VARCHAR(20) NOT NULL ,
 slug VARCHAR(200) NOT NULL UNIQUE,
 description VARCHAR(150),
 created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
 updated_at DATETIME2 NULL
);



CREATE TABLE bills(
 billId  INT IDENTITY(1,1) PRIMARY KEY,
 clientId INT NOT NULL,
 total DECIMAL(10,2),
 status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'PAID', 'CANCELLED')),
 created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
 updated_at DATETIME2 NULL
 CONSTRAINT FK_bills_clients FOREIGN KEY (clientId) REFERENCES clients(clientId) ON DELETE NO ACTION
)

CREATE TABLE bills_products(
 bilproductId  INT IDENTITY(1,1) PRIMARY KEY,
 billId INT NOT NULL,
 productId INT NOT NULL,
 quantity INT NOT NULL CHECK (quantity > 0),
 unit_price DECIMAL(10,2) NOT NULL,
 created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
 updated_at DATETIME2 NULL,
 CONSTRAINT FK_bills_products_bills FOREIGN KEY (billId) REFERENCES bills(billId) ON DELETE CASCADE,
 CONSTRAINT FK_bills_products_products FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE NO ACTION,
)

CREATE TABLE TEST (
testId INT IDENTITY(1,1) PRIMARY KEY,
name VARCHAR(120) NOT NULL ,
qty INT,
created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,

);

-- ==========================================
SELECT * FROM TEST

--AGREGAR COLUMNA
ALTER TABLE TEST ADD price DECIMAL(10,2) ;
--ELIMINAR COLUMNA
ALTER TABLE TEST DROP COLUMN price;
--MODIFICAR COLUMNA
ALTER TABLE TEST ALTER COLUMN price DECIMAL(10,2) NOT NULL;
--modificar nombre columna 
EXEC sp_rename 'TEST.price', 'prices', 'COLUMN';

--MODIFICAR CNOMBRE TABLA
EXEC sp_rename 'TEST', 'test';

--INGRESAR DATOS 
 INSERT INTO products(name,slug) values ('pluma azul', 'pluma-azul');

 --ELIMINAR TABLAS
 DROP TABLE bills_products
 DROP TABLE bills
 DROP TABLE clients
 DROP TABLE products
 DROP TABLE TEST

 
 --SEGUNDA PARTE DE CREANDO TABLAS A MANERA PROFESIONAL

CREATE TABLE products(
 productId INT IDENTITY(1,1) PRIMARY KEY,
 sku VARCHAR(20) NOT NULL UNIQUE ,
 name VARCHAR(20) NOT NULL ,
 slug VARCHAR(200) NOT NULL UNIQUE,
 price DECIMAL(10,2) NOT NULL,
 description VARCHAR(150),
 created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
 updated_at DATETIME2 NULL
)

CREATE TABLE clients(
  clientId INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone_number varchar(15) NOT NULL,
  created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
  updated_at DATETIME2 NULL
);

CREATE TABLE bills(
 billId  INT IDENTITY(1,1) PRIMARY KEY,
 clientId INT NOT NULL,
 total DECIMAL(10,2),
 status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'PAID', 'CANCELLED')),
 created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
 updated_at DATETIME2 NULL
 CONSTRAINT FK_bills_clients FOREIGN KEY (clientId) REFERENCES clients(clientId) ON DELETE NO ACTION
)

CREATE TABLE bills_products(
 bilproductId  INT IDENTITY(1,1) PRIMARY KEY,
 billId INT NOT NULL,
 productId INT NOT NULL,
 quantity INT NOT NULL CHECK (quantity > 0),
 unit_price DECIMAL(10,2) NOT NULL,
 created_at DATETIME2  NOT NULL DEFAULT SYSDATETIME() ,
 updated_at DATETIME2 NULL,
 CONSTRAINT FK_bills_products_bills FOREIGN KEY (billId) REFERENCES bills(billId) ON DELETE CASCADE,
 CONSTRAINT FK_bills_products_products FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE NO ACTION,
)


INSERT INTO products (sku, name, slug, price, description)
VALUES
('SKU-001', 'Toalla Blanca', 'toalla-blanca-algodon', 25.50, 'Toalla de algodón blanca'),
('SKU-002', 'Televisor 65', 'televisor-65-smart', 3200.00, 'Smart TV 65 pulgadas 4K'),
('SKU-003', 'Jabon Hotel', 'jabon-hotel', 5.00, 'Jabón de uso hotelero'),
('SKU-004', 'Laptop Pro', 'laptop-pro-16gb', 4500.99, 'Laptop profesional 16GB RAM'),
('SKU-005', 'Secador Pelo', 'secador-pelo-hotel', 120.75, 'Secador de pelo compacto');


INSERT INTO clients (name, email, phone_number)
VALUES
('Luis Vilchez', 'luis@gmail.com', '999111222'),
('Ana Torres', 'ana@gmail.com', '988222333'),
('Carlos Perez', 'carlos@gmail.com', '977333444'),
('Maria Lopez', 'maria@gmail.com', '966444555'),
('Jorge Ramirez', 'jorge@gmail.com', '955555666');


INSERT INTO bills (clientId, total, status)
VALUES
(1, 3250.50, 'PAID'),
(2, 50.00, 'PENDING'),
(3, 4620.99, 'PAID'),
(4, 120.75, 'CANCELLED'),
(5, 25.50, 'PAID');


INSERT INTO bills_products (billId, productId, quantity, unit_price)
VALUES
(1, 7, 1, 3200.00),
(1, 6, 2, 25.25),
(2, 8, 10, 5.00),
(3, 9, 1, 4500.99);

--para se parece o contenga %luis - luis% - %luis%
SELECT name,email   FROM clients  WHERE name LIKE '%Luis%';
--actualizar
UPDATE clients SET phone_number = '945143815' WHERE name LIKE '%Luis%';

--AGREGAMOS COLUMNA PARA NO ELIMINAR
ALTER TABLE clients ADD isActive BIT NOT NULL DEFAULT 1;
EXEC sp_rename 'clients.isActive', 'isDelete', 'COLUMN';


SELECT name,price ,price*10 AS MULT FROM products 
WHERE price <100
ORDER BY productId DESC;

--funciones agregadoras 
SELECT 
  LEN(name) AS longitud_nombre,
  COUNT(*) AS total
FROM clients
GROUP BY LEN(name)
ORDER BY longitud_nombre;



-- 

SELECT 
  c.clientId,
  c.name AS cliente,
  b.billId,
  b.total,
  b.status
FROM clients c
INNER JOIN bills b 
	ON c.clientId = b.clientId;

SELECT 
  b.billId,
  c.name AS cliente,
  p.name AS producto,
  bp.quantity,
  bp.unit_price,
  (bp.quantity * bp.unit_price) AS subtotal
FROM bills b
INNER JOIN clients c 
	ON b.clientId = c.clientId
INNER JOIN bills_products bp 
	ON b.billId = bp.billId
INNER JOIN products p 
	ON bp.productId = p.productId
ORDER BY b.billId;

