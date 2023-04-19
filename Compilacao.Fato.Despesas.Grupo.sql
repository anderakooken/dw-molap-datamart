Set Language 'Português'

INSERT INTO [dbo].[Fato_Despesas_GruposDespesa]
SELECT 

dp.idDepartamento as IDDEPARTAMENTO,
dp.departamento as DEPARTAMENTO, 
gp.grupoDespesa as GRUPODESPESA, 
tab_c.* 

from (
SELECT 

	tab_b.idEmpresa as IDEMPRESA,
	tab_b.dataDespesa as DATA,
	tab_b.idGrupoDespesa as IDGRUPODESPESA,
	SUM(TOTAL_OPER_SAIDA)TOTAL_OPER_SAIDA,
	SUM(TOTAL_OPER_ENTRADA) TOTAL_OPER_ENTRADA,
	SUM(TRANSFERENCIA) TRANSFERENCIA,
	SUM(DEBITO_AUTOMATICO) DEBITO_AUTOMATICO,
	SUM(DEPOSITO) DEPOSITO,
	SUM(DINHEIRO) DINHEIRO,
	SUM(BOLETO) BOLETO,
	SUM(CHEQUE_PRE) CHEQUE_PRE,
	SUM(CHEQUE) CHEQUE,
	SUM(OUTROS) OUTROS

	FROM (
		SELECT 

			idEmpresa,
			dataDespesa,
			idGrupoDespesa,
			CASE WHEN tipoOperacao = 'S' THEN sum(total) ELSE 0 END as TOTAL_OPER_SAIDA,
			CASE WHEN tipoOperacao = 'E' THEN sum(total) ELSE 0 END as TOTAL_OPER_ENTRADA,

			CASE WHEN tipoPagamento = 'TR' THEN sum(total) ELSE 0 END as TRANSFERENCIA,
			CASE WHEN tipoPagamento = 'DA' THEN sum(total) ELSE 0 END as DEBITO_AUTOMATICO,
			CASE WHEN tipoPagamento = 'DC' THEN sum(total) ELSE 0 END as DEPOSITO,
			CASE WHEN tipoPagamento = 'D' THEN sum(total) ELSE 0 END as DINHEIRO,
			CASE WHEN tipoPagamento = 'BO' THEN sum(total) ELSE 0 END as BOLETO,
			CASE WHEN tipoPagamento = 'CP' THEN sum(total) ELSE 0 END as CHEQUE_PRE,
			CASE WHEN tipoPagamento = 'C' THEN sum(total) ELSE 0 END as CHEQUE,
			CASE WHEN tipoPagamento = 'None' THEN sum(total) ELSE 0 END as OUTROS


			FROM 
			(
				SELECT 

				d.idEmpresa,
				d.tipoOperacao,
				d.tipoPagamento,
				d.tipoDocumento,
				d.situacaoDespesa,
				d.idGrupoDespesa,
				CONVERT(DATE, CONCAT(
				SUBSTRING(d.dataVencimento, 1, 2), '/', 
				SUBSTRING(d.dataVencimento, 4, 2), '/', 
				SUBSTRING(d.dataVencimento, 7, 4)
				))as dataDespesa,

				convert (FLOAT, REPLACE(REPLACE(d.valor,'.',''),',','.')) as total,
				convert (FLOAT, REPLACE(REPLACE(d.valorParcial,'.',''),',','.')) as valorParcial,
				convert (FLOAT, REPLACE(REPLACE(d.desconto,'.',''),',','.')) as desconto,
				convert (FLOAT, REPLACE(REPLACE(d.juros,'.',''),',','.')) as juros

				FROM [DATAWAREHOUSE].[dbo].[Despesas] d


			)tab_a

				WHERE idEmpresa = 10

			GROUP BY idEmpresa, dataDespesa, idGrupoDespesa, tipoOperacao, situacaoDespesa, tipoDocumento, tipoPagamento
	
	)tab_b

		WHERE tab_b.dataDespesa BETWEEN '01/01/2020' AND '31/12/2022' AND tab_b.idEmpresa = 10

	GROUP BY tab_b.dataDespesa, tab_b.idEmpresa, tab_b.idGrupoDespesa

)tab_c

	LEFT JOIN gruposDespesa gp ON (gp.idGrupoDespesa = tab_c.idGrupoDespesa)
	LEFT JOIN departamentos dp ON (dp.idDepartamento = gp.idDepartamento)

	ORDER BY tab_c.DATA
