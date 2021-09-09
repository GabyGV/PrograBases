USE [PrograBases]

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
  NumRetiros_Humanos INT NOT NULL,
  NumRetiros_Automaticos INT NOT NULL,
  ComisionHumano MONEY NOT NULL,
  ComisionAutomatico MONEY NOT NULL,
  Interes INT NOT NULL,

  ID_TMoneda INT NOT NULL,
  FOREIGN KEY (ID_TMoneda) REFERENCES Tipo_Moneda(ID_TMoneda)
);

CREATE TABLE Persona
(
  ID_Persona INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Nombre VARCHAR(64) NOT NULL,
  ValorDocIdentidad VARCHAR(16) NOT NULL,
  FechaNacimiento DATE NOT NULL,
  Email VARCHAR(64) NOT NULL,
  Telefono1 VARCHAR(16) NOT NULL,
  Telefono2 VARCHAR(16) NOT NULL,

  ID_TDoc INT NOT NULL,
  FOREIGN KEY (ID_TDoc) REFERENCES TipoDocIdentidad(ID_TDoc)
);

CREATE TABLE Cuenta
(
  ID_Cuenta INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  ValorDocIdentidad VARCHAR(16) NOT NULL,
  NumeroCuenta VARCHAR(16) NOT NULL,
  FechaCreacion DATE NOT NULL,
  Saldo MONEY NOT NULL,

  ID_TDoc INT NOT NULL,
  ID_TCuenta INT NOT NULL,
  FOREIGN KEY (ID_TDoc) REFERENCES TipoDocIdentidad(ID_TDoc),
  FOREIGN KEY (ID_TCuenta) REFERENCES TipoCuentaAhorro(ID_TCuenta)
);

CREATE TABLE Beneficiario
(
  ID_Beneficiario INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  NumeroCuenta VARCHAR(16) NOT NULL,
  ValorDocIdentidad VARCHAR(16) NOT NULL,
  Porcentaje INT NOT NULL,

  ID_Parentezco INT NOT NULL,
  FOREIGN KEY (ID_Parentezco) REFERENCES Parentezcos(ID_Parentezco)
);

CREATE TABLE Beneficiario_Cuenta
(
  ID_BC INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  
  ID_Beneficiario INT NOT NULL,
  ID_Cuenta INT NOT NULL,
  FOREIGN KEY (ID_Beneficiario) REFERENCES Beneficiario(ID_Beneficiario),
  FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta(ID_Cuenta)
);

CREATE TABLE Usuario
(
  ID_Usuario INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Username VARCHAR(16) NOT NULL,
  Pass VARCHAR(16) NOT NULL,
  ValorDocIdentidad VARCHAR(16) NOT NULL,
  EsAdministrador INT NOT NULL
);

CREATE TABLE Usuarios_Ver
(
  ID_UsuarioVer INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Username VARCHAR(16) NOT NULL,
  NumeroCuenta VARCHAR(16) NOT NULL
);