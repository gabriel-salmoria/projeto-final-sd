import sys
import random
import pathlib

PWD = pathlib.Path(__file__).parent.absolute()
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
            a = random.randint(-2**(n-1), 2**(n-1) - 1)
            b = random.randint(-2**(n-1), 2**(n-1) - 1)
            op = random.randint(0, 1)

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            if op:  # subtração
                bin_c = integer_to_twos_complement(a - b, n)
            else:  # soma
                bin_c = integer_to_twos_complement(a + b, n)[-n:] # truncate to n bits

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
            a = random.randint(-2**(n-1), 2**(n-1) - 1)
            b = random.randint(-2**(n-1), 2**(n-1) - 1)

            bin_a = integer_to_twos_complement(a, n)
            bin_b = integer_to_twos_complement(b, n)

            bin_c = integer_to_twos_complement(a * b, 2 * n)

            file.write(f"{bin_a} {bin_b}\n")
            file.write(f"{bin_c}\n")

    print("Geração do arquivo de estímulos para o módulo mul concluída.")


def print_help_and_exit():
    print("Usage: python3 golden-model.py <module-name>")
    print("Valid module names: addsub, mul")
    sys.exit(1)


if __name__ == "__main__":
    # Read the input
    if len(sys.argv) != 2:
        print_help_and_exit()

    # Check the input
    module_name = sys.argv[1]

    # Generate the golden model for the selected module
    if module_name == "addsub":
        generate_golden_model_addsub()
    elif module_name == "mul":
        generate_golden_model_mul()
    else:
        print(f"Invalid module name: {module_name}")
        print_help_and_exit()
