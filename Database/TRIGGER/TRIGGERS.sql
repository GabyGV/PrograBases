USE [PrograBases] 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER trg_CuentaInsert
   ON  [dbo].Cuenta
   AFTER INSERT

AS 
BEGIN
	BEGIN TRY

		INSERT INTO [dbo].EstadoCuenta( Fecha,
										FechaFin,	
									    SaldoMinimo,
										SaldoInicio,
										SaldoFinal,
										CantOperacionesATM,
										CantOperacionesCajeroHumano,
										IDNumeroCuenta,
										Activo)
		SELECT ins.Fecha, DATEADD(month, 1, ins.Fecha), 0, 0, 0, 0, 0, ins.ID, 1 
		FROM INSERTED ins;

	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END
GO
