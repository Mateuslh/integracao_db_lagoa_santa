from dataclasses import dataclass
from datetime import datetime
from typing import Optional

from .pessoa import Pessoa
from .economico import Economico


@dataclass
class Lancamento:
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
