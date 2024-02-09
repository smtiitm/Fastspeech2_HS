import sys
import os
import subprocess

def process_word(word, phone_file_name):
    with open('tempword', 'w') as tempword_file:
        tempword_file.write(word)

    
    os.system('python scripts/vul.py tempword 2> temp_output_string')

    output = ''
    out_str = ''

    with open('lists/out_word') as out_word_file:
        output = out_word_file.read()

    with open('temp_output_string') as temp_output_string_file:
        out_str = temp_output_string_file.read()

    if out_str != '':
        with open(f'{phone_file_name}.err', 'a') as err_file:
            err_file.write(word + '\n')
    else:
        with open(f'{phone_file_name}.words', 'a') as words_file:
            words_file.write(word + '\n')
        with open(f'{phone_file_name}.cls', 'a') as cls_file:
            cls_file.write(output + '\n')

    os.system('rm -rf phn tempword lists/tmp lists/nasal lists/trans_word lists/out_word')

def main():
    if len(sys.argv) != 5:
        print("Usage: python script.py unique_words output_file_name parser_path rand_num")
        sys.exit(1)

    unique_words = sys.argv[1]
    output_file_name = sys.argv[2]
    parser_path = sys.argv[3]
    rand_num = sys.argv[4]
    phone_file_name = 'phone_out_file'

    os.system(f'cp {unique_words} {parser_path}/')
    curr_path = os.getcwd()
    os.chdir(parser_path)

    os.system(f'rm {phone_file_name}.words {phone_file_name}.cls {phone_file_name}.err {phone_file_name}')
    os.system('rm -rf temp_output_string phn tempword lists/tmp lists/nasal lists/trans_word lists/out_word')

    with open(unique_words) as unique_words_file:
        for word in unique_words_file:
            process_word(word.strip(), phone_file_name)

    os.system(f'rm -rf temp_output_string phn tempword lists/tmp lists/nasal lists/trans_word lists/out_word')
    
    os.system(f'cp {phone_file_name}.cls {phone_file_name}')
    os.system(f'sed -i \'s/ /""/g\' {phone_file_name}')
    os.system(f'sed -i \'s/^/""/g\' {phone_file_name}')
    os.system(f'sed -i \'s/$/""/g\' {phone_file_name}')
    subprocess.run(['python', 'get_phone_mapped_text.py', phone_file_name])
    os.system(f'sed -i \'s/"//g\' {phone_file_name}')
    os.system(f'sed -i \'s/ //g\' {phone_file_name}')

    words_str = ''
    with open(f'{phone_file_name}.words') as words_file:
        words_str = words_file.read()

    if words_str != '':
        os.system(f'paste -d\'\\t\' {phone_file_name}.words {phone_file_name} > {output_file_name}')
    else:
        os.system(f'touch {output_file_name}')
    
    err_str = ''
    # with open(f'{phone_file_name}.err') as err_file:
    #     err_str = err_file.read()

    try:
        with open(f'{phone_file_name}.err') as err_file:
            err_str = err_file.read()
    except FileNotFoundError:
        # File not found, create the file
        with open(f'{phone_file_name}.err', 'w') as err_file:
            # Optionally, you can write some initial content to the file
            err_file.write(f'Error {FileNotFoundError}')

    # if err_str != '':
    #     os.system(f'bash phonify_wrapper.sh {parser_path}/{phone_file_name}.err {output_file_name}.err.out {rand_num} {curr_path}/ssn_parser/')
    #     os.system(f'cat {output_file_name}.err.out >> {output_file_name}')

    os.chdir(curr_path)

if __name__ == "__main__":
    main()
