CREATE TABLE [dbo].[Cidades]
(
	[idCidade] INT NOT NULL , 
    [cidade] NVARCHAR(200) NULL, 
    [estado] NVARCHAR(50) NOT NULL, 
    [pais] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_Cidades] PRIMARY KEY ([idCidade]) 
)
