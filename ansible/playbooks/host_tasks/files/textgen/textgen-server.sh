#!/bin/bash
TARGET_DIR="$HOME/ai/text-generation-webui"

# >>> conda initialize >>>
__conda_setup="$('/home/blee/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/blee/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/blee/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/blee/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ "$(pwd)" != "$TARGET_DIR" ] && cd "$TARGET_DIR"
conda activate textgen
python server.py --chat
