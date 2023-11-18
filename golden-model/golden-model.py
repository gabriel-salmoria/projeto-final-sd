import random
import pathlib

PWD = pathlib.Path(__file__).parent.absolute()
ROOT = PWD.parent.absolute()

def generate_golden_model_add():
    """
    Gera os estímulos para o módulo add.
    
    São 50 blocos de estímulos, cada um consistindo de uma linha com 2 números 
    binários de 64 bits cada separados por espaço, e uma linha com o resultado 
    da soma dos dois, também em binário de 64 bits.
    """
    path = ROOT / 'estimulos-add.dat'
    with path.open('w') as file:
        for _ in range(50):  # 50 blocos de estímulos
            a = random.randint(0, 2**64 - 1)
            b = random.randint(0, 2**64 - 1)
            c = f"{a+b:064b}"[-64:]
            file.write(f"{a:064b} {b:064b}\n")
            file.write(f"{c}\n")
    print('Geração do arquivo de estímulos para o módulo add concluída.')

def generate_golden_model_sub():
    path = ROOT / 'estimulos-sub.dat'
    with path.open('w') as file:
        ...
    print('Geração do arquivo de estímulos para o módulo sub concluída.')

def generate_golden_model_mul():
    path = ROOT / 'estimulos-mul.dat'
    with path.open('w') as file:
        ...
    print('Geração do arquivo de estímulos para o módulo mul concluída.')

if __name__ == '__main__':
    import sys

    # Read the input
    if len(sys.argv) != 2:
        print('Usage: python3 golden-model.py <module-name>')
        print('module names: add, sub, mul')
        sys.exit(1)
    
    # Check the input
    module_name = sys.argv[1]

    # Generate the golden model for the selected module
    if module_name == 'add':
        generate_golden_model_add()
    elif module_name == 'sub':
        generate_golden_model_sub()
    elif module_name == 'mul':
        generate_golden_model_mul()
    else:
        print('Invalid module name:', module_name)
        print('module names: add, sub, mul')
        sys.exit(1)
