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
	WHERE (B.IDNumeroCuenta = @inNumeroCuenta)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO