CREATE TABLE [dbo].[Departamentos]
(
    [idEmpresa] INT NOT NULL, 
    [idDepartamento] INT NOT NULL, 
    [departamento] NVARCHAR(90) NULL, 
    CONSTRAINT [PK_Departamentos] PRIMARY KEY ([idEmpresa],[idDepartamento]) 
)

/*
INSERT INTO Departamentos 
SELECT 
idEmpresa,
idDepartamento,
departamento 
FROM [DATAWAREHOUSE].[dbo].[Despesas] 
group by idEmpresa, idDepartamento, departamento 
ORDER BY idDepartamento
*/