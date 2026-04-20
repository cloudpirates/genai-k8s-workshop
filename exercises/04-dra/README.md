# Exercise 4: Explore DRA ResourceClaims

## Goal

Understand DRA (Dynamic Resource Allocation) by writing and applying ResourceClaim manifests.

Even without real GPUs, the API works — claims stay in a pending state, which is the point.

## Steps

1. Check if DRA CRDs are available:

```bash
kubectl api-resources | grep resource.k8s.io
```

2. Look at the old way vs. the new way:

**Old (Device Plugins):**
```yaml
resources:
  limits:
    nvidia.com/gpu: 1   # "Give me a GPU. Any GPU. I don't care which."
```

**New (DRA with CEL):**
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

3. Apply the ResourceClaim:

```bash
kubectl apply -f exercises/04-dra/resource-claim.yaml
```

4. Check the claim status:

```bash
kubectl get resourceclaim training-gpu
kubectl get resourceclaim training-gpu -o yaml
```

5. Apply the topology-aware claim:

```bash
kubectl apply -f exercises/04-dra/topology-claim.yaml
kubectl get resourceclaim
```

## What to Notice

- Claims stay **pending** — no DRA driver is installed, so no devices are advertised
- In production: the NVIDIA DRA driver publishes device attributes, claims get fulfilled
- CEL expressions give you SQL-like querying for hardware attributes
- The `matchAttribute` constraint ensures NUMA/NVLink topology awareness

## Discussion

- Why is DRA the first MUST requirement in the K8s AI Conformance Program?
- How does DRA enable multi-tenant GPU sharing?
- What's the difference between DRA and MIG (Multi-Instance GPU)?
