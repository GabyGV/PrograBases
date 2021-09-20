USE [PrograBases]

--- CRUD de tabla - Persona --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InserPersona') IS NOT NULL
BEGIN 
DROP PROC InsertPersona
END
GO
CREATE PROCEDURE InsertPersona
	  @inValorDocIdentidad INT,
	  @inNombre VARCHAR(32),
	  @inFechaNacimiento DATE,
	  @inEmail VARCHAR(64),
	  @inTelefono1 VARCHAR(16),
	  @inTelefono2 VARCHAR(16),
	  @inIDTDoc INT
	 
AS
BEGIN TRY
INSERT INTO Persona(
	   ValorDocIdentidad,
	   Nombre,
	   FechaNacimiento,
	   Email,
	   Telefono1,
	   Telefono2,
	   IDTDoc)
    VALUES (
	   @inValorDocIdentidad,
	   @inNombre,
	   @inFechaNacimiento,
	   @inEmail,
	   @inTelefono1,
	   @inTelefono2,
	   @inIDTDoc)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadPersona') IS NOT NULL
BEGIN 
    DROP PROC ReadPersona
END 
GO
CREATE PROC ReadPersona
    @inValorDocIdentidad INT
AS 
BEGIN TRY
    SELECT ValorDocIdentidad, 
		   Nombre,
		   FechaNacimiento,
		   Email,
		   Telefono1,
		   Telefono2,
		   IDTDoc
    FROM   Persona  
    WHERE  (ValorDocIdentidad = @inValorDocIdentidad) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdatePersona') IS NOT NULL
BEGIN 
DROP PROC UpdatePersona
END 
GO
CREATE PROC UpdatePersona
	 @inValorDocIdentidad INT,
	 @inNombre VARCHAR(32),
	 @inFechaNacimiento DATE,
	 @inEmail VARCHAR(64),
	 @inTelefono1 VARCHAR(16),
	 @inTelefono2 VARCHAR(16),
	 @inIDTDoc INT
AS 
BEGIN TRY
UPDATE Persona
	SET  Nombre = @inNombre,
		 FechaNacimiento = @inFechaNacimiento,
		 Email = @inEmail,
		 Telefono1 = @inTelefono1,
		 Telefono2 = @inTelefono2,
		 IDTDoc = @inIDTDoc
	WHERE  (ValorDocIdentidad = @inValorDocIdentidad)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeletePersona') IS NOT NULL
BEGIN 
DROP PROC DeletePersona
END 
GO
CREATE PROC DeletePersona
    @inValorDocIdentidad int
AS 
BEGIN TRY
DELETE
FROM   Persona
WHERE  ValorDocIdentidad = @inValorDocIdentidad
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO