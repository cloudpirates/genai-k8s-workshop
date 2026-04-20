# Generative AI in Kubernetes — Devoxx Greece 2026

Hands-on workshop materials for deploying and serving generative AI workloads on Kubernetes.

**Speaker:** Alessandro Vozza ([@ams0](https://github.com/ams0))
**Conference:** [Devoxx Greece 2026](https://devoxx.gr/)
**Date:** Friday, April 25, 2026
**Duration:** 90 minutes
**Level:** Intermediate

## What You'll Learn

- Deploy an LLM inference endpoint on Kubernetes using **vLLM** (CPU mode, no GPU required)
- Use **KServe** InferenceService CRDs for standardized model serving
- Explore **DRA** (Dynamic Resource Allocation) for GPU scheduling
- Configure **Gateway API Inference Extension** for model-aware routing
- Understand the cloud-native AI stack: vLLM → KServe → llm-d → Gateway API → DRA

## Prerequisites

- Docker Desktop (or compatible container runtime)
- `kubectl` ([install](https://kubernetes.io/docs/tasks/tools/))
- `kind` ([install](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
- Helm 3.x ([install](https://helm.sh/docs/intro/install/))
- ~16 GB RAM available
- `curl` and `jq`

### Quick Setup

```bash
# Clone this repo
git clone https://github.com/RichardFeynmanClaw/genai-k8s-workshop.git
cd genai-k8s-workshop

# Pre-pull images (saves time during the workshop)
./scripts/prepull.sh

# Create the workshop cluster
./scripts/setup.sh
```

## Workshop Flow (90 min)

| Time | Topic | Type |
|------|-------|------|
| 0:00–0:10 | Landscape & Cloud Native AI Stack | Talk |
| 0:10–0:20 | **Exercise 1:** Kind cluster with GPU-labeled nodes | Hands-on |
| 0:20–0:35 | **Exercise 2:** vLLM in CPU mode | Talk + Hands-on |
| 0:35–0:50 | **Exercise 3:** KServe InferenceService | Talk + Hands-on |
| 0:50–1:00 | Kaito & llm-d (talk only — needs GPUs) | Talk |
| 1:00–1:10 | **Exercise 5:** Gateway API Inference Extension | Talk + Hands-on |
| 1:10–1:20 | **Exercise 4:** DRA ResourceClaims | Talk + Hands-on |
| 1:20–1:25 | CNCF AI Conformance & Standards | Talk |
| 1:25–1:30 | Wrap-up & Q&A | Discussion |

## Exercises

| # | Exercise | Directory |
|---|----------|-----------|
| 1 | [Create a Kind cluster with simulated GPU nodes](exercises/01-kind-cluster/) | `exercises/01-kind-cluster/` |
| 2 | [Deploy vLLM in CPU mode](exercises/02-vllm-cpu/) | `exercises/02-vllm-cpu/` |
| 3 | [Deploy KServe InferenceService](exercises/03-kserve/) | `exercises/03-kserve/` |
| 4 | [Explore DRA ResourceClaims](exercises/04-dra/) | `exercises/04-dra/` |
| 5 | [Gateway API Inference Extension](exercises/05-gateway/) | `exercises/05-gateway/` |

## The Cloud Native AI Stack

```
┌─────────────────────────────────────────────┐
│              Applications / Agents           │
├─────────────────────────────────────────────┤
│     Gateway API Inference Extension          │
│     (InferenceModel + InferencePool CRDs)    │
├─────────────────────────────────────────────┤
│  KServe (InferenceService / LLMInferenceService)  │
├──────────────┬──────────────┬───────────────┤
│    vLLM      │   llm-d      │   Kaito       │
│  (engine)    │ (disaggreg.) │  (operator)   │
├──────────────┴──────────────┴───────────────┤
│  LeaderWorkerSet (multi-node inference)      │
├─────────────────────────────────────────────┤
│  DRA + GPU Operator + Kueue (scheduling)     │
├─────────────────────────────────────────────┤
│              Kubernetes                      │
└─────────────────────────────────────────────┘
```

## Key Projects

| Project | What It Does | CNCF Status |
|---------|-------------|-------------|
| [vLLM](https://github.com/vllm-project/vllm) | High-throughput LLM inference engine | Independent |
| [KServe](https://github.com/kserve/kserve) | Standardized model serving platform | Incubating |
| [llm-d](https://github.com/llm-d/llm-d) | Disaggregated LLM inference | Sandbox |
| [Kaito](https://github.com/kaito-project/kaito) | Kubernetes AI Toolchain Operator | Sandbox |
| [Gateway API Inference Ext.](https://github.com/kubernetes-sigs/gateway-api-inference-extension) | Model-aware traffic routing | k8s-sigs |

## Further Reading

- [CNCF Cloud Native AI Whitepaper](https://www.cncf.io/reports/cloud-native-artificial-intelligence-whitepaper/)
- [Kubernetes AI Conformance Program](https://www.cncf.io/announcements/2025/11/11/cncf-launches-certified-kubernetes-ai-conformance-program-to-standardize-ai-workloads-on-kubernetes/)
- [KServe + llm-d: Cloud-Native AI Inference](https://kserve.github.io/website/blog/cloud-native-ai-inference-kserve-llm-d)
- [The Great Migration: Why Every AI Platform is Converging on Kubernetes](https://www.cncf.io/blog/2026/03/05/the-great-migration-why-every-ai-platform-is-converging-on-kubernetes/)

## Cleanup

```bash
kind delete cluster --name genai-workshop
```

## License

Apache License 2.0
