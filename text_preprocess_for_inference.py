'''
TTS Preprocessing
Developed by Arun Kumar A(CS20S013) - November 2022
Code Changes by Utkarsh - 2023
'''
import os
import re
import json
import pandas as pd
import string
from collections import defaultdict
import time
import subprocess
import shutil
from multiprocessing import Process
import traceback

#imports of dependencies from environment.yml
from num_to_words import num_to_word
from g2p_en import G2p

def add_to_dictionary(dict_to_add, dict_file):
    append_string = ""
    for key, value in dict_to_add.items():
        append_string += (str(key) + " " + str(value) + "\n")
    
    if os.path.isfile(dict_file):
        # make a copy of the dictionary
        source_dir = os.path.dirname(dict_file)
        dict_file_name = os.path.basename(dict_file)
        temp_file_name = "." + dict_file_name + ".temp"
        temp_dict_file = os.path.join(source_dir, temp_file_name)
        shutil.copy(dict_file, temp_dict_file)
        # append the new words in the dictionary to the temp file
        with open(temp_dict_file, "a") as f:
            f.write(append_string)
        # check if the write is successful and then replace the temp file as the dict file
        try:
            df_orig = pd.read_csv(dict_file, delimiter=" ", header=None, dtype=str)
            df_temp = pd.read_csv(temp_dict_file, delimiter=" ", header=None, dtype=str)
            if len(df_temp) > len(df_orig):
                os.rename(temp_dict_file, dict_file)
                print(f"{len(dict_to_add)} new words appended to Dictionary: {dict_file}")
        except:
            print(traceback.format_exc())
    else:
        # create a new dictionary
        with open(dict_file, "a") as f:
            f.write(append_string)
        print(f"New Dictionary: {dict_file} created with {len(dict_to_add)} words")


class TextCleaner:
    def __init__(self):
        # this is a static set of cleaning rules to be applied
        self.cleaning_rules = {
            " +" : " ",
            "^ +" : "",
            " +$" : "",
            "#" : "",
            "[.,;।!](\r\n)*" : "# ",
            "[.,;।!](\n)*" : "# ",
            "(\r\n)+" : "# ",
            "(\n)+" : "# ",
            "(\r)+" : "# ",
            """[?;:)(!|&’‘,।\."]""": "",
            "[/']" : "",
            "[-–]" : " ",
        }

    def clean(self, text):
        for key, replacement in self.cleaning_rules.items():
            text = re.sub(key, replacement, text)
        return text

    def clean_list(self, text):
        # input is supposed to be a list of strings
        output_text = []
        for line in text:
            line = line.strip()
            for key, replacement in self.cleaning_rules.items():
                line = re.sub(key, replacement, line)
            output_text.append(line)
        return output_text


class Phonifier:
    def __init__(self, dict_location=None):
        if dict_location is None:
            dict_location = "phone_dict"
        self.dict_location = dict_location

        # self.phone_dictionary = {}
        # # load dictionary for all the available languages
        # for dict_file in os.listdir(dict_location):
        #     try:
        #         if dict_file.startswith("."):
        #             # ignore hidden files
        #             continue
        #         language = dict_file
        #         dict_file_path = os.path.join(dict_location, dict_file)
        #         df = pd.read_csv(dict_file_path, delimiter=" ", header=None, dtype=str)
        #         self.phone_dictionary[language] = df.set_index(0).to_dict('dict')[1]
        #     except Exception as e:
        #         print(traceback.format_exc())

        # print("Phone dictionary loaded for the following languages:", list(self.phone_dictionary.keys()))

        self.g2p = G2p()
        print('Loading G2P model... Done!')
        # Mapping between the cmu phones and the iitm cls
        self.cmu_2_cls_map = {
            "AA" : "aa",
            "AA0" : "aa",
            "AA1" : "aa",
            "AA2" : "aa",
            "AE" : "axx",
            "AE0" : "axx",
            "AE1" : "axx",
            "AE2" : "axx",
            "AH" : "a",
            "AH0" : "a",
            "AH1" : "a",
            "AH2" : "a",
            "AO" : "ax",
            "AO0" : "ax",
            "AO1" : "ax",
            "AO2" : "ax",
            "AW" : "ou",
            "AW0" : "ou",
            "AW1" : "ou",
            "AW2" : "ou",
            "AX" : "a",
            "AY" : "ei",
            "AY0" : "ei",
            "AY1" : "ei",
            "AY2" : "ei",
            "B" : "b",
            "CH" : "c",
            "D" : "dx",
            "DH" : "d",
            "EH" : "ee",
            "EH0" : "ee",
            "EH1" : "ee",
            "EH2" : "ee",
            "ER" : "a r",
            "ER0" : "a r",
            "ER1" : "a r",
            "ER2" : "a r",
            "EY" : "ee",
            "EY0" : "ee",
            "EY1" : "ee",
            "EY2" : "ee",
            "F" : "f",
            "G" : "g",
            "HH" : "h",
            "IH" : "i",
            "IH0" : "i",
            "IH1" : "i",
            "IH2" : "i",
            "IY" : "ii",
            "IY0" : "ii",
            "IY1" : "ii",
            "IY2" : "ii",
            "JH" : "j",
            "K" : "k",
            "L" : "l",
            "M" : "m",
            "N" : "n",
            "NG" : "ng",
            "OW" : "o",
            "OW0" : "o",
            "OW1" : "o",
            "OW2" : "o",
            "OY" : "ei",
            "OY0" : "ei",
            "OY1" : "ei",
            "OY2" : "ei",
            "P" : "p",
            "R" : "r",
            "S" : "s",
            "SH" : "sh",
            "T" : "tx",
            "TH" : "t",
            "UH" : "u",
            "UH0" : "u",
            "UH1" : "u",
            "UH2" : "u",
            "UW" : "uu",
            "UW0" : "uu",
            "UW1" : "uu",
            "UW2" : "uu",
            "V" : "w",
            "W" : "w",
            "Y" : "y",
            "Z" : "z",
            "ZH" : "sh",
        }

        # Mapping between the iitm cls and iitm char
        self.cls_2_chr_map = {
            "aa" : "A",
            "ii" : "I",
            "uu" : "U",
            "ee" : "E",
            "oo" : "O",
            "nn" : "N",
            "ae" : "ऍ",
            "ag" : "ऽ",
            "au" : "औ",
            "axx" : "अ",
            "ax" : "ऑ",
            "bh" : "B",
            "ch" : "C",
            "dh" : "ध",
            "dx" : "ड",
            "dxh" : "ढ",
            "dxhq" : "T",
            "dxq" : "D",
            "ei" : "ऐ",
            "ai" : "ऐ",
            "eu" : "உ",
            "gh" : "घ",
            "gq" : "G",
            "hq" : "H",
            "jh" : "J",
            "kh" : "ख",
            "khq" : "K",
            "kq" : "क",
            "ln" : "ൾ",
            "lw" : "ൽ",
            "lx" : "ള",
            "mq" : "M",
            "nd" : "न",
            "ng" : "ङ",
            "nj" : "ञ",
            "nk" : "Y",
            "nw" : "ൺ",
            "nx" : "ण",
            "ou" : "औ",
            "ph" : "P",
            "rq" : "R",
            "rqw" : "ॠ",
            "rw" : "ർ",
            "rx" : "र",
            "sh" : "श",
            "sx" : "ष",
            "th" : "थ",
            "tx" : "ट",
            "txh" : "ठ",
            "wv" : "W",
            "zh" : "Z",
        }

        # Multilingual support for OOV characters
        oov_map_json_file = 'multilingualcharmap.json'
        with open(oov_map_json_file, 'r') as oov_file:
            self.oov_map = json.load(oov_file)



    def load_lang_dict(self, language, phone_dictionary):            
        # load dictionary for requested language
        try:

            dict_file = language
            print("language", language)
            dict_file_path = os.path.join(self.dict_location, dict_file)
            print("dict_file_path", dict_file_path)
            df = pd.read_csv(dict_file_path, delimiter=" ", header=None, dtype=str)
            phone_dictionary[language] = df.set_index(0).to_dict('dict')[1]

            dict_file = 'english'
            dict_file_path = os.path.join(self.dict_location, dict_file)
            df = pd.read_csv(dict_file_path, delimiter=" ", header=None, dtype=str)
            phone_dictionary['english'] = df.set_index(0).to_dict('dict')[1]
            
        except Exception as e:
            print(traceback.format_exc())

        return phone_dictionary

    def __is_float(self, word):
        parts = word.split('.')
        if len(parts) != 2:
            return False
        return parts[0].isdecimal() and parts[1].isdecimal()

    def en_g2p(self, word):
        phn_out = self.g2p(word)
        # print(f"phn_out: {phn_out}")
        # iterate over the string list and replace each word with the corresponding value from the dictionary
        for i, phn in enumerate(phn_out):
            if phn in self.cmu_2_cls_map.keys():
                phn_out[i] = self.cmu_2_cls_map[phn]
                # cls_out = self.cmu_2_cls_map[phn]
                if phn_out[i] in self.cls_2_chr_map.keys():
                    phn_out[i] = self.cls_2_chr_map[phn_out[i]]
                else:
                    pass
            else:
                pass  # ignore words that are not in the dictionary
            # print(f"i: {i}, phn: {phn}, cls_out: {cls_out}, phn_out: {phn_out[i]}")
        return ("".join(phn_out)).strip().replace(" ", "")

    def __post_phonify(self, text, language, gender):
        language_gender_id = language+'_'+gender
        if language_gender_id in self.oov_map.keys():
            output_string = ''
            for char in text:
                if char in self.oov_map[language_gender_id].keys():
                    output_string += self.oov_map[language_gender_id][char]
                else:
                    output_string += char
                # output_string += self.oov_map['language_gender_id']['char']
            return output_string
        else:
            return text

    def __is_english_word(self, word):
        maxchar = max(word)
        if u'\u0000' <= maxchar <= u'\u007f':
            return True
        return False

    def __phonify(self, text, language, gender, phone_dictionary):
        # text is expected to be a list of strings
        words = set((" ".join(text)).split(" "))
        #print(f"words test: {words}")
        non_dict_words = []
       
        
        if language in phone_dictionary:
            for word in words:
                # print(f"word: {word}")
                if word not in phone_dictionary[language] and (language == "english" or (not self.__is_english_word(word))):
                    non_dict_words.append(word)
                    #print('INSIDE IF CONDITION OF ADDING WORDS')
        else:
            non_dict_words = words
        print(f"word not in dict: {non_dict_words}")

        if len(non_dict_words) > 0:
            # unified parser has to be run for the non dictionary words
            os.makedirs("tmp", exist_ok=True)
            timestamp = str(time.time())
            non_dict_words_file = os.path.abspath("tmp/non_dict_words_" + timestamp)
            out_dict_file = os.path.abspath("tmp/out_dict_" + timestamp)
            with open(non_dict_words_file, "w") as f:
                f.write("\n".join(non_dict_words))

            if(language == 'tamil'):
                current_directory = os.getcwd()
                #tamil_parser_cmd = "tamil_parser.sh"
                tamil_parser_cmd = f"{current_directory}/ssn_parser_new/tamil_parser.py"
                #subprocess.run(["bash", tamil_parser_cmd, non_dict_words_file, out_dict_file, timestamp, "ssn_parser"])
                subprocess.run(["python", tamil_parser_cmd, non_dict_words_file, out_dict_file, timestamp, f"{current_directory}/ssn_parser_new"])
            elif(language == 'english'):
                phn_out_dict = {}
                for i in range(0,len(non_dict_words)):
                    phn_out_dict[non_dict_words[i]] = self.en_g2p(non_dict_words[i])
                # Create a string representation of the dictionary
                data_str = "\n".join([f"{key}\t{value}" for key, value in phn_out_dict.items()])
                print(f"data_str: {data_str}")
                with open(out_dict_file, "w") as f:
                    f.write(data_str)
            else:
          
                out_dict_file = os.path.abspath("tmp/out_dict_" + timestamp)
                from get_phone_mapped_python import TextReplacer
                
                from indic_unified_parser.uparser import wordparse
                
                text_replacer=TextReplacer()
                # def write_output_to_file(output_text, file_path):
                #     with open(file_path, 'w') as f:
                #         f.write(output_text)
                parsed_output_list = []
                for word in non_dict_words:
                    parsed_word = wordparse(word, 0, 0, 1)
                    parsed_output_list.append(parsed_word)
                replaced_output_list = [text_replacer.apply_replacements(parsed_word) for parsed_word in parsed_output_list]
                with open(out_dict_file, 'w', encoding='utf-8') as file:
                    for original_word, formatted_word in zip(non_dict_words, replaced_output_list):
                        line = f"{original_word}\t{formatted_word}\n"
                        file.write(line)
                        print(line, end='') 
                  

            try:
                
                df = pd.read_csv(out_dict_file, delimiter="\t", header=None, dtype=str)
                #print('DATAFRAME OUTPUT FILE', df.head())
                new_dict = df.dropna().set_index(0).to_dict('dict')[1]
                #print("new dict",new_dict)
                if language not in phone_dictionary:
                    phone_dictionary[language] = new_dict
                else:
                    phone_dictionary[language].update(new_dict)
                # run a non-blocking child process to update the dictionary file
                #print("phone_dict", self.phone_dictionary)
                p = Process(target=add_to_dictionary, args=(new_dict, os.path.join(self.dict_location, language)))
                p.start()
            except Exception as err:
                print(f"Error: While loading {out_dict_file}")
                traceback.print_exc()

        # phonify text with dictionary
        text_phonified = []
        for phrase in text:
            phrase_phonified = []
            for word in phrase.split(" "):
                if self.__is_english_word(word):
                    if word in phone_dictionary["english"]:
                        phrase_phonified.append(str(phone_dictionary["english"][word]))
                    else:
                        phrase_phonified.append(str(self.en_g2p(word)))
                elif word in phone_dictionary[language]:
                    # if a word could not be parsed, skip it
                    phrase_phonified.append(str(phone_dictionary[language][word]))
            # text_phonified.append(self.__post_phonify(" ".join(phrase_phonified),language, gender))
            text_phonified.append(" ".join(phrase_phonified))
        return text_phonified

    def __merge_lists(self, lists):
        merged_string = ""
        for list in lists:
            for word in list:
                merged_string += word + " "
        return merged_string.strip()

    def __phonify_list(self, text, language, gender, phone_dictionary):
        # text is expected to be a list of list of strings
        words = set(self.__merge_lists(text).split(" "))
        non_dict_words = []
        if language in phone_dictionary:
            for word in words:
                if word not in phone_dictionary[language] and (language == "english" or (not self.__is_english_word(word))):
                    non_dict_words.append(word)
        else:
            non_dict_words = words

        if len(non_dict_words) > 0:
            print(len(non_dict_words))
            print(non_dict_words)
            # unified parser has to be run for the non dictionary words
            os.makedirs("tmp", exist_ok=True)
            timestamp = str(time.time())
            non_dict_words_file = os.path.abspath("tmp/non_dict_words_" + timestamp)
            out_dict_file = os.path.abspath("tmp/out_dict_" + timestamp)
            with open(non_dict_words_file, "w") as f:
                f.write("\n".join(non_dict_words))

            if(language == 'tamil'):
                current_directory = os.getcwd()
                #tamil_parser_cmd = "tamil_parser.sh"
                tamil_parser_cmd = f"{current_directory}/ssn_parser_new/tamil_parser.py"
                #subprocess.run(["bash", tamil_parser_cmd, non_dict_words_file, out_dict_file, timestamp, "ssn_parser"])
                subprocess.run(["python", tamil_parser_cmd, non_dict_words_file, out_dict_file, timestamp, f"{current_directory}/ssn_parser_new"])
                
            elif(language == 'english'):
                phn_out_dict = {}
                for i in range(0,len(non_dict_words)):
                    phn_out_dict[non_dict_words[i]] = self.en_g2p(non_dict_words[i])
                # Create a string representation of the dictionary
                data_str = "\n".join([f"{key}\t{value}" for key, value in phn_out_dict.items()])
                print(f"data_str: {data_str}")
                with open(out_dict_file, "w") as f:
                    f.write(data_str)
            else:
                out_dict_file = os.path.abspath("tmp/out_dict_" + timestamp)
                from get_phone_mapped_python import TextReplacer
                
                from indic_unified_parser.uparser import wordparse
                
                text_replacer=TextReplacer()
            
                parsed_output_list = []
                for word in non_dict_words:
                    parsed_word = wordparse(word, 0, 0, 1)
                    parsed_output_list.append(parsed_word)
                replaced_output_list = [text_replacer.apply_replacements(parsed_word) for parsed_word in parsed_output_list]
                with open(out_dict_file, 'w', encoding='utf-8') as file:
                    for original_word, formatted_word in zip(non_dict_words, replaced_output_list):
                        line = f"{original_word}\t{formatted_word}\n"
                        file.write(line)
                        print(line, end='') 
        
            try:
                df = pd.read_csv(out_dict_file, delimiter="\t", header=None, dtype=str)
                new_dict = df.dropna().set_index(0).to_dict('dict')[1]
                print(new_dict)
                if language not in phone_dictionary:
                    phone_dictionary[language] = new_dict
                else:
                    phone_dictionary[language].update(new_dict)
                # run a non-blocking child process to update the dictionary file
                p = Process(target=add_to_dictionary, args=(new_dict, os.path.join(self.dict_location, language)))
                p.start()
            except Exception as err:
                traceback.print_exc()

        # phonify text with dictionary
        text_phonified = []
        for line in text:
            line_phonified = []
            for phrase in line:
                phrase_phonified = []
                for word in phrase.split(" "):
                    if self.__is_english_word(word):
                        if word in phone_dictionary["english"]:
                            phrase_phonified.append(str(phone_dictionary["english"][word]))
                        else:
                            phrase_phonified.append(str(self.en_g2p(word)))
                    elif word in phone_dictionary[language]:
                        # if a word could not be parsed, skip it
                        phrase_phonified.append(str(phone_dictionary[language][word]))
                # line_phonified.append(self.__post_phonify(" ".join(phrase_phonified), language, gender))
                line_phonified.append(" ".join(phrase_phonified))
            text_phonified.append(line_phonified)
        return text_phonified

    def phonify(self, text, language, gender, phone_dictionary):
        if not isinstance(text, list):
            out = self.__phonify([text], language, gender)
            return out[0]
        return self.__phonify(text, language, gender, phone_dictionary)
    
    def phonify_list(self, text, language, gender, phone_dictionary):
        if isinstance(text, list):
            return self.__phonify_list(text, language, gender, phone_dictionary)
        else:
            print("Error!! Expected to have a list as input.")


class TextNormalizer:
    def __init__(self, char_map_location=None):
        # self.phonifier = phonifier
        if char_map_location is None:
            char_map_location = "charmap"
    
        # this is a static set of cleaning rules to be applied
        self.cleaning_rules = {
            " +" : " ",
            "^ +" : "",
            " +$" : "",
            "#$" : "",
            "# +$" : "",
        }

        # this is the list of languages supported by num_to_words
        self.keydict = {"english" : "en",
            "hindi" : "hi",
            "gujarati" : "gu",
            "marathi" : "mr",
            "bengali" : "bn",
            "telugu" : "te",
            "tamil" : "ta",
            "kannada" : "kn",
            "odia" : "or",
            "punjabi" : "pa"
        }
        
        # self.g2p = G2p()
        # print('Loading G2P model... Done!')

    def __post_cleaning(self, text):
        for key, replacement in self.cleaning_rules.items():
            text = re.sub(key, replacement, text)
        return text

    def __post_cleaning_list(self, text):
        # input is supposed to be a list of strings
        output_text = []
        for line in text:
            for key, replacement in self.cleaning_rules.items():
                line = re.sub(key, replacement, line)
            output_text.append(line)
        return output_text

    def __check_char_type(self, str_c):
        # Determine the type of the character
        if str_c.isnumeric():
            char_type = "number"
        elif str_c in string.punctuation:
            char_type = "punctuation"
        elif str_c in string.whitespace:
            char_type = "whitespace"
        elif str_c.isalpha() and str_c.isascii():
            char_type = "ascii"
        else:
            char_type = "non-ascii"
        return char_type
    
    def insert_space(self, text):
        '''
        Check if the text contains numbers and English words and if they are without space inserts space between them.
        '''
        # Initialize variables to track the previous character type and whether a space should be inserted
        prev_char_type = None
        next_char_type = None
        insert_space = False

        # Output string
        output_string = ""

        # Iterate through each character in the text
        for i, c in enumerate(text):
            # Determine the type of the character
            char_type = self.__check_char_type(c)
            if i == (len(text) - 1):
                next_char_type = None
            else:
                next_char_type = self.__check_char_type(text[i+1])
            # print(f"{i}: {c} is a {char_type} character and next character is a {next_char_type}")

            # If the character type has changed from the previous character, check if a space should be inserted
            if (char_type != prev_char_type and prev_char_type != None and char_type != "punctuation" and char_type != "whitespace"):
                if next_char_type != "punctuation" or next_char_type != "whitespace":
                    insert_space = True

            # Insert a space if needed
            if insert_space:
                output_string += " "+c
                insert_space = False
            else:
                output_string += c

            # Update the previous character type
            prev_char_type = char_type

        # Print the modified text
        output_string = re.sub(r' +', ' ', output_string)
        return output_string

    def insert_space_list(self, text):
        '''
        Expect the input to be in form of list of string.
        Check if the text contains numbers and English words and if they are without space inserts space between them.
        '''
        # Output string list
        output_list = []

        for line in text:
            # Initialize variables to track the previous character type and whether a space should be inserted
            prev_char_type = None
            next_char_type = None
            insert_space = False
            # Output string
            output_string = ""
            # Iterate through each character in the line
            for i, c in enumerate(line):
                # Determine the type of the character
                char_type = self.__check_char_type(c)
                if i == (len(line) - 1):
                    next_char_type = None
                else:
                    next_char_type = self.__check_char_type(line[i+1])
                # print(f"{i}: {c} is a {char_type} character and next character is a {next_char_type}")

                # If the character type has changed from the previous character, check if a space should be inserted
                if (char_type != prev_char_type and prev_char_type != None and char_type != "punctuation" and char_type != "whitespace"):
                    if next_char_type != "punctuation" or next_char_type != "whitespace":
                        insert_space = True

                # Insert a space if needed
                if insert_space:
                    output_string += " "+c
                    insert_space = False
                else:
                    output_string += c

                # Update the previous character type
                prev_char_type = char_type

            # Print the modified line
            output_string = re.sub(r' +', ' ', output_string)
            output_list.append(output_string)
        return output_list

    def num2text(self, text, language):
        if language in self.keydict.keys():
            digits = sorted(list(map(int, re.findall(r'\d+', text))),reverse=True)
            if digits:
                for digit in digits:
                    text = re.sub(str(digit), ' '+num_to_word(digit, self.keydict[language])+' ', text)
            return self.__post_cleaning(text)
        else:
            print(f"No num-to-char for the given language {language}.")
            return self.__post_cleaning(text)

    def num2text_list(self, text, language):
        # input is supposed to be a list of strings
        if language in self.keydict.keys():
            output_text = []
            for line in text:
                digits = sorted(list(map(int, re.findall(r'\d+', line))),reverse=True)
                if digits:
                    for digit in digits:
                        line = re.sub(str(digit), ' '+num_to_word(digit, self.keydict[language])+' ', line)
                output_text.append(line)
            return self.__post_cleaning_list(output_text)
        else:
            print(f"No num-to-char for the given language {language}.")
            return self.__post_cleaning_list(text)
        
    def numberToTextConverter(self, text, language):
        if language in self.keydict.keys():
            matches = re.findall(r'\d+\.\d+|\d+', text)
            digits = sorted([int(match) if match.isdigit() else match if re.match(r'^\d+(\.\d+)?$', match) else str(match) for match in matches], key=lambda x: float(x) if isinstance(x, str) and '.' in x else x, reverse=True)
            if digits:
                for digit in digits:
                        
                    if isinstance(digit, int):
                        text = re.sub(str(digit), ' '+num_to_word(digit, self.keydict[language]).replace(",", "")+' ', text)
                    else:
                        parts = str(digit).split('.')
                        integer_part = int(parts[0])
                        data1 = num_to_word(integer_part, self.keydict[language]).replace(",", "")
                        decimal_part = str(parts[1])
                        data2 = ''
                        for i in decimal_part:
                            data2 = data2+' '+num_to_word(i, self.keydict[language])
                        if language == 'hindi':
                            final_data = f'{data1} दशमलव {data2}'
                        elif language == 'tamil':
                            final_data = f'{data1} புள்ளி {data2}'
                        else:
                            final_data = f'{data1} point {data2}'

                            
                        text = re.sub(str(digit), ' '+final_data+' ', text)

            return self.__post_cleaning(text)
        else:


            words = {
                '0': 'zero', '1': 'one', '2': 'two', '3': 'three', '4': 'four',
                '5': 'five', '6': 'six', '7': 'seven', '8': 'eight', '9': 'nine'
            }


            # Use regular expression to find and replace decimal points in numbers
            text = re.sub(r'(?<=\d)\.(?=\d)', ' point ', text)

            # Find all occurrences of numbers with decimal points and convert them to words
            matches = re.findall(r'point (\d+)', text)

            for match in matches:
                replacement = ' '.join(words[digit] for digit in match)
                text = text.replace(f'point {match}', f'point {replacement}', 1)


            return self.__post_cleaning(text)


    def normalize(self, text, language):
        return self.__post_cleaning(text)

    def normalize_list(self, text, language):
        # input is supposed to be a list of strings
        return self.__post_cleaning_list(text)


class TextPhrasifier:
    @classmethod
    def phrasify(cls, text):
        phrase_list = []
        for phrase in text.split("#"):
            phrase = phrase.strip()
            if phrase != "":
                phrase_list.append(phrase)
        return phrase_list

class TextPhrasifier_List:
    @classmethod
    def phrasify(cls, text):
        # input is supposed to be a list of strings
        # output is list of list of strings
        output_list = []
        for line in text:
            phrase_list = []
            for phrase in line.split("#"):
                phrase = phrase.strip()
                if phrase != "":
                    phrase_list.append(phrase)
            output_list.append(phrase_list)
        return output_list

class DurAlignTextProcessor:
    def __init__(self):
        # this is a static set of cleaning rules to be applied
        self.cleaning_rules = {
            " +" : "",
           "^" : "$",
            "$" : ".",
        }
        self.cleaning_rules_English = {
            " +" : "",
            "$" : ".",
        }
    def textProcesor(self, text):
        for key, replacement in self.cleaning_rules.items():
            for idx in range(0,len(text)):
                text[idx] = re.sub(key, replacement, text[idx])

        return text
    
    def textProcesorForEnglish(self, text):
        for key, replacement in self.cleaning_rules_English.items():
            for idx in range(0,len(text)):
                text[idx] = re.sub(key, replacement, text[idx])

        return text
    
    def textProcesor_list(self, text):
        # input expected in 'list of list of string' format
        output_text = []
        for line in text:
            for key, replacement in self.cleaning_rules.items():
                for idx in range(0,len(line)):
                    line[idx] = re.sub(key, replacement, line[idx])
            output_text.append(line)

        return output_text




class SharedInit:
    def __init__(self,
                text_cleaner = TextCleaner(),
                text_normalizer=TextNormalizer(),
                phonifier = Phonifier(),
                text_phrasefier = TextPhrasifier(),
                post_processor = DurAlignTextProcessor()):
        self.text_cleaner = text_cleaner
        self.text_normalizer = text_normalizer
        self.phonifier = phonifier
        self.text_phrasefier = text_phrasefier
        self.post_processor = post_processor



class TTSDurAlignPreprocessor(SharedInit):
    # def __init__(self,
    #             text_cleaner = TextCleaner(),
    #             text_normalizer=TextNormalizer(),
    #             phonifier = Phonifier(),
    #             post_processor = DurAlignTextProcessor()):
    #     self.text_cleaner = text_cleaner
    #     self.text_normalizer = text_normalizer
    #     self.phonifier = phonifier
    #     self.post_processor = post_processor

    def preprocess(self, text, language, gender, phone_dictionary):
        # text = text.strip()
        #print(text)
        text = self.text_normalizer.numberToTextConverter(text, language)
        text = self.text_cleaner.clean(text)
        #print("cleaned text", text)
        # text = self.text_normalizer.insert_space(text)
        #text = self.text_normalizer.num2text(text, language)
        # print(text)
        text = self.text_normalizer.normalize(text, language)
        # print(text)
        phrasified_text = TextPhrasifier.phrasify(text)
        #print("phrased",phrasified_text)

        if language not in list(phone_dictionary.keys()):
            phone_dictionary = self.phonifier.load_lang_dict(language, phone_dictionary)

        #print(phone_dictionary.keys())

        phonified_text = self.phonifier.phonify(phrasified_text, language, gender, phone_dictionary)
        #print("phonetext",phonified_text)
        phonified_text = self.post_processor.textProcesor(phonified_text)
        #print(phonified_text)
        return phonified_text, phrasified_text

class TTSDurAlignPreprocessor_VTT(SharedInit):
    # def __init__(self,
    #             text_cleaner = TextCleaner(),
    #             text_normalizer=TextNormalizer(),
    #             phonifier = Phonifier(),
    #             post_processor = DurAlignTextProcessor()):
    #     self.text_cleaner = text_cleaner
    #     self.text_normalizer = text_normalizer
    #     self.phonifier = phonifier
    #     self.post_processor = post_processor

    def preprocess(self, text, language, gender):
        # text = text.strip()
        text = self.text_cleaner.clean_list(text)
        # text = self.text_normalizer.insert_space_list(text)
        text = self.text_normalizer.num2text_list(text, language)
        text = self.text_normalizer.normalize_list(text, language)
        phrasified_text = TextPhrasifier_List.phrasify(text)
        phonified_text = self.phonifier.phonify_list(phrasified_text, language, gender)
        phonified_text = self.post_processor.textProcesor_list(phonified_text)
        return phonified_text, phrasified_text


class CharTextPreprocessor(SharedInit):
    # def __init__(self,
    #             text_cleaner = TextCleaner(),
    #             text_normalizer=TextNormalizer()):
    #     self.text_cleaner = text_cleaner
    #     self.text_normalizer = text_normalizer

    def preprocess(self, text, language, gender=None, phone_dictionary=None):
        text = text.strip()
        text = self.text_normalizer.numberToTextConverter(text, language)
        text = self.text_cleaner.clean(text)
        # text = self.text_normalizer.insert_space(text)
        #text = self.text_normalizer.num2text(text, language)
        text = self.text_normalizer.normalize(text, language)
        phrasified_text = TextPhrasifier.phrasify(text)
        phonified_text = phrasified_text # No phonification for character TTS models
        return phonified_text, phrasified_text

class CharTextPreprocessor_VTT(SharedInit):
    # def __init__(self,
    #             text_cleaner = TextCleaner(),
    #             text_normalizer=TextNormalizer()
    #             ):
    #     self.text_cleaner = text_cleaner
    #     self.text_normalizer = text_normalizer

    def preprocess(self, text, language, gender=None):
        # text = text.strip()
        text = self.text_cleaner.clean_list(text)
        # text = self.text_normalizer.insert_space_list(text)
        text = self.text_normalizer.num2text_list(text, language)
        text = self.text_normalizer.normalize_list(text, language)
        phrasified_text = TextPhrasifier_List.phrasify(text)
        phonified_text = phrasified_text # No phonification for character TTS models
        return phonified_text, phrasified_text


class TTSPreprocessor(SharedInit):
    # def __init__(self,
    #             text_cleaner = TextCleaner(),
    #             text_normalizer=TextNormalizer(),
    #             phonifier = Phonifier(),
    #             text_phrasefier = TextPhrasifier(),
    #             post_processor = DurAlignTextProcessor()):
    #     self.text_cleaner = text_cleaner
    #     self.text_normalizer = text_normalizer
    #     self.phonifier = phonifier
    #     self.text_phrasefier = text_phrasefier
    #     self.post_processor = post_processor
        
    def preprocess(self, text, language, gender, phone_dictionary):
        text = text.strip()
        text = self.text_normalizer.numberToTextConverter(text, language)
        text = self.text_cleaner.clean(text)
        # text = self.text_normalizer.insert_space(text)
        #text = self.text_normalizer.num2text(text, language)
        text = self.text_normalizer.normalize(text, language)
        phrasified_text = TextPhrasifier.phrasify(text)
        if language not in list(phone_dictionary.keys()):
            phone_dictionary = self.phonifier.load_lang_dict(language, phone_dictionary)
        phonified_text = self.phonifier.phonify(phrasified_text, language, gender, phone_dictionary)
        #print(phonified_text)
        phonified_text = self.post_processor.textProcesorForEnglish(phonified_text)
        #print(phonified_text)
        return phonified_text, phrasified_text

class TTSPreprocessor_VTT(SharedInit):
    # def __init__(self,
    #             text_cleaner = TextCleaner(),
    #             text_normalizer=TextNormalizer(),
    #             phonifier = Phonifier(),
    #             text_phrasefier = TextPhrasifier_List()):
    #     self.text_cleaner = text_cleaner
    #     self.text_normalizer = text_normalizer
    #     self.phonifier = phonifier
    #     self.text_phrasefier = text_phrasefier

    def preprocess(self, text, language, gender):
        # print(f"Original text: {text}")
        text = self.text_cleaner.clean_list(text)
        # print(f"After text cleaner: {text}")
        # text = self.text_normalizer.insert_space_list(text)
        # print(f"After insert space: {text}")
        text = self.text_normalizer.num2text_list(text, language)
        # print(f"After num2text: {text}")
        text = self.text_normalizer.normalize_list(text, language)
        # print(f"After text normalizer: {text}")
        phrasified_text = TextPhrasifier_List.phrasify(text)
        # print(f"phrasified_text: {phrasified_text}")
        phonified_text = self.phonifier.phonify_list(phrasified_text, language, gender)
        # print(f"phonified_text: {phonified_text}")
        return phonified_text, phrasified_text
