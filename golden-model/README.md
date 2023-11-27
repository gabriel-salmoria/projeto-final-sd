# Golden Model

## Uso

Para usar o golden model, basta rodar

```bash
python3 path/to/golden-model/golden-model.py <option>
```

Onde `<option>` é o nome do módulo que se deseja gerar o golden model; ou "all"
para gerar todos os módulos; ou "clean" para limpar os arquivos gerados.

## Testes

O golden model gerará um arquivo de testes para cada módulo, com o nome
estimulos-< option >.dat
Para rodar os testes, o usuário deve adicionar como toplevel o módulo desejado e
selecionar o testbench correspondente ao módulo.
