# Exercise 4: GPU Scheduling & DRA

## Goal

Explore GPU scheduling in Kubernetes using fake-gpu-operator (emulated GPUs), then understand how DRA (Dynamic Resource Allocation) evolves the model.

## Part A: GPU Scheduling with fake-gpu-operator

The setup script installed `fake-gpu-operator` which advertises 4x A100 GPUs per node — no real hardware needed.

### 1. Verify GPU resources on your nodes

```bash
kubectl get nodes -o custom-columns=\
NAME:.metadata.name,\
GPU:.status.allocatable.nvidia\\.com/gpu,\
PRODUCT:.metadata.labels.nvidia\\.com/gpu\\.product
```

You should see `4` GPUs and `A100` as the product.

### 2. Deploy a GPU-requesting pod

```bash
kubectl apply -f exercises/04-dra/gpu-pod.yaml
```

```bash
kubectl get pod gpu-test
kubectl describe pod gpu-test | grep -A5 "Requests\|Limits\|nvidia"
```

The pod **actually schedules and runs** — fake-gpu-operator satisfies the request.

### 3. Try to exceed capacity

```bash
kubectl apply -f exercises/04-dra/gpu-greedy.yaml
kubectl get pods -l app=gpu-greedy
```

Watch what happens: pods beyond the 4-GPU capacity stay Pending — the scheduler works correctly even with emulated GPUs.

### 4. Clean up Part A

```bash
kubectl delete -f exercises/04-dra/gpu-pod.yaml
kubectl delete -f exercises/04-dra/gpu-greedy.yaml
```

## Part B: DRA — The Future of Device Allocation

DRA replaces the old device-plugin model with expressive, CEL-based resource claims.

### Old way (Device Plugins):
```yaml
resources:
  limits:
    nvidia.com/gpu: 1   # "Give me a GPU. Any GPU."
```

### New way (DRA with CEL):
```yaml
spec:
  devices:
    requests:
    - name: gpu
      deviceClassName: gpu.nvidia.com
      selectors:
      - cel:
          expression: >
            device.attributes['gpu.nvidia.com'].productName == 'H100' &&
            device.attributes['gpu.nvidia.com'].memory >= 80
```

### 5. Check DRA API availability

```bash
kubectl api-resources | grep resource.k8s.io
```

### 6. Apply DRA ResourceClaims

```bash
kubectl apply -f exercises/04-dra/resource-claim.yaml
kubectl get resourceclaim training-gpu -o yaml
```

Claims stay **Pending** — no DRA driver is installed (that requires the real NVIDIA DRA driver). The point is seeing the API in action.

### 7. Apply a topology-aware claim

```bash
kubectl apply -f exercises/04-dra/topology-claim.yaml
kubectl get resourceclaim
```

## What to Notice

- **Part A**: fake-gpu-operator proves that K8s GPU scheduling is purely a resource accounting problem — the scheduler doesn't care if the GPU is real
- **Part B**: DRA claims stay pending without a driver, but the API lets you express things device-plugins never could (specific models, memory thresholds, topology)
- DRA is the **first MUST requirement** in the CNCF AI Conformance Program

## Discussion

- Why did the community move from device-plugins to DRA?
- How does DRA enable multi-tenant GPU sharing vs. MIG?
- What attributes would you select for in a production training job?
