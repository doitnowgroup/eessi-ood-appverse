# Bokeh - EESSI

Launch interactive Bokeh dashboards using EESSI.
Visualize scientific data directly in your browser.

This Open OnDemand Batch Connect application launches **bokeh** directly from the [European Environment for Scientific Software Installations (EESSI)](https://www.eessi.io/) (`EESSI/2025.06`) without requiring local container builds or privileged background services.

## Prerequisites

1. **CVMFS & EESSI:** `/cvmfs/software.eessi.io` mounted on execution nodes with release `2025.06`.
2. **Open OnDemand 3.1 / 4.x** configured with at least one cluster in `/etc/ood/config/clusters.d/<cluster>.yml`.


## Installation

1. Copy or clone this application directory into your Open OnDemand system apps directory (typically `/var/www/ood/apps/sys/bc_bc_eessi_bokeh`):
   ~~~bash
   cp -r bc_eessi_* /var/www/ood/apps/sys/
   ~~~
2. Ensure permissions are set to `0755` for directories and scripts under `template/`, and `0644` for YAML and Markdown files.
3. Restart your Per-User NGINX (PUN) or wait for the dashboard app cache to refresh; the application will appear under **Interactive Apps**.

## Site Configuration

No edits to the application files are required for standard deployments:

| Setting | Location | Default | Notes |
| :--- | :--- | :--- | :--- |
| **Cluster routing** | `/etc/ood/config/clusters.d/<cluster>.yml` | Automatic (`cluster: "*"`) | Automatically selects your site's configured cluster(s). |
| **EESSI mount path** | `/etc/default/eessi-ood` (`EESSI_ROOT`) | `/cvmfs/software.eessi.io` | Override if CVMFS is mounted at a custom prefix. |
| **EESSI release** | `/etc/ood/config/apps/<app>/env` (`EESSI_VERSION_OVERRIDE`) | `2025.06` | Set per-app (rather than globally in `/etc/default/eessi-ood`) if overriding the default stack version. |
| **Dynamic module list** | `/var/cache/eessi-ood/eessi_catalog_2025.06.json` | Built-in fallback list | Optionally refreshed every 12h from `[https://www.eessi.io/api_data/data/eessi_api_metadata_software.json](https://www.eessi.io/api_data/data/eessi_api_metadata_software.json)` via an unprivileged cron job. |


| **Bind address** | `/etc/default/eessi-ood` (`OOD_APP_BIND_HOST`) | `${host}` (`127.0.0.1` on `systemd`) | Set to `127.0.0.1` on single-node `systemd` hosts; use compute-node firewall rules on multi-node Slurm clusters. |


| **Public hostname** | `/etc/default/eessi-ood` (`OOD_PUBLIC_HOST`) | `$(hostname -f)` | Set to your external OOD DNS name for WebSocket origin validation. |


## Known Limitations

- **CVMFS Cold-Cache Latency:** Initial module loads on a node with an empty CVMFS cache may take 15–30 seconds while libraries stream from Stratum-1 mirrors.
- **Per-App EESSI Release Pinning:** The dropdown fallback module list in `form.yml.erb` is generated for `EESSI/2025.06`; override `EESSI_VERSION_OVERRIDE` per app rather than globally across mixed `2023.06` and `2025.06` apps.


- **Network Isolation:** These servers rely on OOD's reverse proxy and compute-node network isolation; configure compute-node firewall rules so only the OOD portal host can reach ephemeral job ports.


## License

Apache-2.0

