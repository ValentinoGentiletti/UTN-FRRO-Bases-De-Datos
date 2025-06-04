CREATE DATABASE IF NOT EXISTS techouse;
USE techouse; 
create table if not exists clientes(
	id_cliente INT auto_increment PRIMARY KEY, 
    nombre varchar(100) not null, 
    apellido varchar(100) not null, 
    dni varchar(50) unique not null, 
    email varchar(100), 
    fecha_registro datetime not null
);
create table if not exists productos(
	id_producto INT auto_increment PRIMARY KEY,
    nombre varchar(100) not null,
    categoria varchar(100) not null, 
    precio decimal(8,2) NOT NULL CHECK (precio > 0),
    stock int CHECK (stock >= 0)
);
create table if not exists empleados(
	id_empleado int primary key, 
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    puesto varchar(100), 
    salario decimal(8,2) NOT NULL CHECK (salario > 0)
);

create table if not exists ventas(
	id_venta int primary key , 
    fecha_venta datetime not null,
    id_cliente int,
    id_empleado int, 
    foreign key(id_cliente) references clientes(id_cliente),
    foreign key(id_empleado) references empleados(id_empleado)
);
create table if not exists detalle_venta(
	id_venta int,
    id_producto int,
    cantidad int check(cantidad > 0),
    precio_unitario decimal(8,2) not null,
    PRIMARY KEY (id_venta, id_producto),
    foreign key(id_venta) references ventas(id_venta) ,
    foreign key(id_producto) references productos(id_producto)
);
# Insertar datos en la tabla clientes
INSERT INTO clientes (nombre, apellido, dni, email, fecha_registro) VALUES
('Juan', 'Perez', '12345678A', 'juan.perez@example.com', '2023-01-15 10:00:00'),
('Maria', 'Gomez', '87654321B', 'maria.gomez@example.com', '2023-02-20 11:30:00'),
('Carlos', 'Rodriguez', '11223344C', 'carlos.r@example.com', '2023-03-01 09:00:00'),
('Ana', 'Martinez', '55667788D', 'ana.m@example.com', '2023-03-05 14:00:00'),
('Pedro', 'Lopez', '99887766E', NULL, '2023-04-10 16:00:00'),
('Laura', 'Diaz', '12312312F', 'laura.d@example.com', '2023-04-12 09:30:00');

# Insertar datos en la tabla productos
INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Laptop Gamer X200', 'Electrónica', 1200.00, 50),
('Monitor Curvo 27"', 'Periféricos', 300.00, 120),
('Teclado Mecánico RGB', 'Periféricos', 80.00, 200),
('Mouse Inalámbrico Pro', 'Periféricos', 45.00, 300),
('Disco SSD 1TB', 'Componentes', 90.00, 80),
('Webcam Full HD', 'Periféricos', 35.00, 150),
('Auriculares Gaming', 'Audio', 60.00, 100);

# Insertar datos en la tabla empleados
INSERT INTO empleados (id_empleado, nombre, apellido, puesto, salario) VALUES
(1, 'Roberto', 'Sanchez', 'Vendedor Senior', 2500.00),
(2, 'Luisa', 'Fernandez', 'Vendedora Junior', 1800.00),
(3, 'Miguel', 'Torres', 'Gerente de Ventas', 3500.00);

#  Insertar datos en la tabla ventas
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_empleado) VALUES
(101, '2023-05-01 10:15:00', 1, 1),
(102, '2023-05-01 11:00:00', 2, 2),
(103, '2023-05-02 14:30:00', 1, 1), -- Juan Perez realiza otra compra
(104, '2023-05-03 09:45:00', 3, 2),
(105, '2023-05-03 16:00:00', 4, 1),
(106, '2023-05-04 10:00:00', 1, 1), -- Juan Perez realiza una tercera compra
(107, '2023-05-05 12:00:00', 2, 2),
(108, '2023-05-05 15:00:00', 6, 3); -- Nueva venta para Laura Diaz, atendida por Miguel Torres

#  Insertar datos en la tabla detalle_venta
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(101, 1, 1, 1200.00), -- Venta 101: Laptop Gamer
(101, 3, 1, 80.00),   -- Venta 101: Teclado Mecánico
(102, 2, 2, 300.00),  -- Venta 102: Monitores Curvos
(103, 5, 1, 90.00),   -- Venta 103: Disco SSD
(103, 4, 1, 45.00),   -- Venta 103: Mouse
(104, 1, 1, 1200.00), -- Venta 104: Laptop Gamer
(105, 6, 3, 35.00),   -- Venta 105: Webcams
(106, 7, 2, 60.00),   -- Venta 106: Auriculares Gaming (producto nuevo)
(106, 3, 1, 80.00),   -- Venta 106: Teclado Mecánico
(107, 2, 1, 300.00),  -- Venta 107: Monitor Curvo
(108, 1, 1, 1200.00),  -- Venta 108: Laptop Gamer
(108, 4, 1, 45.00);   -- Venta 108: Mouse Inalámbrico

# PARTE 2 CONSULTAS --------------------- 
-- ej 6
SELECT
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    v.fecha_venta,
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado
FROM
    clientes c
JOIN
    ventas v ON c.id_cliente = v.id_cliente
JOIN
    empleados e ON v.id_empleado = e.id_empleado;
-- ej 7
 select
	p.nombre as nombre_product,
    dv.cantidad as cantidad_vendida,
    dv.precio_unitario,
    v.fecha_venta
from
	detalle_venta dv 
join
	productos p on dv.id_producto = p.id_producto
join
	ventas v on dv.id_venta = v.id_venta
order by
	v.fecha_venta;

-- ej 8 
SELECT
	p.nombre as nombre_producto,
    p.stock as stock_actual,
    SUM(COALESCE(dv.cantidad, 0)) AS cantidad_total_vendida
from 
	productos p
left join 
	detalle_venta dv on p.id_producto = dv.id_producto
group by
    p.id_producto, p.nombre, p.stock
order by
    p.nombre;
-- ej 9
select
    e.nombre,
    e.apellido,
    SUM(dv.cantidad * dv.precio_unitario) AS total_facturado
from
    empleados e
join
    ventas v ON e.id_empleado = v.id_empleado
join
    detalle_venta dv ON v.id_venta = dv.id_venta
group by
    e.id_empleado, e.nombre, e.apellido
order by
    total_facturado DESC;
-- ej 10 
SELECT
    c.nombre,
    c.apellido,
    COUNT(v.id_venta) AS cantidad_ventas
FROM
    clientes c
JOIN
    ventas v ON c.id_cliente = v.id_cliente
GROUP BY
    c.id_cliente, c.nombre, c.apellido
HAVING
    COUNT(v.id_venta) > 2
ORDER BY
    c.apellido, c.nombre;



    