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

---------------------------------------------------------------------

CREATE TRIGGER trg_BeneficiarioInsert
   ON  [dbo].Beneficiario
   AFTER INSERT

AS 
BEGIN
	BEGIN TRY
		
		INSERT INTO [dbo].Evento(TipoEvento,
								 IDUser,
								 Fecha)
		SELECT 1, ins.ID_Beneficiario, ins.Fecha
		FROM INSERTED ins

	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END
GO

-------------------------------------------

CREATE TRIGGER trg_BeneficiarioUpdate
   ON  [dbo].Beneficiario
   AFTER UPDATE

AS 
BEGIN
	BEGIN TRY
		
		IF((SELECT ins.Activo FROM INSERTED ins) = 0)
			BEGIN
				INSERT INTO [dbo].Evento(TipoEvento,
								 IDUser,
								 Fecha)
				SELECT 3, ins.ID_Beneficiario, ins.Fecha
				FROM INSERTED ins
			END	
		
		ELSE
			BEGIN
				INSERT INTO [dbo].Evento(TipoEvento,
								 IDUser,
								 Fecha)
				SELECT 2, ins.ID_Beneficiario, ins.Fecha
				FROM INSERTED ins
			END

	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END
GO

-----------------------------------------

CREATE TRIGGER trg_CuentaObjetivoInsert
   ON  [dbo].CuentaObjetivo
   AFTER INSERT

AS 
BEGIN
	BEGIN TRY
		
		INSERT INTO [dbo].Evento(TipoEvento,
								 IDUser,
								 Fecha)
		SELECT 4, ins.ID, ins.FechaInicial
		FROM INSERTED ins

	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END
GO

-----------------------------------------

CREATE TRIGGER trg_CuentaObjetivoUPDATE
   ON  [dbo].CuentaObjetivo
   AFTER UPDATE

AS 
BEGIN
	BEGIN TRY
		
		IF((SELECT ins.Activo FROM INSERTED ins) = 0)
			BEGIN
				INSERT INTO [dbo].Evento(TipoEvento,
								 IDUser,
								 Fecha)
				SELECT 6, ins.ID, ins.FechaFinal
				FROM INSERTED ins
			END	
		
		ELSE
			BEGIN
				INSERT INTO [dbo].Evento(TipoEvento,
								 IDUser,
								 Fecha)
				SELECT 5, ins.ID, ins.FechaInicial
				FROM INSERTED ins
			END

	END TRY
	BEGIN CATCH
		print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END
GO