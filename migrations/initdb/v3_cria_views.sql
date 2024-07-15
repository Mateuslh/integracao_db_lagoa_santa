CREATE OR REPLACE VIEW public.isscadastro
AS SELECT *
   from (SELECT codigo::varchar                                     AS INSCRICAO,
                contribuinte_codigo::varchar                        AS INSCRICAOCAD,
                contribuinte_tipopessoa                             AS TIPOEMPRESA,
                null                                                as NATUREZA,         -- da tabela de campo adicional( natureza)
                CASE
                    WHEN situacao = 'ATIVADO' THEN 'A'
                    WHEN situacao = 'INICIO' THEN 'A'
                    WHEN situacao = 'REINICIO' THEN 'A'
                    WHEN situacao = 'BAIXADO' THEN 'B'
                    WHEN situacao = 'SUSPENSO' THEN 'P'
                    WHEN situacao = 'CANCELADO' THEN 'B'
                    WHEN situacao = 'IRREGULAR' THEN 'L'
                    WHEN situacao = 'REGULAR' THEN 'A'
                    end                                             AS STATUS,
                nome                                                AS NOME,
                null::date                                          as DATAINSCRICAO,    -- da tabela de campo adicional( data inscrição)
                CASE
                    WHEN situacao = 'BAIXADO' then dtsituacao::date
                    end                                             AS DATAFECHAMENTO,
                CASE
                    WHEN regimeCobrancaIss = 'FIXO' then 'A'
                    WHEN regimecobrancaiss = 'ESTIMADO' then 'E'
                    WHEN regimecobrancaiss = 'HOMOLOGADO' then 'F'
                    WHEN regimecobrancaiss = 'SEM_COBRANCA' THEN 'I'
                    END                                             AS REGIMEISS,
                null::date                                          as VIGENCIAREGIMEISS,
                (select ec.atividade_cnae_codigo::bigint
                 from economico_cnae ec
                 where ec.id_economico = economico.id
                   and principal = 'SIM'
                 order by ec.id
                 limit 1)                                           as CODATIVIDADE,
                (select ec.atividade_cnae_descricao
                 from economico_cnae ec
                 where ec.id_economico = economico.id
                   and principal = 'SIM'
                 order by ec.id
                 limit 1)                                           as DESCATIVIDADE,    -- tem que ver
                null::float                                         as ALIQUOTA,         -- tem que ver
                null                                                as SUBATIVIDADE,     -- tem que ver
                null                                                as DESCSUBATIVIDADE, -- tem que ver
                null::float                                         as SUBALIQUOTA,      -- tem que ver
                nomefantasia                                        as NOM_FANTASIA,
                (select c.pessoajuridica_inscricaoestadual
                 from contribuinte as c
                 where c.id = economico.contribuinte_id
                   and c.pessoajuridica_inscricaoestadual != 'nan') as INS_ESTADUAL,
                contribuinte_cpfCnpj                                as CPF_CGC,
                logradouro                                          as ENDERECO,
                CASE
                    WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
                    ELSE regexp_replace(numero, '\D', '', 'g')::bigint
                    END                                             AS NUMCORRES,
                complemento                                         as COMPLEMENTO,
                bairro                                              as BAIRRO,
                cep::bigint                                         as CEP,
                municipio                                           as CIDADE,
                uf                                                  as ESTADO,
                null                                                as TELEFONE,
                null::float                                         as VALORESTIMADO,
                null::float                                         as VALORANUAL,
                null::float                                         as VALORSOCIEDADE,
                null::date                                          as DATAALTERACAO,    -- tem que ver
                logradouro                                          as ENDERECOCORRES,
                CASE
                    WHEN regexp_replace(numero, '\D', '', 'g') = '' THEN NULL
                    ELSE regexp_replace(numero, '\D', '', 'g')::bigint
                    END                                             as NUMERO,
                complemento                                         as COMPCORRES,
                bairro                                              as BAIRROCORRES,
                cep::bigint                                         as CEPCORRES,
                municipio                                           as CIDADECORRES,
                uf                                                  as ESTADOCORRES,
                null::bigint                                        as CONTADOR,
                null::text                                          as OBJETOSOCIAL,     -- campo adicional(objeto social)
                contribuinte_codigo                                 as CONTRIBUINTE,
                case
                    when contribuinte_tipopessoa = 'FISICA' then 'F'
                    when contribuinte_tipopessoa = 'JURIDICA' then 'J'
                    end                                             as TIPOCONT,
                contribuinte_email                                  as EMAIL,
                imovel_codigo::bigint                               as IMOVEL
         FROM economico) as sq
   where sq.CODATIVIDADE is not null;