source tts-hs-hifigan/bin/activate
CUDA_VISIBLE_DEVICES="" gunicorn -w 2 -b 0.0.0.0:4005 app:app --timeout 600 #--daemon # to run in cpu
# CUDA_VISIBLE_DEVICES=1 gunicorn -w 2 -b 0.0.0.0:4005 app:app --timeout 600 --daemon # to run in specific gpu


# CUDA_VISIBLE_DEVICES="" > to make all the GPUs available invisible
