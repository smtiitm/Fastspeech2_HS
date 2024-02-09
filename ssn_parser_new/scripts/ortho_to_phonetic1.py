import re

def cat(file):
    with open(file, 'r') as f:
        return f.read()

def ortho_to_phonetic(input_file, phone_list_file, output_file):
    with open(input_file, 'r') as f:
        words = f.read().split()

    with open(phone_list_file, 'r') as f:
        phone_list = set(f.read().splitlines())

    word_start = 0
    with open(output_file, 'w') as phn_handle:
        while word_start < len(words):
            word = words[word_start]
            if word != "SIL":
                num = len(word)
                phone_start1 = 0
                while phone_start1 < num:
                    p1 = word[phone_start1:phone_start1 + 2]
                    p2 = word[phone_start1:phone_start1 + 3]
                    p3 = word[phone_start1:phone_start1 + 4]
                    p4 = word[phone_start1:phone_start1 + 5]
                    p5 = word[phone_start1:phone_start1 + 6]

                    cou = len(set(re.findall(rf'\b{re.escape(p1)}\b', cat(phone_list_file))))
                    cou1 = len(set(re.findall(rf'\b{re.escape(p2)}\b', cat(phone_list_file))))
                    cou2 = len(set(re.findall(rf'\b{re.escape(p3)}\b', cat(phone_list_file))))
                    cou3 = len(set(re.findall(rf'\b{re.escape(p4)}\b', cat(phone_list_file))))
                    cou4 = len(set(re.findall(rf'\b{re.escape(p5)}\b', cat(phone_list_file))))




                    if cou4 == 1:
                        phn_handle.write(p5 + "\n")
                        phone_start1 += 6
                    elif cou3 == 1:
                        phn_handle.write(p4 + "\n")
                        phone_start1 += 5
                    elif cou2 == 1:
                        phn_handle.write(p3 + "\n")
                        phone_start1 += 4
                    elif cou1 == 1:
                        phn_handle.write(p2 + "\n")
                        phone_start1 += 3
                    elif cou == 1:
                        phn_handle.write(p1 + "\n")
                        phone_start1 += 2
                    else:
                        p1 = word[phone_start1]
                        if p1 in [",", "."]:
                            phone_start1 += 1
                        else:
                            phn_handle.write(p1 + "\n")
                            phone_start1 += 1
            else:
                phn_handle.write("SIL\n")
                break
            word_start += 1

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 4:
        print("Usage: python script.py input_file phone_list output_file")
        sys.exit(0)

    #print("Test -- 6")
    input_file, phone_list_file, output_file = sys.argv[1], sys.argv[2], sys.argv[3]

    #print("output_file", output_file)
    ortho_to_phonetic(input_file, phone_list_file, output_file)
