USE [PrograBases]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[CargarXML]

AS

BEGIN
	BEGIN TRY
		BEGIN TRAN
----Declaramos las tablas temporales-----------------------------------------------------------

			DECLARE @Varios XML
			DECLARE @TemporalTipoDocu table (id INT, nombre VARCHAR(32));
			DECLARE @TemporalTipoMoneda table (id INT, nombre VARCHAR(16));
			DECLARE @TemporalParentezco table (id INT, nombre VARCHAR(16));  
			DECLARE @TemporalTipoCuenta table (id INT, nombre VARCHAR(16), idTipo INT, salMinimo MONEY, 
												multaSalMinimo MONEY, cargoAnual MONEY, numRetiroHum INT,
												numRetiroAut INT, comisionHu MONEY, comisionAut MONEY, interes INT); 
			DECLARE @TemporalPersona table (TipoDocId INT, nombre VARCHAR(64), valorDocId VARCHAR(16),
											fechaNaci DATE, email VARCHAR(64), telofono1 VARCHAR(16),
											telefono2 VARCHAR(16)); 
			DECLARE @TemporalCuenta table (valorDocID VARCHAR(16), tipoCuentaID INT, numeroCuenta VARCHAR(16),
											fechaCreacion DATE, saldo MONEY);
			DECLARE @TemporalBeneficiario table (numeroCuenta VARCHAR(16), valorDicIdBene VARCHAR(16), 
												parentezcoID INT, porcentaje INT);
			DECLARE @TemporalUsuario table (usuario VARCHAR(16), pass VARCHAR(16),
											valorDocId VARCHAR(16), esAdmin INT);
			DECLARE @TemporalUsuarioVer table (usuario VARCHAR(16), numCuenta VARCHAR(16));
			SET NOCOUNT ON 

			SELECT @Varios = C
			FROM OPENROWSET (BULK 'C:\Recursos\Datos.xml', SINGLE_BLOB) AS Varios(C)
			DECLARE @hdoc INT
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @Varios

----Insercion de datos a las tablas temporales ----------------------------------------------

--Tipo_Doc----

			INSERT INTO @TemporalTipoDocu (id, nombre )

			SELECT Id, Nombre
			FROM OPENXML (@hdoc,'Datos/Tipo_Doc/TipoDocuIdentidad', 2)
				WITH(
					Id INT '@Id' ,
					Nombre  VARCHAR(32) '@Nombre'
				);

--Tipo_Moneda----

			INSERT INTO @TemporalTipoMoneda (id, nombre )

			SELECT Id, Nombre
			FROM OPENXML (@hdoc,'Datos/Tipo_Moneda/TipoMoneda', 2)
				WITH(
					Id INT '@Id' ,
					Nombre  VARCHAR(16) '@Nombre'
				);

--Parentezcos----

			INSERT INTO @TemporalParentezco (id, nombre )

			SELECT Id, Nombre
			FROM OPENXML (@hdoc,'Datos/Parentezcos/Parentezco', 2)
				WITH(
					Id INT '@Id' ,
					Nombre  VARCHAR(16) '@Nombre'
				);

--Tipo_Cuenta_Ahorros----

			INSERT INTO @TemporalTipoCuenta (id, nombre, idTipo, salMinimo, 
												multaSalMinimo, cargoAnual, numRetiroHum,
												numRetiroAut, comisionHu, comisionAut, interes)

			SELECT TipoDocuIdentidad, Nombre, IdTipoMoneda, SaldoMinimo, MultaSaldoMin, CargoAnual, NumRetirosHumano,
					NumRetirosAutomatico, ComisionHumano, ComisionAutomatico, Interes
			FROM OPENXML (@hdoc,'Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro', 2)
				WITH(
					TipoDocuIdentidad INT '@Id' ,
					Nombre  VARCHAR(16) '@Nombre',
					IdTipoMoneda INT '@IdTipoMoneda',
					SaldoMinimo MONEY '@SaldoMinimo',					
					MultaSaldoMin MONEY '@MultaSaldoMin', 
					CargoAnual MONEY '@CargoAnual', 
					NumRetirosHumano INT '@NumRetirosHumano',
					NumRetirosAutomatico INT '@NumRetirosAutomatico', 
					ComisionHumano MONEY '@ComisionHumano', 
					ComisionAutomatico MONEY '@ComisionAutomatico', 
					Interes INT '@Interes'
				);

--Persona----

			INSERT INTO @TemporalPersona (TipoDocId, nombre, valorDocId,
											fechaNaci, email, telofono1,
											telefono2)

			SELECT TipoDocuIdentidad, Nombre, ValorDocumentoIdentidad, FechaNacimiento, Email, Telefono1, Telefono2
			FROM OPENXML (@hdoc,'Datos/Personas/Persona', 2)
				WITH(
					TipoDocuIdentidad INT '@TipoDocuIdentidad' ,
					Nombre  VARCHAR(64) '@Nombre',
					ValorDocumentoIdentidad VARCHAR(16) '@ValorDocumentoIdentidad',
					FechaNacimiento DATE '@FechaNacimiento',  
					Email VARCHAR(64) '@Email', 
					Telefono1 VARCHAR(16) '@Telefono1',
					Telefono2 VARCHAR(16) '@Telefono2'
				);

--Cuenta----

			INSERT INTO @TemporalCuenta (valorDocID, tipoCuentaID, numeroCuenta,
											fechaCreacion, saldo)

			SELECT ValorDocumentoIdentidadDelCliente, TipoCuentaId, NumeroCuenta, FechaCreacion, Saldo
			FROM OPENXML (@hdoc,'Datos/Cuentas/Cuenta', 2)
				WITH(
					ValorDocumentoIdentidadDelCliente VARCHAR(16) '@ValorDocumentoIdentidadDelCliente' ,
					TipoCuentaId  INT '@TipoCuentaId',
					NumeroCuenta VARCHAR(16) '@NumeroCuenta', 
				    FechaCreacion DATE '@FechaCreacion', 
					Saldo MONEY '@Saldo'
				);

--Beneficiarios----

			INSERT INTO @TemporalBeneficiario (numeroCuenta, valorDicIdBene, 
												parentezcoID, porcentaje)

			SELECT NumeroCuenta, ValorDocumentoIdentidadBeneficiario, ParentezcoId, Porcentaje
			FROM OPENXML (@hdoc,'Datos/Beneficiarios/Beneficiario', 2)
				WITH(
					NumeroCuenta VARCHAR(16) '@NumeroCuenta', 
					ValorDocumentoIdentidadBeneficiario VARCHAR(16) '@ValorDocumentoIdentidadBeneficiario', 
					ParentezcoId INT '@ParentezcoId', 
					Porcentaje INT '@Porcentaje'
				);

--Usuarios----

			INSERT INTO @TemporalUsuario (usuario, pass,
											valorDocId, esAdmin)

			SELECT Username, Pass, ValorDocumentoIdentidad, EsAdministrador
			FROM OPENXML (@hdoc,'Datos/Usuarios/Usuario', 2)
				WITH(
					Username VARCHAR(16) '@User', 
					Pass VARCHAR(16) '@Pass',
					ValorDocumentoIdentidad VARCHAR(16) '@ValorDocumentoIdentidad', 
					EsAdministrador INT '@EsAdministrador'
				);

--Usuarios_Ver----

			INSERT INTO @TemporalUsuarioVer (usuario, numCuenta)

			SELECT Username, NumeroCuenta
			FROM OPENXML (@hdoc,'Datos/Usuarios_Ver/UsuarioPuedeVer', 2)
				WITH(
					Username VARCHAR(16) '@User', 
					NumeroCuenta VARCHAR(16) '@NumeroCuenta'
				);


						/*--------------------------------------------------------*/

-----Inicio del ciclo para insertar los archivos a las tablas reales ------------------------


	--Tipo_Doc----

			INSERT INTO [dbo].TipoDocIdentidad(ID_TDoc , Tipo)
			SELECT id, nombre  FROM @TemporalTipoDocu;

	--Tipo_Moneda----

			INSERT INTO [dbo].Tipo_Moneda(ID_TMoneda, Nombre)
			SELECT id, nombre  FROM @TemporalTipoMoneda;

	--Parentezcos----

	        INSERT INTO [dbo].Parentezcos(ID_Parentezco , Nombre)
			SELECT id, nombre  FROM @TemporalParentezco;

	--Tipo_Cuenta_Ahorros----

		    INSERT INTO [dbo].TipoCuentaAhorro(ID_TCuenta, Nombre, ID_TMoneda, SaldoMinimo, MultaSaldoMinimo, CargoAnual, NumRetiros_Humanos,
												NumRetiros_Automaticos, ComisionHumano, ComisionAutomatico, Interes)
			SELECT id, nombre, idTipo, salMinimo, multaSalMinimo, cargoAnual,
					numRetiroHum, numRetiroAut, comisionHu, comisionAut, interes FROM @TemporalTipoCuenta;

	--Persona----

	        INSERT INTO [dbo].Persona(ID_TDoc, Nombre, ValorDocIdentidad, FechaNacimiento, Email, Telefono1, Telefono2)
			SELECT TipoDocId, nombre, valorDocId, fechaNaci, email, telofono1, telefono2  FROM @TemporalPersona;

	--Cuenta----

	        INSERT INTO [dbo].Cuenta(ValorDocIdentidad, ID_TCuenta, NumeroCuenta, FechaCreacion, Saldo)
			SELECT valorDocID, tipoCuentaID, numeroCuenta, fechaCreacion, saldo  FROM @TemporalCuenta;

	--Beneficiarios----

	        INSERT INTO [dbo].Beneficiario(NumeroCuenta, ValorDocIdentidad, ID_Parentezco, Porcentaje)
			SELECT numeroCuenta, valorDicIdBene, parentezcoID, porcentaje  FROM @TemporalBeneficiario;

	--Usuarios----

	        INSERT INTO [dbo].Usuario(Username, Pass, ValorDocIdentidad, EsAdministrador)
			SELECT usuario, pass, valorDocId, esAdmin  FROM @TemporalUsuario;

	--Usuarios_Ver----

	        INSERT INTO [dbo].Usuarios_Ver(Username, NumeroCuenta)
			SELECT usuario, numCuenta  FROM @TemporalUsuarioVer;


		COMMIT
	END TRY

	BEGIN CATCH 
	print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END 