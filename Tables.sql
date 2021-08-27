USE [PrograBases]

CREATE TABLE TipoDocIdentidad
(
  ID_TDoc INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Tipo VARCHAR(64) NOT NULL
);

CREATE TABLE Persona
(
  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Nombre VARCHAR(64) NOT NULL,
  ValorDocIdentidad INT NOT NULL
);

CREATE TABLE TipoCuentaAhorro
(
  ID_TCuenta INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Nombre VARCHAR(64) NOT NULL,
  TasaInteres INT NOT NULL,
  Multa INT NOT NULL
);

CREATE TABLE CuentaAhorro
(
  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Saldo INT NOT NULL,
  FechaCreacion DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Beneficiario
(
  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Porcentaje INT NOT NULL
);

CREATE TABLE Parentezco
(
  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Nombre VARCHAR(64) NOT NULL
);

CREATE TABLE Usuario
(
  ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Nombre VARCHAR(64) NOT NULL
);