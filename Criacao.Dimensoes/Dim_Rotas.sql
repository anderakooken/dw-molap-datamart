CREATE TABLE [dbo].[Rotas]
(
	[idRota] INT NOT NULL PRIMARY KEY, 
    [idArea] INT NULL, 
    [area] NVARCHAR(50) NULL, 
    [idSetor] INT NULL, 
    [setor] NVARCHAR(20) NULL
)
