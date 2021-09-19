USE [PrograBases]

--- CRUD de tabla - Usuario --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InserUsuario') IS NOT NULL
BEGIN 
DROP PROC InsertUsuario
END
GO
CREATE PROCEDURE InsertUsuario
	  @inID_Usuario INT,
	  @inUsername VARCHAR(16),
	  @inPass VARCHAR(16),
	  @inEsAdministrador INT,
	  @inIDValorDocIdentidad INT
	 
AS
BEGIN TRY
INSERT INTO Usuario(
	   ID_Usuario,
	   Username,
	   Pass,
	   EsAdministrador,
	   IDValorDocIdentidad)
    VALUES (
	   @inID_Usuario,
	   @inUsername,
	   @inPass,
	   @inEsAdministrador,
	   @inIDValorDocIdentidad)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadUsuario') IS NOT NULL
BEGIN 
    DROP PROC ReadUsuario
END 
GO
CREATE PROC ReadUsuario
    @inID_Usuario INT
AS 
BEGIN TRY
    SELECT ID_Usuario, 
		   Username,
		   Pass,
		   EsAdministrador,
		   IDValorDocIdentidad
    FROM   Usuario  
    WHERE  (ID_Usuario = @inID_Usuario) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateUsuario') IS NOT NULL
BEGIN 
DROP PROC UpdateUsuario
END 
GO
CREATE PROC UpdateUsuario
	 @inID_Usuario INT,
	 @inUsername VARCHAR(16),
	 @inPass VARCHAR(16),
	 @inEsAdministrador INT,
	 @inIDValorDocIdentidad INT
AS 
BEGIN TRY
UPDATE Usuario
	SET  Username = @inUsername,
		 Pass = @inPass,
		 EsAdministrador = @inEsAdministrador,
		 IDValorDocIdentidad = @inIDValorDocIdentidad
	WHERE  (ID_Usuario = @inID_Usuario)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteUsuario') IS NOT NULL
BEGIN 
DROP PROC DeleteUsuario
END 
GO
CREATE PROC DeleteUsuario
    @inID_Usuario int
AS 
BEGIN TRY
DELETE
FROM   Usuario
WHERE  ID_Usuario = @inID_Usuario
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO