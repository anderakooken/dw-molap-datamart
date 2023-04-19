Set Language 'Português'

--insert into [dbo].[Fato_Vendas_Pedidos]
SELECT * FROM (
SELECT 

tab_b.idEmpresa as EMPRESA,
tab_b.DATA as DATA,
tab_b.QTDPED,
tab_b.QTDPED_CD,
tab_b.QTDPED_SD,
tab_b.FATURAMENTO_CD,
tab_b.FATURAMENTO_SD,
tab_pacotes.QTDPACOTES as QTD_PACOTES_TOTAL,
tab_b.FATURAMENTO,
YEAR(tab_b.DATA) as ANO,
(tab_b.FATURAMENTO / tab_b.QTDPED) MEDIA_PEDIDO_GERAL,
(tab_b.FATURAMENTO / tab_pacotes.QTDPACOTES) MEDIA_PACOTE_GERAL,

tab_vndTpCliente.QTD_PJ as QTD_PACOTES_PJ, 
tab_vndTpCliente.QTD_PF as QTD_PACOTES_PF,

-- VALORES POR PJ / PF
(tab_vndTpCliente.QTD_PJ * (tab_b.FATURAMENTO / tab_pacotes.QTDPACOTES)) as FATURAMENTO_PJ,
(tab_vndTpCliente.QTD_PF * (tab_b.FATURAMENTO / tab_pacotes.QTDPACOTES)) as FATURAMENTO_PF,

CASE WHEN tab_vndTpCliente.QTD_PJ > 0  THEN 
((tab_vndTpCliente.QTD_PJ * (tab_b.FATURAMENTO / tab_pacotes.QTDPACOTES)) / tab_b.FATURAMENTO)
ELSE 0 END AS PERC_FATUR_PJ,

CASE WHEN tab_vndTpCliente.QTD_PF > 0  THEN 
((tab_vndTpCliente.QTD_PF * (tab_b.FATURAMENTO / tab_pacotes.QTDPACOTES)) / tab_b.FATURAMENTO)
ELSE 0 END AS PERC_FATUR_PF,

-- VALORES POR ATACADO / VAREJO
tab_vndTpCliente.QTDPACOTE_VAREJO as QTDPACOTE_VAREJO,
tab_vndTpCliente.QTDPACOTE_ATACADO as QTDPACOTE_ATACADO,

--QTD PACOTES EM CD/SD
tab_vndTpCliente.QTDPACOTE_SD AS QTDPACOTE_SD,
tab_vndTpCliente.QTDPACOTE_CD AS QTDPACOTE_CD,


total_pagto.PAGTO_A_VISTA,
total_pagto.PAGTO_A_PRAZO, 
total_pagto.PERC_PAGTO_VISTA,
total_pagto.PERC_PAGTO_PRAZO

FROM (
	
	
	--JUNÇÃO DE SD + CD - PEDIDOS
		SELECT 
	
			idEmpresa,
			SUM(FATURAMENTO) as FATURAMENTO, 
			SUM(FATURAMENTO_SD) as FATURAMENTO_SD,
			SUM(FATURAMENTO_CD) as FATURAMENTO_CD,
			SUM(QTDPED) as QTDPED, 
			SUM(QTDPED_SD) as QTDPED_SD,
			SUM(QTDPED_CD) as QTDPED_CD,
			
			DATA 
			
			FROM (

				SELECT 

					tab_a.idEmpresa,
					count(tab_a.idPedido) as QTDPED,
					sum(tab_a.total) as FATURAMENTO,

					CASE WHEN tipo = '9' THEN count(tab_a.idPedido) ELSE 0 END AS QTDPED_SD,
					CASE WHEN tipo = '0' THEN count(tab_a.idPedido) ELSE 0 END AS QTDPED_CD,

					CASE WHEN tipo = '9' THEN sum(tab_a.total) ELSE 0 END AS FATURAMENTO_SD,
					CASE WHEN tipo = '0' THEN sum(tab_a.total) ELSE 0 END AS FATURAMENTO_CD,

					tab_a.dataPedido as DATA
					FROM (

						-- PEDIDOS
						SELECT 
							ped.idPedido, 
							ped.tipo,
							ped.idEmpresa,
							cli.idCliente,
							CONVERT(DATE, CONCAT(
								SUBSTRING(ped.pedidoData, 1, 2), '/', 
								SUBSTRING(ped.pedidoData, 4, 2), '/', 
								SUBSTRING(ped.pedidoData, 7, 2)
							))as dataPedido,
							convert (FLOAT, REPLACE(REPLACE(ped.valor,'.',''),',','.')) as total
							FROM [dbo].[Pedidos] ped
								LEFT JOIN [dbo].[Clientes] cli 
									ON cli.idCliente = ped.idCliente

					) tab_a GROUP BY tab_a.dataPedido, tab_a.idEmpresa, tipo


			) tab_b 

			GROUP BY idEmpresa, DATA

		) tab_b

	LEFT JOIN (

		--QUANTIDADE DE PACOTES POR PEDIDO
		SELECT 

			idEmpresa,
			sum(tab_a.quantidade) as QTDPACOTES, 
			tab_a.dataPedido FROM (

			--PRODUTOS DO PEDIDO
			SELECT 
				ped.idEmpresa,
				pdp.quantidade,
				CONVERT(DATE, CONCAT(
					SUBSTRING(ped.pedidoData, 1, 2), '/', 
					SUBSTRING(ped.pedidoData, 4, 2), '/', 
					SUBSTRING(ped.pedidoData, 7, 2)
				))as dataPedido
		
					FROM [dbo].[Pedidos] ped
					LEFT JOIN [dbo].[PedidosProdutos] pdp
						ON pdp.idPedido = ped.idPedido

						)tab_a

				GROUP BY tab_a.idEmpresa, tab_a.dataPedido
	) tab_pacotes

		ON (tab_pacotes.dataPedido = tab_b.DATA AND tab_pacotes.idEmpresa = tab_b.idEmpresa)

	LEFT JOIN (
	
		--JUNÇÃO DE PF + PJ
		SELECT 
	
			idEmpresa,
			sum(QTDPACOTE_PJ) as QTD_PJ, 
			sum(QTDPACOTE_PF) as QTD_PF, 
			SUM(QTDPACOTE_VAREJO) as QTDPACOTE_VAREJO,
			SUM(QTDPACOTE_ATACADO) as QTDPACOTE_ATACADO,

			SUM(QTDPACOTE_SD) as QTDPACOTE_SD,
			SUM(QTDPACOTE_CD) as QTDPACOTE_CD,
			DATA 
			
			FROM (

			SELECT

				idEmpresa,
				tipo as TIPOCLIENTE,

				CASE WHEN tipo = 'PJ' THEN sum(quantidade) ELSE 0 END AS QTDPACOTE_PJ,
				CASE WHEN tipo = 'PF' THEN sum(quantidade) ELSE 0 END AS QTDPACOTE_PF,

				CASE WHEN qualificacao = 'V' THEN sum(quantidade) ELSE 0 END AS QTDPACOTE_VAREJO,
				CASE WHEN qualificacao = 'A' THEN sum(quantidade) ELSE 0 END AS QTDPACOTE_ATACADO,

				CASE WHEN tipoPedido = '9' THEN sum(quantidade) ELSE 0 END AS QTDPACOTE_SD,
				CASE WHEN tipoPedido = '0' THEN sum(quantidade) ELSE 0 END AS QTDPACOTE_CD,

				dataPedido as DATA
			FROM (

					SELECT 
							ped.idEmpresa,
							ped.tipo as tipoPedido,
							cli.tipo,
							cli.qualificacao,
							pdp.quantidade,
							convert (FLOAT, REPLACE(REPLACE(pdp.valorUnitario,'.',''),',','.')) as valorUnitario,
							convert (FLOAT, REPLACE(REPLACE(pdp.descontoPercentual,'.',''),',','.')) as descontoPercentual,
							CONVERT(DATE, CONCAT(
								SUBSTRING(ped.pedidoData, 1, 2), '/', 
								SUBSTRING(ped.pedidoData, 4, 2), '/', 
								SUBSTRING(ped.pedidoData, 7, 2)
							))as dataPedido,
							convert (FLOAT, REPLACE(REPLACE(ped.valor,'.',''),',','.')) as total
							FROM [dbo].[Pedidos] ped
								LEFT JOIN [dbo].[Clientes] cli 
									ON cli.idCliente = ped.idCliente
								LEFT JOIN [dbo].[PedidosProdutos] pdp
									ON pdp.idPedido = ped.idPedido
					

								) tab_tipoCli

						GROUP BY idEmpresa, dataPedido, tipo, qualificacao, tipoPedido

			)tab_grp

	GROUP BY idEmpresa, DATA
	
	)tab_vndTpCliente

		ON (tab_vndTpCliente.DATA = tab_b.DATA AND tab_vndTpCliente.idEmpresa = tab_b.idEmpresa)


	LEFT JOIN (

		-- TOTAL POR TIPO DE PAGAMENTO
			SELECT 

			idEmpresa,
			dataPedido,
			SUM(VISTA) as PAGTO_A_VISTA,
			SUM(PRAZO) as PAGTO_A_PRAZO, 

			(SUM(VISTA) + SUM(PRAZO)) as TOTAL_PAGTO,
			(SUM(VISTA) / (SUM(VISTA) + SUM(PRAZO))) as PERC_PAGTO_VISTA,
			(SUM(PRAZO) / (SUM(VISTA) + SUM(PRAZO))) as PERC_PAGTO_PRAZO

			FROM (
			SELECT 
			tab_ped.idEmpresa,
			tab_ped.dataPedido,
			CASE WHEN tab_ped.pagamento = 'DINHEIRO' THEN sum(tab_ped.total) ELSE 0 END AS VISTA,
			CASE WHEN (tab_ped.pagamento = 'FATURA' OR tab_ped.pagamento = 'CHEQUE') THEN sum(tab_ped.total) ELSE 0 END AS PRAZO

			FROM (
			-- PEDIDOS
						SELECT 
	
							ped.idEmpresa,
							ped.pagamento,
							cli.tipo,
							CONVERT(DATE, CONCAT(
								SUBSTRING(ped.pedidoData, 1, 2), '/', 
								SUBSTRING(ped.pedidoData, 4, 2), '/', 
								SUBSTRING(ped.pedidoData, 7, 2)
							))as dataPedido,
							convert (FLOAT, REPLACE(REPLACE(ped.valor,'.',''),',','.')) as total
							FROM [dbo].[Pedidos] ped
								LEFT JOIN [dbo].[Clientes] cli 
									ON cli.idCliente = ped.idCliente
			)tab_ped

				GROUP BY tab_ped.idEmpresa, tab_ped.dataPedido, tab_ped.pagamento

			)tab_pagto

			GROUP BY tab_pagto.idEmpresa, tab_pagto.dataPedido

		
	)total_pagto

		ON (total_pagto.dataPedido = tab_b.DATA and total_pagto.idEmpresa = tab_b.idEmpresa)


)tab_master

WHERE (tab_master.DATA BETWEEN '01/01/2020' AND '31/12/2022') AND tab_master.EMPRESA = '10'

order by tab_master.DATA

