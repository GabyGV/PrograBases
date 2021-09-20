USE [PrograBases]

--- CRUD de tabla - Beneficiario --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InserBeneficiario') IS NOT NULL
BEGIN 
DROP PROC InsertBeneficiario
END
GO
CREATE PROCEDURE InsertBeneficiario
	  @inID_Beneficiario INT,
	  @inPorcentaje INT,
	  @inIDNumeroCuenta INT,
	  @inIDValorDocIdentidad INT,
	  @inIDParentezco INT
	 
AS
BEGIN TRY
INSERT INTO Beneficiario(
	   ID_Beneficiario,
	   Porcentaje,
	   IDValorDocIdentidad,
	   IDNumeroCuenta,
	   IDParentezco)
    VALUES (
	   @inID_Beneficiario,
	   @inPorcentaje,
	   @inIDValorDocIdentidad,
	   @inIDNumeroCuenta,
	   @inIDParentezco)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadBeneficiario') IS NOT NULL
BEGIN 
    DROP PROC ReadBeneficiario
END 
GO
CREATE PROC ReadBeneficiario
    @inID_Beneficiario INT
AS 
BEGIN TRY
    SELECT ID_Beneficiario, 
		   Porcentaje,
		   IDValorDocIdentidad,
		   IDNumeroCuenta,
		   IDParentezco
    FROM   Beneficiario  
    WHERE  (ID_Beneficiario = @inID_Beneficiario) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateBeneficiario') IS NOT NULL
BEGIN 
DROP PROC UpdateBeneficiario
END 
GO
CREATE PROC UpdateBeneficiario
	 @inID_Beneficiario INT,
	 @inPorcentaje INT,
	 @inIDNumeroCuenta INT,
	 @inIDValorDocIdentidad INT,
	 @inIDParentezco INT
AS 
BEGIN TRY
UPDATE Beneficiario
	SET  Porcentaje = @inPorcentaje,
		 IDValorDocIdentidad = @inIDValorDocIdentidad,
		 IDNumeroCuenta = @inIDNumeroCuenta,
		 IDParentezco = @inIDParentezco
	WHERE  (ID_Beneficiario = @inID_Beneficiario)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteBeneficiario') IS NOT NULL
BEGIN 
DROP PROC DeleteBeneficiario
END 
GO
CREATE PROC DeleteBeneficiario
    @inID_Beneficiario int
AS 
BEGIN TRY
DELETE
FROM   Beneficiario
WHERE  ID_Beneficiario = @inID_Beneficiario
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO