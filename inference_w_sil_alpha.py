import sys
import os
#replace the path with your hifigan path to import Generator from models.py 
sys.path.append("hifigan")
import argparse
import torch
from espnet2.bin.tts_inference import Text2Speech
from models import Generator
from scipy.io.wavfile import write
from meldataset import MAX_WAV_VALUE
from env import AttrDict
import json
import yaml
import concurrent.futures
import numpy as np
import time
import re

from text_preprocess_for_inference import TTSDurAlignPreprocessor, CharTextPreprocessor, TTSPreprocessor

SAMPLING_RATE = 22050

def load_hifigan_vocoder(language, gender, device):
    # Load HiFi-GAN vocoder configuration file and generator model for the specified language and gender
    vocoder_config = f"vocoder/{gender}/{language}/config.json"
    vocoder_generator = f"vocoder/{gender}/{language}/generator"
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

def text_synthesis(language, gender, sample_text, vocoder, model, MAX_WAV_VALUE, device, alpha):
    # Perform Text-to-Speech synthesis
    with torch.no_grad():
        # Load the FastSpeech2 model for the specified language and gender
        
        # model = load_fastspeech2_model(language, gender, device)

       
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
    
def split_into_chunks(text, words_per_chunk=100):
    words = text.split()
    chunks = [words[i:i + words_per_chunk] for i in range(0, len(words), words_per_chunk)]
    return [' '.join(chunk) for chunk in chunks]




def extract_text_alpha_chunks(text, default_alpha=1.0):
    alpha_pattern = r"<alpha=([0-9.]+)>"
    sil_pattern = r"<sil=([0-9.]+)(ms|s)>"

    chunks = []
    alpha = default_alpha

    alpha_blocks = re.split(alpha_pattern, text)
    i = 0
    while i < len(alpha_blocks):
        if i == 0:
            current_block = alpha_blocks[i]
            i += 1
        else:
            alpha = float(alpha_blocks[i])
            i += 1
            current_block = alpha_blocks[i] if i < len(alpha_blocks) else ""
            i += 1

        sil_matches = list(re.finditer(sil_pattern, current_block))
        sil_placeholders = {}
        for j, match in enumerate(sil_matches):
            tag = match.group(0)
            value = float(match.group(1))
            unit = match.group(2)
            duration = value / 1000.0 if unit == "ms" else value
            placeholder = f"__SIL_{j}__"
            sil_placeholders[placeholder] = duration
            current_block = current_block.replace(tag, f" {placeholder} ")

        sentences = [s.strip() for s in current_block.split('.') if s.strip()]
        for sentence in sentences:
            words = sentence.split()
            buffer = []
            for word in words:
                if word in sil_placeholders:
                    if buffer:
                        chunks.append((" ".join(buffer), alpha, False, None))
                        buffer = []
                    chunks.append(("", alpha, True, sil_placeholders[word]))
                else:
                    buffer.append(word)
            if buffer:
                chunks.append((" ".join(buffer), alpha, False, None))
    return chunks



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Text-to-Speech Inference")
    parser.add_argument("--language", type=str, required=True, help="Language (e.g., hindi)")
    parser.add_argument("--gender", type=str, required=True, help="Gender (e.g., female)")
    parser.add_argument("--sample_text", type=str, required=True, help="Text to be synthesized")
    parser.add_argument("--output_file", type=str, default="", help="Output WAV file path")
    parser.add_argument("--alpha", type=float, default=1, help="Alpha Parameter for speed control (e.g. 1.1 (slow) or 0.8 (fast))")

    args = parser.parse_args()

    phone_dictionary = {}
    # Set the device
    device = "cuda" if torch.cuda.is_available() else "cpu"

    # Load the HiFi-GAN vocoder with dynamic language and gender
    vocoder = load_hifigan_vocoder(args.language, args.gender, device)
    model = load_fastspeech2_model(args.language, args.gender, device)
    if args.language == "urdu" or args.language == "punjabi":
            preprocessor = CharTextPreprocessor()
    elif args.language == "english":
            preprocessor = TTSPreprocessor()
    else:
            preprocessor = TTSDurAlignPreprocessor()



    start_time = time.time()
    audio_arr = [] 
    result = split_into_chunks(args.sample_text)
    text_alpha_chunks = extract_text_alpha_chunks(args.sample_text, args.alpha)

    with concurrent.futures.ThreadPoolExecutor() as executor:
            futures = []
            for chunk_text, alpha_val, is_silence, sil_duration in text_alpha_chunks:
                if is_silence:
                    silence_samples = int(sil_duration * SAMPLING_RATE)
                    silence_audio = np.zeros(silence_samples, dtype=np.int16)
                    futures.append(silence_audio)
                else:
                    preprocessed_text, _ = preprocessor.preprocess(chunk_text, args.language, args.gender, phone_dictionary)
                    preprocessed_text = " ".join(preprocessed_text)
                    future = executor.submit(
                        text_synthesis, args.language, args.gender, preprocessed_text,
                        vocoder, model, MAX_WAV_VALUE, device, alpha_val
                    )
                    futures.append(future)

            for item in futures:
                if isinstance(item, np.ndarray):
                    audio_arr.append(item)
                else:
                    audio_arr.append(item.result())

    result_array = np.concatenate(audio_arr, axis=0)
    output_file = args.output_file if args.output_file else f"{args.language}_{args.gender}_output.wav"
    write(output_file, SAMPLING_RATE, result_array)
    print(f"Synthesis completed in {time.time()-start_time:.2f} sec → {output_file}")   
