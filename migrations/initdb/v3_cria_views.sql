CREATE OR REPLACE VIEW public.ISSCADASTRO AS
SELECT * FROM (SELECT
    CAST(LPAD(a.codigo::VARCHAR, 6, '0') AS VARCHAR(6)) AS INSCRICAO, -- Código do Mobiliário
    CAST(d.inscricaoMunicipal::VARCHAR AS VARCHAR(20)) AS INSCRICAOCAD, -- Inscrição municipal do Mobiliário
    CAST(
        CASE
            WHEN contribuinte_tipopessoa = 'FISICA' THEN 'F'
            WHEN contribuinte_tipopessoa = 'JURIDICA' THEN 'J'
        END AS VARCHAR(1)
    ) AS TIPOEMPRESA, -- Tipo de Empresa (PJ ou PF)
    CAST(natureza AS VARCHAR(1)) AS NATUREZA, -- Natureza: P, E ou X
    CAST(
        CASE
            WHEN a.situacao IN ('ATIVADO', 'INICIO', 'REINICIO', 'REGULAR') THEN 'A'
            WHEN a.situacao = 'BAIXADO' THEN 'B'
            WHEN a.situacao = 'SUSPENSO' THEN 'P'
            WHEN a.situacao = 'CANCELADO' THEN 'B'
            WHEN a.situacao = 'IRREGULAR' THEN 'L'
        END AS VARCHAR(1)
    ) AS STATUS, -- Situação
    CAST(a.nome AS VARCHAR(254)) AS NOME, -- Nome do Mobiliário
    CAST(dhinicioatividade AS DATE) AS DATAINSCRICAO, -- Data de Inscrição
    CAST(
        CASE
            WHEN a.situacao = 'BAIXADO' THEN dtsituacao
        END AS DATE
    ) AS DATAFECHAMENTO, -- Data de Encerramento
    CAST(
        a.regimecobrancaiss AS VARCHAR(1)
    ) AS REGIMEISS, -- Regime ISS
    CAST(dhinicioatividade AS DATE) AS VIGENCIAREGIMEISS, -- Início vigência do Regime
    CAST(substring(LPAD(cod_atividade_servico, 4, '0') FROM 1 FOR 2) AS NUMERIC(22)) AS CODATIVIDADE, -- Código atividade principal
    CAST(c.descricao AS VARCHAR(254)) AS DESCATIVIDADE, -- Descrição Atividade Principal
    CAST(b.aliquota AS NUMERIC(22)) AS ALIQUOTA, -- Alíquota Atividade Principal
    CAST(substring(LPAD(cod_atividade_servico, 4, '0') FROM 3 FOR 4) AS VARCHAR(20)) AS SUBATIVIDADE, -- Código SubAtividade Principal
    CAST(b.descatividade AS VARCHAR(254)) AS DESCSUBATIVIDADE, -- Descrição SubAtividade Principal
    CAST(b.aliquota AS NUMERIC(22)) AS SUBALIQUOTA, -- Alíquota SubAtividade Principal
    CAST(nomefantasia AS VARCHAR(254)) AS NOM_FANTASIA, -- Nome Fantasia
    CAST(
        (
            SELECT c.pessoajuridica_inscricaoestadual
            FROM contribuinte c
            WHERE c.id = a.contribuinte_id
              AND c.pessoajuridica_inscricaoestadual != 'nan'
        ) AS VARCHAR(20)
    ) AS INS_ESTADUAL, -- Inscrição Estadual
    CAST(contribuinte_cpfCnpj AS VARCHAR(15)) AS CPF_CGC, -- Documento Mobiliário
    CAST(logradouro AS VARCHAR(266)) AS ENDERECO, -- Logradouro
    CAST(
        CASE
            WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
            ELSE regexp_replace(numero, '\D', '', 'g')::BIGINT
        END AS NUMERIC(22)
    ) AS NUMERO, -- Número Logradouro
    CAST(complemento AS VARCHAR(100)) AS COMPLEMENTO, -- Complemento Logradouro
    CAST(bairro AS VARCHAR(100)) AS BAIRRO, -- Bairro
    CAST(cep AS NUMERIC(22)) AS CEP, -- CEP
    CAST(municipio AS VARCHAR(100)) AS CIDADE, -- Cidade
    CAST(uf AS VARCHAR(30)) AS ESTADO, -- Estado
    CAST(telefone AS VARCHAR(200)) AS TELEFONE, -- Telefone
    CAST(NULL AS NUMERIC(22)) AS VALORESTIMADO, -- Valor Estimado informado
    CAST(NULL AS NUMERIC(22)) AS VALORANUAL, -- Valor Anual informado
    CAST(100 AS NUMERIC(22)) AS VALORSOCIEDADE, -- Valor Sociedade Informado
    CAST(dhultimaalteracao AS DATE) AS DATAALTERACAO, -- Data da Última Alteração
    CAST(logradouro AS VARCHAR(266)) AS ENDERECOCORRES, -- Logradouro Correspondência
    CAST(
        CASE
            WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
            ELSE regexp_replace(numero, '\D', '', 'g')::BIGINT
        END AS NUMERIC(22)
    ) AS NUMCORRES, -- Número Correspondência
    CAST(complemento AS VARCHAR(100)) AS COMPCORRES, -- Complemento Correspondência
    CAST(bairro AS VARCHAR(100)) AS BAIRROCORRES, -- Bairro Correspondência
    CAST(cep AS NUMERIC(22)) AS CEPCORRES, -- CEP Correspondência
    CAST(municipio AS VARCHAR(100)) AS CIDADECORRES, -- Cidade Correspondência
    CAST(uf AS VARCHAR(30)) AS ESTADOCORRES, -- Estado Correspondência
    CAST(idcontador AS NUMERIC(22)) AS CONTADOR, -- Contador informado no cadastro
    CAST(objeto_social AS VARCHAR(4000)) AS OBJETOSOCIAL, -- Objeto Social
    CAST(contribuinte_codigo AS NUMERIC(22)) AS CONTRIBUINTE, -- Código Contribuinte
    CAST(
        CASE
            WHEN contribuinte_tipopessoa = 'FISICA' THEN 'F'
            WHEN contribuinte_tipopessoa = 'JURIDICA' THEN 'J'
        END AS VARCHAR(1)
    ) AS TIPOCONT, -- Tipo do Contribuinte
    CAST(contribuinte_email AS VARCHAR(200)) AS EMAIL, -- Email informado
    CAST(imovel_codigo AS NUMERIC(22)) AS IMOVEL -- Código do Imóvel informado
FROM economico a
LEFT JOIN aliquotas b
    ON trim( leading '0' from a.cod_atividade_servico) = trim(leading '0' from b.codigoatividade)
left join atividade c
    on  CAST(substring(LPAD(cod_atividade_servico, 4, '0') FROM 1 FOR 2) AS NUMERIC(22)) = cast(c.atividade as numeric)
left join contribuinte d
    on a.contribuinte_codigo = d.codigo
)sq
WHERE sq.CODATIVIDADE IS NOT NULL;


CREATE OR REPLACE VIEW public.ISSCADASTROATIVCNAE AS
SELECT
    CAST(LPAD(codigo::VARCHAR, 6, '0') AS VARCHAR(6)) AS INSCRICAO,          -- Código do Mobiliário
    CAST(a.atividade_cnae_codigo AS VARCHAR(10)) AS CNAE, -- Código CNAE
    CAST(CASE
            WHEN a.principal = 'SIM' THEN 1
            ELSE 0
         END AS NUMERIC(22)) AS PRINCIPAL,              -- 0 - Não, 1 - Sim
    CAST(a.atividade_cnae_descricao AS VARCHAR(254)) AS DESCATIVIDADE, -- Descrição do CNAE
    CAST(NULL AS NUMERIC(22)) AS VERSAOCNAE             -- Versão do CNAE (sempre NULL)
FROM economico_cnae a
LEFT JOIN integracao_db_lagoa_santa.public.economico b
    ON a.id_economico = b.id;



CREATE OR REPLACE VIEW public.ISSCADASTROATIVSEC AS
SELECT
    CAST(LPAD(codigo_mobiliario::VARCHAR, 6, '0') AS VARCHAR(6)) AS INSCRICAO,          -- Código do Mobiliário
    CAST(substring(LPAD(cod_atividade_servico, 4, '0') FROM 1 FOR 2) AS NUMERIC(22)) AS CODATIVIDADE, -- Código da Atividade
    CAST(dhinicioatividade AS DATE) AS INICIOATIVIDADE,         -- Data Início da Atividade
    CAST(NULL AS DATE) AS FIMATIVIDADE,                         -- Data Fim da Atividade (sempre NULL)
    CAST(c.descricao AS VARCHAR(254)) AS DESCATIVIDADE,     -- Descrição da Atividade
    CAST(b.aliquota AS NUMERIC(22)) AS ALIQUOTA,                -- Alíquota da Atividade
    CAST(substring(LPAD(cod_atividade_servico, 4, '0') FROM 3 FOR 4) AS VARCHAR(20)) AS SUBATIVIDADE,                  -- Código SubAtividade (sempre NULL)
    CAST(b.descatividade AS VARCHAR(254)) AS DESCSUBATIVIDADE,             -- Descrição SubAtividade (sempre NULL)
    CAST(b.aliquota AS NUMERIC(22)) AS SUBALIQUOTA                    -- Alíquota SubAtividade (sempre NULL)
FROM economico_ativ_sec a
LEFT JOIN aliquotas b
    ON trim( leading '0' from a.cod_atividade_servico) = trim(leading '0' from b.codigoatividade)
left join atividade c
    on b.codigoatividade = c.atividade;

CREATE OR REPLACE VIEW public.ISSCADASTROSOCIOS AS
SELECT
    CAST(LPAD(codigomobiliario::VARCHAR, 6, '0') AS VARCHAR(6)) AS INSCRICAO,   -- Código do Mobiliário
    CAST(sequenciasocio AS NUMERIC(22)) AS SOCIO,       -- Sequência Sócio
    CAST(tipopessoasocio AS VARCHAR(1)) AS TIPOSOCIO,   -- Tipo Sócio (PF ou PJ)
    CAST(nomesocio AS VARCHAR(254)) AS NOME,            -- Nome Sócio
    CAST(cpfcnpjsocio AS VARCHAR(15)) AS CGCCPF,        -- Documento Sócio
    CAST(logradouro AS VARCHAR(254)) AS ENDERECO,       -- Logradouro Sócio
    CAST(
        CASE
            WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
            ELSE regexp_replace(numero, '\D', '', 'g')::BIGINT
        END AS NUMERIC(22)
    ) AS NUMERO,                                        -- Número Sócio
    CAST(complemento AS VARCHAR(100)) AS COMPLEMENTO,   -- Complemento Sócio
    CAST(bairro AS VARCHAR(100)) AS BAIRRO,            -- Bairro Sócio
    CAST(cep AS NUMERIC(22)) AS CEP,                   -- CEP Sócio
    CAST(cidade AS VARCHAR(100)) AS CIDADE,            -- Cidade Sócio
    CAST(estado AS VARCHAR(30)) AS ESTADO,             -- Estado Sócio
    CAST(rgsocio AS VARCHAR(30)) AS RG,                -- RG do Sócio
    CAST(NULL AS VARCHAR(254)) AS CARGO                -- Cargo do Sócio (sempre NULL)
FROM infosocios;

CREATE OR REPLACE VIEW public.TRBMOBREGIMEISS AS
SELECT
    CAST(LPAD(codigo_mobiliario::VARCHAR, 6, '0') AS VARCHAR(6))AS INSCRICAO,     -- Código Mobiliário
    CAST(dhinicio AS DATE) AS DATAINICIO,                  -- Data Início do Regime
    CAST(regime AS VARCHAR(1)) AS REGIME,                  -- Tipo de Regime
    CAST(NULL AS VARCHAR(254)) AS JUSTIFICATIVA            -- Justificativa (sempre NULL)
FROM regime_iss_historico;



CREATE OR REPLACE VIEW public.ISSBAIXADOCUMENTOS AS
SELECT
    CAST(c.ano_documento AS NUMERIC(22)) AS ANO_DOCUMENTO,   -- Ano de Geração da Guia
    CAST(c.num_documento AS NUMERIC(22)) AS NUM_DOCUMENTO,   -- Número da Guia
    CAST(a.valor_titulo AS NUMERIC(22)) AS VALOR_TITULO,     -- Valor do Título
    CAST(a.valorpago AS NUMERIC(22)) AS VALORPAGO,           -- Valor Pago
    CAST(a.data_pagamento AS DATE) AS DATA_PAGAMENTO,        -- Data do Pagamento
    CAST(c.tipo_tributo AS VARCHAR(15)) AS TRIBUTO,                  -- Sempre "I.S.S."
    CAST(a.valortotal AS NUMERIC(22)) AS VALORTOTAL,         -- Valor Total
    CAST(a.juros AS NUMERIC(22)) AS JUROS,                  -- Juros
    CAST(a.multas AS NUMERIC(22)) AS MULTAS,                -- Multas
    CAST(a.correcao AS NUMERIC(22)) AS CORRECAO,            -- Correção
    CAST(a.descontos AS NUMERIC(22)) AS DESCONTOS,          -- Desconto
    CAST(a.txexpediente AS NUMERIC(22)) AS TXEXPEDIENTE      -- Taxa de Expediente
FROM pagamentos a
LEFT JOIN lancamento b
    ON a.num_documento = b.id_gerado
LEFT JOIN guia_iss_govdigital c
    ON b.guia_iss_govdigital_id = c.id

UNION ALL
SELECT
    CAST(a.ano_documento AS NUMERIC(22)) AS ANO_DOCUMENTO,   -- Ano de Geração da Guia
    CAST(a.num_documento AS NUMERIC(22)) AS NUM_DOCUMENTO,   -- Número da Guia
    CAST(a.valor_titulo AS NUMERIC(22)) AS VALOR_TITULO,     -- Valor do Título
    CAST(a.valorpago AS NUMERIC(22)) AS VALORPAGO,           -- Valor Pago
    CAST(a.data_pagamento AS DATE) AS DATA_PAGAMENTO,        -- Data do Pagamento
    CAST('ISS' AS VARCHAR(15)) AS TRIBUTO,                  -- Sempre "I.S.S."
    CAST(a.valortotal AS NUMERIC(22)) AS VALORTOTAL,         -- Valor Total
    CAST(a.juros AS NUMERIC(22)) AS JUROS,                  -- Juros
    CAST(a.multas AS NUMERIC(22)) AS MULTAS,                -- Multas
    CAST(a.correcao AS NUMERIC(22)) AS CORRECAO,            -- Correção
    CAST(a.descontos AS NUMERIC(22)) AS DESCONTOS,          -- Desconto
    CAST(a.txexpediente AS NUMERIC(22)) AS TXEXPEDIENTE      -- Taxa de Expediente
FROM pagamentos_chumbados a
where  num_documento is not null

;


CREATE OR REPLACE VIEW public.ISSDIVIDADOCUMENTOS AS
SELECT
    CAST(c.ano_documento AS NUMERIC(22)) AS ANO_DOCUMENTO, -- Ano de Geração da Guia
    CAST(c.num_documento AS NUMERIC(22)) AS NUM_DOCUMENTO, -- Número da Guia
    CAST(a.situacao AS VARCHAR(3)) AS SITUACAO,            -- Situação do título
    CAST(NULL AS VARCHAR(81)) AS PARCELAMENTO,            -- Número do Parcelamento de Dívida Ativa (sempre NULL)
    CAST(CAST(LPAD(cod_cliente::VARCHAR, 6, '0') AS VARCHAR(6)) AS VARCHAR(20)) AS INSCRICAO,      -- Código do Mobiliário
    CAST(c.ano_competencia AS NUMERIC(22)) AS ANO_COMPETENCIA, -- Ano de competência do fato
    CAST(c.mes_competencia AS VARCHAR(10)) AS MES_COMPETENCIA -- Mês de competência do fato
FROM id_debito_inscrito a
LEFT JOIN lancamento b
    ON a.id = b.id_gerado
LEFT JOIN guia_iss_govdigital c
    ON b.guia_iss_govdigital_id = c.id;