# 基于大模型的自动驾驶仿真测试场景高效生成技术研究
## 使用RAG生成
### 1.部署大模型
```shell
vllm serve Qwen/Qwen2.5-7B-Instruct
```
### 2.与大模型交互，生成事故报告
```shell
cd RAG/GenerateFromRAG
python3 generateFromRAG.py
```
## 微调大模型
使用LLaMA-Factory微调Qwen/Qwen2.5-7B-Instruct：首先准备好LLaMA-Factory环境，然后
```shell
cp RAG/accidents.json path/to/LLaMA-Factory/data/accidents.json
cp RAG/dataset_info.json path/to/LLaMA-Factory/data/dataset_info.json
bash finetune.sh
bash merge.sh
```
## 评价生成事故报告的质量
```shell
cd RAG/GenerateFromRAG
python3 val.py
```
