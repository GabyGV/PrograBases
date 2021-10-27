USE [PrograBases]

IF OBJECT_ID('CargarTablas') IS NOT NULL
BEGIN 
DROP PROC CargarTablas 
END
GO
CREATE PROCEDURE CargarTablas
AS
BEGIN TRY 

	DROP TABLE Usuario
	DROP TABLE Usuarios_Ver

	DROP TABLE Movimientos
	DROP TABLE EstadoCuenta
	DROP TABLE Beneficiario
	DROP TABLE Cuenta
	DROP TABLE Persona
	DROP TABLE TipoCuentaAhorro
	DROP TABLE Parentezcos
	DROP TABLE Tipo_Moneda
	DROP TABLE TipoDocIdentidad
	DROP TABLE Tipo_Movimiento
	DROP TABLE Tipo_CambioDolar

	CREATE TABLE TipoDocIdentidad
	(
	  ID_TDoc INT PRIMARY KEY NOT NULL,
	  Tipo VARCHAR(64) NOT NULL
	);

	CREATE TABLE Tipo_Moneda
	(
	  ID_TMoneda INT PRIMARY KEY NOT NULL,
	  Nombre VARCHAR(16)
	);

	CREATE TABLE Parentezcos
	(
	  ID_Parentezco INT PRIMARY KEY NOT NULL,
	  Nombre VARCHAR(16)
	);

	CREATE TABLE TipoCuentaAhorro
	(
	  ID_TCuenta INT PRIMARY KEY NOT NULL,
	  Nombre VARCHAR(32) NOT NULL,
	  SaldoMinimo MONEY NOT NULL,
	  MultaSaldoMinimo MONEY NOT NULL,
	  CargoAnual MONEY NOT NULL,
	  NumRetiros_Humanos INT NOT NULL,
	  NumRetiros_Automaticos INT NOT NULL,
	  ComisionHumano MONEY NOT NULL,
	  ComisionAutomatico MONEY NOT NULL,
	  Interes INT NOT NULL,

	  IDTMoneda INT NOT NULL,
	  FOREIGN KEY (IDTMoneda) REFERENCES Tipo_Moneda(ID_TMoneda)
	);

	CREATE TABLE Persona
	(
      ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  ValorDocIdentidad INT NOT NULL,
	  Nombre VARCHAR(64) NOT NULL,
	  FechaNacimiento DATE NOT NULL,
	  Email VARCHAR(64) NOT NULL,
	  Telefono1 VARCHAR(16) NOT NULL,
	  Telefono2 VARCHAR(16) NOT NULL,
	  Fecha DATE NOT NULL,

	  IDTDoc INT NOT NULL,
	  FOREIGN KEY (IDTDoc) REFERENCES TipoDocIdentidad(ID_TDoc)
	);

	CREATE TABLE Cuenta
	(
	  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  NumeroCuenta INT NOT NULL,
	  Saldo MONEY NOT NULL,
	  Fecha DATE NOT NULL,
	  Activo INT NOT NULL,

	  IDValorDocIdentidad INT NOT NULL,
	  IDTCuenta INT NOT NULL,
	  FOREIGN KEY (IDTCuenta) REFERENCES TipoCuentaAhorro(ID_TCuenta),
	  FOREIGN KEY (IDValorDocIdentidad) REFERENCES Persona(ID)
	);

	CREATE TABLE Beneficiario
	(
	  ID_Beneficiario INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  Porcentaje INT NOT NULL,
	  Fecha DATE NOT NULL,

	  IDValorDocIdentidad INT NOT NULL,
	  IDNumeroCuenta INT NOT NULL,
	  IDParentezco INT NOT NULL,
	  Activo INT NOT NULL,
	  FOREIGN KEY (IDValorDocIdentidad) REFERENCES Persona(ID),
	  FOREIGN KEY (IDNumeroCuenta) REFERENCES Cuenta(ID),
	  FOREIGN KEY (IDParentezco) REFERENCES Parentezcos(ID_Parentezco)
	);


	CREATE TABLE Usuario
	(
	  ID_Usuario INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  Username VARCHAR(16) NOT NULL,
	  Pass VARCHAR(16) NOT NULL,
	  EsAdministrador INT NOT NULL,

	  IDValorDocIdentidad INT NOT NULL,
	  FOREIGN KEY (IDValorDocIdentidad) REFERENCES Persona(ID)
	);

	CREATE TABLE Usuarios_Ver
	(
	  ID_UsuarioVer INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  Username VARCHAR(16) NOT NULL,

	  IDNumeroCuenta INT NOT NULL,
	  FOREIGN KEY (IDNumeroCuenta) REFERENCES Cuenta(ID)
	);

	CREATE TABLE Tipo_Movimiento
	(
      ID INT PRIMARY KEY NOT NULL,
	  Descripcion VARCHAR(128) NOT NULL,
	  Operacion INT NOT NULL
	);

	CREATE TABLE EstadoCuenta
	(
	  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  Fecha DATE NOT NULL,
	  FechaFin DATE NOT NULL,
	  SaldoMinimo MONEY NOT NULL,
	  SaldoInicio MONEY NOT NULL,
	  SaldoFinal MONEY NOT NULL,
	  CantOperacionesATM INT NOT NULL,
	  CantOperacionesCajeroHumano INT NOT NULL,
	  Activo INT NOT NULL,

	  IDNumeroCuenta INT NOT NULL,
	  FOREIGN KEY (IDNumeroCuenta) REFERENCES Cuenta(ID),
	);
		
	CREATE TABLE Movimientos
	(
	  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  Descripcion VARCHAR(128) NOT NULL,
	  MontoMovimiento MONEY NOT NULL,
	  MontoCuenta MONEY NOT NULL,
	  Fecha DATE NOT NULL,
	  Cambio VARCHAR(32) NOT NULL,

	  IDMoneda INT NOT NULL,
	  IDNumeroCuenta INT NOT NULL,
	  IDTMovimiento INT NOT NULL,
	  IDEstadoCuenta INT  NOT NULL,
	  FOREIGN KEY (IDMoneda) REFERENCES Tipo_Moneda(ID_TMoneda),
	  FOREIGN KEY (IDNumeroCuenta) REFERENCES Cuenta(ID),
	  FOREIGN KEY (IDTMovimiento) REFERENCES Tipo_Movimiento(ID),
	  FOREIGN KEY (IDEstadoCuenta) REFERENCES EstadoCuenta(ID)
	);

	CREATE TABLE Tipo_CambioDolar
	(
	  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	  Compra INT NOT NULL,
	  Venta INT NOT NULL,
	  Fecha DATE NOT NULL
	);

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
