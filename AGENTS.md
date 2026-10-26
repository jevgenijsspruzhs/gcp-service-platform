# Contributing to gcp-service-platform

- **Format and lint:** `terraform fmt -recursive`; `terraform validate` and `tflint --recursive`
  must pass. Never commit `.terraform/` or any state file.
- **Least privilege:** grant the narrowest predefined role on the narrowest resource. Basic roles
  (`roles/owner`, `roles/editor`, `roles/viewer`) are never used, and nothing is granted to
  `allUsers` or `allAuthenticatedUsers` without an approved issue that says so.
- **Labels:** every resource that supports labels carries the platform's standard labels.
- **Variables** are typed, have a description, and validate what they can.
- **No destroy by accident:** a rename or a move of a resource comes with a `moved` block, so the
  plan shows no destroy and re-create.
- **Provider versions:** change the constraint in `versions.tf` only in an issue of its own, and
  update `.terraform.lock.hcl` with it.
- **Plans and applies** are the platform team's. A change here is reviewed as code; the plan is
  reviewed before anything is applied.
- **Commits:** `area: what changed` in the imperative, e.g. `iam: drop object delete from the
  runtime role`. Reference the issue key in the body.
- **Changelog:** add a line to `CHANGELOG.md` under "Unreleased" for every change.
