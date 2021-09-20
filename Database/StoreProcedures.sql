USE [PrograBases]

IF OBJECT_ID('VerCuenta') IS NOT NULL
BEGIN 
DROP PROC VerCuenta 
END
GO
CREATE PROCEDURE VerCuenta
	 @inDocumentoIdentidad INT
AS
BEGIN TRY 
	IF 1 = (SELECT U.EsAdministrador FROM Usuario U WHERE (@inDocumentoIdentidad = U.IDValorDocIdentidad))
		SELECT C.IDValorDocIdentidad,
			   C.IDTCuenta,
			   C.NumeroCuenta,
			   C.FechaCreacion,
			   C.Saldo
		FROM Cuenta C

	ELSE 
		SELECT C.IDValorDocIdentidad,
			   C.IDTCuenta,
			   C.NumeroCuenta,
			   C.FechaCreacion,
			   C.Saldo
		FROM Cuenta C
		WHERE (C.IDValorDocIdentidad = @inDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

IF OBJECT_ID('VerDocumentoIdentidad') IS NOT NULL
BEGIN 
DROP PROC VerDocumentoIdentidad 
END
GO
CREATE PROCEDURE VerDocumentoIdentidad
	 @inUsuario VARCHAR(16)
AS
BEGIN TRY 
	SELECT U.IDValorDocIdentidad 
	FROM Usuario U
	WHERE (U.Username = @inUsuario)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

IF OBJECT_ID('VerNumeroCuenta') IS NOT NULL
BEGIN 
DROP PROC VerNumeroCuenta 
END
GO
CREATE PROCEDURE VerNumeroCuenta
	 @inValorDocumentoIdentidad INT
AS
BEGIN TRY 
	SELECT C.NumeroCuenta
	FROM Cuenta C
	WHERE (C.IDValorDocIdentidad = @inValorDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


IF OBJECT_ID('VerBeneficiarios') IS NOT NULL
BEGIN 
DROP PROC VerBeneficiarios 
END
GO
CREATE PROCEDURE VerBeneficiarios
	 @inNumeroCuenta INT
AS
BEGIN TRY 
	SELECT P.Nombre,
		   B.IDParentezco,
		   B.Porcentaje,
		   P.FechaNacimiento,
		   P.ValorDocIdentidad,
		   P.Email,
		   P.Telefono1,
		   P.Telefono2
	FROM Beneficiario B
	INNER JOIN Persona P
	ON P.ValorDocIdentidad = B.IDValorDocIdentidad
	WHERE (B.IDNumeroCuenta = @inNumeroCuenta AND B.Activo = 1)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

IF OBJECT_ID('EliminarBeneficiario') IS NOT NULL
BEGIN 
DROP PROC EliminarBeneficiario 
END
GO
CREATE PROCEDURE EliminarBeneficiario
	 @inValorDocumentoIdentidad INT
AS
BEGIN TRY 
	UPDATE Beneficiario
	SET Activo = 0
	WHERE (IDValorDocIdentidad = @inValorDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

IF OBJECT_ID('ActualizarBeneficiarios') IS NOT NULL
BEGIN 
DROP PROC ActualizarBeneficiarios 
END
GO
CREATE PROCEDURE ActualizarBeneficiarios
	@inValorDocumentoIdentidad INT,
	@inNombre VARCHAR(64),
	@inIDParentezco INT,
	@inPorcentaje INT,
	@inFechaNacimiento DATE,
	@inValorDocIdentidad INT,
	@inEmail VARCHAR(64),
	@inTelefono1 VARCHAR(64),
	@inTelefono2 VARCHAR(64)
AS
BEGIN TRY 
	UPDATE Persona
	SET ValorDocIdentidad = @inValorDocIdentidad,
		Nombre = @inNombre,
		FechaNacimiento = @inFechaNacimiento,
		Email = @inEmail,
		Telefono1 = @inTelefono1,
		Telefono2 = @inTelefono2
	WHERE (ValorDocIdentidad = @inValorDocumentoIdentidad)

	UPDATE Beneficiario
	SET IDParentezco = @inIDParentezco,
		Porcentaje = @inPorcentaje,
		IDValorDocIdentidad = @inValorDocIdentidad
	WHERE (IDValorDocIdentidad = @inValorDocumentoIdentidad)
		
END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

IF OBJECT_ID('AgregarBeneficiario') IS NOT NULL
BEGIN 
DROP PROC AgregarBeneficiario 
END
GO
CREATE PROCEDURE AgregarBeneficiario
	 @inPorcentaje INT,
	 @inValorDocumentoIdentidad INT,
	 @inIDNumeroCuenta INT,
	 @inIDParentezco INT
AS
BEGIN TRY 
	INSERT Beneficiario(Porcentaje,
						IDValorDocIdentidad,
						IDNumeroCuenta,
						IDParentezco,
						Activo)
	VALUES(@inPorcentaje,
		   @inValorDocumentoIdentidad,
		   @inIDNumeroCuenta,
		   @inIDParentezco,
		   1)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


IF OBJECT_ID('AgregarPersona') IS NOT NULL
BEGIN 
DROP PROC AgregarPersona 
END
GO
CREATE PROCEDURE AgregarPersona
	@inValorDocumentoIdentidad INT,
	@inNombre VARCHAR(64),
	@inFechaNacimiento DATE,
	@inEmail VARCHAR(64),
	@inTelefono1 VARCHAR(64),
	@inTelefono2 VARCHAR(64)
AS
BEGIN TRY 
	INSERT Persona(ValorDocIdentidad,
				   Nombre,
				   FechaNacimiento,
				   Email,
				   Telefono1,
				   Telefono2)
	VALUES(@inValorDocumentoIdentidad,
		   @inNombre,
		   @inFechaNacimiento,
		   @inEmail,
		   @inTelefono1,
		   @inTelefono2)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


IF OBJECT_ID('BuscarPersona') IS NOT NULL
BEGIN 
DROP PROC BuscarPersona 
END
GO
CREATE PROCEDURE BuscarPersona
	 @inValorDocumentoIdentidad INT
AS
BEGIN TRY 
	SELECT COUNT(1)
	FROM Persona C
	WHERE (C.ValorDocIdentidad = @inValorDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO