import subprocess
import sys

def cat(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def head(text, lines):
    text_split = text.split('\n')
    return '\n'.join(text_split[:lines])

def tail(text, lines):
    text_split = text.split('\n')
    return '\n'.join(text_split[-lines:])

def process_word_file(word_file_path):
    if len(sys.argv) != 2:
        print("arg --> word file")
        exit(0)
        

    char = cat(sys.argv[1])[1]

    f1 = 0
    with open("lists/alphabets", 'r') as alphabets_file:
        f1 = sum(1 for line in alphabets_file if char in line.split())
        
    if f1 == 0:
        with open("lists/out_word", 'w') as out_word_handle:

            #subprocess.call(["scripts/tamil_trans", "lists/tamil_map", sys.argv[1], "lists/trans_word"])
            command = ["scripts/tamil_trans_py", "lists/tamil_map", sys.argv[1], "lists/trans_word"]
            try:
                #print("Executing command:", " ".join(command))
                return_code = subprocess.run(command)
                #print("Return code:", return_code)
                # if return_code == 0:
                #     print("Command executed successfully")
                # else:
                #     print(f"Command failed with return code {return_code}")
            except Exception as e:
                print(f"An error occurred: {e}")


            # import shutil
            # import os

            # source_path = 'lists/trans_word'
            # destination_path = '/home/mukesh/Desktop/'

            # # Ensure the source file exists before attempting to copy
            # if os.path.exists(source_path):
            #     shutil.copy(source_path, destination_path)
            #     print(f"File copied to {destination_path}")
            # else:
            #     print(f"The source file {source_path} does not exist.")

            #subprocess.call(["python", "scripts/ortho_to_phonetic1.py", "lists/trans_word", "lists/phone_list", "phn"])

            # command1 = ["python", "scripts/ortho_to_phonetic1.py", "lists/trans_word", "lists/phone_list", "phn"]
            # try:
            #     print("Executing command:", " ".join(command1))
            #     return_code1 = subprocess.call(command1)
            #     print("Return code:", return_code1)
            #     if return_code1 == 0:
            #         print("Command executed successfully")
            #     else:
            #         print(f"Command failed with return code {return_code1}")
            # except Exception as e:
            #     print(f"An error occurred: {e}")


            try:
                result = subprocess.run(["python", "scripts/ortho_to_phonetic1.py", "lists/trans_word", "lists/phone_list", "phn"],
                                        capture_output=True, text=True, check=True)

                #print("Subprocess Output:", result.stdout)
            except subprocess.CalledProcessError as e:
                print("Subprocess Error:", e.stderr)
                print("Return Code:", e.returncode)

            phn_lines = cat("phn").split('\n')
            count = len(phn_lines)
            start = 2
            phn = tail(head(cat("phn"), 1), 1)

            if phn == "c":
                out_word_handle.write(" s")
            else:
                out_word_handle.write(f" {phn}")

            while start <= count:
                phn = tail(head(cat("phn"), start), 1)
                c0 = start - 1
                c1 = start + 1
                c2 = start + 2
                phn_1 = tail(head(cat("phn"), c0), 1)
                phn_2 = tail(head(cat("phn"), c1), 1)

                if (
                    (phn == "c" and phn_1 == "c") or
                    (phn == "c" and phn_2 == "c") or
                    (phn == "c" and phn_1 == "tx")
                ):
                    out_word_handle.write(f" {phn}")
                elif phn == "c" and phn_1 == "nj":
                    out_word_handle.write(" j")
                elif phn == "c" and phn_1 != "c":
                    out_word_handle.write(" s")
                elif (phn == "rx" and phn_2 == "rx"):
                    out_word_handle.write(" tx")
                else:
                    temp_vuv_lines = cat("lists/vuv_list").split('\n')
                    with open("lists/tmp", 'w') as list_temp:
                        for line1 in temp_vuv_lines:
                            line_temp = line1.split()
                            if line_temp:  # Check if line_temp is not empty
                                list_temp.write(line_temp[0] + '\n')

                    temp_vuv = cat("lists/tmp").split('\n')
                    flg = sum(1 for line in temp_vuv if phn in line.split())
                    phn0 = tail(head(cat("phn"), c0), 1)
                    phn1 = tail(head(cat("phn"), c1), 1)
                    phn2 = tail(head(cat("phn"), c2), 1)

                    if phn == "u":
                        flg_1 = sum(1 for line in cat("lists/u_list").split('\n') if phn1 in line.split())
                        if (start == count) or (flg_1 != 0 and c1 == count) or (phn1 == "k" and phn2 == "k" and c0 != 1):
                            out_word_handle.write(" eu")
                        else:
                            out_word_handle.write(f" {phn}")
                    elif phn == "c":
                        if phn0 == "c" or phn1 == "c" or c1 == count:
                            out_word_handle.write(f" {phn}")
                        elif phn0 == "nj":
                            out_word_handle.write(" j")
                        else:
                            out_word_handle.write(" s")
                    elif flg == 1:
                        temp_lines = cat("lists/vuv_list").split('\n')
                        with open("lists/nasal", 'w') as list_nasal:
                            for line_nasal in temp_lines:
                                line_temp = line_nasal.split()
                                if len(line_temp) >= 3:  # Check if line_temp has at least three elements
                                    list_nasal.write(line_temp[2] + '\n')


                        flg1 = sum(1 for line in cat("lists/vowel_list").split('\n') if phn0 in line.split())
                        flg2 = sum(1 for line in cat("lists/vowel_list").split('\n') if phn1 in line.split())
                        flg3 = sum(1 for line in cat("lists/nasal").split('\n') if phn0 in line.split())
                        flg4 = sum(1 for line in cat("lists/sv").split('\n') if phn0 in line.split())

                        if phn == "p":
                            if (flg1 == 1 and flg2 == 1) or (flg3 == 1 and phn0 != phn) or (phn0 == "n"):
                                phn_v_tmp = next(line.split() for line in cat("lists/vuv_list").split('\n') if phn in line.split())
                                phn_v = phn_v_tmp[1]
                                out_word_handle.write(f" {phn_v}")
                            else:
                                out_word_handle.write(f" {phn}")
                        elif (flg1 == 1 and flg2 == 1) or (flg3 == 1 and phn0 != phn) or (flg4 == 1 and flg2 == 1):
                            temp_phn_v = next(line.split() for line in cat("lists/vuv_list").split('\n') if phn in line.split())
                            phn_v = temp_phn_v[1]
                            out_word_handle.write(f" {phn_v}")
                        else:
                            out_word_handle.write(f" {phn}")
                    else:
                        out_word_handle.write(f" {phn}")

                start += 1
            #print()

import os
import pdb
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("arg --> word file")
        exit(0)

    process_word_file(sys.argv[1])
