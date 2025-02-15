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
(1, 1, 'Samsung Galaxy S21', 'Smartphone de �ltima generaci�n', 700.00, 999.99),
(1, 2, 'Apple iPhone 13', 'Smartphone de �ltima generaci�n', 800.00, 1099.99),
(1, 3, 'Sony Bravia TV', 'Televisor 4K Ultra HD', 500.00, 799.99),
(2, 4, 'Nike Air Max 90', 'Zapatillas deportivas', 60.00, 120.00),
(2, 5, 'Adidas Ultraboost', 'Zapatillas de running', 80.00, 150.00);


-- Poblar la tabla Usuarios con identificaciones �nicas
INSERT INTO Usuarios (Nombre, Identificacion, Email, Contrase�a, CategoriaPreferidaID) VALUES
('Juan P�rez', 12345678, 'juan.perez@example.com', 'password123', 1),
('Mar�a L�pez', 87654321, 'maria.lopez@example.com', 'password456', 2),
('Carlos Garc�a', 11223344, 'carlos.garcia@example.com', 'password789', 3);


INSERT INTO Sucursales (Nombre, Direccion, Ciudad, Estado, CodigoPostal) VALUES
('Ktronix Bogot� Centro', 'Calle 13 #34-56', 'Bogot�', 'Cundinamarca', '110321'),
('Ktronix Bogot� Norte', 'Carrera 15 #78-45', 'Bogot�', 'Cundinamarca', '110221'),
('Ktronix Bogot� Sur', 'Avenida 68 #22-10', 'Bogot�', 'Cundinamarca', '110511'),
('Ktronix Bogot� Occidente', 'Calle 80 #90-30', 'Bogot�', 'Cundinamarca', '110911');

-- Poblar la tabla Ubicaciones
INSERT INTO Ubicaciones (SucursalID, Nombre, Descripcion) VALUES
(1, 'Almac�n Principal', 'Almac�n principal de la tienda Ktronix Bogot� Centro'),
(1, 'Almac�n Secundario', 'Almac�n secundario de la tienda Ktronix Bogot� Centro'),
(2, 'Almac�n Principal', 'Almac�n principal de la tienda Ktronix Bogot� Norte'),
(3, 'Almac�n Principal', 'Almac�n principal de la tienda Ktronix Bogot� Sur'),
(4, 'Almac�n Principal', 'Almac�n principal de la tienda Ktronix Bogot� Occidente');


-- Poblar la tabla MovimientosInventario con ingresos de mercanc�a
INSERT INTO MovimientosInventario (ProductoID, UbicacionID, TipoMovimiento, Cantidad, FechaMovimiento) VALUES
(2, 1, 'Ingreso', 50, '2025-02-01'), -- Ingreso de 50 unidades de Samsung Galaxy S21 al Almac�n Principal de Ktronix Bogot� Centro
(3, 1, 'Ingreso', 30, '2025-02-01'), -- Ingreso de 30 unidades de Apple iPhone 13 al Almac�n Principal de Ktronix Bogot� Centro
(4, 2, 'Ingreso', 20, '2025-02-01'), -- Ingreso de 20 unidades de Sony Bravia TV al Almac�n Secundario de Ktronix Bogot� Centro
(5, 3, 'Ingreso', 40, '2025-02-01'), -- Ingreso de 40 unidades de Nike Air Max 90 al Almac�n Principal de Ktronix Bogot� Norte
(6, 4, 'Ingreso', 25, '2025-02-01'), -- Ingreso de 25 unidades de Adidas Ultraboost al Almac�n Principal de Ktronix Bogot� Sur
(2, 5, 'Ingreso', 60, '2025-02-01'), -- Ingreso de 60 unidades de Samsung Galaxy S21 al Almac�n Principal de Ktronix Bogot� Occidente
(3, 5, 'Ingreso', 35, '2025-02-01'), -- Ingreso de 35 unidades de Apple iPhone 13 al Almac�n Principal de Ktronix Bogot� Occidente
(4, 5, 'Ingreso', 15, '2025-02-01'); -- Ingreso de 15 unidades de Sony Bravia TV al Almac�n Principal de Ktronix Bogot� Occidente