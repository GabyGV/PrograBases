USE [PrograBases]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC loginUsuario (@in_username VARCHAR(16), @in_Pass VARCHAR(16))
AS

BEGIN

	SELECT COUNT(1) 
	FROM [dbo].[Usuario]
	WHERE Username=@in_username 
	and Pass=@in_Pass;

END

Execute loginUsuario @in_username = 'Gaby', @in_Pass = '123';




--Pruebas Login
INSERT INTO [dbo].[Usuario] (Username, Pass, EsAdministrador, IDValorDocIdentidad)
VALUES ('Gaby', '123', 1, NULL);

INSERT INTO [dbo].[Usuario] (Username, Pass, EsAdministrador, IDValorDocIdentidad)
VALUES ('Dylan', '456', 1, NULL);

SELECT COUNT(1) 
	FROM Usuario 
	WHERE Username='Gaby' 
	and Pass='123';