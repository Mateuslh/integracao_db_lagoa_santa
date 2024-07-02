CREATE TABLE IF NOT EXISTS public.protocolo
(
    id           SERIAL PRIMARY KEY,
    protocolo_id VARCHAR NOT NULL,
    situacao     VARCHAR NOT NULL,
    script_id    INT4    NOT NULL,
    tipo_execucao VARCHAR NOT NULL,
    dhExecucao   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT situacao_check CHECK (situacao::text = ANY (ARRAY [
        ('AGUARDANDO_DOWNLOAD'::character varying)::text,
        ('ERRO_INSERCAO'::character varying)::text,
        ('SINCRONIZANDO'::character varying)::text,
        ('AGUARDANDO_SINC_DB'::character varying)::text,
        ('INSERIDO'::character varying)::text,
        ('AGUARDANDO_EXTRACAO'::character varying)::text,
        ('IGNORAR'::character varying)::text
        ]))
);


CREATE INDEX protocolo_protocolo_id_idx ON public.protocolo USING btree (protocolo_id);


CREATE TABLE IF NOT EXISTS economico_cnae (id SERIAL PRIMARY KEY,
                             id_economico BIGINT,
                             principal VARCHAR CHECK (principal IN ('SIM', 'NAO')),
                             atividade_cnae_codigo VARCHAR,
                             atividade_cnae_descricao VARCHAR
);
CREATE INDEX protocolo_id_economico_idx ON public.economico_cnae USING btree (id_economico);

drop table economico;

CREATE TABLE IF NOT EXISTS economico (
                           imovel_id BIGINT,
                           imovel_codigo BIGINT,
                           contribuinte_id BIGINT,
                           contribuinte_codigo BIGINT,
                           contribuinte_cpfCnpj varchar(255),
                           contribuinte_tipoPessoa VARCHAR(255),
                           contribuinte_email varchar(255),
                           id BIGINT PRIMARY KEY,
                           enderecoFormatado VARCHAR(255),
                           municipio varchar(255),
                           uf varchar,
                           logradouro VARCHAR(255),
                           bairro varchar(255),
                           codigo BIGINT,
                           situacao VARCHAR(255),
                           dtSituacao DATE,
                           nome VARCHAR(255),
                           nomeFantasia VARCHAR(255),
                           apartamento VARCHAR(255),
                           bloco VARCHAR(255),
                           cep VARCHAR(255),
                           complemento VARCHAR(255),
                           numero VARCHAR(255),
                           regimeCobrancaIss VARCHAR(255),
                           idContador BIGINT,
                           principal VARCHAR(255),
                           dhInicioAtividade TIMESTAMP
);

CREATE TABLE if not exists guia_iss_govdigital (
                                     cod_cliente NUMERIC(22),
                                     num_cadastro NUMERIC(22),
                                     num_documento NUMERIC(22),
                                     mes_competencia NUMERIC(22),
                                     ano_competencia NUMERIC(22),
                                     cod_barras VARCHAR(60),
                                     data_emissao DATE,
                                     data_vencimento DATE,
                                     data_pagavelate DATE,
                                     valor_imposto NUMERIC(22),
                                     tipo_tributo VARCHAR(60),
                                     timestamp DATE,
                                     idguia NUMERIC(22),
                                     correcao NUMERIC(22),
                                     juros NUMERIC(22),
                                     multa NUMERIC(22),
                                     tsa NUMERIC(22),
                                     total NUMERIC(22),
                                     ano_documento NUMERIC(22),
                                     papel VARCHAR(10),
                                     obs VARCHAR(4000),
                                     grp_processado NUMERIC(22)
);


CREATE TABLE IF NOT EXISTS ISSCADASTRO (
                             INSCRICAO VARCHAR(6),
                             INSCRICAOCAD VARCHAR(20),
                             TIPOEMPRESA CHAR(1),
                             NATUREZA CHAR(1),
                             STATUS CHAR(1),
                             NOME VARCHAR(254),
                             DATAINSCRICAO DATE,
                             DATAFECHAMENTO DATE,
                             REGIMEISS CHAR(1),
                             VIGENCIAREGIMEISS DATE,
                             CODATIVIDADE NUMERIC(22),
                             DESCATIVIDADE VARCHAR(254),
                             ALIQUOTA NUMERIC(22,2),
                             SUBATIVIDADE VARCHAR(20),
                             DESCSUBATIVIDADE VARCHAR(254),
                             SUBALIQUOTA NUMERIC(22,2),
                             NOM_FANTASIA VARCHAR(254),
                             INS_ESTADUAL VARCHAR(20),
                             CPF_CGC VARCHAR(15),
                             ENDERECO VARCHAR(266),
                             NUMERO NUMERIC(22),
                             COMPLEMENTO VARCHAR(100),
                             BAIRRO VARCHAR(100),
                             CEP NUMERIC(22),
                             CIDADE VARCHAR(100),
                             ESTADO VARCHAR(30),
                             TELEFONE VARCHAR(200),
                             VALORESTIMADO NUMERIC(22,2),
                             VALORANUAL NUMERIC(22,2),
                             VALORSOCIEDADE NUMERIC(22,2),
                             DATAALTERACAO DATE,
                             ENDERECOCORRES VARCHAR(266),
                             NUMCORRES NUMERIC(22),
                             COMPCORRES VARCHAR(100),
                             BAIRROCORRES VARCHAR(100),
                             CEPCORRES NUMERIC(22),
                             CIDADECORRES VARCHAR(100),
                             ESTADOCORRES VARCHAR(30),
                             CONTADOR NUMERIC(22),
                             OBJETOSOCIAL VARCHAR(4000),
                             CONTRIBUINTE NUMERIC(22),
                             TIPOCONT CHAR(1),
                             EMAIL VARCHAR(200),
                             IMOVEL NUMERIC(22)
);