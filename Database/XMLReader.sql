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
			DECLARE @TemporalPersona table (TipoDocId INT, 
											nombre VARCHAR(64), 
											valorDocId INT,
											fechaNaci DATE, 
											email VARCHAR(64), 
											telofono1 VARCHAR(16),
											telefono2 VARCHAR(16)); 

			DECLARE @TemporalCuenta table (valorDocID INT, 
										   tipoCuentaID INT, 
										   numeroCuenta INT,
										   fechaCreacion DATE, 
										   saldo MONEY);

			DECLARE @TemporalBeneficiario table (numeroCuenta INT, 
												 valorDicIdBene INT, 
												 parentezcoID INT, 
												 porcentaje INT);

			DECLARE @TemporalUsuario table (usuario VARCHAR(16), 
											pass VARCHAR(16),
											valorDocId INT, 
											esAdmin INT);

			DECLARE @TemporalUsuarioVer table (usuario VARCHAR(16), 
											   numCuenta INT);
			SET NOCOUNT ON 

			SELECT @Varios = C
			FROM OPENROWSET (BULK 'C:\Recursos\Datos.xml', SINGLE_BLOB) AS Varios(C)
			DECLARE @hdoc INT
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @Varios

----Insercion de datos a las tablas temporales ----------------------------------------------


--Persona----

			INSERT INTO @TemporalPersona (TipoDocId, 
										  nombre, 
										  valorDocId,
										  fechaNaci, 
										  email, 
										  telofono1,
										  telefono2)

			SELECT TipoDocuIdentidad, Nombre, ValorDocumentoIdentidad, FechaNacimiento, Email, Telefono1, Telefono2
			FROM OPENXML (@hdoc,'Datos/Personas/Persona', 2)
				WITH(
					TipoDocuIdentidad INT '@TipoDocuIdentidad' ,
					Nombre  VARCHAR(64) '@Nombre',
					ValorDocumentoIdentidad INT '@ValorDocumentoIdentidad',
					FechaNacimiento DATE '@FechaNacimiento',  
					Email VARCHAR(64) '@Email', 
					Telefono1 VARCHAR(16) '@Telefono1',
					Telefono2 VARCHAR(16) '@Telefono2'
				);

--Cuenta----

			INSERT INTO @TemporalCuenta (valorDocID, 
										 tipoCuentaID, 
										 numeroCuenta,
										 fechaCreacion, 
										 saldo)

			SELECT ValorDocumentoIdentidadDelCliente, TipoCuentaId, NumeroCuenta, FechaCreacion, Saldo
			FROM OPENXML (@hdoc,'Datos/Cuentas/Cuenta', 2)
				WITH(
					ValorDocumentoIdentidadDelCliente VARCHAR(16) '@ValorDocumentoIdentidadDelCliente' ,
					TipoCuentaId  INT '@TipoCuentaId',
					NumeroCuenta INT '@NumeroCuenta', 
				    FechaCreacion DATE '@FechaCreacion', 
					Saldo MONEY '@Saldo'
				);

--Beneficiarios----

			INSERT INTO @TemporalBeneficiario (numeroCuenta, 
			                                   valorDicIdBene, 
											   parentezcoID,
											   porcentaje)

			SELECT NumeroCuenta, ValorDocumentoIdentidadBeneficiario, ParentezcoId, Porcentaje
			FROM OPENXML (@hdoc,'Datos/Beneficiarios/Beneficiario', 2)
				WITH(
					NumeroCuenta INT '@NumeroCuenta', 
					ValorDocumentoIdentidadBeneficiario INT '@ValorDocumentoIdentidadBeneficiario', 
					ParentezcoId INT '@ParentezcoId', 
					Porcentaje INT '@Porcentaje'
				);

--Usuarios----

			INSERT INTO @TemporalUsuario (usuario, 
								          pass,
										  valorDocId, 
										  esAdmin)

			SELECT Username, Pass, ValorDocumentoIdentidad, EsAdministrador
			FROM OPENXML (@hdoc,'Datos/Usuarios/Usuario', 2)
				WITH(
					Username VARCHAR(16) '@Usuario', 
					Pass VARCHAR(16) '@Pass',
					ValorDocumentoIdentidad INT '@ValorDocumentoIdentidad', 
					EsAdministrador INT '@EsAdministrador'
				);

--Usuarios_Ver----

			INSERT INTO @TemporalUsuarioVer (usuario, 
											 numCuenta)

			SELECT Username, NumeroCuenta
			FROM OPENXML (@hdoc,'Datos/Usuarios_Ver/UsuarioPuedeVer', 2)
				WITH(
					Username VARCHAR(16) '@Usuario', 
					NumeroCuenta INT '@NumeroCuenta'
				);


						/*--------------------------------------------------------*/

-----Inicio del ciclo para insertar los archivos a las tablas reales ------------------------


	--Persona---------------------------------------------------------

	        INSERT INTO [dbo].Persona(IDTDoc, 
									  Nombre, 
									  ValorDocIdentidad, 
									  FechaNacimiento, 
									  Email, 
									  Telefono1, 
									  Telefono2)
			SELECT TipoDocId, nombre, valorDocId, fechaNaci, email, telofono1, telefono2  FROM @TemporalPersona;

	--Cuenta---------------------------------------------------------

	        INSERT INTO [dbo].Cuenta(IDValorDocIdentidad, 
									 IDTCuenta, 
									 NumeroCuenta, 
									 FechaCreacion, 
									 Saldo)
			SELECT valorDocID, tipoCuentaID, numeroCuenta, fechaCreacion, saldo  FROM @TemporalCuenta;

	--Beneficiarios---------------------------------------------------------

			INSERT INTO [dbo].Persona(IDTDoc, 
									  Nombre, 
									  ValorDocIdentidad, 
									  FechaNacimiento, 
									  Email, 
									  Telefono1, 
									  Telefono2)
			SELECT  1,
					'No Conocido',
					valorDicIdBene,
					'1990-01-01',
					'na@na.com',
					'00000000',
					'00000000'
			FROM @TemporalBeneficiario B
			WHERE NOT EXISTS(
							SELECT *
							FROM Persona Pe
							WHERE (Pe.ValorDocIdentidad = B.valorDicIdBene))

	        INSERT INTO [dbo].Beneficiario(IDNumeroCuenta, 
										   IDValorDocIdentidad, 
										   IDParentezco,
										   Porcentaje,
										   Activo)
			SELECT numeroCuenta, valorDicIdBene, parentezcoID, porcentaje, 1  FROM @TemporalBeneficiario;

	--Usuarios---------------------------------------------------------

	        INSERT INTO [dbo].Usuario(Username, 
									  Pass, 
									  IDValorDocIdentidad, 
									  EsAdministrador)
			SELECT usuario, pass, valorDocId, esAdmin  FROM @TemporalUsuario;

	--Usuarios_Ver---------------------------------------------------------

	        INSERT INTO [dbo].Usuarios_Ver(Username, 
										   IDNumeroCuenta)
			SELECT usuario, numCuenta  FROM @TemporalUsuarioVer;


		COMMIT
	END TRY

	BEGIN CATCH 
	print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END 