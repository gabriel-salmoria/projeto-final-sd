# Golden Model

## Uso

Para usar o golden model, basta rodar

python3 path/to/golden-model/golden-model.py < module-name >

São aceitos como entrada os seguintes módulos:

- add
- sub
- mul

## Testes

O golden model gerará um arquivo de testes para cada módulo, com o nome
estimulos-< module-name >.dat
Para rodar os testes, o usuário deve settar como toplevel o módulo desejado e
selecionar o testbench correspondente ao módulo.
