# gpt

Quick and dirty scripts to update or launch text-generation UI.

## models

* [TheBloke/Llama-2-13B-chat-GPTQ](https://huggingface.co/TheBloke/Llama-2-13B-chat-GPTQ)

## compute constraints note

TheBloke says 11Gb vram is insufficient for 13B models, so it will probably run into problems during extended use. But it runs fine in all of my testing so far. Here's llama-2-13B-chat-GPTQ:

```
nvidia-smi                                                                                                                                                                                                                                                     ✔  3m 56s  
Fri Jul 21 08:23:31 2023       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.54.03              Driver Version: 535.54.03    CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 2080 Ti     Off | 00000000:01:00.0 Off |                  N/A |
|  0%   34C    P8              21W / 260W |   8840MiB / 11264MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A       841      C   python                                     8832MiB |
|    0   N/A  N/A       974      G   /usr/lib/Xorg                                 4MiB |
+---------------------------------------------------------------------------------------+
```