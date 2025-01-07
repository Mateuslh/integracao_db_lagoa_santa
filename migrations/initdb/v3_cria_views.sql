CREATE OR REPLACE VIEW public.isscadastro
AS
SELECT *
FROM (
SELECT
    codigo::varchar AS INSCRICAO,
    contribuinte_codigo::varchar AS INSCRICAOCAD,
    contribuinte_tipopessoa AS TIPOEMPRESA,
    natureza AS NATUREZA,  -- da tabela de campo adicional (natureza)
    CASE
        WHEN situacao = 'ATIVADO' THEN 'A'
        WHEN situacao = 'INICIO' THEN 'A'
        WHEN situacao = 'REINICIO' THEN 'A'
        WHEN situacao = 'BAIXADO' THEN 'B'
        WHEN situacao = 'SUSPENSO' THEN 'P'
        WHEN situacao = 'CANCELADO' THEN 'B'
        WHEN situacao = 'IRREGULAR' THEN 'L'
        WHEN situacao = 'REGULAR' THEN 'A'
        END AS STATUS,
    nome AS NOME,
    dhinicioatividade::date AS DATAINSCRICAO,  -- da tabela de campo adicional (data inscrição)
    CASE
        WHEN situacao = 'BAIXADO' THEN dtsituacao::date
        END AS DATAFECHAMENTO,
    CASE
        WHEN regimeCobrancaIss = 'FIXO' THEN 'A'
        WHEN regimecobrancaiss = 'ESTIMADO' THEN 'E'
        WHEN regimecobrancaiss = 'HOMOLOGADO' THEN 'F'
        WHEN regimecobrancaiss = 'SEM_COBRANCA' THEN 'I'
        END AS REGIMEISS,
    dhinicioatividade::date AS VIGENCIAREGIMEISS,
    LPAD(SPLIT_PART(cod_atividade_servico, '.', 1), 4, '0') AS CODATIVIDADE,
    b.descatividade AS DESCATIVIDADE,
    b.aliquota::float AS ALIQUOTA,
    null AS SUBATIVIDADE,
    null AS DESCSUBATIVIDADE,
    null::float AS SUBALIQUOTA,
    nomefantasia AS NOM_FANTASIA,
    (
        SELECT c.pessoajuridica_inscricaoestadual
        FROM contribuinte c
        WHERE c.id = economico.contribuinte_id
          AND c.pessoajuridica_inscricaoestadual != 'nan'
    ) AS INS_ESTADUAL,
    contribuinte_cpfCnpj AS CPF_CGC,
    logradouro AS ENDERECO,
    CASE
        WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
        ELSE regexp_replace(numero, '\D', '', 'g')::bigint
        END AS NUMCORRES,
    complemento AS COMPLEMENTO,
    bairro AS BAIRRO,
    CAST(split_part(cep, '.', 1) AS bigint) AS CEP,
    municipio AS CIDADE,
    uf AS ESTADO,
    telefone AS TELEFONE,
    null::float AS VALORESTIMADO,
    null::float AS VALORANUAL,
    100::float AS VALORSOCIEDADE,
    dhultimaalteracao::date AS DATAALTERACAO,
    logradouro AS ENDERECOCORRES,
    CASE
        WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
        ELSE regexp_replace(numero, '\D', '', 'g')::bigint
        END AS NUMERO,
    complemento AS COMPCORRES,
    bairro AS BAIRROCORRES,
    CAST(split_part(cep, '.', 1) AS bigint) AS CEPCORRES,
    municipio AS CIDADECORRES,
    uf AS ESTADOCORRES,
    idcontador::bigint AS CONTADOR,
    objeto_social::text AS OBJETOSOCIAL,
    contribuinte_codigo AS CONTRIBUINTE,
    CASE
        WHEN contribuinte_tipopessoa = 'FISICA' THEN 'F'
        WHEN contribuinte_tipopessoa = 'JURIDICA' THEN 'J'
        END AS TIPOCONT,
    contribuinte_email AS EMAIL,
    imovel_codigo::bigint AS IMOVEL
FROM economico
         left join aliquotas b on LPAD(SPLIT_PART(economico.cod_atividade_servico, '.', 1), 4, '0') = b.codigoatividade
) AS sq
WHERE sq.CODATIVIDADE IS NOT NULL;


CREATE OR REPLACE VIEW public.isscadastroativcnae
AS
SELECT *
FROM (
    SELECT
    b.codigo INSCRICAO,
    a.atividade_cnae_codigo    CNAE,
    case when a.principal = 'SIM' then 1 else 0 end as principal,
    a.atividade_cnae_descricao DESCATIVIDADE,
    null VERSAOCNAE
    FROM economico_cnae a
    LEFT JOIN integracao_db_lagoa_santa.public.economico b ON a.id_economico = b.id

     ) as sq;

CREATE OR REPLACE VIEW public.ISSCADASTROATIVSEC
AS
SELECT *
FROM (
        SELECT
        codigo_mobiliario::varchar AS INSCRICAO,
        cod_atividade_servico as CODATIVIDADE,
        dhinicioatividade::date as INICIOATIVIDADE,
        null::date as FIMATIVIDADE,
        b.descatividade::varchar as DESCATIVIDADE,
        b.aliquota::float as ALIQUOTA,
        null::varchar as SUBATIVIDADE,
        null::varchar as DESCSUBATIVIDADE,
        null::float as SUBALIQUOTA
        FROM economico_ativ_sec
             left join aliquotas b on LPAD(SPLIT_PART(economico_ativ_sec.cod_atividade_servico, '.', 1), 4, '0') = b.codigoatividade
     ) as sq
WHERE sq.CODATIVIDADE IS NOT NULL;

CREATE OR REPLACE VIEW public.ISSCADASTROSOCIOS
AS
SELECT
    codigomobiliario::varchar AS INSCRICAO,
    sequenciasocio::varchar AS SOCIO,
    tipopessoasocio AS TIPOSOCIO,
    nomesocio as NOME,
    cpfcnpjsocio as CGCCPF,
    logradouro as ENDERECO,
    numero as NUMERO,
    complemento::varchar as COMPLEMENTO,
    bairro as BAIRRO,
    cep::varchar as CEP,
    cidade as CIDADE,
    estado as ESTADO,
    rgsocio as RG,
    null::varchar as CARGO
    FROM infosocios;

CREATE OR REPLACE VIEW public.TRBMOBREGIMEISS
AS
SELECT *
FROM (
     select
     codigo_mobiliario::varchar AS INSCRICAO,
     dhinicio::varchar AS DATAINICIO,
     regime::varchar AS REGIME,
     null::varchar AS JUSTIFICATIVA
     from regime_iss_historico e
     ) as sq;


CREATE OR REPLACE VIEW public.ISSBAIXADOCUMENTOS
AS
SELECT *
FROM (
        select
        c.ano_documento,
        c.num_documento as num_documento,
        a.valor_titulo,
        a.valorpago,
        a.data_pagamento,
        'ISS' as TRIBUTO,
        a.valortotal,
        a.juros,
        a.multas,
        a.correcao,
        a.descontos,
        a.txexpediente

            from pagamentos a
            left join lancamento b
                on a.num_documento = b.id_gerado
            left join guia_iss_govdigital c
                on b.guia_iss_govdigital_id = c.id


     ) as sq;

CREATE OR REPLACE VIEW public.ISSDIVIDADOCUMENTOS
AS
SELECT *
FROM (
        select
        c.ano_documento,
        c.num_documento,
        a.situacao,
        null as PARCELAMENTO,
        c.cod_cliente as INSCRICAO,
        c.ano_competencia,
        c.mes_competencia

            from id_debito_inscrito a
            left join lancamento b
                on a.id = b.id_gerado
            left join guia_iss_govdigital c
                on b.guia_iss_govdigital_id = c.id
     ) as sq;