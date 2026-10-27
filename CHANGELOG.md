# Changelog

## Unreleased

- The image repository, the data bucket and the Cloud Run service carry the standard labels: `team`, `environment`, `managed-by` and `cost-center`.
- New variable `cost_center`, validated as `cc-` followed by four digits; set to `cc-4100` for dev and `cc-4200` for prod.

## 0.3.0

- The data bucket deletes object versions beyond the newest five.
- The runtime service account comes from the `service-account` module.

## 0.2.0

- The Cloud Run service moved to the v2 API, with internal ingress only.

## 0.1.0

- First version: the image repository, the data bucket and the service.
