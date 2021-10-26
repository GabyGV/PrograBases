USE [PrograBases]
GO

IF OBJECT_ID('CargarXML') IS NOT NULL
BEGIN 
DROP PROC CargarXML 
END
GO
Create PROCEDURE [dbo].[CargarXML]

AS

BEGIN
	BEGIN TRY
		BEGIN TRAN
----Declaramos las tablas temporales-----------------------------------------------------------

			DECLARE @Varios XML
			DECLARE @TemporalFechas table (fecha date);
			DECLARE @TemporalPersona table (TipoDocId INT, 
											nombre VARCHAR(64), 
											valorDocId INT,
											fechaNaci DATE, 
											email VARCHAR(64), 
											telofono1 VARCHAR(16),
											telefono2 VARCHAR(16),
											FechaTemp DATE); 

			DECLARE @TemporalCuenta table (valorDocID INT, 
										   tipoCuentaID INT, 
										   numeroCuenta INT,
										   saldo MONEY,
										   FechaTemp DATE);

			DECLARE @TemporalBeneficiario table (numeroCuenta INT, 
												 valorDicIdBene INT, 
												 parentezcoID INT, 
												 porcentaje INT,
												 FechaTemp DATE);

			DECLARE @TemporalMovimientos table (descripcion VARCHAR(128),
												idMoneda INT,
												monto MONEY,
												numeroCuenta INT,
												tipo INT,
												FechaTemp DATE);

			DECLARE @TemporalUsuario table (usuario VARCHAR(16), 
											pass VARCHAR(16),
											valorDocId INT, 
											esAdmin INT);

			DECLARE @TemporalUsuarioVer table (usuario VARCHAR(16), 
											   numCuenta INT);


			SET NOCOUNT ON 

			DECLARE @fechaMinima DATE
			DECLARE @fechaMaxima DATE
			DECLARE @DiaDeCobro INT

			SELECT @Varios = C
			FROM OPENROWSET (BULK 'C:\Recursos\Datos.xml', SINGLE_BLOB) AS Varios(C)
			DECLARE @hdoc INT
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @Varios

----Insercion de datos a las tablas temporales ----------------------------------------------

----Guardo las fechas a la tabla temporal----------------------------------------------

			INSERT INTO @TemporalFechas (fecha)
			SELECT convert(date, fechaInsercion, 121) [fechaInsercion]
			FROM OPENXML (@hdoc,'Datos/FechaOperacion', 1)

			WITH([fechaInsercion] VARCHAR (16) '@Fecha');

			SELECT @fechaMaxima = MAX(fecha) FROM @TemporalFechas 
			SELECT @fechaMinima = MIN(fecha) FROM @TemporalFechas 
			
			Declare @cont int
			DECLARE @fechaActual date
			SET @fechaActual = @fechaMinima;


--Persona----

			INSERT INTO @TemporalPersona (TipoDocId, 
										  nombre, 
										  valorDocId,
										  fechaNaci, 
										  email, 
										  telofono1,
										  telefono2,
										  FechaTemp)

			SELECT TipoDocuIdentidad, Nombre, ValorDocumentoIdentidad, FechaNacimiento, Email, Telefono1, Telefono2, fechaLeida
			FROM OPENXML (@hdoc,'Datos/FechaOperacion/AgregarPersona', 2)
				WITH(
					TipoDocuIdentidad INT '@TipoDocuIdentidad' ,
					Nombre  VARCHAR(64) '@Nombre',
					ValorDocumentoIdentidad INT '@ValorDocumentoIdentidad',
					FechaNacimiento DATE '@FechaNacimiento',  
					Email VARCHAR(64) '@Email', 
					Telefono1 VARCHAR(16) '@Telefono1',
					Telefono2 VARCHAR(16) '@Telefono2',
					fechaLeida VARCHAR(40) '../@Fecha'
				);

--Cuenta----

			INSERT INTO @TemporalCuenta (valorDocID, 
										 tipoCuentaID, 
										 numeroCuenta,
										 saldo,
										 FechaTemp)

			SELECT ValorDocumentoIdentidadDelCliente, TipoCuentaId, NumeroCuenta, Saldo, fechaLeida
			FROM OPENXML (@hdoc,'Datos/FechaOperacion/AgregarCuenta', 2)
				WITH(
					ValorDocumentoIdentidadDelCliente VARCHAR(16) '@ValorDocumentoIdentidadDelCliente' ,
					TipoCuentaId  INT '@TipoCuentaId',
					NumeroCuenta INT '@NumeroCuenta',  
					Saldo MONEY '@Saldo',
					fechaLeida VARCHAR(40) '../@Fecha'
				);

--Beneficiarios----

			INSERT INTO @TemporalBeneficiario (numeroCuenta, 
			                                   valorDicIdBene, 
											   parentezcoID,
											   porcentaje,
											   FechaTemp)

			SELECT NumeroCuenta, ValorDocumentoIdentidadBeneficiario, ParentezcoId, Porcentaje, fechaLeida
			FROM OPENXML (@hdoc,'Datos/FechaOperacion/AgregarBeneficiario', 2)
				WITH(
					NumeroCuenta INT '@NumeroCuenta', 
					ValorDocumentoIdentidadBeneficiario INT '@ValorDocumentoIdentidadBeneficiario', 
					ParentezcoId INT '@ParentezcoId', 
					Porcentaje INT '@Porcentaje',
					fechaLeida VARCHAR(40) '../@Fecha'
				);

--Movimiento----

			INSERT INTO @TemporalMovimientos (descripcion,
											  idMoneda,
											  monto,
											  numeroCuenta,
											  tipo,
											  FechaTemp)

			SELECT Descripcion, IDMoneda, Monto, NumeroCuenta, Tipo, fechaLeida
			FROM OPENXML (@hdoc,'Datos/FechaOperacion/Movimientos', 2)
				WITH(
					Descripcion VARCHAR(128) '@Descripcion',
					IDMoneda INT '@IdMoneda',
					Monto MONEY '@Monto',
					NumeroCuenta INT '@NumeroCuenta',
					Tipo INT '@Tipo',
					fechaLeida VARCHAR(40) '../@Fecha'
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

			WHILE (@fechaActual <= @fechaMaxima)
				BEGIN
					SET NOCOUNT ON 

					SET @DiaDeCobro = Day(@fechaActual);
	--Persona---------------------------------------------------------

					INSERT INTO [dbo].Persona(IDTDoc, 
											  Nombre, 
											  ValorDocIdentidad, 
											  FechaNacimiento, 
											  Email, 
											  Telefono1, 
											  Telefono2,
											  Fecha)
					SELECT TipoDocId, nombre, valorDocId, fechaNaci, email, telofono1, telefono2, FechaTemp  
					FROM @TemporalPersona
					WHERE [@TemporalPersona].FechaTemp = @fechaActual;

	--Cuenta---------------------------------------------------------

					INSERT INTO [dbo].Cuenta(IDValorDocIdentidad, 
											 IDTCuenta, 
											 NumeroCuenta,  
											 Saldo,
											 Fecha,
											 Activo)
					SELECT P.ID, tipoCuentaID, numeroCuenta, saldo, FechaTemp, 1
					FROM @TemporalCuenta
					INNER JOIN Persona P
					ON P.ValorDocIdentidad = [@TemporalCuenta].valorDocID
					WHERE [@TemporalCuenta].[FechaTemp] = @fechaActual;

	--Beneficiarios---------------------------------------------------------

					--INSERT INTO [dbo].Persona(IDTDoc, 
					--						  Nombre, 
					--						  ValorDocIdentidad, 
					--						  FechaNacimiento, 
					--						  Email, 
					--						  Telefono1, 
					--						  Telefono2,
					--						  Fecha)
					--SELECT  1,
					--		'No Conocido',
					--		valorDicIdBene,
					--		'1990-01-01',
					--		'na@na.com',
					--		'00000000',
					--		'00000000',
					--		@fechaActual
					--FROM @TemporalBeneficiario B
					--WHERE NOT EXISTS(
					--				SELECT *
					--				FROM Persona Pe
					--				WHERE (Pe.ValorDocIdentidad = B.valorDicIdBene))

					INSERT INTO [dbo].Beneficiario(IDNumeroCuenta, 
												   IDValorDocIdentidad, 
												   IDParentezco,
												   Porcentaje,
												   Activo,
												   Fecha)
					SELECT C.ID, P.ID, parentezcoID, porcentaje, 1, FechaTemp
					FROM @TemporalBeneficiario
					INNER JOIN Persona P
					ON P.ValorDocIdentidad = [@TemporalBeneficiario].valorDicIdBene
					INNER JOIN Cuenta C
					ON C.NumeroCuenta = [@TemporalBeneficiario].numeroCuenta
					WHERE [@TemporalBeneficiario].[FechaTemp] = @fechaActual;

	--Movimientos------------------------------------------------------

					INSERT INTO [dbo].Movimientos(Descripcion,
												  MontoMovimiento, 
												  MontoCuenta,
												  Fecha,
												  IDMoneda,
												  IDNumeroCuenta,
												  IDTMovimiento,
												  IDEstadoCuenta)
					SELECT T.descripcion, T.monto, T.monto, T.FechaTemp, T.idMoneda, C.ID , T.tipo, E.IDNumeroCuenta
					FROM @TemporalMovimientos T
					INNER JOIN Cuenta C
					ON C.NumeroCuenta = T.numeroCuenta
					INNER JOIN EstadoCuenta E
					ON E.IDNumeroCuenta = C.ID
					WHERE (T.FechaTemp = @fechaActual) AND (E.Activo = 1);
	


				SELECT @fechaActual = DATEADD(DAY,1,@fechaActual);


			END

	--Usuarios---------------------------------------------------------

		INSERT INTO [dbo].Usuario(Username, 
									Pass, 
									IDValorDocIdentidad, 
									EsAdministrador)
		SELECT usuario, pass, P.ID, esAdmin  
		FROM @TemporalUsuario
		INNER JOIN Persona P
		ON P.ValorDocIdentidad = [@TemporalUsuario].valorDocId;

	--Usuarios_Ver---------------------------------------------------------

		INSERT INTO [dbo].Usuarios_Ver(Username, 
										IDNumeroCuenta)
		SELECT usuario, C.ID  
		FROM @TemporalUsuarioVer
		INNER JOIN Cuenta C
		ON C.NumeroCuenta = [@TemporalUsuarioVer].numCuenta;

		COMMIT
	END TRY

	BEGIN CATCH 
	print error_message()
		ROLLBACK;
		THROW 70001,'Error en la insercion de Operaciones',1;
	END CATCH

END 