USE [PrograBases]

IF OBJECT_ID('ProcesarCO') IS NOT NULL
BEGIN 
DROP PROC ProcesarCO 
END
GO
CREATE PROCEDURE ProcesarCO @inDay INT
AS
BEGIN TRY 

DECLARE @lo INT
DECLARE @hi INT
DECLARE @monto MONEY
DECLARE @montoActual MONEY
DECLARE @mes INT
DECLARE @porcentaje FLOAT
DECLARE @date DATE

DECLARE @TemporalCO TABLE(id INT IDENTITY(1,1) ,
							cuentaMaestra INT,
							cuentaObjetivo INT,
							montoMensual INT,
							diaAhorro INT,
							fechaInicial DATE,
							fechaFinal DATE,
							descripcion VARCHAR(100))
INSERT @TemporalCO( cuentaMaestra ,
					cuentaObjetivo ,
					montoMensual ,
					diaAhorro ,
					fechaInicial,
					fechaFinal ,
					descripcion )
SELECT C.CuentaMaestra, C.CuentaObjetivo, C.MontoMensual, C.DiaDeAhorro, C.FechaInicial, C.FechaFinal, C.Descripcion
FROM dbo.CuentaObjetivo C
WHERE C.DiaDeAhorro = @inDay



SELECT @hi = MAX(id) FROM @TemporalCO 
SELECT @lo = MIN(id) FROM @TemporalCO 

WHILE @lo<@hi 
BEGIN
	
	SELECT @mes = DATEDIFF (month, C.FechaFinal, C.fechaInicial)
					FROM @TemporalCO C
					WHERE C.id = @lo

	Select @monto = C.MontoMensual 
					FROM @TemporalCO C
					WHERE C.id = @lo

	SELECT @montoActual = M.NuevoIntAcumulado 
					FROM MovimientoIntCO M
					INNER JOIN CuentaObjetivo C
					ON C.ID = M.IDCuentaObjetivo
					INNER JOIN @TemporalCO T
					ON T.cuentaObjetivo = C.CuentaObjetivo
					WHERE M.IDCuentaObjetivo = C.ID

	SELECT @porcentaje = T.TasaInteres FROM TasaInteresesCO T
						 WHERE T.ID = @mes 

	BEGIN TRANSACTION



 		UPDATE MovimientoIntCO
		SET Monto = NuevoIntAcumulado, NuevoIntAcumulado = @montoActual + ( @monto * @porcentaje )
		FROM @TemporalCO T
		WHERE @lo = T.id





	COMMIT 
	Set @lo=@lo+1

END


END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
