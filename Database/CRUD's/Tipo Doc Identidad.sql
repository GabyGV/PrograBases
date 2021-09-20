USE [PrograBases]

--- CRUD de tabla - TipoDocIdentidad  --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InsertTipoDocIdentidad') IS NOT NULL
BEGIN 
DROP PROC InsertTipoDocIdentidad
END
GO
CREATE PROCEDURE InsertTipoDocIdentidad
	  @inID_TDoc INT,
	  @inTipo VARCHAR(64)
	 
AS
BEGIN TRY
INSERT INTO TipoDocIdentidad(
	   ID_TDoc,
	   Tipo)
    VALUES (
	   @inID_TDoc,
	   @inTipo)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadTipoDocIdentidad') IS NOT NULL
BEGIN 
    DROP PROC ReadTipoDocIdentidad
END 
GO
CREATE PROC ReadTipoDocIdentidad
    @inID_TDoc INT
AS 
BEGIN TRY
    SELECT ID_TDoc, Tipo
    FROM   TipoDocIdentidad  
    WHERE  (ID_TDoc = @inID_TDoc) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateTipoDocIdentidad') IS NOT NULL
BEGIN 
DROP PROC UpdateTipoDocIdentidad
END 
GO
CREATE PROC UpdateTipoDocIdentidad
	 @inID_TDoc INT,
	 @inTipo VARCHAR(64)
AS 
BEGIN TRY
UPDATE TipoDocIdentidad
	SET  Tipo = @inTipo
	WHERE  (ID_TDoc = @inID_TDoc)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteTipoDocIdentidad') IS NOT NULL
BEGIN 
DROP PROC DeleteTipoDocIdentidad
END 
GO
CREATE PROC DeleteTipoDocIdentidad
    @inID_TDoc int
AS 
BEGIN TRY
DELETE
FROM   TipoDocIdentidad
WHERE  ID_TDoc = @inID_TDoc
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO