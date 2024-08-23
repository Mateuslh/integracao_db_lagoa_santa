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
        ('ERRO_DOWNLOAD'::character varying)::text,
        ('SINCRONIZANDO'::character varying)::text,
        ('AGUARDANDO_SINC_DB'::character varying)::text,
        ('INSERIDO'::character varying)::text,
        ('AGUARDANDO_EXTRACAO'::character varying)::text,
        ('IGNORAR'::character varying)::text
        ]))
);

CREATE INDEX protocolo_protocolo_id_idx ON public.protocolo USING btree (protocolo_id);

CREATE TABLE IF NOT EXISTS public.economico_cnae
(
    id                       SERIAL PRIMARY KEY,
    id_economico             BIGINT,
    principal                VARCHAR CHECK (principal IN ('SIM', 'NAO')),
    atividade_cnae_codigo    VARCHAR,
    atividade_cnae_descricao VARCHAR
);

CREATE INDEX protocolo_id_economico_idx ON public.economico_cnae USING btree (id_economico);

CREATE TABLE IF NOT EXISTS public.economico
(
    imovel_id               BIGINT,
    imovel_codigo           BIGINT,
    contribuinte_id         BIGINT,
    contribuinte_codigo     BIGINT,
    contribuinte_cpfCnpj    VARCHAR(255),
    contribuinte_tipoPessoa VARCHAR(255),
    contribuinte_email      VARCHAR(255),
    id                      BIGINT PRIMARY KEY,
    enderecoFormatado       VARCHAR(255),
    municipio               VARCHAR(255),
    uf                      VARCHAR(255),
    logradouro              VARCHAR(255),
    bairro                  VARCHAR(255),
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

CREATE TABLE guia_iss_govdigital
(
    id              SERIAL PRIMARY KEY,
    cod_cliente     numeric(6)            NOT NULL,
    num_cadastro    numeric(10)           NULL,
    num_documento   numeric(76, 38)       NOT NULL,
    mes_competencia numeric(2)            NOT NULL,
    ano_competencia numeric(4)            NOT NULL,
    cod_barras      varchar(60)           NULL,
    data_emissao    timestamp             NULL,
    data_vencimento timestamp             NULL,
    data_pagavelate timestamp             NULL,
    valor_imposto   numeric(16, 2)        NULL,
    tipo_tributo    varchar(60)           NULL,
    "timestamp"     timestamp             NOT NULL,
    idguia          numeric(12)           NULL,
    correcao        numeric(16, 2)        NULL,
    juros           numeric(16, 2)        NULL,
    multa           numeric(16, 2)        NULL,
    tsa             numeric(16, 2)        NULL,
    total           numeric(16, 2)        NULL,
    ano_documento   numeric(4)            NOT NULL,
    papel           varchar(10)           NULL,
    obs             varchar(4000)         NULL,
    grp_processado  numeric(1)            NOT NULL,
    numero_boleto   numeric(20)           NULL,
    convenio        numeric(76, 38)       NULL,
    nota_avulsa     numeric(1)            NULL,
    contribuinte    numeric(10)           NULL,
    tipocont        varchar(1)            NULL,
    enviado         BOOLEAN DEFAULT FALSE NOT NULL
);



CREATE INDEX idx_guia_iss_govdigital_enviado
    ON public.guia_iss_govdigital (enviado);


CREATE TABLE IF NOT EXISTS public.contribuinte
(
    pessoaJuridica_inscricaoEstadual VARCHAR(255),
    pessoaJuridica_id                NUMERIC,
    pessoaFisica_id                  NUMERIC,
    id                               NUMERIC PRIMARY KEY,
    codigo                           NUMERIC,
    nome                             VARCHAR(255),
    cpfCnpj                          VARCHAR(255),
    situacao                         VARCHAR(255),
    tipoPessoa                       VARCHAR(255)
);

CREATE TABLE guia_iss_govdigital_canc
(
    num_cadastro    numeric(10)     NOT NULL,
    num_documento   numeric(76, 38) NOT NULL,
    ano_documento   numeric(4)      NOT NULL,
    descricao       varchar(4000)   NULL,
    data_descarte   timestamp       NULL,
    data_migracao   timestamp       NULL DEFAULT now(),
    data_pagavelate timestamp       NULL,
    idguia          numeric(12)     NOT NULL,
    grp_processado  numeric(1)      NOT NULL,
    numero_boleto   numeric(20)     NULL,
    convenio        numeric(76, 38) NULL,
    papel           varchar(10)     NULL,
    contribuinte    numeric(10)     NULL,
    tipocont        varchar(1)      NULL
);


CREATE TABLE encerramento_govdigital
(
    encerramento_id     numeric(22)    NOT NULL,
    num_cadastro        numeric(10)    NOT NULL,
    ano_competencia     numeric(22)    NOT NULL,
    mes_competencia     numeric(22)    NOT NULL,
    tipo                numeric(3)     NOT NULL,
    papel               varchar(10)    NULL,
    data_encerramento   timestamp      NOT NULL,
    cancelado           numeric(1)     NOT NULL DEFAULT 0,
    data_cancelamento   timestamp      NULL,
    motivo_cancelamento varchar(800)   NULL,
    grp_processado      numeric(1)     NOT NULL,
    "timestamp"         timestamp      NOT NULL,
    total_imposto       numeric(19, 5) NULL,
    total_faturado      numeric(19, 5) NULL
);

CREATE TABLE lancamento (
    id SERIAL PRIMARY KEY NOT NULL,
    guia_iss_govdigital_id INTEGER NOT NULL,
    situacao VARCHAR(16) NOT NULL,
    id_gerado NUMERIC,
    nro_baixa numeric,
    json_retorno json,
    json_enviado json,
    FOREIGN KEY (guia_iss_govdigital_id) REFERENCES guia_iss_govdigital(id)
);

drop table lancamento