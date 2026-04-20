# Exercise 1: Create a Kind Cluster with Simulated GPU Nodes

## Goal

Stand up a local Kubernetes cluster with fake GPU node labels to explore scheduling concepts.

## Steps

1. Create the cluster:

```bash
kind create cluster --name genai-workshop --config kind-config.yaml
```

2. Verify nodes and labels:

```bash
kubectl get nodes
kubectl get nodes --show-labels | grep accelerator
```

3. Inspect the "GPU" nodes:

```bash
kubectl describe node genai-workshop-worker
kubectl describe node genai-workshop-worker2
```

## What to Notice

- The worker nodes have `accelerator: nvidia-gpu` labels
- They have fake GPU product names (H100, A100)
- The third worker has no GPU label — it's our CPU inference node
- In production, the NVIDIA GPU Operator adds these labels automatically

## Discussion

- How does the Kubernetes scheduler use node labels?
- What's the difference between labels and DRA ResourceClaims?
- Why are opaque integers (`nvidia.com/gpu: 1`) not enough?
