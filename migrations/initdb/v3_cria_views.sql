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
    b.descatividade AS DESCATIVIDADE,  -- tem que ver
    b.aliquota::float AS ALIQUOTA,  -- tem que ver -- travado por melhoria, solicitar acesso aos campos adicionais da atividade via fonte ou api
    null AS SUBATIVIDADE,  -- tem que ver -- travado por melhoria, solicitar acesso aos campos adicionais da atividade via fonte ou api
    null AS DESCSUBATIVIDADE,  -- tem que ver -- travado por melhoria, solicitar acesso aos campos adicionais da atividade via fonte ou api
    null::float AS SUBALIQUOTA,  -- tem que ver -- travado por melhoria, solicitar acesso aos campos adicionais da atividade via fonte ou api
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
    dhultimaalteracao::date AS DATAALTERACAO,  -- tem que ver
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
    objeto_social::text AS OBJETOSOCIAL,  -- campo adicional (objeto social)
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
    a.principal,
    a.atividade_cnae_codigo    CNAE,
    a.atividade_cnae_descricao DESCATIVIDADE
    FROM economico_cnae a
    LEFT JOIN integracao_db_lagoa_santa.public.economico b ON a.id_economico = b.id

     ) as sq;

CREATE OR REPLACE VIEW public.ISSCADASTROATIVSEC
AS
SELECT *
FROM (
        SELECT
        codigo::varchar AS INSCRICAO,
        cod_atividade_servico as CODATIVIDADE,
        dhinicioatividade::date as INICIOATIVIDADE,
        null::date as FIMATIVIDADE,
        null::varchar as DESCATIVIDADE,
        b.aliquota::float as ALIQUOTA,
        null::varchar as SUBATIVIDADE,
        null::varchar as DESCSUBATIVIDADE,
        null::float as SUBALIQUOTA
        FROM economico
             left join aliquotas b on LPAD(SPLIT_PART(economico.cod_atividade_servico, '.', 1), 4, '0') = b.codigoatividade
     ) as sq
WHERE sq.CODATIVIDADE IS NOT NULL;

CREATE OR REPLACE VIEW public.ISSCADASTROSOCIOS
AS
SELECT
    e.codigo::varchar AS INSCRICAO,
    null::NUMERIC AS SEQUENCIASOCIO,
    null::varchar AS TIPOSOCIO,
    null::varchar AS NOMESOCIO,
    null::varchar AS DOCUMENTOSOCIO,
    null::varchar AS LOGRADOUROSOCIO,
    null::numeric AS NUMEROSOCIO,
    null::varchar AS COMPLEMENTOSOCIO,
    null::varchar AS BAIRROSOCIO,
    null::varchar AS CEPSOCIO,
    null::varchar AS CIDADESOCIO,
    null::varchar AS ESTADOSOCIO,
    null::varchar AS RGSOCIO,
    null::varchar AS CARGOSOCIO
FROM economico e;


CREATE OR REPLACE VIEW public.TRBMOBREGIMEISS
AS
SELECT *
FROM (
     select
     null::varchar AS INSCRICAO,
     null::varchar AS DATAINICIO,
     null::varchar AS REGIME,
     null::varchar AS JUSTIFICATIVA
     from economico e
     ) as sq;

CREATE OR REPLACE VIEW public.ISSDIVIDADOCUMENTOS
AS
SELECT *
FROM (
        select * from integracao_db_lagoa_santa.public.contribuinte

     ) as sq;

CREATE OR REPLACE VIEW public.ISSBAIXADOCUMENTOS
AS
SELECT *
FROM (
        select * from integracao_db_lagoa_santa.public.contribuinte

     ) as sq;

CREATE OR REPLACE VIEW public.ISSCANCELADOCUMENTOS
AS
SELECT *
FROM (
        select * from integracao_db_lagoa_santa.public.contribuinte

     ) as sq;