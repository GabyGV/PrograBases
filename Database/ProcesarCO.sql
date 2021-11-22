USE [PrograBases]

IF OBJECT_ID('ProcesarCO') IS NOT NULL
BEGIN 
DROP PROC ProcesarCO 
END
GO
CREATE PROCEDURE ProcesarCO @inDay INT
AS
BEGIN TRY 

DECLARE @TemporalCO TABLE(id INT IDENTITY(1,1) ,
							cuentaMaestra INT,
							cuentaObjetivo INT,
							montoMensual INT,
							diaAhorro INT,
							fechaFinal DATE,
							descripcion VARCHAR(100))
INSERT @TemporalCO( cuentaMaestra ,
					cuentaObjetivo ,
					montoMensual ,
					diaAhorro ,
					fechaFinal ,
					descripcion )
SELECT C.CuentaMaestra, C.CuentaObjetivo, C.MontoMensual, C.DiaDeAhorro, C.FechaFinal, C.Descripcion
FROM dbo.CuentaObjetivo C
WHERE C.DiaDeAhorro = @inDay

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
