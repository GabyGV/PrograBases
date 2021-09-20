USE [PrograBases]

--- CRUD de tabla - Parentezcos --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InsertParentezcos') IS NOT NULL
BEGIN 
DROP PROC InsertParentezcos
END
GO
CREATE PROCEDURE InsertParentezcos
	  @inID_Parentezco INT,
	  @inNombre VARCHAR(16)
	 
AS
BEGIN TRY
INSERT INTO Parentezcos(
	   ID_Parentezco,
	   Nombre)
    VALUES (
	   @inID_Parentezco,
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

IF OBJECT_ID('ReadParentezcos') IS NOT NULL
BEGIN 
    DROP PROC ReadParentezcos
END 
GO
CREATE PROC ReadParentezcos
    @inID_Parentezco INT
AS 
BEGIN TRY
    SELECT ID_Parentezco, Nombre
    FROM   Parentezcos  
    WHERE  (ID_Parentezco = @inID_Parentezco) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateParentezcos') IS NOT NULL
BEGIN 
DROP PROC UpdateParentezcos
END 
GO
CREATE PROC UpdateParentezcos
	 @inID_Parentezco INT,
	 @inNombre VARCHAR(16)
AS 
BEGIN TRY
UPDATE Parentezcos
	SET  Nombre = @inNombre
	WHERE  (ID_Parentezco = @inID_Parentezco)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteParentezcos') IS NOT NULL
BEGIN 
DROP PROC DeleteParentezcos
END 
GO
CREATE PROC DeleteParentezcos
    @inID_Parentezco int
AS 
BEGIN TRY
DELETE
FROM   Parentezcos
WHERE  ID_Parentezco = @inID_Parentezco
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO