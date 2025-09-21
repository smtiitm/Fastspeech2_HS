# Fastspeech2 Model using Hybrid Segmentation (HS)

This repository contains a [Fastspeech2](https://arxiv.org/abs/2006.04558) Model for 16 Indian languages (male and female both) implemented using the [Hybrid Segmentation](https://www.isca-archive.org/interspeech_2014/shanmugam14_interspeech.pdf) (HS) for speech synthesis. The model is capable of generating mel-spectrograms from text inputs and can be used to synthesize speech. The Architecture of FS2:
![image](https://github.com/user-attachments/assets/61128598-c1b9-4b64-84eb-e14f07f598ac) Image Source ([Fastspeech2](https://arxiv.org/abs/2006.04558))


As requested, here is the details of FS2 architecture:

Fs2 is composed of 6 feed-forward Transformer blocks with multi-head self-attention and 1D convolution on both phoneme encoder and mel-spectrogram decoder. In each feed-forward Transformer, the hidden size of multi-head attention is set to 256 and the number of head is set to 2. The kernel size of 1D convolution in the two-layer convolution network is set to 9 and 1, and the input/output size of the number of channels in the first and the second layer is 256/1024 and 1024/256. The duration predictor and variance adaptor, which are composed of stacks of several convolution networks and the final linear projection layer. The convolution layers of the duration predictor and variance adaptor are set to 2 and 5, the kernel size is set to 3, the input/output size of all layers is 256/256, and the dropout rate is set to 0.5. 

The Repo is large in size. We have used [Git LFS](https://git-lfs.com/) due to Github's size constraint (please install latest git LFS from the link, we have provided the current one below).


```
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.python.sh | bash
sudo apt-get install git-lfs
git lfs install
```

Language model files are uploaded using git LFS. so please use:

```
git lfs fetch --all
git lfs pull
```
to get the original files in your directory.

### NOTE:  NEw HQ Models are available now in separate branch.

## Model Files

The model for each language includes the following files:

- `config.yaml`: Configuration file for the Fastspeech2 Model.
- `energy_stats.npz`: Energy statistics for normalization during synthesis.
- `feats_stats.npz`: Features statistics for normalization during synthesis.
- `feats_type`: Features type information.
- `pitch_stats.npz`: Pitch statistics for normalization during synthesis.
- `model.pth`: Pre-trained Fastspeech2 model weights.

## Installation

1. Install [Miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install#linux-2) first. Create a conda environment using the provided `environment.yml` file:

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

(**We have used the HIFIGAN vocoder and have provided Vocoder for Aryan and Dravidian languages**)

## Usage

The directory paths are Relative. ( But if needed, Make changes to **text_preprocess_for_inference.py** and **inference.py** file, Update folder/file paths wherever required.)

**Please give language/gender in small cases and sample text between quotes. Adjust output speed using the alpha parameter (higher for slow voiced output and vice versa). Output argument is optional; the provide name will be used for the output file.** 

Use the inference file to synthesize speech from text inputs:
```shell
python inference.py --sample_text "Your input text here" --language <language> --gender <gender> --alpha <alpha> --output_file <file_name.wav OR path/to/file_name.wav>
```

**Example:**

```
python inference.py --sample_text "श्रीलंका और पाकिस्तान में खेला जा रहा एशिया कप अब तक का सबसे विवादित टूर्नामेंट होता जा रहा है।" --language hindi --gender male --alpha 1 --output_file male_hindi_output.wav
```
The file will be stored as `male_hindi_output.wav` and will be inside current working directory. If **--output_file** argument is not given it will be stored as `<language>_<gender>_output.wav` in the current working directory.

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

## IndicTTS Models Language Coverage

### Legend:
- ✅ = Available
- ⬜ = Not available / To-do

| Language       | Gender | 22kHz(Old models - main Branch) | 48kHz (New HQ models - New-models branch) | Notes               |
|----------------|--------|-------|--------|----------------------|
| Assamese       | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Bengali        | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ⬜     | Female Model had training issues                     |
| Bodo           | Male   | ⬜     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Dogri          | Male   | ⬜     | ✅     |                      |
|                | Female | ⬜     | ✅     |                      |
| Gujarati       | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Hindi          | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Kannada        | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Kashmiri       | Male   | ⬜     | ⬜     |   Pending Data Verification                  |
|                | Female | ⬜     | ⬜     |   Pending Data Verification                  |
| Konkani        | Male   | ⬜     | ✅     |                      |
|                | Female | ⬜     | ✅     |                      |
| Maithili       | Male   | ⬜     | ✅     |                      |
|                | Female | ⬜     | ✅     |                      |
| Malayalam      | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Manipuri       | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Marathi        | Male   | ✅     | ✅     |                     |
|                | Female | ✅     | ✅     |                    |
| Nepali         | Male   | ⬜     | ✅     |                      |
|                | Female | ⬜     | ✅     |                      |
| Odia           | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅️     |                     |
| Punjabi        | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Rajasthani        | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Sanskrit       | Male   | ⬜     | ✅     |                      |
|                | Female | ⬜     | ✅     |                      |
| Sindhi         | Male   | ⬜     | ⬜️     | Pending Data Verification                    |
|                | Female | ⬜️     | ⬜️     | Pending Data Verification                     |
| Tamil          | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Telugu         | Male   | ✅     | ✅     |                      |
|                | Female | ✅     | ✅     |                      |
| Urdu           | Male   | ✅     | ⬜️     |   Data collection in progress                   |
|                | Female | ✅     | ⬜️     |   Data collection in progress                   |




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
