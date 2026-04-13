---
name: add-secret
description: Add a new secret to the SOPS secrets file. Use when the user wants to add, create, or generate a new secret/credential/key.
argument-hint: <sops-path> [length]
allowed-tools: Bash
---

# Add Secret to SOPS

Add a new randomly generated secret to the SOPS-encrypted secrets file.

## Arguments

- `$0` — The SOPS path in dot notation, e.g. `foo.bar`
- `$1` — (Optional) Length of the secret in bytes (default: 32)

## Instructions

1. Parse the dot-separated path from `$0` and convert it to SOPS bracket notation. For example, `foo.bar` becomes `["foo"]["bar"]`.
2. Determine the secret length from `$1`, defaulting to 32 bytes if not provided.
3. Run the following single command to generate and store the secret — NEVER generate the secret separately or decrypt the secrets file:

```bash
openssl rand -hex <length> | tr -d '\n' | jq -sR | sops set --value-stdin secrets/secrets.yaml '<sops-path>'
```

4. Confirm the secret was added successfully.

## Rules

- NEVER decrypt `secrets/secrets.yaml`
- NEVER generate a secret and paste it into the file manually
- ALWAYS use a single piped command so the plaintext secret is never stored
- The secrets file is always `secrets/secrets.yaml` relative to the project root
