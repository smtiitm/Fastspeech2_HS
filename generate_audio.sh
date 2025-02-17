#!/bin/bash

# Define paths
TEXT_FILES_DIR="TextFiles"
AUDIO_FILES_DIR="AudioFiles"

# List of languages (modify as needed)
#LANGUAGES=("Bengali" "Kannada" "Gujarati" "Tamil" "Telugu" "Malayalam")
LANGUAGES=("Punjabi")
# Iterate over the list of languages
for lang in "${LANGUAGES[@]}"; do
  # Check if the corresponding text file exists
  text_file="${TEXT_FILES_DIR}/${lang}.txt"
  
  if [ ! -f "$text_file" ]; then
    echo "Warning: Text file for language '$lang' not found: $text_file"
    continue
  fi
  
  # Read each line in the text file
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Extract BlockID, SentenceID, and Sentence
    blockID=$(echo "$line" | awk '{print $1}')       # First word is BlockID
    sentenceID=$(echo "$line" | awk '{print $2}')    # Second word is SentenceID
    sentence=$(echo "$line" | cut -d' ' -f3-)        # Rest of the line is Sentence
    
    # Create a directory for the block inside the language folder
    block_folder="${AUDIO_FILES_DIR}/${lang}/Sentences_Block_${blockID}"
    mkdir -p "$block_folder"
    
    # Convert language name to lowercase
    lang_lower=$(echo "$lang" | tr '[:upper:]' '[:lower:]')
    
    # Generate output file name
    output_file="${block_folder}/${lang}_sentence_${blockID}_${sentenceID}.wav"
    
    # Run the inference command
    python inference.py --sample_text "$sentence" --language "${lang_lower}_latest" --gender male --output_file "$output_file"
    
    # Print status
    echo "Generated: $output_file"
  done < "$text_file"
done

echo "All audio files for the given languages and blocks have been generated."

#!/bin/bash

# # Define paths
# TEXT_FILES_DIR="TextFiles"
# AUDIO_FILES_DIR="AudioFiles"

# # List of languages (modify as needed)
# LANGUAGES=("Marathi")

# # Iterate over the list of languages
# for lang in "${LANGUAGES[@]}"; do
#   # Check if the corresponding text file exists
#   text_file="${TEXT_FILES_DIR}/${lang}.txt"
  
#   if [ ! -f "$text_file" ]; then
#     echo "Warning: Text file for language '$lang' not found: $text_file"
#     continue
#   fi
  
#   # Read each line in the text file
#   while IFS= read -r line || [[ -n "$line" ]]; do
#     # Extract BlockID, SentenceID, and Sentence
#     blockID=$(echo "$line" | awk '{print $1}')       # First word is BlockID
#     sentenceID=$(echo "$line" | awk '{print $2}')    # Second word is SentenceID
#     sentence=$(echo "$line" | cut -d' ' -f3-)        # Rest of the line is Sentence
    
#     # Create a directory for the block inside the language folder
#     block_folder="${AUDIO_FILES_DIR}/${lang}/Sentences_Block_${blockID}"
#     mkdir -p "$block_folder"
    
#     # Convert language name to lowercase
#     lang_lower=$(echo "$lang" | tr '[:upper:]' '[:lower:]')
    
#     # Generate output file name
#     output_file="${block_folder}/${lang}_sentence_${blockID}_${sentenceID}.wav"
    
#     # Prepare the API request
#     url="http://10.24.6.165:2013"  # Replace with your actual API endpoint
#     payload=$(jq -n \
#       --arg input "$sentence" \
#       --argjson alpha 1 \
#       --arg segmentwise "True" \
#       '{input: $input, alpha: $alpha, segmentwise: $segmentwise}')
    
#     # Make the API call
#     response=$(curl -s -X POST "$url" \
#       -H "Content-Type: application/json" \
#       -d "$payload")
    
#     # Check if the response contains 'audio' or 'segments'
#     audio=$(echo "$response" | jq -r '.audio // empty')
#     segments=$(echo "$response" | jq -c '.segments // empty')

#     if [[ -n "$audio" ]]; then
#       # Decode and save the single audio file
#       echo "$audio" | base64 -d > "$output_file"
#       echo "Generated: $output_file"
#     elif [[ -n "$segments" ]]; then
#       # Decode and save each segment
#       i=0
#       echo "$segments" | jq -c '.[]' | while read -r segment; do
#         segment_output="${block_folder}/${lang}_sentence_${blockID}_${sentenceID}_seg${i}.wav"
#         echo "$segment" | base64 -d > "$segment_output"
#         echo "Generated segment: $segment_output"
#         ((i++))
#       done
#     else
#       echo "Error: Unable to generate audio for sentence '$sentence'"
#       echo "Response: $response"
#     fi

#   done < "$text_file"
# done

# echo "All audio files for the given languages and blocks have been generated."
