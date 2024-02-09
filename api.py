# TTS IITM SPEECH LAB
import requests
import json
import base64
  
text = "सुप्रभात, आप कैसे हैं?" # hindi
# text = "സുപ്രഭാതം, സുഖമാ?" # malayalam
# text = "সুপ্ৰভাত, তুমি কেনে?" # manipuri
# text = "सुप्रभात, तुम्ही कसे आहात?" # marathi
# text = "ಶುಭೋದಯ, ನೀವು ಹೇಗಿದ್ದೀರಿ?" # kannada
# text = "बसु म्विथ्बो, बरि दिबाबो?" # bodo male not working <---
# text = "Good morning, how are you?" # english
# text = "সুপ্ৰভাত, আপুনি কেমন আছে?" # assamese
# text = "காலை வணக்கம், நீங்கள் எப்படி இருக்கின்றீர்கள்?" # tamil
# text = "ସୁପ୍ରଭାତ, ଆପଣ କେମିତି ଅଛନ୍ତି?" # odia male not working <---
# text = "सुप्रभात, आप कैसे छो?" # rajasthani
# text = "శుభోదయం, మీరు ఎలా ఉన్నారు?" # telugu
# text = "সুপ্রভাত, আপনি কেমন আছেন?" # bengali male not working <---
# text = "સુપ્રભાત, તમે કેમ છો?" # gujarati

lang = 'hindi'
gender = 'female'

url = "http://localhost:4005/tts"
# url = 'http://projects.respark.iitm.ac.in:8009/tts' # proxy

payload = json.dumps({
"input": text,
"gender": gender,
"lang": lang,
"alpha": 1,
"segmentwise":"True"
})
headers = {'Content-Type': 'application/json'}
response = requests.request("POST", url, headers=headers, data=payload).json()

audio = response['audio']
file_name = "tts.mp3"
wav_file = open(file_name,'wb')
decode_string = base64.b64decode(audio)
wav_file.write(decode_string)
wav_file.close()

'''
Supported languages

Assamese
Bengali
Bodo
English
Gujarati
Hindi
Kannada
Malayalam
Manipuri
Marathi
Odia
Punjabi
Rajasthani
Tamil
Telugu
Urdu
'''
