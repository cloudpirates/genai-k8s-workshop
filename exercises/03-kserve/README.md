# Exercise 3: Deploy KServe InferenceService

## Goal

Use KServe to deploy a model with the standard InferenceService CRD.

## Steps

1. Install cert-manager (KServe dependency):

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.3/cert-manager.yaml
kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=120s
```

2. Install KServe in raw deployment mode:

```bash
kubectl apply -f exercises/03-kserve/kserve-install.yaml
kubectl wait --for=condition=Available deployment --all -n kserve --timeout=180s
```

3. Deploy an InferenceService:

```bash
kubectl apply -f exercises/03-kserve/inference-service.yaml
```

4. Check the status:

```bash
kubectl get inferenceservice tiny-llm
kubectl get inferenceservice tiny-llm -o yaml | grep -A5 status
```

5. Once ready, port-forward and test:

```bash
kubectl port-forward svc/tiny-llm-predictor 8080:80 &

curl -s http://localhost:8080/v1/models | jq .

curl -s http://localhost:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-125m",
    "prompt": "Cloud native AI is",
    "max_tokens": 50
  }' | jq .
```

## What to Notice

- Compare the InferenceService YAML with the raw vLLM Deployment from Exercise 2
- KServe adds: standardized API, autoscaling, canary rollouts, model versioning
- The InferenceService CRD is the lingua franca of model serving on Kubernetes
- In production: swap `storageUri` to point at a 70B+ model on S3/GCS

## Troubleshooting

- **KServe pods not starting?** Check cert-manager: `kubectl get pods -n cert-manager`
- **InferenceService stuck?** Check events: `kubectl describe inferenceservice tiny-llm`
