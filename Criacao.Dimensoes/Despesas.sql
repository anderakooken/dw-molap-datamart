CREATE TABLE [dbo].[Despesas]
(
[idEmpresa] INT NOT NULL
,[documento] NVARCHAR(50) NOT NULL
,[idFornecedor] INT NOT NULL
,[fornecedor] NVARCHAR(90) NULL
,[idOrdem] NVARCHAR(20) NULL
,[idGrupoFornecedor] NVARCHAR(20) NULL
,[nf] NVARCHAR(20) NULL
,[idGrupoDespesa] NVARCHAR(20) NULL
,[grupoDespesa] NVARCHAR(50) NULL
,[idDepartamento] NVARCHAR(20) NULL
,[departamento] NVARCHAR(50) NULL
,[tipoPagamento] NVARCHAR(20) NULL
,[dataEmissao] NVARCHAR(20) NULL
,[dataVencimento] NVARCHAR(20) NULL
,[dataMovimento] NVARCHAR(20) NULL
,[dataPagamento] NVARCHAR(20) NULL
,[dataProgramada] NVARCHAR(20) NULL
,[tipoOperacao] NVARCHAR(10) NULL
,[valor] NVARCHAR(30) NULL
,[valorParcial] NVARCHAR(30) NULL
,[juros] NVARCHAR(30) NULL
,[desconto] NVARCHAR(30) NULL
,[tipoDocumento] NVARCHAR(30) NULL
,[situacaoDespesa] NVARCHAR(20) NULL
,[diasQtd] NVARCHAR(10) NULL
,[observacoes] NVARCHAR(600) NULL, 
    CONSTRAINT [PK_Despesas] PRIMARY KEY ([idEmpresa],[documento],[idFornecedor]) 

)