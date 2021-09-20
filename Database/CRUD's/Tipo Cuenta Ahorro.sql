USE [PrograBases]

--- CRUD de tabla - TipoCuentaAhorro --------------------

---- CREATE ------------------------------


IF OBJECT_ID('InserTipoCuentaAhorro') IS NOT NULL
BEGIN 
DROP PROC InsertTipoCuentaAhorro
END
GO
CREATE PROCEDURE InsertTipoCuentaAhorro
	  @inID_TCuenta INT,
	  @inNombre VARCHAR(32),
	  @inSaldoMinimo MONEY,
	  @inMultaSaldoMinimo MONEY,
	  @inCargoAnual MONEY,
	  @inNumRetiros_Humanos INT,
	  @inNumRetiros_Automaticos INT,
	  @inComisionHumano MONEY,
	  @inComisionAutomatico MONEY,
	  @inInteres INT,
	  @inIDTMoneda INT
	 
AS
BEGIN TRY
INSERT INTO TipoCuentaAhorro(
	   ID_TCuenta,
	   Nombre,
	   SaldoMinimo,
	   MultaSaldoMinimo,
	   CargoAnual,
	   NumRetiros_Humanos,
	   NumRetiros_Automaticos,
	   ComisionHumano,
	   ComisionAutomatico,
	   Interes,
	   IDTMoneda)
    VALUES (
	   @inID_TCuenta,
	   @inNombre,
	   @inSaldoMinimo,
	   @inMultaSaldoMinimo,
	   @inCargoAnual,
	   @inNumRetiros_Humanos,
	   @inNumRetiros_Automaticos,
  	   @inComisionHumano,
	   @inComisionAutomatico,
	   @inInteres,
	   @inIDTMoneda)
	   return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO
---- READ   ------------------------------

IF OBJECT_ID('ReadTipoCuentaAhorro') IS NOT NULL
BEGIN 
    DROP PROC ReadTipoCuentaAhorro
END 
GO
CREATE PROC ReadTipoCuentaAhorro
    @inID_TCuenta INT
AS 
BEGIN TRY
    SELECT ID_TCuenta, 
		   Nombre,
		   SaldoMinimo,
		   MultaSaldoMinimo,
		   CargoAnual,
		   NumRetiros_Humanos,
		   NumRetiros_Automaticos,
		   ComisionHumano,
		   ComisionAutomatico,
		   Interes,
		   IDTMoneda
    FROM   TipoCuentaAhorro  
    WHERE  (ID_TCuenta = @inID_TCuenta) 
	return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la datos no validos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- UPDATE ------------------------------

IF OBJECT_ID('UpdateTipoCuentaAhorro') IS NOT NULL
BEGIN 
DROP PROC UpdateTipoCuentaAhorro
END 
GO
CREATE PROC UpdateTipoCuentaAhorro
	 @inID_TCuenta INT,
	 @inNombre VARCHAR(32),
	 @inSaldoMinimo MONEY,
	 @inMultaSaldoMinimo MONEY,
	 @inCargoAnual MONEY,
	 @inNumRetiros_Humanos INT,
	 @inNumRetiros_Automaticos INT,
	 @inComisionHumano MONEY,
     @inComisionAutomatico MONEY,
	 @inInteres INT,
	 @inIDTMoneda INT
AS 
BEGIN TRY
UPDATE TipoCuentaAhorro
	SET  Nombre = @inNombre,
		 SaldoMinimo = @inSaldoMinimo,
		 MultaSaldoMinimo = @inMultaSaldoMinimo,
		 CargoAnual = @inCargoAnual,
		 NumRetiros_Humanos = @inNumRetiros_Humanos,
		 NumRetiros_Automaticos = @inNumRetiros_Automaticos,
	   	 ComisionHumano = @inComisionHumano,
		 ComisionAutomatico = @inComisionAutomatico,
		 Interes = @inInteres,
		 IDTMoneda = @inIDTMoneda
	WHERE  (ID_TCuenta = @inID_TCuenta)
return 1
END TRY
BEGIN CATCH
	RAISERROR('Error en la actualizacion de datos fallida', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


---- DELETE ------------------------------

IF OBJECT_ID('DeleteTipoCuentaAhorro') IS NOT NULL
BEGIN 
DROP PROC DeleteTipoCuentaAhorro
END 
GO
CREATE PROC DeleteTipoCuentaAhorro
    @inID_TCuenta int
AS 
BEGIN TRY
DELETE
FROM   TipoCuentaAhorro
WHERE  ID_TCuenta = @inID_TCuenta
return 1
END TRY 
BEGIN CATCH
	RAISERROR('Error en la eliminacion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO