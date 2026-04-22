---
marp: true
theme: default
paginate: true
backgroundColor: #1a1a2e
color: #ffffff
style: |
  section {
    font-family: 'Segoe UI', Arial, sans-serif;
  }
  h1 { color: #326ce5; }
  h2 { color: #4a9eff; }
  code { background: #2d2d4e; }
  table { font-size: 0.8em; }
  th { background: #326ce5; color: white; }
  a { color: #4a9eff; }
  strong { color: #4a9eff; }
---

# Generative AI in Kubernetes

## From vLLM to Production

**Alessandro Vozza** — Devoxx Greece 2026

Golden Kubestronaut · KubeCon Speaker

---

# About Me

- **Alessandro Vozza** — Cloud Native Architect
- 🏆 Golden Kubestronaut, Microsoft CSA
- 🎤 KubeCon speaker, CNCF contributor
- 🐙 GitHub: **@ams0**

---

# Why Kubernetes for AI?

- **60%** of Fortune 500 run AI workloads on Kubernetes
- Kubernetes is the **de facto platform** for ML/AI
- CNCF ecosystem: purpose-built projects for every layer
- Today: **hands-on** with the key projects

---

# The Cloud Native AI Stack

```
┌─────────────────────────────────────────┐
│     Gateway API Inference Extension     │  Routing
├─────────────────────────────────────────┤
│     KServe / KAITO                      │  Serving
├─────────────────────────────────────────┤
│     vLLM / llm-d                        │  Inference
├─────────────────────────────────────────┤
│     DRA / fake-gpu-operator             │  Devices
├─────────────────────────────────────────┤
│     Kubernetes                          │  Platform
└─────────────────────────────────────────┘
```

---

# Workshop Flow — 90 Minutes

| Time | Topic |
|------|-------|
| 30 min | **Slides** (this deck) |
| 8 min | Lab 1: Cluster + fake-gpu-operator |
| 12 min | Lab 2: LLM Inference (Ollama) |
| 8 min | Lab 3: KServe InferenceService |
| 10 min | Lab 4: GPU Scheduling & DRA |
| 5 min | Lab 5: Gateway API Inference |
| 8 min | Lab 6: KAITO Workspace |
| 8 min | Lab 7: llm-d Disaggregated |
| 5 min | Wrap-up + Q&A |

---

<!-- _class: lead -->
# Part 1: Inference Engines

---

# What is vLLM?

- **Most popular** open-source LLM serving engine (~60% share)
- Created at UC Berkeley (2023)
- Key innovations:
  - **PagedAttention** — virtual memory for GPU KV cache
  - **Continuous batching** — new requests join mid-batch
  - **Speculative decoding** — small model drafts, large verifies
- **OpenAI-compatible API** out of the box

---

# PagedAttention — Why It Matters

**Problem:** GPU memory fragmentation kills throughput

**Traditional serving:**
- Contiguous memory per sequence
- 60-80% of GPU memory wasted on fragmentation

**PagedAttention:**
- KV cache managed like OS virtual memory (pages)
- Non-contiguous allocation
- **2-4x throughput** over naive serving
- Efficient memory sharing across requests

---

# vLLM in Production

- **API:** OpenAI-compatible (`/v1/chat/completions`)
- **Scaling:** HPA on queue depth, TTFT, GPU utilization
- **GPU modes:** CUDA, ROCm, CPU (for dev/workshops)
- **Models:** Any HuggingFace, GGUF, AWQ, GPTQ
- **Lab 2:** You'll run inference on CPU with TinyLlama 1.1B

---

<!-- _class: lead -->
# Part 2: Model Serving

---

# KServe — Kubernetes-Native Serving

- **CNCF project** — standardized model serving
- **InferenceService CRD** — one YAML to deploy a model
- Features:
  - Autoscaling (including **scale-to-zero**)
  - **Canary rollouts** with traffic splitting
  - Multi-framework: HuggingFace, PyTorch, TensorFlow, vLLM
  - v1/v2 inference protocol
- Used by: Bloomberg, IBM, Seldon, Cisco

---

# KServe Architecture

```
                    ┌──────────────┐
   Client ────────► │   Ingress    │
                    └──────┬───────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
    ┌──────────────┐         ┌──────────────┐
    │  Predictor   │         │  Transformer │
    │  (vLLM/HF)   │         │  (pre/post)  │
    └──────────────┘         └──────────────┘
```

- **Predictor** — runs the model
- **Transformer** — optional pre/post processing
- **Explainer** — optional model explanations (SHAP)

---

# 6 Steps → 1 CRD

**Manual (Labs 1-2):** cluster → GPU operator → node labels → model download → Deployment → Service → health checks

**KServe:**
```yaml
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: my-model
spec:
  predictor:
    model:
      modelFormat: {name: huggingface}
      storageUri: "hf://meta-llama/Llama-3-8B"
```

**Lab 3:** You'll deploy an InferenceService

---

<!-- _class: lead -->
# Part 3: GPU Management

---

# The GPU Problem

- GPUs are **expensive** ($2-4/hr per A100)
- Old device-plugin model: `nvidia.com/gpu: 1`
  - That's **all** you can say
- No way to express:
  - "I need an **H100**, not a T4"
  - "I need **80GB** VRAM"
  - "I need 2 GPUs on the **same NUMA node**"
- Enter: **DRA** (Dynamic Resource Allocation)

---

# DRA — Dynamic Resource Allocation

**GA in Kubernetes 1.33+**

Old way:
```yaml
resources:
  limits:
    nvidia.com/gpu: 1  # "Any GPU. I don't care."
```

New way (CEL expressions):
```yaml
spec:
  devices:
    requests:
    - name: gpu
      exactly:
        deviceClassName: gpu.nvidia.com
        selectors:
        - cel:
            expression: >
              device.attributes["gpu.nvidia.com"].productName == "H100"
              && device.capacity["gpu.nvidia.com"].memory >= 80
```

---

# DRA — Why It Matters

- **First MUST requirement** in CNCF AI Conformance
- NVIDIA **donated** GPU DRA driver to CNCF (March 2026)
- Enables:
  - Multi-Instance GPU (**MIG**) partitioning
  - **Topology-aware** placement (NUMA, NVLink)
  - Multi-tenant GPU sharing
  - Device **health reporting**
- **Lab 4:** fake-gpu-operator + DRA ResourceClaims

---

# fake-gpu-operator

- By **Run:ai** — emulates GPU resources on CPU nodes
- Nodes advertise `nvidia.com/gpu` resources
- Scheduler treats them as **real GPUs**
- Perfect for: workshops, CI/CD testing, development
- **Lab 1:** Install it, watch GPU pods schedule

---

<!-- _class: lead -->
# Part 4: Intelligent Routing

---

# Gateway API Inference Extension

**Problem:** LLM traffic ≠ web traffic

- Requests have wildly different costs (10 vs 10,000 tokens)
- Some requests need specific **LoRA adapters** in GPU memory
- Production traffic should **preempt** batch traffic

**Solution:** Two new CRDs
- **InferenceModel** — model endpoint + criticality
- **InferencePool** — model server group + routing strategy

---

# How It Works

```
Client → Gateway → InferenceModel → InferencePool → vLLM Pod
                   (criticality)    (selection)
```

Routing strategies:
- **Token-aware** load balancing (not just request count)
- **LoRA affinity** — route to pod with adapter loaded
- **Criticality shedding** — drop Sheddable, keep Critical
- **KV cache awareness** — route to pod with most free cache

Implementations: Envoy Gateway, Istio, kgateway

**Lab 5:** Create InferenceModel + InferencePool CRDs

---

<!-- _class: lead -->
# Part 5: KAITO

---

# KAITO — Kubernetes AI Toolchain Operator

- **CNCF Sandbox** project (from Microsoft)
- **One CRD** replaces everything:
  - GPU node provisioning
  - Model download from curated catalog
  - Inference server deployment
  - Service + health checks + scaling

---

# KAITO Workspace CRD

```yaml
apiVersion: kaito.sh/v1alpha1
kind: Workspace
metadata:
  name: llama3-inference
spec:
  resource:
    instanceType: "Standard_NC24ads_A100_v4"
    count: 1
  inference:
    preset:
      name: "llama-3-8b-instruct"
    adapters:
    - source:
        name: "custom-lora"
        image: "ghcr.io/my-org/lora-adapter:v1"
```

- **instanceType** → provisions the right GPU node
- **preset** → downloads and serves the model
- **adapters** → LoRA weights from OCI images

---

# KAITO Model Catalog

| Preset | Model | GPU |
|--------|-------|-----|
| llama-3-8b-instruct | Meta Llama 3 8B | 1× A100 |
| phi-4 | Microsoft Phi-4 | 1× A100 |
| mistral-7b-instruct | Mistral 7B | 1× A100 |
| falcon-40b | TII Falcon 40B | 2× A100 |
| deepseek-r1 | DeepSeek R1 | 4× A100 |

- Supports **fine-tuning** (QLoRA/LoRA)
- Integrates with **Gateway API Inference Extension**
- **Lab 6:** Create a Workspace CRD

---

<!-- _class: lead -->
# Part 6: Disaggregated Inference

---

# The Problem with Monolithic Serving

LLM inference = two phases with **opposite** needs:

| Phase | Duration | Needs | Bottleneck |
|-------|----------|-------|------------|
| **Prefill** | 100-500ms | Compute (FLOPS) | Matrix multiply |
| **Decode** | 1-30s | Memory bandwidth | KV cache reads |

Monolithic → GPU utilization **40-60%**

---

# llm-d — Disaggregated Inference

**Red Hat** (CNCF Sandbox candidate)

```
              ┌──────────────┐
Request ────► │    Router    │
              └──────┬───────┘
                     │
        ┌────────────┼────────────┐
        ▼                         ▼
  ┌──────────┐              ┌──────────┐
  │ Prefill  │───KV Cache──►│  Decode  │
  │ (FLOPS)  │              │  (BW)    │
  └──────────┘              └──────────┘
```

- Separate pools for prefill and decode
- KV cache transfer via RDMA/NVLink
- **2-3x throughput** at same GPU cost

---

# llm-d Architecture

```yaml
spec:
  prefill:
    replicas: 2
    resources: {limits: {nvidia.com/gpu: 4}}
  decode:
    replicas: 4
    resources: {limits: {nvidia.com/gpu: 2}}
  router:
    strategy: "least-kv-cache"
  kvCacheTransfer:
    method: "nixTransport"
```

- Built on **vLLM** + **Gateway API Inference Extension**
- Router dispatches → Prefill → KV transfer → Decode
- **Lab 7:** Explore the architecture + CRDs

---

<!-- _class: lead -->
# Part 7: Conformance & Future

---

# CNCF AI Conformance Program

Announced KubeCon NA 2025

| Requirement | Level |
|-------------|-------|
| DRA (Dynamic Resource Allocation) | **MUST** |
| Device Health Reporting | **MUST** |
| Device Scheduling (partitionable) | **MUST** |
| LeaderWorkerSet | SHOULD |
| JobSet | SHOULD |
| Kueue (fair scheduling) | SHOULD |

**Conformant:** AKS, GKE, EKS, OpenShift, Canonical K8s

---

# Projects to Watch

| Project | What | Status |
|---------|------|--------|
| **vLLM** | Inference engine | Dominant |
| **KServe** | Model serving | CNCF |
| **KAITO** | One-CRD deployment | CNCF Sandbox |
| **llm-d** | Disaggregated inference | Sandbox candidate |
| **KubeFleet** | Multi-cluster AI | CNCF Sandbox |
| **Kueue** | Fair scheduling | CNCF |
| **LeaderWorkerSet** | Distributed training | K8s SIG |

---

# Let's Build! 🚀

**7 hands-on labs:**
1. Cluster + fake-gpu-operator
2. LLM Inference (Ollama + TinyLlama)
3. KServe InferenceService
4. GPU Scheduling & DRA
5. Gateway API Inference Extension
6. KAITO Workspace
7. llm-d Disaggregated Inference

**iximiuz playground** — everything runs on CPU, no GPU needed

---

# Resources

- **Workshop repo:** github.com/cloudpirates/genai-k8s-workshop
- CNCF AI Conformance: cncf.io/certification/kubernetes-ai
- Gateway API Inference: gateway-api-inference-extension.sigs.k8s.io
- vLLM: docs.vllm.ai
- KServe: kserve.github.io/website
- KAITO: github.com/kaito-project/kaito
- llm-d: github.com/llm-d/llm-d

---

# Thank You!

**Alessandro Vozza** — @ams0

Golden Kubestronaut · KubeCon Speaker

Questions? 🤔
