# Exercise 5: Gateway API Inference Extension

## Goal

See how model-aware routing works with InferenceModel and InferencePool CRDs.

## Steps

1. Apply the CRDs (InferenceModel + InferencePool):

```bash
kubectl apply -f exercises/05-gateway/crds.yaml
```

2. Create an InferencePool pointing at the vLLM deployment from Exercise 2:

```bash
kubectl apply -f exercises/05-gateway/inference-pool.yaml
```

3. Create an InferenceModel:

```bash
kubectl apply -f exercises/05-gateway/inference-model.yaml
```

4. Inspect the resources:

```bash
kubectl get inferencemodel,inferencepool
kubectl describe inferencemodel opt-125m
kubectl describe inferencepool llm-pool
```

## What to Notice

- **InferenceModel** declares _what model_ is available
- **InferencePool** defines _where it runs_ (which pods)
- The `criticality` field enables priority lanes (Critical vs. BestEffort)
- In production: the endpoint picker routes based on KV cache utilization, LoRA adapters, and prefix cache hits

## How It Works in Production

```
Client → Gateway (Istio/Envoy) → Endpoint Picker → Pod with best KV cache state
                                  ↓
                          Considers:
                          - Model name match
                          - LoRA adapter loaded?
                          - KV cache utilization
                          - Prefix cache hit?
                          - Criticality class
```

## Discussion

- Why is round-robin load balancing bad for LLM inference?
- How does the InferenceModel/InferencePool split enable platform teams vs. app teams?
- What gateway implementations support this today?
