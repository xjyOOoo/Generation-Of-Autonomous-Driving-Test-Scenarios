DISTRIBUTED_ARGS="
    --nproc_per_node 2 \
    --nnodes 1 \
    --node_rank 0\
    --master_addr localhost \
    --master_port 12355
  "

torchrun $DISTRIBUTED_ARGS src/train.py \
    --stage sft \
    --do_train \
    --use_fast_tokenizer \
    --model_name_or_path "path/to/your/model" \
    --dataset accidents \
    --template qwen \
    --finetuning_type lora \
    --lora_target all \
    --output_dir "your/output/path" \
    --overwrite_cache \
    --overwrite_output_dir \
    --warmup_steps 0 \
    --weight_decay 0.1 \
    --per_device_train_batch_size 2 \
    --gradient_accumulation_steps 8 \
    --ddp_timeout 9000 \
    --learning_rate 5e-6 \
    --lr_scheduler_type cosine \
    --logging_steps 1 \
    --cutoff_len 4096 \
    --save_steps 1000 \
    --plot_loss \
    --num_train_epochs 2 \
    --bf16 True
