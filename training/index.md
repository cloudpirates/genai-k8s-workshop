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
| 1    | 10  | Intro: The Cloud Native AI Stack |
| 2    | 10  | Lab 1: Cluster Setup + fake-gpu-operator |
| 3    | 20  | Lab 2: Deploy vLLM in CPU Mode |
| 4    | 15  | Lab 3: KServe InferenceService |
| 5    | 15  | Lab 4: GPU Scheduling & DRA |
| 6    | 10  | Lab 5: Gateway API Inference Extension |
| 7    | 10  | Wrap-up: CNCF AI Conformance & What's Next |

### Prerequisites

- Comfortable with `kubectl` and Kubernetes basics
- Familiarity with YAML and Helm
- No GPU needed — everything runs on CPU

### Author

**Alessandro Vozza** — Cloud Native architect, Golden Kubestronaut, KubeCon speaker
- GitHub: [ams0](https://github.com/ams0)
- Email: alessandro.vozza@linux.com
