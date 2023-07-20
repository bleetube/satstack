#!/bin/bash
TARGET_DIR="$HOME/src/text-generation-webui"
[ "$(pwd)" != "$TARGET_DIR" ] && cd "$TARGET_DIR"

source  /opt/miniconda3/etc/profile.d/conda.sh

# better debug messages, maybe?
export CUDA_LAUNCH_BLOCKING=1

conda activate textgen310
python server.py --chat --api
