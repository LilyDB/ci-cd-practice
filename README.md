# CI/CD Practice Setup

## How GitHub Actions Works
GitHub Actions automatically runs code when you push to GitHub. It uses YAML files in `.github/workflows/` to define what to run.

## Setup Commands

1. **Create Python file:**
   ```bash
   echo 'print("Hello CI/CD!")' > hello.py
   ```

2. **Create workflow directory:**
   ```bash
   mkdir -p .github/workflows
   ```

3. **Create workflow file:** `.github/workflows/simple.yml`
   ```yaml
   name: Simple Test
   on: [push]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v4
       - uses: actions/setup-python@v4
         with:
           python-version: '3.11'
       - run: python hello.py
   ```

4. **Initialize git and create GitHub repo:**
   ```bash
   git init
   git add .
   git commit -m "initial setup"
   gh repo create ci-cd-practice --public
   git remote add origin https://github.com/$(gh api user --jq .login)/ci-cd-practice.git
   git branch -M main
   git push -u origin main
   ```

## Check GitHub Actions

**Command line:**
```bash
gh run list              # List all workflow runs
gh run view --log        # View latest run logs
gh run watch             # Watch current run
```

**Web interface:**
- Go to GitHub → Your repo → Actions tab
- Click workflow run → Click job → See step output

## What Happens
1. Push triggers workflow on GitHub servers
2. GitHub spins up Ubuntu virtual machine
3. Downloads your code and runs steps
4. Results appear in Actions logs