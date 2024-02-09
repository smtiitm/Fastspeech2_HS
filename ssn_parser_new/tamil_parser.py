import shutil
import subprocess
import sys
import os

def main():
    if len(sys.argv) != 5:
        print("Usage: python script.py inp_file out_file rand_num ssn_parser_folder")
        sys.exit(1)
    

    inp_file = sys.argv[1]
    out_file = sys.argv[2]
    rand_num = sys.argv[3]
    ssn_parser_folder = sys.argv[4]

    new_folder = f"{ssn_parser_folder}_{rand_num}"
    
    # Copy the ssn_parser_folder to a new folder

    shutil.copytree(ssn_parser_folder, new_folder)

    # Run the non_parallel-parser.py script
    subprocess.run([
        "python",
        os.path.join(new_folder, "non_parallel-parser.py"),
        inp_file,
        out_file,
        new_folder,
        rand_num
    ])

    # Remove the temporary folder
    shutil.rmtree(new_folder)

if __name__ == "__main__":
    main()
