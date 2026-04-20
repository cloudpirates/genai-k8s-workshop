# Exercise 2: Deploy vLLM in CPU Mode

## Goal

Deploy a real LLM inference endpoint on Kubernetes — no GPU needed.

## Steps

1. Deploy vLLM:

```bash
kubectl apply -f exercises/02-vllm-cpu/
```

2. Wait for the pod to be ready (~2-3 min):

```bash
kubectl wait --for=condition=ready pod -l app=vllm-cpu --timeout=300s
```

3. Port-forward:

```bash
kubectl port-forward svc/vllm-cpu-service 8000:8000 &
```

4. List available models:

```bash
curl -s http://localhost:8000/v1/models | jq .
```

5. Send a completion request:

```bash
curl -s http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "prompt": "Kubernetes is great for AI because",
    "max_tokens": 50
  }' | jq .
```

6. Try chat completions:

```bash
curl -s http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "messages": [{"role": "user", "content": "What is Kubernetes?"}],
    "max_tokens": 100
  }' | jq .
```

7. Check Prometheus metrics:

```bash
curl -s http://localhost:8000/metrics | head -30
```

## What to Notice

- The API is **OpenAI-compatible** — same endpoints, same JSON format
- This is the exact same vLLM that runs on H100 GPUs — only `--device cpu` changes
- opt-125m is tiny (125M params) — in production you'd serve 8B–405B models
- Check the metrics: TTFT, queue depth, KV cache usage

## Troubleshooting

- **OOMKilled?** Reduce `--max-model-len` to `256` or increase memory limits
- **Slow startup?** Model download takes 1-2 min (~250 MB)
- **Pod pending?** Check the `nodeSelector` matches your kind node labels
