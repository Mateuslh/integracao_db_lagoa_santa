import json
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from typing import Optional

from .pessoa import Pessoa
from .economico import Economico


@dataclass
class Lancamento_guia:
    chaveLancamento: str
    dataLancamento: datetime.date
    dataVencimento: datetime.date
    competencia: str
    ano: int
    observacoesReceitaDiversa: str
    pessoa: Pessoa
    economico: Economico
    nroBaixa: Optional[int]
    codigoBarras: str
    camposAdicionais: dict[str, str]
    nroBaixa: int

    def to_json(self):
        return json.dumps({
            "chaveLancamento": self.chaveLancamento,
            "dataLancamento": self.dataLancamento.strftime("%Y-%m-%d"),
            "dataVencimento": self.dataVencimento.strftime("%Y-%m-%d"),
            "competencia": self.competencia,
            "nroParcela":self.competencia,
            "nroBaixa" : self.nroBaixa,
            "ano": self.ano,
            "observacoesReceitaDiversa": self.observacoesReceitaDiversa,
            "pessoa": {
                "codigo": self.pessoa.codigo,
                "id": self.pessoa.id,
            },
            "economico": {
                "id": self.economico.id,
                "codigo": self.economico.codigo,
            },
            "camposAdicionais": {
                "Valor": self.camposAdicionais.get("valor")
            }
        },default=self._json_default)

    def _json_default(self, value):
        if isinstance(value, Decimal):
            return float(value)
        raise TypeError(f"Object of type {value.__class__.__name__} is not JSON serializable")
