# terraform-google-cli

This is a Terraform CLI extension specialized for Google Cloud. It runs Terraform commands inside a Docker container to ensure a consistent environment and automates backend initialization.

## Install terraform-google

```sh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/creal/terraform-google-cli/refs/heads/main/install.sh)"
```

## Prerequisites

Ensure the following tools are installed and configured on your machine:

- Docker: Required to run the Terraform container.
- Git: Required to determine the repository root.

### Environment Variable

You must set the GOOGLE_APPLICATION_CREDENTIALS environment variable pointing to your Google Cloud Service Account key file.

```sh
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"
```

### Configuration

1. Terraform State Bucket

This tool automatically detects the GCS bucket for remote state. You must have a GCS bucket labeled with terraform=state in your current project.

To create or label a bucket:

```sh
gcloud storage buckets create gs://BUCKET_NAME \
  --location=asia-northeast1 && \
gcloud storage buckets update gs://BUCKET_NAME \
  --update-labels=terraform=state
```

2. Directory Structure (tfvars)

Create a `tfvars` file for each environment as shown below. You can define as many environments as needed.
The directory name (e.g., `prod`, `stg`) corresponds to the environment name passed via the `-e` option.

```
.
├── environments/
│   ├── prod/
│   │   └── terraform.tfvars
│   └── stg/
│       └── terraform.tfvars
├── modules/
└── main.tf
```

## Usage

```sh
terraform-google [-e environment] <subcommand> [args...]
```

```
Options:
  -e environment    Specify the target environment (e.g., dev, prod).
                    Required for 'plan' and 'apply' commands.
  -h                Show this help message and exit.

Subcommands:
  plan              Generate and show an execution plan.
  apply             Builds or changes infrastructure.
  mv <src> <dst>    Move an item in the state.
  rm <address>      Remove one or more items from the state.
  unlock <id>       Unlock the state for a specific lock ID.

Examples:
  # Plan for development environment
  terraform-google -e dev plan

  # Remove a resource from state
  terraform-google rm module.vpc.google_compute_network.main

  # Unlock a state lock
  terraform-google unlock 1234-5678-90ab-cdef
```
