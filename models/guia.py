from dataclasses import dataclass
from typing import Optional, Dict, Any, Tuple
from datetime import date


@dataclass
class Guia:
    cod_cliente: Optional[int]
    num_cadastro: Optional[int]
    num_documento: Optional[int]
    mes_competencia: Optional[int]
    ano_competencia: Optional[int]
    cod_barras: Optional[str]
    data_emissao: Optional[date]
    data_vencimento: Optional[date]
    data_pagavelate: Optional[date]
    valor_imposto: Optional[float]
    tipo_tributo: Optional[str]
    timestamp: Optional[date]
    idguia: Optional[int]
    correcao: Optional[float]
    juros: Optional[float]
    multa: Optional[float]
    tsa: Optional[float]
    total: Optional[float]
    ano_documento: Optional[int]
    papel: Optional[str]
    obs: Optional[str]
    grp_processado: Optional[int]
    enviado: bool = False

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'Guia':
        return Guia(
            cod_cliente=int(data.get('cod_cliente')) if data.get('cod_cliente') is not None else None,
            num_cadastro=int(data.get('num_cadastro')) if data.get('num_cadastro') is not None else None,
            num_documento=int(data.get('num_documento')) if data.get('num_documento') is not None else None,
            mes_competencia=int(data.get('mes_competencia')) if data.get('mes_competencia') is not None else None,
            ano_competencia=int(data.get('ano_competencia')) if data.get('ano_competencia') is not None else None,
            cod_barras=data.get('cod_barras'),
            data_emissao=data.get('data_emissao'),
            data_vencimento=data.get('data_vencimento'),
            data_pagavelate=data.get('data_pagavelate'),
            valor_imposto=float(data.get('valor_imposto')) if data.get('valor_imposto') is not None else None,
            tipo_tributo=data.get('tipo_tributo'),
            timestamp=data.get('timestamp'),
            idguia=int(data.get('idguia')) if data.get('idguia') is not None else None,
            correcao=float(data.get('correcao')) if data.get('correcao') is not None else None,
            juros=float(data.get('juros')) if data.get('juros') is not None else None,
            multa=float(data.get('multa')) if data.get('multa') is not None else None,
            tsa=float(data.get('tsa')) if data.get('tsa') is not None else None,
            total=float(data.get('total')) if data.get('total') is not None else None,
            ano_documento=int(data.get('ano_documento')) if data.get('ano_documento') is not None else None,
            papel=data.get('papel'),
            obs=data.get('obs'),
            grp_processado=int(data.get('grp_processado')) if data.get('grp_processado') is not None else None,
            enviado=bool(data.get('enviado')) if data.get('enviado') is not None else False
        )

    @staticmethod
    def from_row(row: Tuple) -> 'Guia':
        return Guia(
            cod_cliente=int(row[0]) if row[0] is not None else None,
            num_cadastro=int(row[1]) if row[1] is not None else None,
            num_documento=int(row[2]) if row[2] is not None else None,
            mes_competencia=int(row[3]) if row[3] is not None else None,
            ano_competencia=int(row[4]) if row[4] is not None else None,
            cod_barras=row[5],
            data_emissao=row[6],
            data_vencimento=row[7],
            data_pagavelate=row[8],
            valor_imposto=float(row[9]) if row[9] is not None else None,
            tipo_tributo=row[10],
            timestamp=row[11],
            idguia=int(row[12]) if row[12] is not None else None,
            correcao=float(row[13]) if row[13] is not None else None,
            juros=float(row[14]) if row[14] is not None else None,
            multa=float(row[15]) if row[15] is not None else None,
            tsa=float(row[16]) if row[16] is not None else None,
            total=float(row[17]) if row[17] is not None else None,
            ano_documento=int(row[18]) if row[18] is not None else None,
            papel=row[19],
            obs=row[20],
            grp_processado=int(row[21]) if row[21] is not None else None,
            enviado=row[22] if row[22] is not None else False
        )
