import sys
import fileinput

# ,"":"","":""

confusionSet = {"ऩ":"ऩ","ऩ":"ऩ","ऱ":"ऱ","ऱ":"ऱ","क़":"क़","क़":"क़","ख़":"ख़","ख़":"ख़","ग़":"ग़","ग़":"ग़","ज़":"ज़","ज़":"ज़","ड़":"ड़","ड़":"ड़","ढ़":"ढ़","ढ़":"ढ़","फ़":"फ़","फ़":"फ़","य़":"य़","य़":"य़","ऴ":"ऴ","ऴ":"ऴ","ொ":"ொ","ொ":"ொ","ோ":"ோ","ோ":"ோ","ൊ":"ൊ","ൊ":"ൊ","ോ":"ോ","ോ":"ോ","ല്‍‌":"ൽ","ൽ":"ല്‍‌","ള്‍":"ൾ","ൾ":"ള്‍","ര്‍":"ർ","ർ":"ര്‍","ന്‍":"ൻ","ൻ":"ന്‍","ണ്‍":"ൺ","ൺ":"ണ്‍"}
phoneDict = {}

# phone_map_file="map_888.txt"
phone_map_file=sys.argv[1]

# text_file="replace_in.txt"
text_file=sys.argv[2]

base_path=sys.argv[3]
unifParFold=base_path+'/unified_parser'
randNum=sys.argv[4]

for lines in open(phone_map_file,'r'):
	line = lines.split(' ')
	phoneDict[line[0]]=line[1].strip()

# print(phoneDict)

# for line in fileinput.input(text_file, inplace=True):
# 	line = line.replace("ड़","ड़")
# 	line = line.strip()+' '
# 	for f_key, f_value in phoneDict.items():
# 		if ' '+f_key+' ' in line:
# 			# print(f_key+' '+f_value)
# 			line = line.replace(' '+f_key+' ', ' '+f_value+' ')
# 			line = line.replace(' '+f_key+' ', ' '+f_value+' ')
# 	print(line.strip())

for line in fileinput.input(text_file, inplace=True):
	words = line.strip().split(' ')
	phones = []
	for word in words[1:]:
		if word in phoneDict.keys():
			phones.append(phoneDict[word])
		else:
			flag=0
			for confusionCharKey, confusionCharVal in confusionSet.items():
				if confusionCharKey in word:
					word = word.replace(confusionCharKey, confusionCharVal)
					if word in phoneDict.keys():
						phones.append(phoneDict[word])
						flag=1
						break
					else:
						word = word.replace(confusionCharVal, confusionCharKey)
			if flag==0:
				sys.exit("Word '"+word+"' not found in map")
	phones.insert(0,words[0])
	line = " ".join(phones)
	print(line.strip())

