# 🌍 Scalable Static Website with S3 + Cloudflare + GitHub Actions

> Host and auto-deploy a static website using AWS S3 and deliver it globally with Cloudflare CDN + HTTPS. Automatically deployed from GitHub using GitHub Actions CI/CD.

---

## 📦 Stack Used

- **AWS S3 (Free Tier)** – Static site hosting
- **Cloudflare (Free)** – HTTPS, CDN, and DNS management
- **GitHub Actions** – CI/CD pipeline
- **Terraform** – Infrastructure as Code (S3, IAM, Cloudflare DNS)
- **HTML/CSS** – Simple static web page

---

## 🛠️ Infrastructure Architecture

```

Developer → GitHub → GitHub Actions ─┬─> AWS S3 (HTML upload)
└─> Cloudflare (Cache Purge + DNS)

```

---

## 📁 Folder Structure

```

scalable-static-site/
├── infra/                   # Terraform IaC setup
├── static-site/             # HTML/CSS website files
├── .github/workflows/       # CI/CD pipeline
├── README.md
└── .gitignore

````

---

## ⚙️ How It Works

1. **Terraform** provisions:
   - S3 bucket with public static website hosting
   - IAM user with limited S3 deploy rights
   - Cloudflare DNS `CNAME` record pointing to S3 endpoint

2. **GitHub Actions**:
   - Uploads website files to S3 on every `git push`
   - Purges Cloudflare cache to reflect changes instantly

---

## 🚀 Deployment Steps

### 1. Clone & Deploy Infra

```bash
cd infra
terraform init
terraform apply
````

> Use `terraform.tfvars` to provide values like domain, token, bucket name.

### 2. Add GitHub Secrets

Go to your repo > **Settings** > **Secrets and Variables** → **Actions**, and add:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `CLOUDFLARE_ZONE_ID`
* `CLOUDFLARE_API_TOKEN`

### 3. Push Static Website

Edit `static-site/index.html` and push to `main` branch:

```bash
git add .
git commit -m "Initial deploy"
git push origin main
```

---

## ✅ Output

* **Live URL**: [https://yourdomain.com](https://yourdomain.com) (via Cloudflare)
* **S3 URL** (debug only): `http://<bucket>.s3-website-<region>.amazonaws.com`

---

## 🖼️ Screenshot

*Add screenshot of your site here*

---

## 🧠 Credits

Built with ❤️ using AWS, Terraform, Cloudflare, and GitHub Actions.

````

---

## 📁 `.gitignore` — Prevent Sensitive Files from Being Tracked

```gitignore
# Terraform state files
*.tfstate
*.tfstate.backup
.terraform/

# Secrets
infra/terraform.tfvars

# VS Code or IDE junk
.vscode/
.idea/

# Mac junk
.DS_Store
````

---

🎉 That's it — your full project is now production-ready and portfolio-worthy!
