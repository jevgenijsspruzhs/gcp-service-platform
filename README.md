# gcp-service-platform

The Google Cloud infrastructure of one team's service, `inventory-api`, as Terraform:

- **Artifact Registry:** a Docker repository for the service's images.
- **Cloud Storage:** a data bucket with versioning, uniform bucket-level access and public access
  prevention; old object versions beyond the newest five are deleted.
- **Cloud Run:** the service itself (v2), internal ingress only, scaled from `min_instances`.
- **IAM:** a dedicated runtime service account (the local module `modules/service-account`) with
  only the roles the service needs: writing logs and metrics, reading its images, and its bucket.

## Layout

| Path | What |
|---|---|
| `versions.tf`, `providers.tf` | Terraform and the `hashicorp/google` provider (locked in `.terraform.lock.hcl`) |
| `variables.tf`, `outputs.tf` | the inputs (with validation) and outputs |
| `main.tf` | the resources |
| `modules/service-account/` | a service account with a fixed list of project roles; basic roles are refused |
| `environments/*.tfvars` | the values per environment (`dev`, `prod`) |

## Checks

Every change must pass, without credentials and without touching any cloud resource:

```sh
terraform fmt -check -recursive
terraform init -backend=false -input=false -lockfile=readonly
terraform validate
tflint --recursive
```

CI runs the same four on every pull request.

## Deploying

Plans and applies are run by the platform team, against the remote state, never from CI or a
developer's machine:

```sh
terraform plan -var-file=environments/dev.tfvars
```

The state backend is configured by the platform team at apply time and is not part of this
repository.
