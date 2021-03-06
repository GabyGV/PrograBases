USE [PrograBases]
GO

IF OBJECT_ID('CargarXMLCatalogo') IS NOT NULL
BEGIN 
DROP PROC CargarXMLCatalogo 
END
GO
Create PROCEDURE [dbo].[CargarXMLCatalogo]

AS

BEGIN
	BEGIN TRY
		BEGIN TRAN
----Declaramos El inicio de la lectura XML-----------------------------------------------------

			DECLARE @Varios XML

			SELECT @Varios = C
			FROM OPENROWSET (BULK 'C:\Recursos\Datos.xml', SINGLE_BLOB) AS Varios(C)
			DECLARE @hdoc INT
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @Varios

----Insercion de datos a las tablas No- Catalogo ----------------------------------------------

--Tipo_Doc----

			INSERT INTO [dbo].TipoDocIdentidad (ID_TDoc, Tipo)

			SELECT Id, Nombre
			FROM OPENXML (@hdoc,'Datos/Tipo_Doc/TipoDocuIdentidad', 2)
				WITH(
					Id INT '@Id' ,
					Nombre  VARCHAR(32) '@Nombre'
				);

--Tipo_Moneda----

			INSERT INTO [dbo].Tipo_Moneda(ID_TMoneda, Nombre)

			SELECT Id, Nombre
			FROM OPENXML (@hdoc,'Datos/Tipo_Moneda/TipoMoneda', 2)
				WITH(
					Id INT '@Id' ,
					Nombre  VARCHAR(16) '@Nombre'
				);

--Parentezcos----

			INSERT INTO [dbo].Parentezcos(ID_Parentezco, Nombre)

			SELECT Id, Nombre
			FROM OPENXML (@hdoc,'Datos/Parentezcos/Parentezco', 2)
				WITH(
					Id INT '@Id' ,
					Nombre  VARCHAR(16) '@Nombre'
				);

--Tipo_Cuenta_Ahorros----

			INSERT INTO [dbo].TipoCuentaAhorro(ID_TCuenta,
												Nombre,
												IDTMoneda,
												SaldoMinimo,
												MultaSaldoMinimo,
												CargoAnual,
												NumRetiros_Humanos,
												NumRetiros_Automaticos,
												ComisionHumano,
												ComisionAutomatico,
												Interes)

			SELECT TipoDocuIdentidad, Nombre, IdTipoMoneda, SaldoMinimo, MultaSaldoMin, CargoAnual, NumRetirosHumano,
					NumRetirosAutomatico, ComisionHumano, ComisionAutomatico, Interes
			FROM OPENXML (@hdoc,'Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro', 2)
				WITH(
					TipoDocuIdentidad INT '@Id' ,
					Nombre  VARCHAR(16) '@Nombre',
					IdTipoMoneda INT '@IdTipoMoneda',
					SaldoMinimo MONEY '@SaldoMinimo',					
					MultaSaldoMin MONEY '@MultaSaldoMin', 
					CargoAnual MONEY '@CargoMensual', 
					NumRetirosHumano INT '@NumRetirosHumano',
					NumRetirosAutomatico INT '@NumRetirosAutomatico', 
					ComisionHumano MONEY '@ComisionHumano', 
					ComisionAutomatico MONEY '@ComisionAutomatico', 
					Interes INT '@Interes'
				);

--Tipo_Movimiento----

			INSERT INTO [dbo].Tipo_Movimiento(ID,
											  Descripcion,
											  Operacion)

			SELECT id, descripcion, operacion
			FROM OPENXML (@hdoc,'Datos/Tipo_Movimientos/TipoMovimiento', 2)
				WITH(
					id INT '@Id' ,
					descripcion VARCHAR(128) '@Descripcion',
					operacion INT '@Operacion'
				);


--Tipo_MovimientoCO----

			INSERT INTO [dbo].TipoMovimientoCO(ID,
											  Operacion,
											  Nombre)

			SELECT id, operacion, nombre
			FROM OPENXML (@hdoc,'Datos/TipoMovimientosCO/TipoMovimientoCO', 2)
				WITH(
					id INT '@Id' ,
					operacion INT '@Operacion',
					nombre VARCHAR(64) '@Descripcion'
				);


--TasaInteresesCO----

			INSERT INTO [dbo].TasaInteresesCO(ID,
											  TasaInteres)

			SELECT id, tasaInteres
			FROM OPENXML (@hdoc,'Datos/TasaInteresesCO/TasaInteresCO', 2)
				WITH(
					id INT '@Id' ,
					tasaInteres FLOAT '@TasaInteres'
				);

--TipoEventos----

			INSERT INTO [dbo].TipoEvento(ID,
										  Nombre)

			SELECT id, nombre
			FROM OPENXML (@hdoc,'Datos/TipoEventos/TipoEvento', 2)
				WITH(
					id INT '@Id' ,
					nombre VARCHAR(64) '@Nombre'
				);

		COMMIT
	END TRY

	BEGIN CATCH 
	print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END 