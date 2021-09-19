USE [PrograBases]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC loginUsuario 
@in_username VARCHAR(256), 
@in_Pass VARCHAR(256)
AS

BEGIN

	SELECT COUNT(1) 
	FROM Usuario 
	WHERE Username=@in_username 
	and Pass=@in_Pass;

END;

Execute loginUsuario('Gaby','123');

INSERT into [dbo].[Usuario] values ("Gaby", "123", 1, NULL)


--Pruebas Login
INSERT INTO [dbo].[Usuario] (Username, Pass, EsAdministrador, IDValorDocIdentidad)
VALUES ('Gaby', '123', 1, NULL);

INSERT INTO [dbo].[Usuario] (Username, Pass, EsAdministrador, IDValorDocIdentidad)
VALUES ('Dylan', '456', 1, NULL);