---
kind: training

title: "Generative AI in Kubernetes: From vLLM to Production"

description: |
  A 90-minute hands-on workshop covering the state-of-the-art for running
  generative AI workloads on Kubernetes. Deploy vLLM for real CPU inference,
  use KServe for model serving, explore GPU scheduling with fake-gpu-operator
  and DRA, and configure Gateway API Inference Extension for model-aware routing.
  All exercises run on CPU — no GPU required.

categories:
  - kubernetes
  - containers

tagz:
  - vllm
  - kserve
  - gpu
  - ai
  - inference

createdAt: 2026-04-22
updatedAt: 2026-04-22

cover: __static__/genai-k8s-cover.png
---

## Workshop Overview

**Duration:** 90 minutes
**Level:** Intermediate (comfortable with kubectl, YAML, Helm)
**Event:** Devoxx Greece 2026

### What You'll Build

Starting from a bare Kubernetes cluster, you'll progressively build a complete
AI inference platform covering the key CNCF projects:

| Unit | Min | Topic |
| ---- | --- | ----- |
| —    | 30  | Slides: The Cloud Native AI Stack |
| 1    | 8   | Lab 1: Cluster Setup + fake-gpu-operator |
| 2    | 12  | Lab 2: Deploy an LLM (Ollama + TinyLlama) |
| 3    | 8   | Lab 3: KServe InferenceService |
| 4    | 10  | Lab 4: GPU Scheduling & DRA |
| 5    | 5   | Lab 5: Gateway API Inference Extension |
| 6    | 8   | Lab 6: KAITO Workspace |
| 7    | 8   | Lab 7: llm-d Disaggregated Inference |
| —    | 5   | Wrap-up: CNCF AI Conformance & Q&A |

### Prerequisites

- Comfortable with `kubectl` and Kubernetes basics
- Familiarity with YAML and Helm
- No GPU needed — everything runs on CPU

### Author

**Alessandro Vozza** — Cloud Native architect, Golden Kubestronaut, KubeCon speaker
- GitHub: [ams0](https://github.com/ams0)
- Email: alessandro.vozza@linux.com
