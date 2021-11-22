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
			DECLARE @TemporalFechas table (fecha DATE);
			DECLARE	@Operaciones table (elemento INT IDENTITY(1,1),
										id INT);
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

			DECLARE @TemporalMovimientos table (id INT IDENTITY(1,1),
												descripcion VARCHAR(128),
												idMoneda INT,
												monto MONEY,
												numeroCuenta INT,
												tipo INT,
												FechaTemp DATE);

			DECLARE @TemporalTipoCambio table (compra INT, 
											   venta INT,
											   FechaTemp DATE);

			DECLARE @TemporalAgregarCO table (cuentaMaestra INT,
											  descripcion VARCHAR(100),
											  diaAhorro INT,
											  fechaFinal DATE,
											  montoAhorrar MONEY,
											  numeroCO INT,
											  FechaTemp DATE);

			DECLARE @TemporalUsuario table (usuario VARCHAR(16), 
											pass VARCHAR(16),
											valorDocId INT, 
											esAdmin INT);

			DECLARE @TemporalUsuarioVer table (usuario VARCHAR(16), 
											   numCuenta INT);

						-- Variables para operaciones-----------------------------

			DECLARE @SaldoActual MONEY;
			DECLARE @SaldoMinimo MONEY; 
			DECLARE @IdValorDocumentIdentidad INT;
			DECLARE @IdTipoOperacion INT;
			DECLARE @IdCuenta INT;
			DECLARE @IdMovimiento INT;
			DECLARE @IdEstadoCuenta INT;
			DECLARE @IdTipoCuenta INT;
			DECLARE @MontoMovimiento INT;
			DECLARE @MontoFinal INT;
			DECLARE @TipoMonedaCuenta INT;
			DECLARE @TipoMonedaMovimiento INT ;
			DECLARE @Cambio VARCHAR(32);
			DECLARE @IdTipoCambio INT;
			DECLARE @TipoMovimiento INT;
			
			DECLARE @TipoCuenta INT;
			DECLARE @Intereses INT;
			DECLARE @Contador INT;


			DECLARE @IdMin INT;
			DECLARE @IdMax INT;
			DECLARE @IdActual INT;


			----------------------------------------------------------

			SET NOCOUNT ON 

			DECLARE @fechaMinima DATE
			DECLARE @fechaMaxima DATE
			DECLARE @DiaDeCierre INT
			DECLARE @DiaDeCO INT

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

--Tipo_Cambio----

			INSERT INTO @TemporalTipoCambio (compra, 
											 venta,
											 FechaTemp)

			SELECT Compra, Venta, fechaLeida
			FROM OPENXML (@hdoc,'Datos/FechaOperacion/TipoCambioDolares', 2)
				WITH(
					Compra INT '@Compra', 
					Venta INT '@Venta',
					fechaLeida VARCHAR(40) '../@Fecha'
				);

--AgregarCo----

			INSERT INTO @TemporalAgregarCO (cuentaMaestra, 
											descripcion,
											diaAhorro,
											fechaFinal,
											montoAhorrar,
											numeroCO,
											FechaTemp)

			SELECT CuentaMaestra, Descripcion, DiaAhorro, FechaFinal, MontoAhorrar, NumeroCO, fechaLeida
			FROM OPENXML (@hdoc,'Datos/FechaOperacion/AgregarCO', 2)
				WITH(
					CuentaMaestra INT '@CuentaMaestra',
					Descripcion VARCHAR(100) '@Descripcion',
					DiaAhorro INT '@DiadeAhorro',
					FechaFinal DATE '@FechaFinal',
					MontoAhorrar MONEY '@MontoAhorrar',
					NumeroCO INT '@NumeroCO',
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

					SET @DiaDeCierre = Day(@fechaActual);
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

    --TipoCambio-------------------------------------------------------

					INSERT INTO [dbo].Tipo_CambioDolar(Compra,
													   Venta,
													   Fecha)
					SELECT T.compra, T.venta, T.FechaTemp
					FROM @TemporalTipoCambio T
					WHERE T.FechaTemp = @fechaActual;

	--AgregarCO-------------------------------------------------------

					INSERT INTO [dbo].CuentaObjetivo(CuentaMaestra,
													 CuentaObjetivo,
													 MontoMensual,
													 FechaInicial,
													 FechaFinal,
													 DiaDeAhorro,
													 Descripcion)
					SELECT C.ID, T.numeroCO, T.montoAhorrar, T.FechaTemp, T.fechaFinal, T.diaAhorro, T.descripcion
					FROM @TemporalAgregarCO T
					INNER JOIN Cuenta C
					ON T.cuentaMaestra = C.NumeroCuenta
					WHERE T.FechaTemp = @fechaActual;

	--Movimientos------------------------------------------------------
					
					INSERT @Operaciones (id)
					SELECT T.id
					FROM @TemporalMovimientos T
					WHERE T.FechaTemp = @fechaActual;

					SET @IdMin = 1;
					SET @IdActual = @IdMin;
					SELECT @IdMax = MAX(O.elemento) FROM @Operaciones O 

					WHILE (@IdActual <= @IdMax)
					BEGIN
		---- Seteo de datos -------------------------------------------------------------------
						SET @IdMovimiento = (SELECT M.id
										     FROM @TemporalMovimientos M
											 INNER JOIN @Operaciones O
											 ON O.id = M.id
											 WHERE O.elemento = @IdActual)

						SET @IdCuenta = (SELECT C.ID 
										FROM Cuenta C
										INNER JOIN @TemporalMovimientos M
										ON C.NumeroCuenta = M.numeroCuenta
										WHERE M.id = @IdMovimiento)

						SET @SaldoActual = (SELECT C.Saldo 
											FROM Cuenta C
											WHERE C.ID = @IdCuenta)

						SET @IdEstadoCuenta = (SELECT E.ID 
											   FROM EstadoCuenta E 
											   WHERE (E.IDNumeroCuenta = @IdCuenta) AND (E.Activo = 1))

						SET @IdTipoOperacion = (SELECT T.Operacion
												FROM Tipo_Movimiento T
												INNER JOIN @TemporalMovimientos M
												ON M.tipo = T.ID
												WHERE M.id = @IdMovimiento)

						SET @TipoMonedaCuenta = (SELECT T.IDTMoneda
												 FROM TipoCuentaAhorro T
												 INNER JOIN Cuenta C
												 ON C.IDTCuenta = T.ID_TCuenta
												 WHERE C.ID = @IdCuenta)

						SET @TipoMonedaMovimiento = (SELECT M.idMoneda
													 FROM @TemporalMovimientos M
													 WHERE M.ID = @IdMovimiento)

						SET @MontoMovimiento = (SELECT M.monto
												FROM @TemporalMovimientos M
												WHERE M.id = @IdMovimiento)

						SET @IdTipoCambio = (SELECT MAX(T.ID)
											 FROM Tipo_CambioDolar T)

						SET @SaldoMinimo = (SELECT E.SaldoMinimo 
											FROM EstadoCuenta E
											WHERE E.ID = @IdEstadoCuenta)
						
						
						IF ((@TipoMonedaCuenta = 1) AND (@TipoMonedaMovimiento = 2))
							BEGIN
								SET @Cambio = 'Dolares a Colones'
								IF(@IdTipoOperacion = 1)
									BEGIN
										SET @MontoFinal = (SELECT (@MontoMovimiento*T.Venta) 
														   FROM Tipo_CambioDolar T
														   WHERE T.ID = @IdTipoCambio)
									END
								ELSE 
									BEGIN
										SET @MontoFinal = (SELECT (@MontoMovimiento*T.Compra)*-1
														   FROM Tipo_CambioDolar T
														   WHERE T.ID = @IdTipoCambio)
									END
							END		
						ELSE 
							BEGIN
								IF ((@TipoMonedaCuenta = 2) AND (@TipoMonedaMovimiento = 1))
									BEGIN
										SET @Cambio = 'Colones a Dolares'
										IF(@IdTipoOperacion = 1)
											BEGIN
												SET @MontoFinal = (SELECT (@MontoMovimiento/T.Compra) 
																   FROM Tipo_CambioDolar T
																   WHERE T.ID = @IdTipoCambio)
											END
										ELSE 
											BEGIN
												SET @MontoFinal = (SELECT (@MontoMovimiento/T.Venta)*-1
																   FROM Tipo_CambioDolar T
																   WHERE T.ID = @IdTipoCambio)
											END
									END
								ELSE
									BEGIN
										SET @Cambio = 'Sin conversion'
										SET @MontoFinal = @MontoMovimiento
									END
							END

						IF (@SaldoMinimo > @SaldoActual+@MontoFinal)
							BEGIN
								SET @SaldoMinimo = @SaldoActual + @MontoFinal
							END
		-----------------------------------------------------------------------				
		---- Ingreso en Movimientos -------------------------------------------
						INSERT INTO [dbo].Movimientos(Descripcion,
													  MontoMovimiento, 
													  MontoCuenta,
													  Fecha,
													  Cambio,
													  IDMoneda,
													  IDNumeroCuenta,
													  IDTMovimiento,
													  IDEstadoCuenta)
						SELECT T.descripcion, @MontoMovimiento, @MontoFinal, T.FechaTemp, @Cambio, 
									T.idMoneda, @IdCuenta, T.tipo, @IdEstadoCuenta
						FROM @TemporalMovimientos T
						INNER JOIN @Operaciones O
						ON O.id = T.id
						WHERE (T.FechaTemp = @fechaActual) AND (O.elemento = @IdActual);
		
		-----------------------------------------------------------------------	
		------ Ajustes en tablas Cuenta y Estado Cuenta -----------------------	

						UPDATE Cuenta
						SET Saldo = Saldo + @MontoFinal
						WHERE @IdCuenta = Cuenta.ID

						SET @TipoMovimiento = (SELECT T.tipo FROM @TemporalMovimientos T WHERE T.id = @IdMovimiento)

						IF((@TipoMovimiento = 1) OR (@TipoMovimiento = 7) OR (@TipoMovimiento = 9))
						BEGIN 
							UPDATE EstadoCuenta
							SET SaldoFinal = @SaldoActual + @MontoFinal, SaldoMinimo = @SaldoMinimo, CantOperacionesCajeroHumano = CantOperacionesCajeroHumano + 1
							WHERE EstadoCuenta.ID = @IdEstadoCuenta
						END
						IF((@TipoMovimiento = 2) OR (@TipoMovimiento = 6) OR (@TipoMovimiento = 10))
						BEGIN 
							UPDATE EstadoCuenta
							SET SaldoFinal = @SaldoActual + @MontoFinal, SaldoMinimo = @SaldoMinimo, CantOperacionesATM = CantOperacionesATM + 1
							WHERE EstadoCuenta.ID = @IdEstadoCuenta
						END
		-----------------------------------------------------------------------	
							
						
					
						SET @IdActual = @IdActual + 1
					END
					
					DELETE FROM @Operaciones;


	--Store Procedures -------------------------------------------------
				
					EXEC [dbo].[ProcesarCO] @DiaDeCierre

					WHILE (@IdActual <= @IdMax)
						BEGIN
							
							SET @IdCuenta = (SELECT E.IDNumeroCuenta 
											FROM EstadoCuenta E
											INNER JOIN @Operaciones O
											ON O.id = E.ID
											WHERE O.elemento = @IdActual)

							SET @SaldoActual = (SELECT C.Saldo 
												FROM Cuenta C
												WHERE C.ID = @IdCuenta)							
							

							SET @IdEstadoCuenta = (SELECT E.ID 
												   FROM EstadoCuenta E 
												   INNER JOIN @Operaciones O
												   ON O.id = E.ID
												   WHERE (O.elemento = @IdActual) AND (E.Activo = 1))

							SET @SaldoMinimo = (SELECT E.SaldoMinimo
												FROM EstadoCuenta E
												WHERE E.ID = @IdEstadoCuenta)

							SET @TipoCuenta = (SELECT C.IDTCuenta
											   FROM Cuenta C
											   WHERE C.ID = @IdCuenta )
							IF(@SaldoActual) IS NOT NULL
							BEGIN
							---- APLICADO DE INTERESES ------------------------------------
								SET @SaldoActual = (SELECT @SaldoActual -(@SaldoMinimo*(SELECT T.Interes/100 FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta)))
						
							---- MULTA SALDO MINIMO ---------------------------------------
								IF(@SaldoMinimo < (SELECT T.SaldoMinimo FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta))
									BEGIN
										SET @SaldoActual = @SaldoActual - (SELECT T.MultaSaldoMinimo FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta)
									END

							---- MULTA OPERACIONES EN ATM ----------------------------------
								SET @Contador = (SELECT E.CantOperacionesATM FROM EstadoCuenta E WHERE E.ID = @IdEstadoCuenta)
								IF(@Contador > (SELECT T.NumRetiros_Automaticos FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta))
									BEGIN
										SET @SaldoActual = @SaldoActual - (SELECT T.ComisionAutomatico FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta)
									END

							---- MULTA OPERACIONES EN CAJERO HUMANO ------------------------
								SET @Contador = (SELECT E.CantOperacionesCajeroHumano FROM EstadoCuenta E WHERE E.ID = @IdEstadoCuenta)
								IF(@Contador > (SELECT T.NumRetiros_Humanos FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta))
									BEGIN
										SET @SaldoActual = @SaldoActual - (SELECT T.ComisionHumano FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta)
									END

							---- COBRO DE CARGOS POR SERVICIO ------------------------------
								SET @SaldoActual = @SaldoActual - (SELECT T.CargoAnual FROM TipoCuentaAhorro T WHERE T.ID_TCuenta = @TipoCuenta)
						
							---- CERRAR ESTADO DE CUENTA -----------------------------------
								UPDATE EstadoCuenta	
								SET SaldoFinal = @SaldoActual, Activo = 0
								WHERE EstadoCuenta.ID = @IdEstadoCuenta

								UPDATE Cuenta
								SET Saldo = @SaldoActual
								WHERE Cuenta.ID = @IdCuenta
							
							---- INSERTAR NUENO ESTADO DE CUENTA ---------------------------
							
								INSERT INTO [dbo].EstadoCuenta( Fecha,
																FechaFin,	
																SaldoMinimo,
																SaldoInicio,
																SaldoFinal,
																CantOperacionesATM,
																CantOperacionesCajeroHumano,
																IDNumeroCuenta,
																Activo)
								SELECT @fechaActual, DATEADD(month, 1, @fechaActual), @SaldoActual, @SaldoActual, @SaldoActual, 0, 0, @IdCuenta, 1;
							END


							SET @IdActual = @IdActual + 1
						END
					
					DELETE FROM @Operaciones;

	--------------------------------------------------------------------


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