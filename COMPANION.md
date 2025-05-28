# Receivers for Real People

*A companion to "Push, Wait, ...Nothing? Let's Talk GitOps Reliability" — GitOpsCon EU 2025.*

**Generated with the help of a large language model (LLM). May contain inaccuracies. Please verify before copy-pasting into production systems.**

---

## 🧠 What’s a Receiver, Really?

In Flux, a **Receiver** is a Kubernetes resource that listens for **incoming webhook events** and maps them to **reconciliation triggers** on one or more Flux resources (usually Sources).

It exists to solve a simple problem:

> Kubernetes can't auto-subscribe to SaaS.

That is:

* `GitRepository`, `HelmRepository`, `OCIRepository`, etc. are inside your cluster.
* GitHub, GitLab, Bitbucket, etc. are outside.

The Receiver acts as a **webhook bridge** to turn push events into immediate syncs.

---

## ✅ When You Should Use a Receiver

* You want **instant feedback** in dev.
* Your `spec.interval` is too long (e.g. 10m) and you don’t want to shorten it.
* You’re tired of running `flux reconcile source git my-repo` manually.
* Your Git provider supports webhook delivery.
* You want to build a system that behaves more like CI/CD: fast, reactive, reliable.

---

## 🧾 Anatomy of a Receiver

```yaml
apiVersion: notification.toolkit.fluxcd.io/v1beta2
kind: Receiver
metadata:
  name: github-webhook
  namespace: flux-system
spec:
  type: github
  events:
    - push
  resources:
    - kind: GitRepository
      name: my-repo
  secretRef:
    name: webhook-secret
```

* `type:` tells Flux how to interpret the payload (GitHub, GitLab, etc.)
* `resources:` should only point to **Sources** (GitRepository, OCIRepository, etc.)
* `secretRef:` holds the shared secret for webhook HMAC verification

---

## 🔄 What Happens When a Webhook Fires

1. The SaaS platform (e.g., GitHub) sends a `push` event to the Receiver.
2. Flux validates the HMAC signature using the shared secret.
3. If valid, it triggers reconciliation on the referenced Source.
4. The Source updates its artifact.
5. Appliers (Kustomizations, HelmReleases) react to the new artifact.
6. Your changes go live.

---

## ❌ What *Not* to Do

* Don’t point a Receiver directly at a Kustomization or HelmRelease.

  * Appliers should respond to their Source being updated, not be triggered directly.

* Don’t try to target multiple components at once.

  * Race conditions may cause non-deterministic behavior.

* Don’t use Receivers as a substitute for CI.

  * They trigger deploys, not builds.

---

## 🧪 Easy Local Test

Once deployed, test with:

```bash
curl -X POST \
  -H 'X-GitHub-Event: push' \
  -H 'X-Hub-Signature-256: sha256=<HMAC>' \
  -H 'Content-Type: application/json' \
  -d '{"ref": "refs/heads/main"}' \
  http://<receiver-url>
```

---

## 🤔 Common Questions

**Q: Can I use Receivers with non-Git sources like HelmRepository?**
A: Yes, but only if the source supports webhook-driven triggering and you're sure it’s safe. Stick to GitRepository or OCIRepository unless you really know what you're doing.

**Q: What if my Receiver isn’t triggering?**

* Check your webhook secret (HMAC signature).
* Make sure your webhook provider is using the correct headers.
* Check `flux logs -n flux-system notification-controller`

**Q: Do I still need intervals?**
A: Yes — the Receiver is supplemental. Set a long interval as a fallback (e.g., 30m).

---

## 🛡️ Security Tips

* Always use HMAC-verified secrets.
* Never expose your Receiver to the public Internet without protections.
* Use ingress IP allow-lists or GitHub/GitLab webhook IP ranges.

---

## 📌 TL;DR

* Receivers bridge the gap between Git providers and Kubernetes.
* They give you instant feedback in your GitOps loop.
* Target Sources, not Appliers.
* Validate webhooks with shared secrets.
* Flux does the rest.

---

*Generated with the help of a large language model. Reviewed by a human. Please verify examples before use in production.*
