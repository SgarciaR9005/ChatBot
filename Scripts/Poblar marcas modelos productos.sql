INSERT INTO Marcas (Nombre) VALUES
('Samsung'),
('Apple'),
('Sony'),
('Nike'),
('Adidas');

-- Poblar la tabla Modelos
INSERT INTO Modelos (MarcaID, Nombre) VALUES
(1, 'Galaxy S21'),
(2, 'iPhone 13'),
(3, 'Bravia TV'),
(4, 'Air Max 90'),
(5, 'Ultraboost');



INSERT INTO Productos (CategoriaID, ModeloID, Nombre, Descripcion, Costo, PVP) VALUES
(1, 1, 'Samsung Galaxy S21', 'Smartphone de última generación', 700.00, 999.99),
(1, 2, 'Apple iPhone 13', 'Smartphone de última generación', 800.00, 1099.99),
(1, 3, 'Sony Bravia TV', 'Televisor 4K Ultra HD', 500.00, 799.99),
(2, 4, 'Nike Air Max 90', 'Zapatillas deportivas', 60.00, 120.00),
(2, 5, 'Adidas Ultraboost', 'Zapatillas de running', 80.00, 150.00);


-- Poblar la tabla Usuarios con identificaciones únicas
INSERT INTO Usuarios (Nombre, Identificacion, Email, Contraseña, CategoriaPreferidaID) VALUES
('Juan Pérez', 12345678, 'juan.perez@example.com', 'password123', 1),
('María López', 87654321, 'maria.lopez@example.com', 'password456', 2),
('Carlos García', 11223344, 'carlos.garcia@example.com', 'password789', 3);


INSERT INTO Sucursales (Nombre, Direccion, Ciudad, Estado, CodigoPostal) VALUES
('Ktronix Bogotá Centro', 'Calle 13 #34-56', 'Bogotá', 'Cundinamarca', '110321'),
('Ktronix Bogotá Norte', 'Carrera 15 #78-45', 'Bogotá', 'Cundinamarca', '110221'),
('Ktronix Bogotá Sur', 'Avenida 68 #22-10', 'Bogotá', 'Cundinamarca', '110511'),
('Ktronix Bogotá Occidente', 'Calle 80 #90-30', 'Bogotá', 'Cundinamarca', '110911');

-- Poblar la tabla Ubicaciones
INSERT INTO Ubicaciones (SucursalID, Nombre, Descripcion) VALUES
(1, 'Almacén Principal', 'Almacén principal de la tienda Ktronix Bogotá Centro'),
(1, 'Almacén Secundario', 'Almacén secundario de la tienda Ktronix Bogotá Centro'),
(2, 'Almacén Principal', 'Almacén principal de la tienda Ktronix Bogotá Norte'),
(3, 'Almacén Principal', 'Almacén principal de la tienda Ktronix Bogotá Sur'),
(4, 'Almacén Principal', 'Almacén principal de la tienda Ktronix Bogotá Occidente');


-- Poblar la tabla MovimientosInventario con ingresos de mercancía
INSERT INTO MovimientosInventario (ProductoID, UbicacionID, TipoMovimiento, Cantidad, FechaMovimiento) VALUES
(2, 1, 'Ingreso', 50, '2025-02-01'), -- Ingreso de 50 unidades de Samsung Galaxy S21 al Almacén Principal de Ktronix Bogotá Centro
(3, 1, 'Ingreso', 30, '2025-02-01'), -- Ingreso de 30 unidades de Apple iPhone 13 al Almacén Principal de Ktronix Bogotá Centro
(4, 2, 'Ingreso', 20, '2025-02-01'), -- Ingreso de 20 unidades de Sony Bravia TV al Almacén Secundario de Ktronix Bogotá Centro
(5, 3, 'Ingreso', 40, '2025-02-01'), -- Ingreso de 40 unidades de Nike Air Max 90 al Almacén Principal de Ktronix Bogotá Norte
(6, 4, 'Ingreso', 25, '2025-02-01'), -- Ingreso de 25 unidades de Adidas Ultraboost al Almacén Principal de Ktronix Bogotá Sur
(2, 5, 'Ingreso', 60, '2025-02-01'), -- Ingreso de 60 unidades de Samsung Galaxy S21 al Almacén Principal de Ktronix Bogotá Occidente
(3, 5, 'Ingreso', 35, '2025-02-01'), -- Ingreso de 35 unidades de Apple iPhone 13 al Almacén Principal de Ktronix Bogotá Occidente
(4, 5, 'Ingreso', 15, '2025-02-01'); -- Ingreso de 15 unidades de Sony Bravia TV al Almacén Principal de Ktronix Bogotá Occidente