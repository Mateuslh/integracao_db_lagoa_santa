from dataclasses import dataclass
from typing import Optional, Tuple
import json

@dataclass
class Lancamento:
    id: int
    guia_iss_govdigital_id: int
    situacao: str
    id_gerado: Optional[float] = None
    nro_baixa: Optional[float] = None
    json_retorno: Optional[dict] = None
    json_enviado: Optional[dict] = None

    @classmethod
    def from_row(cls, row: Tuple) -> 'Lancamento':
        return cls(
            id=row[0],
            guia_iss_govdigital_id=row[1],
            situacao=row[2],
            id_gerado=row[3],
            nro_baixa=row[4],
            json_retorno=json.loads(row[5]) if row[5] else None,
            json_enviado=json.loads(row[6]) if row[6] else None
        )
