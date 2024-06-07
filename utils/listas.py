def collate(lista, tamanho_sublista):
    sublistas = []
    for i in range(0, len(lista), tamanho_sublista):
        sublista = lista[i:i + tamanho_sublista]
        sublistas.append(sublista)
    return sublistas
def groupBy(lista, *args):
    grupo = {}
    for item in lista:
        valor_chave = ""
        for parametro in args:
            valor_chave += item[parametro]
        if valor_chave in grupo:
            grupo[valor_chave].append(item)
        else:
            grupo[valor_chave] = [item]
    return grupo
def flatten(lst):
    flat_list = []
    for item in lst:
        if isinstance(item, list):
            flat_list.extend(flatten(item))
        else:
            flat_list.append(item)
    return flat_list
