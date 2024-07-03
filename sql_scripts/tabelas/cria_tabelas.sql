CREATE TABLE IF NOT EXISTS public.protocolo
(
    id            SERIAL PRIMARY KEY,
    protocolo_id  VARCHAR NOT NULL,
    situacao      VARCHAR NOT NULL,
    script_id     INT4    NOT NULL,
    tipo_execucao VARCHAR NOT NULL,
    dhExecucao    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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


CREATE TABLE IF NOT EXISTS economico_cnae
(
    id                       SERIAL PRIMARY KEY,
    id_economico             BIGINT,
    principal                VARCHAR CHECK (principal IN ('SIM', 'NAO')),
    atividade_cnae_codigo    VARCHAR,
    atividade_cnae_descricao VARCHAR
);
CREATE INDEX protocolo_id_economico_idx ON public.economico_cnae USING btree (id_economico);

drop table economico;

CREATE TABLE IF NOT EXISTS economico
(
    imovel_id               BIGINT,
    imovel_codigo           BIGINT,
    contribuinte_id         BIGINT,
    contribuinte_codigo     BIGINT,
    contribuinte_cpfCnpj    varchar(255),
    contribuinte_tipoPessoa VARCHAR(255),
    contribuinte_email      varchar(255),
    id                      BIGINT PRIMARY KEY,
    enderecoFormatado       VARCHAR(255),
    municipio               varchar(255),
    uf                      varchar,
    logradouro              VARCHAR(255),
    bairro                  varchar(255),
    codigo                  BIGINT,
    situacao                VARCHAR(255),
    dtSituacao              DATE,
    nome                    VARCHAR(255),
    nomeFantasia            VARCHAR(255),
    apartamento             VARCHAR(255),
    bloco                   VARCHAR(255),
    cep                     VARCHAR(255),
    complemento             VARCHAR(255),
    numero                  VARCHAR(255),
    regimeCobrancaIss       VARCHAR(255),
    idContador              BIGINT,
    principal               VARCHAR(255),
    dhInicioAtividade       TIMESTAMP
);

CREATE TABLE if not exists guia_iss_govdigital
(
    cod_cliente     NUMERIC(22),
    num_cadastro    NUMERIC(22),
    num_documento   NUMERIC(22),
    mes_competencia NUMERIC(22),
    ano_competencia NUMERIC(22),
    cod_barras      VARCHAR(60),
    data_emissao    DATE,
    data_vencimento DATE,
    data_pagavelate DATE,
    valor_imposto   NUMERIC(22),
    tipo_tributo    VARCHAR(60),
    timestamp       DATE,
    idguia          NUMERIC(22),
    correcao        NUMERIC(22),
    juros           NUMERIC(22),
    multa           NUMERIC(22),
    tsa             NUMERIC(22),
    total           NUMERIC(22),
    ano_documento   NUMERIC(22),
    papel           VARCHAR(10),
    obs             VARCHAR(4000),
    grp_processado  NUMERIC(22)
);


