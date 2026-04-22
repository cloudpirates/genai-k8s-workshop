---
kind: unit
title: "The Cloud Native AI Stack"
name: intro-cloud-native-ai
---

# The Cloud Native AI Stack

Welcome to the **Generative AI in Kubernetes** workshop! In 90 minutes, you'll go from a bare cluster to a working AI inference platform.

## Why Kubernetes for AI?

Kubernetes has become the de facto platform for AI/ML workloads. The CNCF ecosystem now includes purpose-built projects for every layer of the AI stack:

**Inference Serving**
- **vLLM** — High-throughput LLM serving with PagedAttention, continuous batching, and speculative decoding
- **KServe** — Kubernetes-native model serving with autoscaling, canary rollouts, and standardized APIs
- **KAITO** (CNCF Sandbox) — Kubernetes AI Toolchain Operator: one CRD to deploy models with auto-provisioned GPU nodes

**Infrastructure**
- **DRA (Dynamic Resource Allocation)** — CEL-based device claims replacing the old device-plugin model (GA in K8s 1.33+)
- **LeaderWorkerSet** — Multi-node distributed training/inference coordination
- **fake-gpu-operator** — Emulate GPU scheduling for development and workshops (what we'll use today!)

**Networking**
- **Gateway API Inference Extension** — Model-aware routing: token-based load balancing, LoRA affinity, criticality tiers
- **llm-d** — Red Hat's disaggregated inference stack (prefill/decode separation on Kubernetes)

**Governance**
- **CNCF AI Conformance Program** — Standardizes what "AI-ready Kubernetes" means (DRA, device health, scheduling)

## Today's Architecture

```
┌─────────────────────────────────────────┐
│           Gateway API + Inference Ext    │ ← Lab 5: model-aware routing
├─────────────────────────────────────────┤
│    KServe InferenceService              │ ← Lab 3: standardized serving
├─────────────────────────────────────────┤
│    vLLM (CPU mode, TinyLlama 1.1B)     │ ← Lab 2: real inference
├─────────────────────────────────────────┤
│    fake-gpu-operator + DRA              │ ← Lab 4: GPU scheduling
├─────────────────────────────────────────┤
│    Kind cluster (k8s 1.33+)            │ ← Lab 1: setup
└─────────────────────────────────────────┘
```

## Key Numbers (2026)

- **60%** of Fortune 500 companies run AI workloads on Kubernetes
- **DRA** is the #1 MUST requirement in the CNCF AI Conformance Program
- **vLLM** serves 60%+ of open-source LLM deployments
- **KServe** handles model serving for Bloomberg, IBM, Seldon, and dozens of enterprises

## Let's Go!

In the next unit, you'll create a Kubernetes cluster with emulated GPU nodes and start deploying models. Everything runs on CPU — the scheduling and APIs are real, just the hardware is simulated.
