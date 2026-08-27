# Architecture

## Responsibility boundary

```text
OpenTofu/Terraform
  ├─ Hetzner SSH key
  ├─ static primary IPv4
  ├─ Cloud Firewall
  └─ Ubuntu server + cloud-init
       └─ Plane release Docker Compose
            ├─ web, admin, space, live
            ├─ API, worker, beat, migrator
            ├─ PostgreSQL, Valkey, RabbitMQ, MinIO
            └─ Caddy-based proxy on 80/443
```

The module deliberately does not translate Plane's services into individual OpenTofu resources. Plane publishes and tests those services as one versioned Compose bundle. Keeping that boundary makes application upgrades recognizable to Plane operators and avoids a divergent deployment specification.

## Bootstrap

Cloud-init installs distribution-packaged Docker, downloads assets from the pinned Plane GitHub release, generates service secrets locally, renders `plane.env`, and starts Compose. Generated secrets never appear in OpenTofu configuration or state.

Cloud-init is first-boot configuration, not a continuous deployment mechanism. Changing its template on an existing server may update the planned server metadata but does not rerun bootstrap. Application upgrades therefore use Plane's explicit backup-and-upgrade procedure.

## Availability and growth

The default is a single CAX11 node for a small team. It has 4 GB RAM and a 2 GiB swap safety valve; resize to CAX21 before sustained swap, repeated OOM events, larger imports, or heavier concurrent work. Hetzner backups improve recovery but do not make the service highly available. For business-critical use, externalize PostgreSQL and S3-compatible object storage, establish monitored off-server backups, and evaluate an orchestrated deployment separately.

Small 4 GB deployments may configure a host swap file to reduce out-of-memory termination during migrations or workload spikes. Swap is deliberately opt-in and is not equivalent to RAM; sustained swap activity is a signal to resize the server.
