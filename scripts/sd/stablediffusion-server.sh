#!/bin/bash
TARGET_DIR="$HOME/ai/stable-diffusion-webui"

[ "$(pwd)" != "$TARGET_DIR" ] && cd "$TARGET_DIR"
source $TARGET_DIR/venv/bin/activate
TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"
exec accelerate launch --num_cpu_threads_per_process=6 launch.py
