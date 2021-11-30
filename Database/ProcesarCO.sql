USE [PrograBases]

IF OBJECT_ID('ProcesarCO') IS NOT NULL
BEGIN 
DROP PROC ProcesarCO 
END
GO
CREATE PROCEDURE ProcesarCO @inDay INT, @inFecha DATE
AS
BEGIN TRY 

DECLARE @lo INT
DECLARE @hi INT
DECLARE @monto MONEY
DECLARE @montoActual MONEY
DECLARE @intereses MONEY
DECLARE @mes INT
DECLARE @porcentaje FLOAT
DECLARE @date DATE


SELECT @hi = MAX(ID) FROM CuentaObjetivo 
SELECT @lo = MIN(ID) FROM CuentaObjetivo 

WHILE @lo<@hi 
BEGIN
	
	IF((SELECT DATEPART(DAY, C.FechaInicial) FROM CuentaObjetivo C WHERE C.ID = @lo) = @inDay)
	BEGIN

		SELECT @mes = DATEDIFF (month, C.FechaFinal, C.fechaInicial)
						FROM CuentaObjetivo C
						WHERE C.ID = @lo

		Select @monto = C.MontoMensual 
						FROM CuentaObjetivo C
						WHERE C.ID = @lo

		SELECT @montoActual = C.Saldo
						FROM Cuenta C
						INNER JOIN CuentaObjetivo CO
						ON C.ID = CO.CuentaMaestra
						WHERE C.ID = @lo

		SELECT @porcentaje = T.TasaInteres 
							 FROM TasaInteresesCO T
							 WHERE T.ID = @mes 

		SELECT @intereses = (C.Saldo * @porcentaje)
							FROM CuentaObjetivo C
							WHERE C.ID = @lo

		BEGIN TRANSACTION

		
			INSERT MovimientoIntCO(Fecha,
								   Monto,
								   Descripcion,
								   IDCuentaObjetivo)
			SELECT @inFecha, (C.Saldo * @porcentaje) , 'Intereses', C.ID
			FROM CuentaObjetivo C
			WHERE C.ID = @lo;

			INSERT MovimientoCO(Fecha,
								Monto,
								NuevoSaldo,
								Descripcion,
								IDTipoMovimientoCO,
								IDCuentaObjetivo,
								Logrado)
			SELECT @inFecha, (CO.Saldo * @porcentaje), ((CO.Saldo * @porcentaje) + CO.Saldo), 'Interes por Ahorro', 2, CO.ID, 1
			FROM CuentaObjetivo CO
			WHERE CO.ID = @lo

			UPDATE CuentaObjetivo
			SET Saldo = Saldo + @intereses
			FROM CuentaObjetivo
			WHERE ID = @lo
		
			IF(@montoActual >= @monto)
				BEGIN
				
					INSERT MovimientoCO(Fecha,
										Monto,
										NuevoSaldo,
										Descripcion,
										IDTipoMovimientoCO,
										IDCuentaObjetivo,
										Logrado)
					SELECT @inFecha, @monto, (@monto + CO.Saldo), 'Credito por Ahorro', 1, CO.ID, 1
					FROM CuentaObjetivo CO
					WHERE CO.ID = @lo

					UPDATE CuentaObjetivo
					SET Saldo = Saldo + @monto
					FROM CuentaObjetivo C
					WHERE C.ID = @lo

					UPDATE Cuenta
					SET Cuenta.Saldo = Cuenta.Saldo - @monto
					FROM Cuenta
					INNER JOIN CuentaObjetivo C
					ON C.CuentaMaestra = Cuenta.ID
					WHERE C.ID = @lo

				END
			ELSE
				BEGIN

					INSERT MovimientoCO(Fecha,
										Monto,
										NuevoSaldo,
										Descripcion,
										IDTipoMovimientoCO,
										IDCuentaObjetivo,
										Logrado)
					SELECT @inFecha, @monto, CO.Saldo, 'Credito por Ahorro Fallido', 1, CO.ID, 0
					FROM CuentaObjetivo CO
					WHERE CO.ID = @lo
				
				END

			COMMIT 
	END
	Set @lo=@lo+1

END


END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
