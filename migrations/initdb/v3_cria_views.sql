create or replace view  ISSCADASTRO as
SELECT codigo                  AS INSCRICAO,
                      contribuinte_codigo     AS INSCRICAOCAD,
                      contribuinte_tipopessoa AS TIPOEMPRESA,
                      null                    as NATUREZA,         -- da tabela de campo adicional( natureza)
                      CASE
                          WHEN situacao = 'ATIVADO' THEN 'A'
                          WHEN situacao = 'INICIO' THEN 'A'
                          WHEN situacao = 'REINICIO' THEN 'A'
                          WHEN situacao = 'BAIXADO' THEN 'B'
                          WHEN situacao = 'SUSPENSO' THEN 'P'
                          WHEN situacao = 'CANCELADO' THEN 'B'
                          WHEN situacao = 'IRREGULAR' THEN 'L'
                          WHEN situacao = 'REGULAR' THEN 'A'
                          end                 AS STATUS,
                      nome                    AS NOME,
                      null                    as DATAINSCRICAO,    -- da tabela de campo adicional( data inscrição)
                      CASE
                          WHEN situacao = 'BAIXADO' then dtsituacao
                          end                 AS DATAFECHAMENTO,
                      CASE
                          WHEN regimeCobrancaIss = 'FIXO' then 'A'
                          WHEN regimecobrancaiss = 'ESTIMADO' then 'E'
                          WHEN regimecobrancaiss = 'HOMOLOGADO' then 'F'
                          WHEN regimecobrancaiss = 'SEM_COBRANCA' THEN 'I'
                          END                 AS REGIMEISS,
                      null                    as VIGENCIAREGIMEISS,
                      null                    as CODATIVIDADE,     -- tem que ver
                      null                    as DESCATIVIDADE,    -- tem que ver
                      null                    as ALIQUOTA,         -- tem que ver
                      null                    as SUBATIVIDADE,     -- tem que ver
                      null                    as DESCSUBATIVIDADE, -- tem que ver
                      null                    as SUBALIQUOTA,      -- tem que ver
                      nomefantasia            as NOM_FANTASIA,
                      (select c.pessoajuridica_inscricaoestadual
                       from contribuinte as c
                       where c.id = economico.contribuinte_id and
                           c.pessoajuridica_inscricaoestadual != 'nan') as INS_ESTADUAL,
                      contribuinte_cpfCnpj    as CPF_CGC,
                      logradouro              as ENDERECO,
                      numero                  as NUMCORRES,
                      complemento             as COMPLEMENTO,
                      bairro                  as BAIRRO,
                      cep                     as CEP,
                      municipio               as CIDADE,
                      uf                      as ESTADO,
                      null                    as TELEFONE,
                      null                    as VALORESTIMADO,
                      null                    as VALORANUAL,
                      null                    as VALORSOCIEDADE,
                      null                    as DATAALTERACAO,    -- tem que ver
                      logradouro              as ENDERECOCORRES,
                      numero                  as NUMERO,
                      complemento             as COMPCORRES,
                      bairro                  as BAIRROCORRES,
                      cep                     as CEPCORRES,
                      municipio               as CIDADECORRES,
                      uf                      as ESTADOCORRES,
                      null                    as CONTADOR,
                      null                    as OBJETOSOCIAL,     -- campo adicional(objeto social)
                      contribuinte_codigo     as CONTRIBUINTE,
                      case
                          when contribuinte_tipopessoa = 'FISICA' then 'F'
                          when contribuinte_tipopessoa = 'JURIDICA' then 'J'
                          end                 as TIPOCONT,
                      contribuinte_email      as EMAIL,
                      imovel_codigo           as IMOVEL
               FROM economico;