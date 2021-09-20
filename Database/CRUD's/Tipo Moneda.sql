USE [PrograBases]

--- CRUD de tabla -  Tipo_Moneda --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InsertTipo_Moneda') IS NOT NULL
BEGIN 
DROP PROC InsertTipo_Moneda
END
GO
CREATE PROCEDURE InsertTipo_Moneda
	  @inID_TMoneda INT,
	  @inNombre VARCHAR(16)
	 
AS
BEGIN TRY
INSERT INTO Tipo_Moneda(
	   ID_TMoneda,
	   Nombre)
    VALUES (
	   @inID_TMoneda,
	   @inNombre)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadTipo_Moneda') IS NOT NULL
BEGIN 
    DROP PROC ReadTipo_Moneda
END 
GO
CREATE PROC ReadTipo_Moneda
    @inID_TMoneda INT
AS 
BEGIN TRY
    SELECT ID_TMoneda, Nombre
    FROM   Tipo_Moneda  
    WHERE  (ID_TMoneda = @inID_TMoneda) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateTipo_Moneda') IS NOT NULL
BEGIN 
DROP PROC UpdateTipo_Moneda
END 
GO
CREATE PROC UpdateTipo_Moneda
	 @inID_TMoneda INT,
	 @inNombre VARCHAR(16)
AS 
BEGIN TRY
UPDATE Tipo_Moneda
	SET  Nombre = @inNombre
	WHERE  (ID_TMoneda = @inID_TMoneda)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteTipo_Moneda') IS NOT NULL
BEGIN 
DROP PROC DeleteTipo_Moneda
END 
GO
CREATE PROC DeleteTipo_Moneda 
    @inID_TMoneda int
AS 
BEGIN TRY
DELETE
FROM   Tipo_Moneda
WHERE  ID_TMoneda = @inID_TMoneda
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO