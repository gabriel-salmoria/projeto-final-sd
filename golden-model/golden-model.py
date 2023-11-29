import sys
import random
import pathlib

PWD = pathlib.Path(__file__).parent
ROOT = PWD.parent.absolute()


def integer_to_twos_complement(number: str, n_bits: int):
    """
    Converts an integer to its Two's Complement representation.
    """
    if number >= 0:
        binary = bin(number)[2:].zfill(n_bits)
        return binary
    else:
        valor_absoluto = abs(number)
        binary = bin(valor_absoluto)[2:].zfill(n_bits)
        
        # Inversão dos bits
        complement = ''.join('1' if bit == '0' else '0' for bit in binary)
        
        # Adicionar 1 ao complemento de dois
        decimal_complement = int(complement, 2) + 1
        binary_complement = bin(decimal_complement)[2:].zfill(n_bits)
        return binary_complement


def generate_golden_model_addsub():
    """
    Gera os estímulos para o módulo addsub.

    São 100 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada e um binário de 1 bit indicando a operação
    (0: soma; 0: subtração), todos separados por espaço, e uma linha com o
    resultado da soma/subtração, de 32 bits.

    A quantidade de somas e subtrações é aleatória.
    """
    path = ROOT / "estimulos-addsub.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(100):
            a = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            b = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            op = random.randint(0, 1)

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            if op:  # subtração
                bin_c = integer_to_twos_complement(a - b, n)
            else:  # soma
                bin_c = integer_to_twos_complement(a + b, n)[-n:]  # truncate to n bits

            file.write(f"{bin_a} {bin_b} {op}\n")
            file.write(f"{bin_c}\n")

    print("Geração do arquivo de estímulos para o módulo addsub concluída.")


def generate_golden_model_mul():
    """
    Gera os estímulos para o módulo mul.

    São 50 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada, separados por espaço, e uma linha com o resultado
    da nultiplicação dos dois, de 64 bits.
    """
    path = ROOT / "estimulos-mul.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(50):
            a = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            b = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            bin_c = integer_to_twos_complement(a * b, 2 * n + 1)

            file.write(f"{bin_a} {bin_b}\n")
            file.write(f"{bin_c}\n")

    print("Geração do arquivo de estímulos para o módulo mul concluída.")


def generate_golden_model_slt():
    """
    Gera os estímulos para o módulo slt.

    São 50 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada, separados por espaço, e uma linha com o resultado
    da comparação (1: a < b; 0: a >= b), de 1 bit.
    """
    path = ROOT / "estimulos-slt.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(50):
            a = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            b = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            if a < b:
                bin_c = "1"
            else:
                bin_c = "0"

            file.write(f"{bin_a} {bin_b}\n")
            file.write(f"{bin_c}\n")

    print("Geração do arquivo de estímulos para o módulo slt concluída.")


def generate_golden_model_and_or():
    """
    Gera os estímulos para o módulo and_or.

    São 100 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cadao e um binário de 1 bit indicando a operação
    (0: and; 0: or), todos separados por espaço, e uma linha com o
    resultado do and/or bit a bit, de 32 bits.

    A quantidade de and's e or's bit a bit é aleatória.
    """
    path = ROOT / "estimulos-and_or.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(100):
            a = random.randint(0, 2**n - 1)
            b = random.randint(0, 2**n - 1)
            op = random.randint(0, 1)

            bin_a = format(a, f"0{n}b")
            bin_b = format(b, f"0{n}b")

            if op:  # or
                bin_c = format(a | b, f"0{n}b")
            else:  # and
                bin_c = format(a & b, f"0{n}b")

            file.write(f"{bin_a} {bin_b} {op}\n")
            file.write(f"{bin_c}\n")

    print("Geração do arquivo de estímulos para o módulo and_or concluída.")


def generate_all():
    """
    Gera os estímulos para todos os módulos.
    """
    generate_golden_model_addsub()
    generate_golden_model_mul()
    generate_golden_model_slt()
    generate_golden_model_and_or()


def clean():
    """
    Remove todos os arquivos de estímulos.
    """
    for path in ROOT.glob("estimulos-*.dat"):
        path.unlink()


def print_help_and_exit(options: list[str]):
    print("Usage: python3 golden-model.py <option>")
    print("Valid options:", ", ".join(options))
    sys.exit(1)


if __name__ == "__main__":
    # List of valid module names
    functions = {
        "addsub": generate_golden_model_addsub,
        "mul": generate_golden_model_mul,
        "slt": generate_golden_model_slt,
        "and_or": generate_golden_model_and_or,
        "all": generate_all,
        "clean": clean,
    }
    options = list(functions.keys())

    # Read the input
    if len(sys.argv) != 2:
        print_help_and_exit(options)

    # Check the input
    option = sys.argv[1]

    if option not in functions.keys():
        print(f"Invalid option: {option}")
        print_help_and_exit(options)

    # Generate the golden model for the selected module
    functions[option]()
