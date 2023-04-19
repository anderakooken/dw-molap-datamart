CREATE TABLE [dbo].[Pedidos]
(
	[idPedido] INT NOT NULL , 
    [idLiquidacao] INT NOT NULL,
    [idEmpresa] INT NOT NULL, 
    [idCliente] INT NOT NULL,
    [idArea] INT NULL, 
    [idSetor] INT NULL, 
    [rota] INT NULL,  
    [liquidacaoData] NCHAR(10) NULL, 
    [nfe] NVARCHAR(50) NULL, 
    [nfe_dev] NVARCHAR(50) NULL, 
    [pedidoData] NVARCHAR(20) NULL, 
    [idPagamento] INT NULL, 
    [pagamento] NVARCHAR(200) NULL,
    [idVencimento] INT NULL, 
    [vencimento] NVARCHAR(200) NULL,
    [valor] NVARCHAR(50) NULL, 
    [tipo] INT NULL, 
    [operacaoFaturamento] INT NULL, 
    PRIMARY KEY ([idPedido], [idLiquidacao], [idEmpresa], [idCliente])
)
