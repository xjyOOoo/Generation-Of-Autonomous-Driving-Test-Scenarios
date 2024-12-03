CUDA_VISIBLE_DEVICES=0 llamafactory-cli export \
    --model_name_or_path path/to/your/model \
    --adapter_name_or_path your/output/path \
    --template qwen \
    --finetuning_type lora \
    --export_dir your/export/path \
    --export_size 5 \
    --export_legacy_format False