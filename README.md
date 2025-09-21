# Latest Fastspeech2 Models using FLAT Start

This repository branch `(New-Models)` contains new and high quality Fastspeech2 Models for Indian languages implemented using the Flat Start for speech synthesis. The models are capable of generating mel-spectrograms from text inputs and can be used to synthesize speech. 

**NOTE: The main branch became large in size and underwent few changes in the inference and preprocessing scripts, necessitating the creation of a separate branch. Training information and the script will be shared after further code optimization and footprint reduction.**

Clone this branch using the command:

```
git clone -b New-Models --single-branch https://github.com/smtiitm/Fastspeech2_HS.git
```

The Repo is large in size. New Models are in "language"_latest folder.

Supported languages: Assamese, Bengali, Bodo, Dogri, Gujarati, Hindi, Kannada, Konkani(Maharashtrian), Maithili, Malayalam, Manipuri, Nepali, Punjabi, Rajasthani, Sanskrit, Tamil, Telugu.


## Model Files

The model for each language includes the following files:

- `config.yaml`: Configuration file for the Fastspeech2 Model.
- `energy_stats.npz`: Energy statistics for normalization during synthesis.
- `feats_stats.npz`: Features statistics for normalization during synthesis.
- `feats_type`: Features type information.
- `pitch_stats.npz`: Pitch statistics for normalization during synthesis.
- `model.pth`: Pre-trained Fastspeech2 model weights.

## Installation

1. Install [Miniconda](https://docs.conda.io/projects/miniconda/en/latest/) first. Create a conda environment using the provided `environment.yml` file:

```shell
conda env create -f environment.yml
```

2.Activate the conda environment (check inside environment.yaml file):
```shell
conda activate tts-hs-hifigan
```

3.  Install PyTorch separately (you can install the specific version based on your requirements):
```shell
conda install pytorch cudatoolkit
pip install torchaudio
```
## Vocoder
For generating WAV files from mel-spectrograms, you can use a vocoder of your choice. One popular option is the [HIFIGAN](https://github.com/jik876/hifi-gan) vocoder (Clone this repo and put it in the current working directory). Please refer to the documentation of the vocoder you choose for installation and usage instructions. 

(**We have used the HIFIGAN V1 vocoder and have provided Vocoder for few languages in the Vocoder folder. If needed, make sure to adjust the path in the inference file.**)

## Usage

The directory paths are Relative. ( But if needed, Make changes to **text_preprocess_for_inference.py** and **inference.py** file, Update folder/file paths wherever required.)

**Please give language/gender in small cases and sample text between quotes. Adjust output speed using the alpha parameter (higher for slow voiced output and vice versa). Output argument is optional; the provide name will be used for the output file.** 

Use the inference file to synthesize speech from text inputs:
```shell
python inference.py --sample_text "Your input text here" --language <language> --gender <gender> --alpha <alpha> --output_file <file_name.wav OR path/to/file_name.wav>
```

**Example:**

```
python inference.py --sample_text "श्रीलंका और पाकिस्तान में खेला जा रहा एशिया कप अब तक का सबसे विवादित टूर्नामेंट होता जा रहा है।" --language hindi_latest --gender male --alpha 1 --output_file male_hindi_output.wav
```
The file will be stored as `male_hindi_output.wav` and will be inside current working directory. If **--output_file** argument is not given it will be stored as `<language>_<gender>_output.wav` in the current working directory.

**Use "language"_latest in --language to use latest models.**

---

## New Update: Alpha & Silence Tags

We now support fine-grained control of **speech rate** and **pauses** directly from the input text. 

USE the `inference_w_sil_alpha.py` file.

Note: The code uses regex, make sure there is no space inside the tag.

---

## 1. Speed Control with `<alpha>`

You can locally adjust the speech rate inside your text:

```text
This is normal speed. <alpha=1.2> This part will be slower. <alpha=0.8> And this part will be faster.
````

* `alpha=1.0` → default (normal speed)
* `<1.0` → Faster speech
* `>1.0` → Slower speech

---

## 2. Silence Control with `<sil>`

You can insert pauses of arbitrary duration:

```text
This is the first sentence. <sil=500ms> This comes after a short pause. <sil=2s> Now a longer pause before continuing.
```

* `<sil=500ms>` → half a second pause
* `<sil=2s>` → two second pause

---

## 3. Combining Alpha and Silence

Both controls can be mixed naturally:

```text
<alpha=0.8> તું kaam કર, પછી <sil=50ms> क्रिकेट <alpha=1> ખેલેંગે.
```

This example will:

* Become fast at `<alpha=0.8>`
* Insert 50ms of silence
* Resume at default speed afterwards

---



### Citation
If you use this Fastspeech2 Model in your research or work, please consider citing:

“
COPYRIGHT
2025, Speech Technology Consortium,

Bhashini, MeiTY and by Hema A Murthy & S Umesh,


DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING
and
ELECTRICAL ENGINEERING,
IIT MADRAS. ALL RIGHTS RESERVED "



Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
