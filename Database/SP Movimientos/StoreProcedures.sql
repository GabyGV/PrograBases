USE [PrograBases]

IF OBJECT_ID('CierreEstadosCuenta') IS NOT NULL
BEGIN 
DROP PROC CierreEstadosCuenta 
END
GO
CREATE PROCEDURE CierreEstadosCuenta
	@inDia INT
AS
BEGIN TRY 
	


END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
