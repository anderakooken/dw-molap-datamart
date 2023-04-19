CREATE TABLE [dbo].[GruposDespesa]
(
    [idEmpresa] INT NOT NULL, 
	[idGrupoDespesa] INT NOT NULL, 
    [idDepartamento] INT NOT NULL, 
    [grupoDespesa] NVARCHAR(90) NULL, 
    CONSTRAINT [PK_GruposDespesa] PRIMARY KEY ([idEmpresa],[idGrupoDespesa],[idDepartamento]) 
)

/*
INSERT INTO GruposDespesa 
SELECT 
idEmpresa,
idGrupoDespesa, 
idDepartamento,
grupoDespesa 
FROM [DATAWAREHOUSE].[dbo].[Despesas] 
group by idEmpresa,idGrupoDespesa, grupoDespesa, idDepartamento 
ORDER BY idGrupoDespesa
*/