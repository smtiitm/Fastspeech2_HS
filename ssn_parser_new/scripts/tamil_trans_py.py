import sys

class TableEntry:
    def __init__(self):
        self.tamil = ""
        self.english = ""

def is_d_v(character, d_v):
    return character in d_v

def is_non_printable(character):
    return character in {'\n', '\r', '\t', ' '}

def transliterate(token, tamil_map):
    for entry in tamil_map:
        if token == entry.tamil:
            return entry.english
    print(f"No English character in the map file for {token}")
    return None

def main():
    if len(sys.argv) == 2:
        map_file = open(sys.argv[1], "r")
        input_text = sys.stdin
        output_text = sys.stdout
    elif len(sys.argv) == 4:
        map_file = open(sys.argv[1], "r")
        input_text = open(sys.argv[2], "r")
        output_text = open(sys.argv[3], "w")
    else:
        print("./tamil_english map_file or\n./tamil_english map_file input output")
        return 3

    tamil_map = []
    n_characters = 0

    for line in map_file:
        if line[0] == '#':
            continue
        tamil, english = line.split()
        entry = TableEntry()
        entry.tamil = tamil
        entry.english = english
        tamil_map.append(entry)
        n_characters += 1

    d_v = ['\u0BBE', '\u0BBF', '\u0BC0', '\u0BC1', '\u0BC2', '\u0BC6', '\u0BC7', '\u0BC8', '\u0BCA', '\u0BCB', '\u0BCC']
    vowels = ['\u0B85', '\u0B86', '\u0B87', '\u0B88', '\u0B89', '\u0B8A', '\u0B8E', '\u0B8F', '\u0B90', '\u0B92', '\u0B93', '\u0B94', '\u0B83']

    character_previous = ''
    character = input_text.read(1)
    character_next = input_text.read(1)

    while character:
        pos = input_text.tell()

        if is_non_printable(character):
            print(f"\nNon Printable\tSS{character}SS")
            output_text.write(character)
        elif is_d_v(character, vowels):
            if character == '\u0B83' and character_next == '\u0BAA':
                token = character
                character_transliterated = transliterate(token, tamil_map)
                if character_transliterated is not None:
                    output_text.write(character_transliterated)
            else:
                token = character
                input_text.seek(pos)
                character_transliterated = transliterate(token, tamil_map)
                if character_transliterated is not None:
                    output_text.write(character_transliterated)
        else:
            if character_next == '\u0BCD':
                token = character + character_next
                character_transliterated = transliterate(token, tamil_map)
                if character_transliterated is not None:
                    output_text.write(character_transliterated)
            elif is_d_v(character, d_v):
                token = character
                input_text.seek(pos)
                character_transliterated = transliterate(token, tamil_map)
                if character_transliterated is not None:
                    output_text.write(character_transliterated)
            elif not is_d_v(character_next, d_v):
                token = character
                input_text.seek(pos)
                character_transliterated = transliterate(token, tamil_map)
                if character_transliterated is not None:
                    if token == character_transliterated:
                        output_text.write(character_transliterated)
                    else:
                        output_text.write(character_transliterated + "a")
            elif is_d_v(character_next, d_v):
                token = character
                input_text.seek(pos)
                character_transliterated = transliterate(token, tamil_map)
                if character_transliterated is not None:
                    output_text.write(character_transliterated)

        character = character_next
        character_next = input_text.read(1)

if __name__ == "__main__":
    main()
