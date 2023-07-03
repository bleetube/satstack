# Host Tasks

This is an assortment of various tasks to run on specific machines on my home network. 

## incineroar

GPU: [Asus RTX 2080 Ti](https://www.gpuzoo.com/GPU-ASUS/Dual_GeForce_RTX_2080_Ti_OC_Edition_11GB_-_DUAL-RTX2080TI-O11G.html) (11gb vram, [4352 cuda cores](https://browser.geekbench.com/opencl-benchmarks))

### text-generation-webui

This software changes often and the process to set it up frequently changes, so it's mostly installed manually. Moreover, models are bandwidth intensive and shouldn't be automatically pulled in since better models come out every week at this point. Here's a recap of the manual installation steps:

* install [miniconda3](https://conda.io/projects/conda/en/latest/user-guide/install/linux.html)

```bash
export PATH=$HOME/miniconda3/bin:$PATH
conda init zsh
conda create -n textgen
conda activate textgen
pip install torch torchvision torchaudio
git clone https://github.com/oobabooga/text-generation-webui
cd text-generation-webui
pip install -r requirements.txt
cp settings-template.yaml settings.yaml
mkdir repositories
cd repositories
git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git -b cuda
pip install https://github.com/jllllll/GPTQ-for-LLaMa-Wheels/raw/Linux-x64/quant_cuda-0.0.0-cp310-cp310-linux_x86_64.whl
python download-model.py TheBloke/stable-vicuna-13B-GPTQ
pip install -r ./extensions/silero_tts/requirements.txt
pip install -r ./extensions/whisper_stt/requirements.txt
python server.py
```

This playbook maintains the `settings.yaml`, orchestrates a systemd user process to automatically launch the webui, and writes nginx configuration to act as a forward proxy with websockets for proper remote access.

Plugins:

* elevenlabs_tts

Resources:

* [huggingface.co/TheBloke](https://huggingface.co/TheBloke)

Roadmap: 

* install/update miniconda
