import sys
import random
import pathlib

PWD = pathlib.Path(__file__).parent
ROOT = PWD.parent.absolute()


def integer_to_twos_complement(number, num_bits):
    """
    Converts an integer to its Two's Complement representation.
    """
    if number >= 0:
        return format(number, f"0{num_bits}b")
    else:
        # Calculate Two's Complement for negative numbers
        complement = (1 << num_bits) + number
        return format(complement, f"0{num_bits}b")


def generate_golden_model_addsub():
    """
    Gera os estímulos para o módulo addsub.

    São 300 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada e um binário de 1 bit indicando a operação
    (0: soma; 0: subtração), todos separados por espaço, e uma linha com o
    resultado da soma/subtração, de 32 bits.

    A quantidade de somas e subtrações é aleatória.
    """
    path = ROOT / "estimulos-addsub.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(300):
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

    São 300 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada, separados por espaço, e uma linha com o resultado
    da nultiplicação dos dois, de 64 bits.
    """
    path = ROOT / "estimulos-mul.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(300):
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

    São 300 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada, separados por espaço, e uma linha com o resultado
    da comparação (0: a < b; 1: a >= b), de 1 bit.
    """
    path = ROOT / "estimulos-slt.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(300):
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

    São 300 blocos de estímulos, cada um consistindo de uma linha com 2 números
    binários de 32 bits cada um e um binário de 1 bit indicando a operação
    (0: and; 0: or), todos separados por espaço, e uma linha com o
    resultado do and/or bit a bit, de 32 bits.

    A quantidade de and's e or's bit a bit é aleatória.
    """
    path = ROOT / "estimulos-and_or.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(300):
            a = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            b = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            op = random.randint(0, 1)

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            if op:  # or
                bin_c = "".join(str(int(bin_a[i]) | int(bin_b[i])) for i in range(n))
            else:  # and
                bin_c = "".join(str(int(bin_a[i]) & int(bin_b[i])) for i in range(n))

            file.write(f"{bin_a} {bin_b} {op}\n")
            file.write(f"{bin_c}\n")

    print("Geração do arquivo de estímulos para o módulo and_or concluída.")


def generate_golden_model_toplevel():
    """
    Gera os estímulos para o módulo toplevel.
    Interface:
    - Entradas:
        - A: 32 bits
        - B: 32 bits
        - funct: 6 bits
    - Saídas:
        - S: 32 bits
    """
    path = ROOT / "estimulos-toplevel.dat"
    n = 32

    with path.open("w") as file:
        for _ in range(300):
            a = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            b = random.randint(-(2 ** (n - 1)), 2 ** (n - 1) - 1)
            funct = random.choice(
                [
                    "100000",  # add
                    "100010",  # sub
                    "100100",  # and
                    "100101",  # or
                    "101010",  # slt
                    "111111",  # mul (dummy value)
                ]
            )

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            bin_sum = integer_to_twos_complement(a + b, n)[-n:]  # truncate to n bits
            bin_sub = integer_to_twos_complement(a - b, n)
            bin_mul = integer_to_twos_complement(a * b, 2 * n + 1)
            bin_slt = "0" * 31 + "1" if a < b else "0"
            bin_and = "".join(str(int(bin_a[i]) & int(bin_b[i])) for i in range(n))
            bin_or = "".join(str(int(bin_a[i]) | int(bin_b[i])) for i in range(n))

            if funct == "100000":
                final = bin_sum
            elif funct == "100010":
                final = bin_sub
            elif funct == "100100":
                final = bin_and
            elif funct == "100101":
                final = bin_or
            elif funct == "101010":
                final = bin_slt
            else:
                final = bin_mul

            if len(final) < 65:
                final = (65-len(final)) * "0" + final

            file.write(f"{bin_a} {bin_b} {funct}\n")
            file.write(f"{final}\n")

    print("Geração do arquivo de estímulos para o módulo toplevel concluída.")


def generate_all():
    """
    Gera os estímulos para todos os módulos.
    """
    generate_golden_model_addsub()
    generate_golden_model_mul()
    generate_golden_model_slt()
    generate_golden_model_and_or()
    generate_golden_model_toplevel()


def clean():
    """
    Remove todos os arquivos de estímulos.
    """
    for path in ROOT.glob("estimulos-*.dat"):
        path.unlink()

    print("Arquivos de estímulos removidos.")


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
        "toplevel": generate_golden_model_toplevel,
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
