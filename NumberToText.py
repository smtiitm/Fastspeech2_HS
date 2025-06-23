import os
import csv

class NumberDictionary:
    def __init__(self):
        directoryPath = "numToText"
        # print(directoryPath)
        languages = self.get_filenames_in_folder(directoryPath)
        # print(languages, directoryPath)
        self.lang_num_dictionary = self.load_language_dictionary(directoryPath, languages)
        # print(self.lang_num_dictionary)

        

    def get_filenames_in_folder(self,folder_path):
        file_list = []
        
        # Loop through the files in the directory
        for filename in os.listdir(folder_path):
            # Check if it's a file (not a subdirectory)
            if os.path.isfile(os.path.join(folder_path, filename)):
                file_list.append(filename[:-4])
        
        return file_list


    def load_language_dictionary(self, directory_path, file_names):
        lang_num_dictionary = {}

        for file_name in file_names:
            language = os.path.splitext(file_name)[0]
            file_path = os.path.join(directory_path, f"{file_name}.csv")
            if not os.path.exists(file_path):
                # print(f"File '{file_path}' not found. Skipping...")
                continue

            with open(file_path, 'r', encoding='utf-8') as file:
                reader = csv.reader(file)
                language_map = {row[0].strip(): row[1].strip() for row in reader}

            lang_num_dictionary[language] = language_map

        return lang_num_dictionary

    def num2text(self, input_str, language):
        if language not in self.lang_num_dictionary:
            return "Language not supported."

        integer_part, *decimal_part = input_str.split('.')
        try:
            int_part = int(integer_part)
        except ValueError:
            return "Invalid input. Please provide a valid number."

        if int_part < 0 or int_part > 999999999999999:
            return "Number out of range (0-999999999999999)"

        lang_map = self.lang_num_dictionary[language]
        integer_text = self.convert_to_indian_number(int_part, lang_map)

        if decimal_part:
            decimal_text = lang_map.get('.', '') + ' '
            for digit in decimal_part[0]:
                decimal_text += lang_map.get(digit, '') + ' '
            return (integer_text + ' ' + decimal_text).strip()
        else:
            return integer_text.strip()

    def convert_to_indian_number(self, n, lang_map):
        numeric_keys = [key for key in lang_map.keys() if key.isdigit()]  # Filter numeric keys
        if n <= 20 or (n <= 100 and str(n) in lang_map):
            return lang_map.get(str(n), '')
        elif n < 1000:
            result = f"{lang_map.get(str(n // 100), '')} {lang_map.get('100', '')}"
            if n % 100 != 0:
                result += f" {self.convert_to_indian_number(n % 100, lang_map)}"
            return result.strip()
        else:
            base, term = 0, ''
            for key in sorted(numeric_keys, key=int, reverse=True):  # Sort only numeric keys
                if n >= int(key):
                    base = int(key)
                    term = lang_map[key]
                    break

            if n % base == 0:
                return f"{self.convert_to_indian_number(n // base, lang_map)} {term}"
            else:
                return f"{self.convert_to_indian_number(n // base, lang_map)} {term} {self.convert_to_indian_number(n % base, lang_map)}"




# number_dict = NumberDictionary()
# result = number_dict.num2text("2000048.145", "gujarati")
# print(result)
