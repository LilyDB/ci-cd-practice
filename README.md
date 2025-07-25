# CI/CD Practice Guide

## Working CI/CD Workflows

This repository demonstrates real CI/CD practices with working examples.

### ✅ **Continuous Integration (CI) Workflows**

#### 1. Complete CI Pipeline (`.github/workflows/complete.yml`)
```yaml
name: Complete CI/CD
on:
  push:
    paths: ['*.py', 'requirements.txt', '.github/workflows/**']
jobs:
  test-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    - name: Install dependencies
      run: pip install bandit safety flake8 pytest
    - name: Run pytest calculator tests
      run: pytest test_calculator.py -v
    - name: Run security scan
      run: |
        bandit -r . -f json -o bandit-report.json || true
        safety check --json --output safety-report.json || true
        flake8 --max-line-length=88 *.py || true
    - name: Test web app
      run: |
        python app.py &
        sleep 3
        curl -f http://localhost:8001/health || exit 1
        pkill -f "python app.py"
    - name: Upload security reports
      uses: actions/upload-artifact@v4
      with:
        name: security-reports
        path: "*-report.json"
```

**What it does:**
- Runs tests with pytest
- Security scanning (Bandit, Safety)
- Code quality checks (flake8)
- Health checks on web app
- Uploads security reports as artifacts

#### 2. Security Scanning (`.github/workflows/security.yml`)
- **Schedule:** Weekly on Mondays at 8 AM UTC
- **Trigger:** When `requirements.txt` changes
- **Tools:** Bandit, Safety, flake8


### ✅ **Continuous Deployment (CD) Workflows**

#### 1. Terraform Infrastructure Deployment (`.github/workflows/terraform.yml`)
```yaml
name: 'Terraform Deploy'
on: [push]
jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
    - name: Terraform Init
      run: terraform init
    - name: Terraform Validate
      run: terraform validate
    - name: Terraform Plan
      run: terraform plan -input=false
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: terraform apply -auto-approve -input=false
    - name: Upload deployment artifact
      uses: actions/upload-artifact@v4
      with:
        name: terraform-deployment
        path: deployment-info.txt
```

**Real deployment:** Creates `deployment-info.txt` with deployment metadata and timestamp.

## Key CI/CD Concepts Demonstrated

### **Path-based Triggers**
```yaml
on:
  push:
    paths:
      - '*.py'
      - 'requirements.txt'
      - '.github/workflows/**'
```
Only runs when relevant files change, saving GitHub Actions minutes.

### **Scheduled Workflows**
```yaml
on:
  schedule:
    - cron: '0 8 * * 1'  # Every Monday at 8 AM UTC
```

### **Conditional Deployment**
```yaml
- name: Terraform Apply
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: terraform apply -auto-approve -input=false
```

### **Artifact Management**
```yaml
- name: Upload security reports
  uses: actions/upload-artifact@v4
  with:
    name: security-reports
    path: "*-report.json"
```

## Commands to Check Workflows

```bash
# List all workflow runs
gh run list

# View latest run logs
gh run view --log

# Watch current run in real-time
gh run watch

# Download artifacts
gh run download [run-id]
```

## Files in This Repository

- `app.py` - Simple HTTP server with health endpoint
- `calculator.py` - Basic calculator functions
- `test_calculator.py` - Pytest tests
- `hello.py` - Simple hello world script
- `Dockerfile` - Container configuration
- `main.tf` - Terraform infrastructure configuration
- `requirements.txt` - Python dependencies

## Real-World Practices Shown

1. **CI Pipeline:** Test → Lint → Security scan → Build
2. **CD Pipeline:** Deploy infrastructure with Terraform
3. **Security:** Automated vulnerability scanning
4. **Scheduling:** Weekly security audits
5. **Artifacts:** Download build outputs and reports
6. **Conditional Logic:** Deploy only from main branch