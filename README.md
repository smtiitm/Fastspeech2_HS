# Fastspeech2 Model using Hybrid Segmentation (HS)

This repository contains a Fastspeech2 Model for 16 Indian languages (male and female both) implemented using the Hybrid Segmentation (HS) for speech synthesis. The model is capable of generating mel-spectrograms from text inputs and can be used to synthesize speech..

The Repo is large in size. Directly go to the next Installation part. <s>We have used [Git LFS](https://git-lfs.com/) due to Github's size constraint (please install latest git LFS from the link, we have provided the current one below).
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
to get the original files in your directory. </s>

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
pip install numpy==1.23.0
```
## Vocoder
For generating WAV files from mel-spectrograms, you can use a vocoder of your choice. One popular option is the [HIFIGAN](https://github.com/jik876/hifi-gan) vocoder (Clone this repo and put it in the current working directory). Please refer to the documentation of the vocoder you choose for installation and usage instructions. 

(**We have used the HIFIGAN vocoder and have provided Vocoder tuned on Aryan and Dravidian languages**)

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


### Citation
If you use this Fastspeech2 Model in your research or work, please consider citing:

“
COPYRIGHT
2023, Speech Technology Consortium,

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
