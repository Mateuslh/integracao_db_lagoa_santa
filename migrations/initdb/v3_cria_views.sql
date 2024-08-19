CREATE OR REPLACE VIEW public.isscadastro
AS
SELECT *
FROM (
    SELECT
        codigo::varchar AS INSCRICAO,
        contribuinte_codigo::varchar AS INSCRICAOCAD,
        contribuinte_tipopessoa AS TIPOEMPRESA,
        null AS NATUREZA,  -- da tabela de campo adicional (natureza)
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
        null::date AS DATAINSCRICAO,  -- da tabela de campo adicional (data inscrição)
        CASE
            WHEN situacao = 'BAIXADO' THEN dtsituacao::date
        END AS DATAFECHAMENTO,
        CASE
            WHEN regimeCobrancaIss = 'FIXO' THEN 'A'
            WHEN regimecobrancaiss = 'ESTIMADO' THEN 'E'
            WHEN regimecobrancaiss = 'HOMOLOGADO' THEN 'F'
            WHEN regimecobrancaiss = 'SEM_COBRANCA' THEN 'I'
        END AS REGIMEISS,
        null::date AS VIGENCIAREGIMEISS,
        (
            SELECT ec.atividade_cnae_codigo::bigint
            FROM economico_cnae ec
            WHERE ec.id_economico = economico.id
              AND principal = 'SIM'
            ORDER BY ec.id
            LIMIT 1
        ) AS CODATIVIDADE,
        (
            SELECT ec.atividade_cnae_descricao
            FROM economico_cnae ec
            WHERE ec.id_economico = economico.id
              AND principal = 'SIM'
            ORDER BY ec.id
            LIMIT 1
        ) AS DESCATIVIDADE,  -- tem que ver
        null::float AS ALIQUOTA,  -- tem que ver
        null AS SUBATIVIDADE,  -- tem que ver
        null AS DESCSUBATIVIDADE,  -- tem que ver
        null::float AS SUBALIQUOTA,  -- tem que ver
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
        null AS TELEFONE,
        null::float AS VALORESTIMADO,
        null::float AS VALORANUAL,
        null::float AS VALORSOCIEDADE,
        null::date AS DATAALTERACAO,  -- tem que ver
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
        null::bigint AS CONTADOR,
        null::text AS OBJETOSOCIAL,  -- campo adicional (objeto social)
        contribuinte_codigo AS CONTRIBUINTE,
        CASE
            WHEN contribuinte_tipopessoa = 'FISICA' THEN 'F'
            WHEN contribuinte_tipopessoa = 'JURIDICA' THEN 'J'
        END AS TIPOCONT,
        contribuinte_email AS EMAIL,
        imovel_codigo::bigint AS IMOVEL
        FROM economico
) AS sq
WHERE sq.CODATIVIDADE IS NOT NULL;
