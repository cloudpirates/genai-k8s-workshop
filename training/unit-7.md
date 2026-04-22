---
kind: unit
title: "CNCF AI Conformance & What's Next"
name: wrapup-conformance
---

# CNCF AI Conformance & What's Next

## What You Built Today

In 90 minutes you went from a bare cluster to:

✅ **Emulated GPU nodes** — fake-gpu-operator proving scheduling works without hardware
✅ **Real LLM inference** — vLLM serving TinyLlama on CPU, OpenAI-compatible API
✅ **Standardized model serving** — KServe InferenceService with autoscaling support
✅ **GPU scheduling & DRA** — device-plugin limits + CEL-based ResourceClaims
✅ **Model-aware routing** — Gateway API Inference Extension with criticality tiers

## The CNCF AI Conformance Program

Announced at KubeCon NA 2025, the **Certified Kubernetes AI Conformance Program** defines what "AI-ready Kubernetes" means.

### v1.0 Requirements (3 MUST, 3 SHOULD)

| Requirement | Status | What It Means |
| ----------- | ------ | ------------- |
| DRA (Dynamic Resource Allocation) | **MUST** | CEL-based device claims for GPUs/accelerators |
| Device Health Reporting | **MUST** | Nodes report device health, scheduler respects it |
| Device Scheduling (partitionable) | **MUST** | MIG-style GPU partitioning via DRA |
| LeaderWorkerSet | SHOULD | Multi-node distributed training coordination |
| JobSet | SHOULD | Complex multi-job training pipelines |
| Kueue | SHOULD | Fair scheduling and quota management for AI jobs |

### v2.0 Roadmap

- Inference-specific requirements (Gateway API Inference Extension)
- Training lifecycle management
- Model registry integration

### Who's Conformant?

AKS, GKE, EKS, OpenShift, Canonical K8s — all major distros are pursuing conformance.

## Projects to Watch

| Project | What It Does | Status |
| ------- | ------------ | ------ |
| **llm-d** | Disaggregated inference (prefill/decode split) | CNCF Sandbox candidate |
| **KAITO** | One CRD to deploy models + auto-provision GPUs | CNCF Sandbox |
| **KubeFleet** | Multi-cluster AI workload orchestration | CNCF Sandbox |
| **Kueue** | Fair scheduling and quota for AI jobs | CNCF project |
| **vLLM** | Inference engine (PagedAttention, speculative decoding) | Open source, dominant |

## Going Further

### From This Workshop to Production

1. **Replace fake-gpu-operator** with real GPUs + NVIDIA DRA driver
2. **Swap TinyLlama** for production models (Llama 3.x, Mistral, Qwen)
3. **Add monitoring** — vLLM Prometheus metrics, KServe dashboards
4. **Implement llm-d** — disaggregate prefill/decode for 2-3x throughput
5. **Enable Gateway API Inference Extension** on your real gateway (Envoy/Istio)

### Resources

- [CNCF AI Conformance](https://www.cncf.io/certification/kubernetes-ai/)
- [Gateway API Inference Extension](https://gateway-api-inference-extension.sigs.k8s.io/)
- [vLLM Documentation](https://docs.vllm.ai/)
- [KServe Documentation](https://kserve.github.io/website/)
- [KAITO Project](https://github.com/kaito-project/kaito)
- [llm-d Project](https://github.com/llm-d/llm-d)

### Workshop Repo

All manifests and exercises: [github.com/cloudpirates/genai-k8s-workshop](https://github.com/cloudpirates/genai-k8s-workshop)

## Thank You!

Questions? Find me at the workshop or on GitHub/LinkedIn.

**Alessandro Vozza** — @ams0
