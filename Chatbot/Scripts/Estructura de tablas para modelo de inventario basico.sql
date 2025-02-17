CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255)
);

CREATE TABLE Marcas (
    MarcaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL
);

CREATE TABLE Modelos (
    ModeloID INT PRIMARY KEY IDENTITY(1,1),
    MarcaID INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    FOREIGN KEY (MarcaID) REFERENCES Marcas(MarcaID)
);

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    CategoriaID INT NOT NULL,
    ModeloID INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Costo DECIMAL(10, 2) NOT NULL,
	PVP DECIMAL(10, 2) NOT NULL,
	FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    FOREIGN KEY (ModeloID) REFERENCES Modelos(ModeloID)
);

CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
	Identificacion Int NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Contraseña NVARCHAR(100) NOT NULL,
    CategoriaPreferidaID INT,
	FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoriaPreferidaID) REFERENCES Categorias(CategoriaID)
);


CREATE TABLE Sucursales (
    SucursalID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(255) NOT NULL,
    Ciudad NVARCHAR(100) NOT NULL,
    Estado NVARCHAR(100) NOT NULL,
    CodigoPostal NVARCHAR(20) NOT NULL
);

CREATE TABLE Ubicaciones (
    UbicacionID INT PRIMARY KEY IDENTITY(1,1),
    SucursalID INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    FOREIGN KEY (SucursalID) REFERENCES Sucursales(SucursalID)
);

CREATE TABLE MovimientosInventario (
    MovimientoID INT PRIMARY KEY IDENTITY(1,1),
    ProductoID INT NOT NULL,
    UbicacionID INT NOT NULL,
    TipoMovimiento NVARCHAR(50) NOT NULL, -- 'Ingreso' o 'Salida'
    Cantidad INT NOT NULL,
    FechaMovimiento DATETIME NOT NULL,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (UbicacionID) REFERENCES Ubicaciones(UbicacionID)
);

CREATE TABLE LogsActividad (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UsuarioID INT,
    Accion NVARCHAR(255),
    FechaHora DATETIME DEFAULT GETDATE(),
    Detalles NVARCHAR(1000),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Errores (
    ErrorID INT PRIMARY KEY IDENTITY(1,1),
    FechaHora DATETIME DEFAULT GETDATE(),
    UsuarioID INT,
    MensajeError NVARCHAR(1000),
    StackTrace NVARCHAR(MAX),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);