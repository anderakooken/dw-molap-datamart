CREATE TABLE [dbo].[PedidosProdutos]
(
	[idPedido] INT NOT NULL , 
    [idLiquidacao] INT NOT NULL, 
    [idProduto] INT NOT NULL, 
    [valorUnitario] NVARCHAR(255) NULL, 
    [descontoPercentual] NVARCHAR(255) NULL, 
    [quantidade] INT NULL, 
    [icms] NVARCHAR(255) NULL, 
    [ipi] NVARCHAR(255) NULL, 
    [substituto] NVARCHAR(255) NULL, 
    CONSTRAINT [PK_PedidosProdutos] PRIMARY KEY ([idPedido], [idProduto], [idLiquidacao])
)
