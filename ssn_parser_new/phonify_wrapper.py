import os
import subprocess

def main():
    inpFile = sys.argv[1]
    outFile = sys.argv[2]
    randNum = sys.argv[3]
    basePath = sys.argv[4]
    currPath = os.getcwd()
    unifParFold = os.path.join(basePath, 'unified_parser')
    uniParOut = f'.uniOut_{randNum}.txt'
    uniParList = inpFile
    uniParTemp = f'.uniTemp_{randNum}.txt'
    
    print("The data is successfully reached")
    os.chdir(unifParFold)
    os.mkdir(f'uniPar_{randNum}')
    
    nj = int(subprocess.check_output(['wc', '-l', inpFile]).decode().split()[0])  # number of parallel jobs
    if nj > 48:
        nj = 48
    
    with open(uniParList, 'r') as infile:
        with open(uniParTemp, 'w') as tempfile:
            for i, line in enumerate(infile, start=1):
                tempfile.write(f"{line.rstrip()}\tuniPar_{randNum}/word_{i:04d}.txt\n")
    
    command = f"awk '{{printf \"%s\\tuniPar_{randNum}/word_%04d.txt\\n\", $0, NR}}' {uniParList} | \
               parallel -j {nj} --colsep '\t' 'valgrind ./unified-parser {{1}} {{2}} 1 0 0 0 > /dev/null 2> /dev/null' > /dev/null 2> /dev/null"
    subprocess.run(command, shell=True, check=True)
    
    os.system(f"cat uniPar_{randNum}/*.txt > {uniParTemp}")
    os.rmdir(f'uniPar_{randNum}')
    
    subprocess.run(['bash', 'get_phone_mapped_text_updated.sh', uniParTemp, uniParOut])
    
    os.system(f"sed -i \"s:^(set! wordstruct '::g\" {uniParOut}")
    os.system(f"sed -i 's:[)(\"0 ]::g' {uniParOut}")
    
    command = f"paste -d' ' {uniParList} {uniParOut} >> {outFile}"
    os.system(command)
    
    os.remove(uniParTemp)
    os.remove(uniParOut)
    
    os.chdir(currPath)

if __name__ == "__main__":
    import sys
    main()
