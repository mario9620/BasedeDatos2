CREATE DATABASE OLTP;
GO

USE OLTP;
GO

CREATE TABLE Persona
(
IdPersona INTEGER PRIMARY KEY ,
PrimerNombre VARCHAR(50) NOT NULL,
SegundoNombre VARCHAR(50) ,
PrimerApellido VARCHAR(50)NOT NULL,
Sexo VARCHAR(20) NOT NULL,
CorreoElectronico VARCHAR(50) NOT NULL UNIQUE,
Identidad VARCHAR(13) NOT NULL UNIQUE,
RTN VARCHAR(14) NOT NULL UNIQUE
)
GO

ALTER TABLE Persona 
ADD CONSTRAINT Ck_person_Id CHECK (Identidad LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

ALTER TABLE Persona 
ADD CONSTRAINT Ck_person_RTN CHECK (RTN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO
--/Contiene el Historial de las Facturas
CREATE TABLE HistorialFactura(
IdHistorialFactura INTEGER PRIMARY KEY,
Descripcion VARCHAR(100) NOT NULL
)
GO

--// Esta tabla hereda la informacion de la tabla persona y identifica a la persona como cliente
CREATE TABLE Cliente(
IdCliente INTEGER PRIMARY KEY ,
IdPersonaC INTEGER NOT NULL,
FOREIGN KEY (IdPersonaC) REFERENCES Persona (IdPersona),
IdHistorialCompra INTEGER NOT NULL
FOREIGN KEY (IdHistorialCompra) REFERENCES HistorialFactura(IdHistorialFactura)
);
GO

--/Esta tabla muestra la informacion de los proveedores
CREATE TABLE Proveedor(
IdProveedor INTEGER PRIMARY KEY,
NombreProveedor VARCHAR(50) NOT NULL,
Direccion VARCHAR(100) NOT NULL,
Pais VARCHAR(50) NOT NULL,
)
GO
--/Describe la informacion de las sucursales
CREATE TABLE Sucursal(
IdSucursal INTEGER PRIMARY KEY,
NombreSucursal VARCHAR(50) NOT NULL,
NumeroSucursal INTEGER NOT NULL,
Departamento VARCHAR(50) NOT NULL,
DireccionEspecifica VARCHAR(100) NOT NULL
)
GO

ALTER TABLE Sucursal
ADD CONSTRAINT CK_Departament_Name CHECK (
		Departamento='Atlántida'  OR
		Departamento='Colón' OR
		Departamento='Comayagua'  OR
		Departamento='Copán' OR
		Departamento='Cortés'  OR
		Departamento='Choluteca' OR
		Departamento='El Paraíso' OR
		Departamento='Francisco Morazán'  OR
		Departamento='Gracias a Dios' OR
		Departamento='Intibucá'  OR
		Departamento='Islas de la Bahía'  OR
		Departamento='La Paz' OR
		Departamento='Lempira'OR
		Departamento='Ocotopeque'  OR
		Departamento='Olancho'  OR
		Departamento='Santa Bárbara' OR
		Departamento='Valle'  OR
		Departamento='Yoro' 
);

--//Muestra los numeros de la tienda 
CREATE TABLE Telefono(
IdTelefono INTEGER PRIMARY KEY,
Numero VARCHAR(9) NOT NULL,
IdClienteT INTEGER NOT NULL
FOREIGN KEY(IdClienteT) REFERENCES Cliente(IdCliente),
IdProveedorT INTEGER NOT NULL
FOREIGN KEY(IdProveedorT) REFERENCES Proveedor(IdProveedor),
IdSucursalT INTEGER NOT NULL
FOREIGN KEY (IdSucursalT) REFERENCES Sucursal(IdSucursal)
)

--/Tabla que muestra la informacion del empleado
CREATE TABLE Empleado(
IdEmpleado INTEGER PRIMARY KEY,
FechaContratacion DATE NOT NULL,
SalarioBase FLOAT NOT NULL,
Estado VARCHAR(50) NOT NULL ,
Jefe INTEGER 
FOREIGN KEY(Jefe) REFERENCES Empleado(IdEmpleado),
IdPersonaE INTEGER NOT NULL,
FOREIGN KEY (IdPersonaE) REFERENCES Persona (IdPersona)
);
GO

ALTER TABLE Empleado
ADD CONSTRAINT CHK_Salary CHECK (SalarioBase>0);

--/Tabla que muestra la los cargos de la empresa
CREATE TABLE Cargo(
IdCargo INTEGER PRIMARY KEY ,
NombreCargo VARCHAR(50) NOT NULL UNIQUE
);
GO

--//Esta tabla contiene el catalogo de los cargos de los empleados
CREATE TABLE CargoEmpleado(
FechaInicio DATE NOT NULL,
IdEmpleadoE INTEGER NOT NULL,
FOREIGN KEY (IdEmpleadoE) REFERENCES Empleado (IdEmpleado),
IdCargoE INTEGER NOT NULL,
FOREIGN KEY (IdCargoE) REFERENCES Cargo (IdCargo),
PRIMARY KEY (IdEmpleadoE,IdCargoE)
);
GO



--/Aqui Mostramos las categorias de productos disponibles
CREATE TABLE Categoria(
IdCategoria INTEGER PRIMARY KEY,
NombreCategoria VARCHAR(50) NOT NULL,
DescripcionCategoria VARCHAR(100) NOT NULL,
)
GO

--/Esta tabla contiene los productos que posee una tienda
CREATE TABLE Producto(
IdProducto INTEGER PRIMARY KEY,
CodigoProducto VARCHAR(10) UNIQUE,
NombreProducto VARCHAR(100) NOT NULL,
DescripcionPro VARCHAR(100) NOT NULL,
Marca VARCHAR(50) NOT NULL,
PrecioUnitario DECIMAL NOT NULL,
CostoUnitario DECIMAL NOT NULL,
IdCategoria INTEGER NOT NULL
FOREIGN KEY(IdCategoria) REFERENCES Categoria(IdCategoria)
)
GO
--/Muestra los movimientos de inventario 
CREATE TABLE TipoMovimiento(
IdMovimiento INTEGER PRIMARY KEY,
Codigo CHAR(20) NOT NULL UNIQUE,
Nombre CHAR(20) NOT NULL UNIQUE,
Movimiento INTEGER NOT NULL
)
--/Esta nos muestra el inventario de la sucursal correspondiente 
CREATE TABLE Inventario(
IdInventario INTEGER PRIMARY KEY,
Cantidad INTEGER NOT NULL,
Referencia VARCHAR(200),
IdSucursalIn INTEGER NOT NULL
FOREIGN KEY (IdSucursalIn) REFERENCES Sucursal(IdSucursal),
IdProductoIn INTEGER NOT NULL
FOREIGN KEY (IdProductoIn) REFERENCES Producto(IdProducto)
)
GO


CREATE TABLE ProveedorProducto(
IdProductoPP INTEGER NOT NULL
FOREIGN KEY (IdProductoPP) REFERENCES Producto (IdProducto),
IdProveedorPP INTEGER NOT NULL
FOREIGN KEY (IdProveedorPP) REFERENCES Proveedor (IdProveedor),
PRIMARY KEY (IdProductoPP,IdProveedorPP)
);
GO

--/Mostramos la informacion de los tipos de pagos de la factura
CREATE TABLE TipoPago(
IdTipoPago INTEGER PRIMARY KEY ,
NombreTipoP VARCHAR(50) NOT NULL UNIQUE
)
GO

--/Descuentos que puede tener una factura
CREATE TABLE Descuento(
IdDescuento INTEGER PRIMARY KEY,
NombreDescuento  VARCHAR(50) NOT NULL UNIQUE,
Estado BIT NOT NULL
)
GO

--/Esta es la tabla donde se guarda la informacion de una factura a imprimir
CREATE TABLE Factura(
IdFactura INTEGER PRIMARY KEY,
NFactura INT NOT NULL,
ISV DECIMAL NOT NULL,
FechaEmision DATE NOT NULL,
TotalFactura DECIMAL NOT NULL,
IdHistorialF INTEGER NOT NULL
FOREIGN KEY(IdHistorialF) REFERENCES HistorialFactura(IdHistorialFactura),
IdEmpleadoF INTEGER NOT NULL
FOREIGN KEY (IdEmpleadoF) REFERENCES Empleado(IdEmpleado),
IdTipoPago INTEGER NOT NULL
FOREIGN KEY(IdTipoPago) REFERENCES TipoPago (IdTipoPago),
IdDescuento INTEGER NOT NULL
FOREIGN KEY (IdDescuento) REFERENCES Descuento(IdDescuento)
)
GO

--/Muestra la informacion de los tipos de pagos que se aplican en la factura
CREATE TABLE TipoPagoFactura(
IdTipoPago INTEGER NOT NULL
FOREIGN KEY (IdTipoPago) REFERENCES TipoPago(IdTipoPago),
IdFacturaT INTEGER NOT NULL
FOREIGN KEY (IdFacturaT) REFERENCES Factura(IdFactura),
PRIMARY KEY (IdTipoPago,IdFacturaT)
)
GO

CREATE TABLE DescuentoFactura(
IdDescuento INTEGER NOT NULL
FOREIGN KEY (IdDescuento) REFERENCES TipoPago(IdTipoPago),
IdFacturaD INTEGER NOT NULL
FOREIGN KEY (IdFacturaD) REFERENCES Factura(IdFactura),
PRIMARY KEY (IdDescuento,IdFacturaD)
)
GO

--/Aqui mostramos los detalles de factura
CREATE TABLE FacturaDetalle(
IdDetalleFactura INTEGER PRIMARY KEY,
CantidadProductos INTEGER NOT NULL,
Total DECIMAL NOT NULL,
IdProductoFT INTEGER NOT NULL
FOREIGN KEY(IdProductoFT) REFERENCES Producto(IdProducto),
IdFacturaFT INTEGER NOT NULL
FOREIGN KEY (IdFacturaFT) REFERENCES Factura(IdFactura)
)
GO