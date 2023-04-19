CREATE TABLE [dbo].[Clientes]
(
	[idCliente] INT NOT NULL , 
    [cliente] NVARCHAR(200) NULL, 
    [cnpj] NVARCHAR(50) NOT NULL, 
    [qualificacao] NVARCHAR(2) NULL, 
    [tipo] NVARCHAR(2) NULL, 
    [idCadeia] INT NULL, 
    [idCidade] INT NULL, 
    [idGeo] INT NULL, 
    [geo] NVARCHAR(60) NULL, 
    [endereco] NVARCHAR(200) NULL, 
    [tel1] NVARCHAR(20) NULL, 
    [tel2] NVARCHAR(20) NULL, 
    [email] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_Table2] PRIMARY KEY ([idCliente]) 
)
