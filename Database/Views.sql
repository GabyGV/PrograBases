--------------------------------------------------------------------------------------------------------------------------
/* 
Vista FechaMaxima
Objetivo: Retornar la fecha en la que se realizó la mayor cantidad de operaciones ATM por cada cuenta
*/

IF OBJECT_ID('FechaMaxima') IS NOT NULL
BEGIN 
DROP VIEW FechaMaxima 
END
GO

CREATE VIEW FechaMaxima
AS
SELECT MAX(E.Fecha) AS FechaMax,
		C.NumeroCuenta AS NumCuenta
FROM Cuenta C
INNER JOIN EstadoCuenta E
ON C.ID = E.IDNumeroCuenta
WHERE(CONCAT(E.CantOperacionesATM, '-', E.IDNumeroCuenta) in 
	(SELECT CONCAT(MAX(E2.CantOperacionesATM), '-', E2.IDNumeroCuenta) FROM EstadoCuenta E2 GROUP BY (E2.IDNumeroCuenta)))
GROUP BY C.NumeroCuenta



--------------------------------------------------------------------------------------------------------------------------
/* 
Vista PorcentajeMaximo
Objetivo: Retornar la cuenta en la que el beneficiario tiene su mayor porcentaje
*/

IF OBJECT_ID('PorcentajeMaximo') IS NOT NULL
BEGIN 
DROP VIEW PorcentajeMaximo 
END
GO

CREATE VIEW PorcentajeMaximo
AS
SELECT B.IDNumeroCuenta,
		B.IDValorDocIdentidad,
		MAX(B.Porcentaje) AS Porcentaje
FROM Beneficiario B
WHERE(CONCAT(B.Porcentaje, '-', B.IDValorDocIdentidad) in (SELECT CONCAT(MAX(B2.Porcentaje), '-', B2.IDVAlorDocIdentidad) 
															FROM Beneficiario B2 GROUP BY B2.IDValorDocIdentidad))
GROUP BY B.IDNumeroCuenta, B.IDValorDocIdentidad

