USE [PrograBases]


/* 
Procedimiento VerCuenta
Objetivo: Encontrar las cuentas a las que el usuario esta ligado y a la vez mostrar todas si es administrador
	Entradas : Id de la persona
	Salidas  : Datos de cuentas
*/

IF OBJECT_ID('VerCuenta') IS NOT NULL
BEGIN 
DROP PROC VerCuenta 
END
GO
CREATE PROCEDURE VerCuenta
	 @inDocumentoIdentidad INT
AS
BEGIN TRY 
	IF 1 = (SELECT U.EsAdministrador FROM Usuario U WHERE (@inDocumentoIdentidad = U.IDValorDocIdentidad))
		SELECT C.IDValorDocIdentidad,
			   C.IDTCuenta,
			   C.NumeroCuenta,
			   C.FechaCreacion,
			   C.Saldo
		FROM Cuenta C

	ELSE 
		SELECT C.IDValorDocIdentidad,
			   C.IDTCuenta,
			   C.NumeroCuenta,
			   C.FechaCreacion,
			   C.Saldo
		FROM Cuenta C
		WHERE (C.IDValorDocIdentidad = @inDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerDocumentoIdentidad
Objetivo: Ver el Documento de identidad ligado al usuario que accedio al sistema
	Entradas : Usuario 
	Salidas  : Documento de Identidad
*/
IF OBJECT_ID('VerDocumentoIdentidad') IS NOT NULL
BEGIN 
DROP PROC VerDocumentoIdentidad 
END
GO
CREATE PROCEDURE VerDocumentoIdentidad
	 @inUsuario VARCHAR(16)
AS
BEGIN TRY 
	SELECT U.IDValorDocIdentidad 
	FROM Usuario U
	WHERE (U.Username = @inUsuario)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento CountBeneficiarios
Objetivo: Contador de Beneficiarios
	Entradas : Cuenta 
	Salidas  : Cantidad de Beneficiarios
*/
IF OBJECT_ID('CountBeneficiarios') IS NOT NULL
BEGIN 
DROP PROC CountBeneficiarios 
END
GO
CREATE PROCEDURE CountBeneficiarios
	 @inIDCuenta INT
AS
BEGIN TRY 
	SELECT COUNT(B.ID_Beneficiario)
	FROM Beneficiario B
	WHERE (B.IDNumeroCuenta = @inIDCuenta AND B.Activo = 1)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO





--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerNumeroCuenta
Objetivo: Ver el numero de cuenta ligado a un documento de identidad
	Entradas : Documento de identidad 
	Salidas  : El numero de cuenta ligado a la persona
*/
IF OBJECT_ID('VerNumeroCuenta') IS NOT NULL
BEGIN 
DROP PROC VerNumeroCuenta 
END
GO
CREATE PROCEDURE VerNumeroCuenta
	 @inIDDocumentoIdentidad INT
AS
BEGIN TRY 
	SELECT C.ID
	FROM Cuenta C
	WHERE (C.IDValorDocIdentidad = @inIDDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerBeneficiarios
Objetivo: Retornar los datos de los beneficiarios asociados a la cuenta
	Entradas : El numero de la cuenta con el cual buscar los beneficiarios 
	Salidas  : Los datos solicitados de las tablas Beneficiarios y Persona
*/
IF OBJECT_ID('VerBeneficiarios') IS NOT NULL
BEGIN 
DROP PROC VerBeneficiarios 
END
GO
CREATE PROCEDURE VerBeneficiarios
	 @inIDCuenta INT
AS
BEGIN TRY 
	SELECT P.Nombre,
		   B.IDParentezco,
		   B.Porcentaje,
		   P.FechaNacimiento,
		   P.ValorDocIdentidad,
		   P.Email,
		   P.Telefono1,
		   P.Telefono2
	FROM Beneficiario B
	INNER JOIN Persona P
	ON P.ID = B.IDValorDocIdentidad
	WHERE (B.IDNumeroCuenta = @inIDCuenta AND B.Activo = 1)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerBeneficiarios
Objetivo: Retornar los datos de los beneficiarios asociados a la cuenta
	Entradas : El numero de la cuenta con el cual buscar los beneficiarios 
	Salidas  : Los datos solicitados de las tablas Beneficiarios
*/
IF OBJECT_ID('VerBeneficiariosMini') IS NOT NULL
BEGIN 
DROP PROC VerBeneficiariosMini 
END
GO
CREATE PROCEDURE VerBeneficiariosMini
	 @inIDCuenta INT
AS
BEGIN TRY 
	SELECT B.Porcentaje,
		   B.IDValorDocIdentidad,
		   B.IDNumeroCuenta,
		   B.IDParentezco
	FROM Beneficiario B
	WHERE (B.IDNumeroCuenta = @inIDCuenta AND B.Activo = 1)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento EliminarBeneficiario
Objetivo: Cambia el valor activo en el beneficiario solicitado
	Entradas : Valor documento identidad
	Salidas  : Cambio directo en la base
*/
IF OBJECT_ID('EliminarBeneficiario') IS NOT NULL
BEGIN 
DROP PROC EliminarBeneficiario 
END
GO
CREATE PROCEDURE EliminarBeneficiario
	 @inIDDocumentoIdentidad INT
AS
BEGIN TRY 
	UPDATE Beneficiario
	SET Activo = 0
	WHERE (IDValorDocIdentidad = @inIDDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento ActualizarBeneficiarios
Objetivo: SP encargado de actualizar los datos de los beneficiarios en las tablas de Beneficiario y Persona
	Entradas : Los parametros a cambiar
	Salidas  : Actualizacion en la base
*/
IF OBJECT_ID('ActualizarBeneficiarios') IS NOT NULL
BEGIN 
DROP PROC ActualizarBeneficiarios 
END
GO
CREATE PROCEDURE ActualizarBeneficiarios
	@inIDDocumentoIdentidad INT,
	@inNombre VARCHAR(64),
	@inIDParentezco INT,
	@inPorcentaje INT,
	@inFechaNacimiento DATE,
	@inValorDocIdentidad INT,
	@inEmail VARCHAR(64),
	@inTelefono1 VARCHAR(64),
	@inTelefono2 VARCHAR(64)
AS
BEGIN TRY 
	UPDATE Persona
	SET ValorDocIdentidad = @inValorDocIdentidad,
		Nombre = @inNombre,
		FechaNacimiento = @inFechaNacimiento,
		Email = @inEmail,
		Telefono1 = @inTelefono1,
		Telefono2 = @inTelefono2
	WHERE (ValorDocIdentidad = @inValorDocIdentidad)

	UPDATE Beneficiario
	SET IDParentezco = @inIDParentezco,
		Porcentaje = @inPorcentaje,
		IDValorDocIdentidad = @inValorDocIdentidad
	WHERE (IDValorDocIdentidad = @inIDDocumentoIdentidad)
		
END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento AgregarBeneficiario
Objetivo: Agregar un nuevo beneficiario
	Entradas : Datos necesarios para la creacion del beneficiario 
	Salidas  : Nuevo beneficiario o -1 en caso de error
*/
IF OBJECT_ID('AgregarBeneficiario') IS NOT NULL
BEGIN 
DROP PROC AgregarBeneficiario 
END
GO
CREATE PROCEDURE AgregarBeneficiario
	 @inPorcentaje INT,
	 @inIDDocumentoIdentidad INT,
	 @inIDNumeroCuenta INT,
	 @inIDParentezco INT
AS
BEGIN TRY 
	INSERT Beneficiario(Porcentaje,
						IDValorDocIdentidad,
						IDNumeroCuenta,
						IDParentezco,
						Activo)
	VALUES(@inPorcentaje,
		   @inIDDocumentoIdentidad,
		   @inIDNumeroCuenta,
		   @inIDParentezco,
		   1)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento AgregarPersona
Objetivo Agregar una nueva persona a la base de datos 
	Entradas : Datos de la persona
	Salidas  : Insercion de datos en la tabla
*/
IF OBJECT_ID('AgregarPersona') IS NOT NULL
BEGIN 
DROP PROC AgregarPersona 
END
GO
CREATE PROCEDURE AgregarPersona
	@inValorDocumentoIdentidad INT,
	@inNombre VARCHAR(64),
	@inFechaNacimiento DATE,
	@inEmail VARCHAR(64),
	@inTelefono1 VARCHAR(64),
	@inTelefono2 VARCHAR(64),
	@inTDocumento INT
AS
BEGIN TRY 
	INSERT Persona(ValorDocIdentidad,
				   Nombre,
				   FechaNacimiento,
				   Email,
				   Telefono1,
				   Telefono2,
				   IDTDoc)
	VALUES(@inValorDocumentoIdentidad,
		   @inNombre,
		   @inFechaNacimiento,
		   @inEmail,
		   @inTelefono1,
		   @inTelefono2,
		   @inTDocumento)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento BuscarPersona
Objetivo: Dar a saber si una persona existe o no en la base de datos 
	Entradas : Valor Documento de identidad
	Salidas  : Contador con resultado de 1 si es que la encontro
*/
IF OBJECT_ID('BuscarPersona') IS NOT NULL
BEGIN 
DROP PROC BuscarPersona 
END
GO
CREATE PROCEDURE BuscarPersona
	 @inValorDocumentoIdentidad INT
AS
BEGIN TRY 
	SELECT COUNT(1)
	FROM Persona C
	WHERE (C.ValorDocIdentidad = @inValorDocumentoIdentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento SumarPorcentajes
Objetivo: Dar a saber la suma de porcentajes 
	Entradas : Numero de Cuenta, Porcentaje y Valor de la persona a cambiar
	Salidas  : Suma total de los datos a sumar
*/
IF OBJECT_ID('SumarPorcentajes') IS NOT NULL
BEGIN 
DROP PROC SumarPorcentajes 
END
GO
CREATE PROCEDURE SumarPorcentajes
	 @inIDCuenta INT,
	 @inIDDocIndentidad INT
AS
BEGIN TRY 
	SELECT SUM(B.Porcentaje)
	FROM Beneficiario B
	WHERE (B.IDNumeroCuenta = @inIDCuenta AND B.IDValorDocIdentidad != @inIDDocIndentidad)

END TRY
BEGIN CATCH
	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO



--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento ActualizarPorcentaje
Objetivo: Actualizar porcentajes de los beneficiarios 
	Entradas : ID's de los mismo junto con su porcentaje
	Salidas  : Confirmacion de cambios aplicados
*/
--IF OBJECT_ID('ActualizarPorcentaje') IS NOT NULL
--BEGIN 
--DROP PROC EliminarBeneficiario 
--END
--GO
--CREATE PROCEDURE EliminarBeneficiario
--	 @inValorDocumentoIdentidad INT
--AS
--BEGIN TRY 
--	UPDATE Beneficiario
--	SET Activo = 0
--	WHERE (IDValorDocIdentidad = @inValorDocumentoIdentidad)

--END TRY
--BEGIN CATCH
--	RAISERROR('Error en la insercion de datos', 16, 1) WITH NOWAIT;
--	PRINT error_message()
--	return -1
--END CATCH
--GO

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerNumCuentas
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/
IF OBJECT_ID('VerNumCuentas') IS NOT NULL
BEGIN 
DROP PROC VerNumCuentas 
END
GO
CREATE PROCEDURE VerNumCuentas
	 @inIDPersona INT
AS
BEGIN TRY 
	SELECT C.numeroCuenta
	FROM Cuenta C
	INNER JOIN Persona P
	ON P.ID = C.IDValorDocIdentidad
	WHERE (C.IDValorDocIdentidad = @inIDPersona and C.Activo = 1)

END TRY
BEGIN CATCH
	RAISERROR('Error al consultar numeros de cuenta', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerNumCuentasAdmin
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/
IF OBJECT_ID('VerNumCuentasAdmin') IS NOT NULL
BEGIN 
DROP PROC VerNumCuentasAdmin 
END
GO
CREATE PROCEDURE VerNumCuentasAdmin
AS
BEGIN TRY 
	SELECT C.numeroCuenta
	FROM Cuenta C

END TRY
BEGIN CATCH
	RAISERROR('Error al consultar numeros de cuenta', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerEstadosCuenta
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/
IF OBJECT_ID('VerEstadosCuenta') IS NOT NULL
BEGIN 
DROP PROC VerEstadosCuenta 
END
GO
CREATE PROCEDURE VerEstadosCuenta
	 @inNumCuenta INT
AS
BEGIN TRY 
	SELECT E.Fecha
		, E.SaldoMinimo
		, E.SaldoInicio
		, E.SaldoFinal
		, E.CantOperacionesATM
		, E. CantOperacionesCajeroHumano
	FROM EstadoCuenta E
	INNER JOIN Cuenta C
	ON C.ID = E.IDNumeroCuenta
	WHERE (C.NumeroCuenta = @inNumCuenta)

END TRY
BEGIN CATCH
	RAISERROR('Error al consultar estados de cuenta', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento VerMovimientos
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/
IF OBJECT_ID('VerMovimientos') IS NOT NULL
BEGIN 
DROP PROC VerMovimientos 
END
GO
CREATE PROCEDURE VerMovimientos
	 @inNumCuenta INT,
	 @inFecha DATE
AS
BEGIN TRY 

	DECLARE @FechaFinal DATE
	SET @FechaFinal = (SELECT DATEADD (month, 1, @inFecha))

	SELECT M.Fecha
		, M.Cambio
		, T.Compra
		, T.Venta
		, M.MontoMovimiento
		, M.MontoCuenta
		, M.Descripcion 
	FROM Movimientos M
	INNER JOIN Cuenta C
	ON C.ID = M.IDNumeroCuenta
	INNER JOIN Tipo_CambioDolar T
	ON T.Fecha = @inFecha
	WHERE (C.NumeroCuenta = @inNumCuenta and M.Fecha >= @inFecha and M.Fecha < @FechaFinal)

END TRY
BEGIN CATCH
	RAISERROR('Error al consultar los movimientos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO 


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento esAdmin
Objetivo: Retornar si el usuario es admin
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/
IF OBJECT_ID('esAdmin') IS NOT NULL
BEGIN 
DROP PROC esAdmin 
END
GO
CREATE PROCEDURE esAdmin
	 @inUserName VARCHAR(16)
AS
BEGIN TRY 
	SELECT U.EsAdministrador
	FROM Usuario U
	WHERE (U.Username = @inUserName)

END TRY
BEGIN CATCH
	RAISERROR('Error al consultar el administrador', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO 

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento desactivarCuenta
Objetivo: Desactivar una cuenta
	Entradas : El número de cuenta 
	Salidas  : NA
*/
IF OBJECT_ID('desactivarCuenta') IS NOT NULL
BEGIN 
DROP PROC desactivarCuenta 
END
GO
CREATE PROCEDURE desactivarCuenta
	 @inNumCuenta INT
AS
BEGIN TRY 
	UPDATE Cuenta 
	SET Activo = 0
	WHERE (Cuenta.NumeroCuenta = @inNumCuenta)


END TRY
BEGIN CATCH
	RAISERROR('Error al desactivar Cuenta', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO 

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento desactivarCuenta
Objetivo: Desactivar una cuenta
	Entradas : El número de cuenta 
	Salidas  : NA
*/
IF OBJECT_ID('desactivarCuenta') IS NOT NULL
BEGIN 
DROP PROC desactivarCuenta 
END
GO
CREATE PROCEDURE desactivarCuenta
	 @inNumCuenta INT
AS
BEGIN TRY 
	UPDATE Cuenta 
	SET Activo = 0
	WHERE (Cuenta.NumeroCuenta = @inNumCuenta)


END TRY
BEGIN CATCH
	RAISERROR('Error al desactivar Cuenta', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO 

--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento ConsultarMultaPorATM
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/
USE [PrograBases]
CREATE VIEW FechaMaxima
AS
SELECT MAX(E.Fecha) as FechaMax,
		C.NumeroCuenta as NumCuenta
FROM Cuenta C
INNER JOIN EstadoCuenta E
ON C.ID = E.IDNumeroCuenta
WHERE(CONCAT(E.CantOperacionesATM, '-', E.IDNumeroCuenta) in 
	(SELECT CONCAT(MAX(E2.CantOperacionesATM), '-', E2.IDNumeroCuenta) FROM EstadoCuenta E2 GROUP BY (E2.IDNumeroCuenta)))
GROUP BY C.NumeroCuenta



USE [PrograBases]
IF OBJECT_ID('ConsultarMultaPorATM') IS NOT NULL
BEGIN 
DROP PROC ConsultarMultaPorATM 
END
GO
CREATE PROCEDURE ConsultarMultaPorATM
	 @inNumDias INT
AS
BEGIN TRY 
/*
	DECLARE @FechaFinal DATE
	SET @FechaFinal = (SELECT MAX Fecha from Evento)
	
	DECLARE @FechaInicial DATE
	SET @FechaInicial = (SELECT DATEADD(DAY, -@inNumDias, @FechaFinal))*/
	/*
	DECLARE @Promedio FLOAT
	SET @Promedio = (SELECT AVG(E.CantOperacionesATM)
					FROM Cuenta C
					INNER JOIN EstadoCuenta E
					ON C.ID = E.IDNumeroCuenta)*/
	
	

	/*SELECT E.Fecha
	FROM Cuenta C
	INNER JOIN EstadoCuenta E
	ON C.ID = E.IDNumeroCuenta
	WHERE(E.CantOperacionesATM = (SELECT MAX(E2.CantOperacionesATM) FROM EstadoCuenta E2 WHERE (E2.IDNumeroCuenta = C.ID)))*/

	SELECT C.ID,
			AVG(E.CantOperacionesATM) as Promedio,
			CONCAT(MONTH(F.FechaMax), '/', YEAR(F.FechaMax)) AS FechaMax
	FROM Cuenta C
	INNER JOIN EstadoCuenta E
	ON C.ID = E.IDNumeroCuenta
	INNER JOIN TipoCuentaAhorro T
	ON C.IDTCuenta = T.ID_TCuenta
	INNER JOIN FechaMaxima F
	ON C.NumeroCuenta = F.NumCuenta
	WHERE (E.CantOperacionesATM > T.NumRetiros_Automaticos)
	GROUP BY C.ID, F.FechaMax



END TRY
BEGIN CATCH
	RAISERROR('Error al consultar la multa por ATM', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO 


--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento ConsultarBeneficiarios
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta
*/


IF OBJECT_ID('ConsultarBeneficiarios') IS NOT NULL
BEGIN 
DROP PROC ConsultarBeneficiarios 
END
GO
CREATE PROCEDURE ConsultarBeneficiarios
AS
BEGIN TRY 

	SELECT B.ID_Beneficiario
	FROM Beneficiario B
	INNER JOIN Cuenta C
	ON B.IDNumeroCuenta = C.ID
	GROUP BY B.ID_Beneficiario, C.NumeroCuenta

	SELECT B.IDNumeroCuenta,
			B.IDValorDocIdentidad,
			MAX(B.Porcentaje) as Porcentaje
	FROM Beneficiario B
	WHERE(CONCAT(B.Porcentaje, '-', B.IDValorDocIdentidad) in (SELECT CONCAT(MAX(B2.Porcentaje), '-', B2.IDVAlorDocIdentidad) 
																FROM Beneficiario B2 GROUP BY B2.IDValorDocIdentidad))
	GROUP BY B.IDNumeroCuenta, B.IDValorDocIdentidad

	SELECT B.IDValorDocIdentidad,
			COUNT(B.IDNumeroCuenta) as CantidadCuentas
	FROM Beneficiario B
	GROUP BY B.IDValorDocIdentidad






END TRY
BEGIN CATCH
	RAISERROR('Error al consultar beneficiarios', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO 

EXECUTE ConsultarBeneficiarios
--------------------------------------------------------------------------------------------------------------------------
/* 
Procedimiento ConsultarRetirosNegativos
Objetivo: Retornar todas las cuentas asociadas a un usuario
	Entradas : El ID del usuario 
	Salidas  : Los numeros de cuenta

IF OBJECT_ID('ConsultarRetirosNegativos') IS NOT NULL
BEGIN 
DROP PROC ConsultarBeneficiarios 
END
GO
CREATE PROCEDURE ConsultarRetirosNegativos
AS
BEGIN TRY 



END TRY
BEGIN CATCH
	RAISERROR('Error al consultar retiros negativos', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO */