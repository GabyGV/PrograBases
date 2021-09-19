USE [PrograBases]

--- CRUD de tabla - Cuenta --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InserCuenta') IS NOT NULL
BEGIN 
DROP PROC InsertCuenta
END
GO
CREATE PROCEDURE InsertCuenta
	  @inNumeroCuenta INT,
	  @inFechaCreacion DATE,
	  @inSaldo MONEY,
	  @inIDValorDocIdentidad INT,
	  @inIDTCuenta INT
	 
AS
BEGIN TRY
INSERT INTO Cuenta(
	   NumeroCuenta,
	   FechaCreacion,
	   Saldo,
	   IDValorDocIdentidad,
	   IDTCuenta)
    VALUES (
	   @inNumeroCuenta,
	   @inFechaCreacion,
	   @inSaldo,
	   @inIDValorDocIdentidad,
	   @inIDTCuenta)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadCuenta') IS NOT NULL
BEGIN 
    DROP PROC ReadCuenta
END 
GO
CREATE PROC ReadCuenta
    @inNumeroCuenta INT
AS 
BEGIN TRY
    SELECT NumeroCuenta, 
		   FechaCreacion,
		   Saldo,
		   IDValorDocIdentidad,
		   IDTCuenta
    FROM   Cuenta  
    WHERE  (NumeroCuenta = @inNumeroCuenta) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateCuenta') IS NOT NULL
BEGIN 
DROP PROC UpdateCuenta
END 
GO
CREATE PROC UpdateCuenta
	 @inNumeroCuenta INT,
	 @inFechaCreacion DATE,
	 @inSaldo MONEY,
	 @inIDValorDocIdentidad INT,
	 @inIDTCuenta INT
AS 
BEGIN TRY
UPDATE Cuenta
	SET  FechaCreacion = @inFechaCreacion,
		 Saldo = @inSaldo,
		 IDValorDocIdentidad = @inIDValorDocIdentidad,
		 IDTCuenta = @inIDTCuenta
	WHERE  (NumeroCuenta = @inNumeroCuenta)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteCuenta') IS NOT NULL
BEGIN 
DROP PROC DeleteCuenta
END 
GO
CREATE PROC DeleteCuenta
    @inNumeroCuenta int
AS 
BEGIN TRY
DELETE
FROM   Cuenta
WHERE  NumeroCuenta = @inNumeroCuenta
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO