USE [PrograBases]

--- CRUD de tabla - Usuarios_Ver --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InserUsuarios_Ver') IS NOT NULL
BEGIN 
DROP PROC InsertUsuarios_Ver
END
GO
CREATE PROCEDURE InsertUsuarios_Ver
	  @inID_UsuarioVer INT,
	  @inUsername VARCHAR(16),
	  @inIDNumeroCuenta INT
	 
AS
BEGIN TRY
INSERT INTO Usuarios_Ver(
	   ID_UsuarioVer,
	   Username,
	   IDNumeroCuenta)
    VALUES (
	   @inID_UsuarioVer,
	   @inUsername,
	   @inIDNumeroCuenta)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadUsuarios_Ver') IS NOT NULL
BEGIN 
    DROP PROC ReadUsuarios_Ver
END 
GO
CREATE PROC ReadUsuarios_Ver
    @inID_UsuarioVer INT
AS 
BEGIN TRY
    SELECT ID_UsuarioVer, 
		   Username,
		   IDNumeroCuenta
    FROM   Usuarios_Ver  
    WHERE  (ID_UsuarioVer = ID_UsuarioVer) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateUsuarios_Ver') IS NOT NULL
BEGIN 
DROP PROC UpdateUsuarios_Ver
END 
GO
CREATE PROC UpdateUsuarios_Ver
	 @inID_UsuarioVer INT,
	 @inUsername VARCHAR(16),
	 @inIDNumeroCuenta INT
AS 
BEGIN TRY
UPDATE Usuarios_Ver
	SET  Username = @inUsername,
		 IDNumeroCuenta = @inIDNumeroCuenta
	WHERE  (ID_UsuarioVer = @inID_UsuarioVer)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteUsuarios_Ver') IS NOT NULL
BEGIN 
DROP PROC DeleteUsuarios_Ver
END 
GO
CREATE PROC DeleteUsuarios_Ver
    @inID_UsuarioVer int
AS 
BEGIN TRY
DELETE
FROM   Usuarios_Ver
WHERE  ID_UsuarioVer = @inID_UsuarioVer
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO