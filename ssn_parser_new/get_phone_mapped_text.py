import sys
import re

def replace_in_file(file_path, replacements):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    for search, replace in replacements.items():
        content = re.sub(search, replace, content)

    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(content)

def main():
    in_file = sys.argv[1]

    replacements = {
        '"aa"': '"A"',
        '"ii"': '"I"',
        '"uu"': '"U"',
        '"ee"': '"E"',
        '"oo"': '"O"',
        '"nn"': '"N"',
        '"ae"': '"ऍ"',
        '"ag"': '"ऽ"',
        '"au"': '"औ"',
        '"ax"': '"ऑ"',
        '"bh"': '"B"',
        '"ch"': '"C"',
        '"dh"': '"ध"',
        '"dx"': '"ड"',
        '"dxh"': '"ढ"',
        '"dxhq"': '"ढ़"',
        '"dxq"': '"ड़"',
        '"ei"': '"ऐ"',
        '"ai"': '"ऐ"',
        '"eu"': '"उ"',
        '"gh"': '"घ"',
        '"gq"': '"ग़"',
        '"hq"': '"H"',
        '"jh"': '"J"',
        '"kh"': '"ख"',
        '"khq"': '"ख़"',
        '"kq"': '"क़"',
        '"ln"': '"ൾ"',
        '"lw"': '"ൽ"',
        '"lx"': '"ള"',
        '"mq"': '"M"',
        '"nd"': '"ऩ"',
        '"ng"': '"ङ"',
        '"nj"': '"ञ"',
        '"nk"': '"़"',
        '"nw"': '"ൺ"',
        '"nx"': '"ण"',
        '"ou"': '"औ"',
        '"ph"': '"P"',
        '"rq"': '"R"',
        '"rqw"': '"ॠ"',
        '"rw"': '"ർ"',
        '"rx"': '"ऱ"',
        '"sh"': '"श"',
        '"sx"': '"ष"',
        '"th"': '"थ"',
        '"tx"': '"ट"',
        '"txh"': '"ठ"',
        '"wv"': '"W"',
        '"zh"': '"Z"',
    }

    replace_in_file(in_file, replacements)

if __name__ == "__main__":
    main()
