from flask import Flask, render_template, request, send_file, jsonify
import requests
import json
import ssl
import logging
import sys
import os
import base64
import io
#replace the path with your hifigan path to import Generator from models.py 
sys.path.append("hifigan")
# import argparse
import torch
from espnet2.bin.tts_inference import Text2Speech
from models import Generator
from scipy.io.wavfile import write
from meldataset import MAX_WAV_VALUE
from env import AttrDict
import json
import yaml
from text_preprocess_for_inference import TTSDurAlignPreprocessor
# import time

logging.basicConfig(filename='access.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

SAMPLING_RATE = 22050
if torch.cuda.is_available():
    device = "cuda"
else:
    device = "cpu"

preprocessor = TTSDurAlignPreprocessor()

app = Flask(__name__)
# app.config['SECRET_KEY'] = 'key'
# socketio = SocketIO(app)

# @socketio.on('new_user')
# def handle_new_user(data):
#     client_id = data['id']
#     # print('\n'+f"New user connected with ID: {client_id}")
#     logging.info('\n'+f"New user connected with ID: {client_id}")

def load_hifigan_vocoder(language, gender, device):
    # Load HiFi-GAN vocoder configuration file and generator model for the specified language and gender
    vocoder_config = f"vocoder/{gender}/aryan/hifigan/config.json"
    vocoder_generator = f"vocoder/{gender}/aryan/hifigan/generator"
    # Read the contents of the vocoder configuration file
    with open(vocoder_config, 'r') as f:
        data = f.read()
    json_config = json.loads(data)
    h = AttrDict(json_config)
    torch.manual_seed(h.seed)
    # Move the generator model to the specified device (CPU or GPU)
    device = torch.device(device)
    generator = Generator(h).to(device)
    state_dict_g = torch.load(vocoder_generator, device)
    generator.load_state_dict(state_dict_g['generator'])
    generator.eval()
    generator.remove_weight_norm()

    # Return the loaded and prepared HiFi-GAN generator model
    return generator

def load_fastspeech2_model(language, gender, device):
    
    #updating the config.yaml fiel based on language and gender
    with open(f"{language}/{gender}/model/config.yaml", "r") as file:      
     config = yaml.safe_load(file)
    
    current_working_directory = os.getcwd()
    feat="model/feats_stats.npz"
    pitch="model/pitch_stats.npz"
    energy="model/energy_stats.npz"
    
    feat_path=os.path.join(current_working_directory,language,gender,feat)
    pitch_path=os.path.join(current_working_directory,language,gender,pitch)
    energy_path=os.path.join(current_working_directory,language,gender,energy)

    
    config["normalize_conf"]["stats_file"]  = feat_path
    config["pitch_normalize_conf"]["stats_file"]  = pitch_path
    config["energy_normalize_conf"]["stats_file"]  = energy_path
        
    with open(f"{language}/{gender}/model/config.yaml", "w") as file:
        yaml.dump(config, file)
    
    tts_model = f"{language}/{gender}/model/model.pth"
    tts_config = f"{language}/{gender}/model/config.yaml"
    
    
    return Text2Speech(train_config=tts_config, model_file=tts_model, device=device)

def text_synthesis(language, gender, sample_text, vocoder, MAX_WAV_VALUE, device, alpha=1):
    # Perform Text-to-Speech synthesis
    with torch.no_grad():
        # Load the FastSpeech2 model for the specified language and gender
        
        model = load_fastspeech2_model(language, gender, device)
       
        # Generate mel-spectrograms from the input text using the FastSpeech2 model
        out = model(sample_text, decode_conf={"alpha": alpha})
        print("TTS Done")  
        x = out["feat_gen_denorm"].T.unsqueeze(0) * 2.3262
        x = x.to(device)
        
        # Use the HiFi-GAN vocoder to convert mel-spectrograms to raw audio waveforms
        y_g_hat = vocoder(x)
        audio = y_g_hat.squeeze()
        audio = audio * MAX_WAV_VALUE
        audio = audio.cpu().numpy().astype('int16')
        
        # Return the synthesized audio
        return audio

def setup_app():
    genders = ['male','female']
    # to make dummy calls in all languages available
    languages = {'hindi': "नमस्ते",'malayalam': "ഹലോ",'manipuri': "হ্যালো",'marathi': "हॅलो",'kannada': "ಹಲೋ",'bodo': "हॅलो",'english': "Hello",'assamese': "হ্যালো",'tamil': "ஹலோ",'odia': "ହେଲୋ",'rajasthani': "हॅलो",'telugu': "హలో",'bengali': "হ্যালো",'gujarati': "હલો"}
    
    vocoders = {}
    for gender in genders:
        vocoders[gender]={}
        for language,text in languages.items():
            # Load the HiFi-GAN vocoder with dynamic language and gender
            vocoder = load_hifigan_vocoder(language, gender, device)
            vocoders[gender][language] = vocoder
            # dummy calls
            print(f"making dummy calls for {language} - {gender}")
            try:
                out = text_synthesis(language, gender, text, vocoder, MAX_WAV_VALUE, device)
            except:
                message = f"cannot make dummy call for {gender} - {language} <==================="
                print(message.upper())
                
    print("Server Started...")
    return vocoders
vocoders = setup_app()

@app.route('/', methods=['GET'])
def main():
    return "IITM_TTS_V2"

@app.route('/tts', methods=['GET', 'POST'], strict_slashes=False)
def tts():
    try:
        json_data = request.get_json()
        text = json_data["input"]
        if not isinstance(text,str):
            input_type = type(text)
            ret = jsonify(status='failure', reason=f"Unsupported input type {input_type}. Input text should be in string format.")
        gender = json_data["gender"]
        language = json_data["lang"].lower()
        alpha = json_data["alpha"]
        # Preprocess the sample text
        preprocessed_text, phrases = preprocessor.preprocess(text, language, gender)
        preprocessed_text = " ".join(preprocessed_text)
        vocoder = vocoders[gender][language]
        out = text_synthesis(language, gender, preprocessed_text, vocoder, MAX_WAV_VALUE, device, alpha=alpha)
        
        # output_file = f"{language}_{gender}_output.wav"
        # write(output_file, SAMPLING_RATE, out)
        # audio_wav_bytes = base64.b64encode(open(output_file, "rb").read())

        # avoid saving file on disk
        output_stream = io.BytesIO()
        write(output_stream, SAMPLING_RATE, out)
        audio_wav_bytes = base64.b64encode(output_stream.getvalue())

        ret = jsonify(status="success",audio=audio_wav_bytes.decode('utf-8'))

    except Exception as err:
        ret = jsonify(status="failure", reason=str(err))
    return ret

if __name__ == '__main__':
    # ssl_context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    # ssl_context.load_cert_chain('./ssl2023/iitm2022.crt','./ssl2023/iitm2022.key')
    app.run(host='0.0.0.0', port=4005, debug=True)