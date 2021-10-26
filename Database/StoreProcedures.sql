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
	 @inNumCuenta INT
AS
BEGIN TRY 
	SELECT COUNT(B.ID_Beneficiario)
	FROM Beneficiario B
	WHERE (B.IDNumeroCuenta = @inNumCuenta AND B.Activo = 1)

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
	 @inValorDocumentoIdentidad INT
AS
BEGIN TRY 
	SELECT C.NumeroCuenta
	FROM Cuenta C
	WHERE (C.IDValorDocIdentidad = @inValorDocumentoIdentidad)

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
	 @inNumeroCuenta INT
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
	ON P.ValorDocIdentidad = B.IDValorDocIdentidad
	WHERE (B.IDNumeroCuenta = @inNumeroCuenta AND B.Activo = 1)

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
	 @inNumeroCuenta INT
AS
BEGIN TRY 
	SELECT B.Porcentaje,
		   B.IDValorDocIdentidad,
		   B.IDNumeroCuenta,
		   B.IDParentezco
	FROM Beneficiario B
	WHERE (B.IDNumeroCuenta = @inNumeroCuenta AND B.Activo = 1)

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
	 @inValorDocumentoIdentidad INT
AS
BEGIN TRY 
	UPDATE Beneficiario
	SET Activo = 0
	WHERE (IDValorDocIdentidad = @inValorDocumentoIdentidad)

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
	@inValorDocumentoIdentidad INT,
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
	WHERE (ValorDocIdentidad = @inValorDocumentoIdentidad)

	UPDATE Beneficiario
	SET IDParentezco = @inIDParentezco,
		Porcentaje = @inPorcentaje,
		IDValorDocIdentidad = @inValorDocIdentidad
	WHERE (IDValorDocIdentidad = @inValorDocumentoIdentidad)
		
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
	 @inValorDocumentoIdentidad INT,
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
		   @inValorDocumentoIdentidad,
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
	 @inNumeroCuenta INT,
	 @inValorDocIndentidad INT
AS
BEGIN TRY 
	SELECT SUM(B.Porcentaje)
	FROM Beneficiario B
	WHERE (B.IDNumeroCuenta = @inNumeroCuenta AND B.IDValorDocIdentidad != @inValorDocIndentidad)

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
	WHERE (C.IDValorDocIdentidad = @inIDPersona)

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
	ON C.INumeroCuenta = E.IDNumeroCuenta
	WHERE (C.INumeroCuenta = @inNumCuenta)

END TRY
BEGIN CATCH
	RAISERROR('Error al consultar estados de cuenta', 16, 1) WITH NOWAIT;
	PRINT error_message()
	return -1
END CATCH
GO

