USE [PrograBases]

DROP TABLE Usuario
DROP TABLE Usuarios_Ver

DROP TABLE Beneficiario
DROP TABLE Cuenta
DROP TABLE Persona
DROP TABLE TipoCuentaAhorro
DROP TABLE Parentezcos
DROP TABLE Tipo_Moneda
DROP TABLE TipoDocIdentidad

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
  ValorDocIdentidad INT PRIMARY KEY NOT NULL,
  Nombre VARCHAR(64) NOT NULL,
  FechaNacimiento DATE NOT NULL,
  Email VARCHAR(64) NOT NULL,
  Telefono1 VARCHAR(16) NOT NULL,
  Telefono2 VARCHAR(16) NOT NULL,

  IDTDoc INT NOT NULL,
  FOREIGN KEY (IDTDoc) REFERENCES TipoDocIdentidad(ID_TDoc)
);

CREATE TABLE Cuenta
(
  NumeroCuenta INT PRIMARY KEY NOT NULL,
  FechaCreacion DATE NOT NULL,
  Saldo MONEY NOT NULL,

  IDValorDocIdentidad INT NOT NULL,
  IDTCuenta INT NOT NULL,
  FOREIGN KEY (IDTCuenta) REFERENCES TipoCuentaAhorro(ID_TCuenta),
  FOREIGN KEY (IDValorDocIdentidad) REFERENCES Persona(ValorDocIdentidad)
);

CREATE TABLE Beneficiario
(
  ID_Beneficiario INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Porcentaje INT NOT NULL,

  IDValorDocIdentidad INT NOT NULL,
  IDNumeroCuenta INT NOT NULL,
  IDParentezco INT NOT NULL,
  FOREIGN KEY (IDValorDocIdentidad) REFERENCES Persona(ValorDocIdentidad),
  FOREIGN KEY (IDNumeroCuenta) REFERENCES Cuenta(NumeroCuenta),
  FOREIGN KEY (IDParentezco) REFERENCES Parentezcos(ID_Parentezco)
);


CREATE TABLE Usuario
(
  ID_Usuario INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Username VARCHAR(16) NOT NULL,
  Pass VARCHAR(16) NOT NULL,
  EsAdministrador INT NOT NULL,

  IDValorDocIdentidad INT NOT NULL,
  FOREIGN KEY (IDValorDocIdentidad) REFERENCES Persona(ValorDocIdentidad)
);

CREATE TABLE Usuarios_Ver
(
  ID_UsuarioVer INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Username VARCHAR(16) NOT NULL,

  IDNumeroCuenta INT NOT NULL,
  FOREIGN KEY (IDNumeroCuenta) REFERENCES Cuenta(NumeroCuenta)
);