-- Caso 1: Optimización y seguridad en la gestión de inventarios
-- Creación de tablas
CREATE TABLE Productos (
    producto_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    categoria_id NUMBER,
    precio DECIMAL(10, 2),
    stock NUMBER
);

CREATE TABLE Categorias (
    categoria_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255)
);

CREATE TABLE Almacenes (
    almacen_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    ubicación VARCHAR2(255)
);

CREATE TABLE Movimientos (
    movimiento_id NUMBER PRIMARY KEY,
    producto_id NUMBER,
    almacen_id NUMBER,
    cantidad NUMBER,
    fecha DATE,
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id),
    FOREIGN KEY (almacen_id) REFERENCES Almacenes(almacen_id)
);

-- Creación de secuencias
CREATE SEQUENCE producto_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE categoria_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE almacen_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE movimiento_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Poblamiento de datos
BEGIN
    -- Insertar Categorías
    INSERT INTO Categorias VALUES (categoria_seq.NEXTVAL, 'Electrónica');
    INSERT INTO Categorias VALUES (categoria_seq.NEXTVAL, 'Hogar');
    INSERT INTO Categorias VALUES (categoria_seq.NEXTVAL, 'Ropa');

    -- Insertar Almacenes
    INSERT INTO Almacenes VALUES (almacen_seq.NEXTVAL, 'Almacén Central', 'Ciudad Central');
    INSERT INTO Almacenes VALUES (almacen_seq.NEXTVAL, 'Almacén Norte', 'Ciudad Norte');
    INSERT INTO Almacenes VALUES (almacen_seq.NEXTVAL, 'Almacén Sur', 'Ciudad Sur');

    -- Insertar Productos
    INSERT INTO Productos VALUES (producto_seq.NEXTVAL, 'Laptop Pro', 1, 1200.00, 50);
    INSERT INTO Productos VALUES (producto_seq.NEXTVAL, 'Smartphone Max', 1, 800.00, 30);
    INSERT INTO Productos VALUES (producto_seq.NEXTVAL, 'Aspiradora', 2, 150.00, 75);

    -- Insertar Movimientos
    INSERT INTO Movimientos VALUES (movimiento_seq.NEXTVAL, 1, 1, 20, TO_DATE('2023-06-01', 'YYYY-MM-DD'));
    INSERT INTO Movimientos VALUES (movimiento_seq.NEXTVAL, 2, 2, 10, TO_DATE('2023-06-05', 'YYYY-MM-DD'));
    INSERT INTO Movimientos VALUES (movimiento_seq.NEXTVAL, 3, 3, 15, TO_DATE('2023-06-10', 'YYYY-MM-DD'));

END;
/

-- Creación de vistas, sinónimos, índices y secuencias
CREATE OR REPLACE VIEW Vista_Productos_Stock AS
SELECT p.nombre AS producto_nombre, 
       c.nombre AS categoria_nombre, 
       p.stock, 
       a.ubicación AS almacen_ubicacion
FROM Productos p
JOIN Categorias c ON p.categoria_id = c.categoria_id
JOIN Movimientos m ON p.producto_id = m.producto_id
JOIN Almacenes a ON m.almacen_id = a.almacen_id;

CREATE OR REPLACE SYNONYM Movs FOR Movimientos;

CREATE INDEX idx_productos_stock ON Productos(stock);

-- Creación de usuario y rol
CREATE USER analista IDENTIFIED BY Analista_2024ABC;
GRANT CREATE SESSION TO analista;

CREATE ROLE rol_lectura;
GRANT SELECT ON Vista_Productos_Stock TO rol_lectura;
GRANT rol_lectura TO analista;


-- Caso 2: Gestión de pedidos y clientes
-- Creación de tablas
CREATE TABLE Clientes (
    cliente_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(255),
    email VARCHAR2(255),
    fecha_registro DATE
);

CREATE TABLE Pedidos (
    pedido_id NUMBER PRIMARY KEY,
    cliente_id NUMBER,
    fecha_pedido DATE,
    total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE Detalles_Pedido (
    detalle_id NUMBER PRIMARY KEY,
    pedido_id NUMBER,
    producto_id NUMBER,
    cantidad NUMBER,
    precio_unitario DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- Creación de secuencias
CREATE SEQUENCE cliente_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE pedido_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE SEQUENCE detalle_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Poblamiento de datos
BEGIN
-- Insertar Clientes
    INSERT INTO Clientes VALUES (cliente_seq.NEXTVAL, 'Juan Perez', 'juan.perez@gmail.com', TO_DATE('2020-01-15', 'YYYY-MM-DD'));
    INSERT INTO Clientes VALUES (cliente_seq.NEXTVAL, 'Ana Gomez', 'ana.gomez@gmail.com', TO_DATE('2021-05-22', 'YYYY-MM-DD'));
    INSERT INTO Clientes VALUES (cliente_seq.NEXTVAL, 'Luis Rodriguez', 'luis.rodriguez@gmail.com', TO_DATE('2022-09-30', 'YYYY-MM-DD'));

    -- Insertar Pedidos
    INSERT INTO Pedidos VALUES (pedido_seq.NEXTVAL, 1, TO_DATE('2023-07-01', 'YYYY-MM-DD'), 2400.00);
    INSERT INTO Pedidos VALUES (pedido_seq.NEXTVAL, 2, TO_DATE('2023-08-15', 'YYYY-MM-DD'), 1600.00);

    -- Insertar Detalles de Pedido (corrección aplicada)
    INSERT INTO Detalles_Pedido VALUES (detalle_seq.NEXTVAL, 1, 1, 2, 1200.00);
    INSERT INTO Detalles_Pedido VALUES (detalle_seq.NEXTVAL, 2, 2, 2, 800.00);
END;
/

-- Creación de vistas, sinónimos, índices y secuencias
CREATE OR REPLACE VIEW Vista_Pedidos_Detalles AS
SELECT c.nombre AS cliente_nombre,
       p.fecha_pedido,
       prod.nombre AS producto_nombre,
       d.cantidad,
       (d.cantidad * d.precio_unitario) AS precio_total
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.cliente_id
JOIN Detalles_Pedido d ON p.pedido_id = d.pedido_id
JOIN Productos prod ON d.producto_id = prod.producto_id;

CREATE OR REPLACE SYNONYM Cli FOR Clientes;

CREATE INDEX idx_pedidos_fecha ON Pedidos(fecha_pedido);


-- Paso 5: Creación de usuario y rol
CREATE USER cliente IDENTIFIED BY Cliente_2024ABC;
GRANT CREATE SESSION TO cliente;

CREATE ROLE rol_cliente;
GRANT SELECT ON Vista_Pedidos_Detalles TO rol_cliente;
GRANT rol_cliente TO cliente;
/







