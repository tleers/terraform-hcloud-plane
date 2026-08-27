# Plane on Hetzner

This runbook deploys Plane Community Edition on one Hetzner Cloud server. It is a sensible starting point for a two-person company and keeps the migration path to managed PostgreSQL and S3-compatible storage open.

For a reproducible deployment, use the module at this repository's root. The manual steps below remain useful for understanding and operating the server.

## Recommended shape

- Ubuntu 24.04 LTS, x86-64 or ARM64
- The default CAX11 profile: 2 vCPU, 4 GB RAM, 40 GB disk, and a 2 GiB swap safety valve for a small team
- CAX21 (4 vCPU, 8 GB RAM, 80 GB disk) when usage or background work needs more memory headroom
- A dedicated hostname such as `plane.example.com`
- Hetzner Cloud Firewall allowing TCP 80 and 443 from anywhere, and TCP 22 only from the founders' fixed IPs or a private VPN
- Hetzner server backups enabled, plus a separate off-server application backup

Do not expose PostgreSQL, Redis/Valkey, RabbitMQ, or MinIO ports publicly. Docker Compose keeps them on its private network; only Plane's proxy should publish ports 80 and 443.

For a small installation, colocating the services is the simplest operational choice. If Plane becomes business-critical, move PostgreSQL and object storage off the VM before scaling the application tier.

## DNS and server preparation

1. Create the server and reserve/attach a primary public IP.
2. Add an `A` record for `plane.example.com` pointing to that IP. Add an `AAAA` record only if IPv6 is configured and tested.
3. Create a non-root sudo user with SSH keys, disable SSH password authentication, and apply security updates.
4. Install Docker Engine from Docker's official Ubuntu repository and confirm `docker compose version` works.
5. Attach the Cloud Firewall described above.

## Install Plane Community Edition

Run as the deployment user from a persistent directory:

```bash
sudo mkdir -p /opt/plane-selfhost
sudo chown "$USER":"$USER" /opt/plane-selfhost
cd /opt/plane-selfhost
curl -fsSL -o setup.sh https://github.com/makeplane/plane/releases/latest/download/setup.sh
chmod +x setup.sh
./setup.sh install
```

Edit `/opt/plane-selfhost/plane-app/plane.env` before starting:

```dotenv
APP_DOMAIN=plane.example.com
WEB_URL=https://plane.example.com
CORS_ALLOWED_ORIGINS=https://plane.example.com
LISTEN_HTTP_PORT=80
LISTEN_HTTPS_PORT=443
SITE_ADDRESS=:80
CERT_EMAIL=ops@example.com
```

Replace all shipped database, RabbitMQ, and object-storage passwords/keys with unique generated secrets. Keep `DEBUG=0`. Then start and verify:

```bash
cd /opt/plane-selfhost
./setup.sh start
docker compose -f plane-app/docker-compose.yaml --env-file plane-app/plane.env ps
curl -I https://plane.example.com
```

Complete the first-run flow immediately to claim the instance-admin account.

## Authentication for a cofounder

The recommended small-team setup is invite-only access with SMTP and either password login or GitHub OAuth:

1. Open `https://plane.example.com/god-mode` as the instance admin.
2. Under **General**, disable **Allow anyone to sign up without an invite** and enable **Prevent anyone from creating a workspace**.
3. Under **Email**, configure an authenticated SMTP relay. This enables invitations, password resets, and unique-code login.
4. Keep password login enabled as a recovery path. Invite the cofounder's email address from the workspace and assign the appropriate workspace role.
5. Optionally configure GitHub OAuth in **God mode → Authentication → GitHub**. Register a GitHub OAuth App with:
   - Homepage: `https://plane.example.com`
   - Callback: `https://plane.example.com/auth/github/callback/`
   - Mobile callback, if needed: `https://plane.example.com/auth/mobile/github/callback/`
6. Test in a private browser window as the cofounder before disabling any alternative login method.

GitHub OAuth is the best convenience option when both founders already use GitHub. SMTP is still worth configuring because invitations, password resets, notifications, and exports depend on email. Custom OIDC is a Pro/Business feature, so it is not the default recommendation for Community Edition.

Do not make the cofounder an instance admin unless they need infrastructure-wide administration. If they do, first let them register with the exact email address, then run:

```bash
docker exec plane-app-api-1 python manage.py create_instance_admin cofounder@example.com
```

Container names can vary; obtain the API container name with `docker ps --format '{{.Names}}' | grep api` first.

## Backups and upgrades

- Enable Hetzner server backups for fast whole-VM recovery.
- Schedule Plane's `./setup.sh backup` and copy the resulting archive off the server (for example to a private S3-compatible bucket). A backup left only on the VM is not a disaster-recovery backup.
- Separately back up `plane-app/plane.env` in an encrypted secrets store.
- Before every upgrade, run and export a backup. Download the newest `setup.sh`, run `./setup.sh upgrade`, compare any new variables with `plane.env`, then start and smoke-test the instance.
- Test a restore periodically on a separate machine.

## Operational checks

After deployment, verify:

- HTTPS has a valid certificate and HTTP redirects to HTTPS.
- Public scans show only ports 22 (restricted), 80, and 443.
- Anonymous signup and workspace creation are disabled.
- The cofounder can accept an invitation, log in, log out, and reset their password.
- Uploads work and survive a container restart.
- A backup is copied off-server and can be restored.
- Docker and OS security updates are scheduled, with monitoring for disk usage and container health.
