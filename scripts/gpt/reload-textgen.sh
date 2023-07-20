#!/bin/bash
TARGET_DIR="$HOME/src/text-generation-webui"
[ "$(pwd)" != "$TARGET_DIR" ] && cd "$TARGET_DIR"

INSTALL_DEPS() {
    pip install -r requirements.txt
#   pip install -r ./extensions/openai/requirements.txt
    pip install -r ./extensions/api/requirements.txt
#   pip install -r ./extensions/superbooga/requirements.txt
    pip install -r ./extensions/whisper_stt/requirements.txt
#   pip install -r ./extensions/google_translate/requirements.txt
#   pip install -r ./extensions/elevenlabs_tts/requirements.txt
    pip install -r ./extensions/silero_tts/requirements.txt
#   pushd $TARGET_DIR/repostories
#   conda install -c conda-forge cudatoolkit-dev gxx==11.3.0
#   popd
}


source  /opt/miniconda3/etc/profile.d/conda.sh
conda activate textgen310
INSTALL_DEPS

python server.py --chat 
