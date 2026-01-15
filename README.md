# Linux Dev Environment Tools

A curated collection of **idempotent bootstrap scripts** for provisioning a modern Linux development environment focused on:

* 🐳 Containers & infrastructure
* ☁️ Cloud tooling
* 🧰 Developer productivity
* 🔁 Reproducibility and automation

These scripts are designed to be:

* ✅ Safe to re-run
* ✅ Explicit and readable
* ✅ Minimal and dependency-aware
* ✅ Suitable for personal laptops, lab machines, and cloud VMs

This repository is intentionally structured to mirror real-world DevOps / platform bootstrapping practices.

---

## 📂 Repository Structure

```
linux-dev-env-tools/
├── scripts/
│   ├── core/                # Core platform tooling
│   │   ├── 01-install-docker.sh
│   │   ├── 02-install-terraform.sh
│   │   └── 03-install-gcloud.sh
│   ├── dev-languages/       # Language runtimes and tooling
│   │   ├── 03-install-python-dev-tools.sh
│   │   └── 04-install-uv.sh
│   ├── drivers/             # Hardware and runtime drivers
│   │   └── 02-install-nvidia-container-toolkit.sh
│   └── editors/             # Developer editors and IDEs
│       └── 04-install-vscode.sh
├── LICENSE
└── README.md
```

---

## 🎯 Design Principles

### 1. Idempotency

All scripts are safe to run multiple times. They:

* Check whether packages, keys, or repositories already exist
* Skip work when appropriate
* Avoid destructive operations

This allows the same scripts to be reused across machines and rebuilt environments.

---

### 2. Explicit Dependencies

Scripts install only what they require and clearly separate:

* System prerequisites
* GPG keys
* Package repositories
* Package installation
* Validation

This makes debugging and auditing easier.

---

### 3. No Hidden State or Secrets

* No credentials are embedded in scripts
* Authentication is always performed manually (e.g., `gcloud auth`)
* No secrets are committed to the repository

---

### 4. Real-World Alignment

The tooling mirrors what is commonly used in:

* Cloud infrastructure provisioning
* Data engineering pipelines
* DevOps automation
* Local reproducible environments

---

## 🧰 Available Scripts

### 🔧 Core

| Script                    | Description                                           |
| ------------------------- | ----------------------------------------------------- |
| `01-install-docker.sh`    | Installs Docker Engine and CLI                        |
| `02-install-terraform.sh` | Installs Terraform from HashiCorp official repository |
| `03-install-gcloud.sh`    | Installs Google Cloud CLI (`gcloud`)                  |

---

### 🐍 Development Languages

| Script                           | Description                                |
| -------------------------------- | ------------------------------------------ |
| `03-install-python-dev-tools.sh` | Python build tools and system dependencies |
| `04-install-uv.sh`               | Installs `uv` Python package manager       |

---

### 🎮 Drivers

| Script                                   | Description                    |
| ---------------------------------------- | ------------------------------ |
| `02-install-nvidia-container-toolkit.sh` | Enables GPU support for Docker |

---

### ✍️ Editors

| Script                 | Description                 |
| ---------------------- | --------------------------- |
| `04-install-vscode.sh` | Installs Visual Studio Code |

---

## 🚀 Usage

Clone the repository:

```bash
git clone <repo-url>
cd linux-dev-env-tools
```

Make a script executable:

```bash
chmod +x scripts/core/03-install-gcloud.sh
```

Run the script:
```bash
./scripts/core/03-install-gcloud.sh
```

Scripts may prompt for sudo privileges when needed.

---

## 🔐 Authentication Notes

Some tools require manual authentication after installation.

### Google Cloud CLI

After installing gcloud:

```bash
gcloud auth application-default login
```

This opens a browser login flow and stores credentials securely under:

```
~/.config/gcloud/
```

Credentials are not modified by install scripts.

---

## 🧪 Validation

Most scripts include validation output at the end. Example:

```bash
terraform version
gcloud --version
docker --version
```

---

## 🧹 Re-running Scripts

It is safe to re-run any script:

* Existing keys are reused
* Existing repositories are skipped
* Installed packages are left intact

This supports:

* Machine rebuilds
* System upgrades
* Drift correction

---

## 🧩 Intended Use Cases

* Local developer workstation bootstrap
* Data engineering lab environments
* Cloud VM provisioning
* Reproducible learning environments
* CI bootstrap foundations

---

## 📜 License

See LICENSE file.

