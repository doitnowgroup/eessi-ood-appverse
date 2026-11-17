# MLflow - EESSI

Launch MLflow using software provided by EESSI.
Track machine learning experiments, parameters,
metrics, models and artifacts.

This Open OnDemand Batch Connect application launches **MLflow** directly from the [European Environment for Scientific Software Installations (EESSI)](https://www.eessi.io/) (`EESSI/2025.06`) without requiring local container builds, open ports, or root daemons.

## Prerequisites

1. **CVMFS & EESSI:** `/cvmfs/software.eessi.io` mounted on execution nodes with release `2025.06`.
2. **Open OnDemand 3.1 / 4.x** configured with at least one cluster in `/etc/ood/config/clusters.d/<cluster>.yml`.


## Site Configuration

No edits to the application files are required for standard deployments:

| Setting | Location | Default | Notes |
| :--- | :--- | :--- | :--- |
| **Cluster routing** | `/etc/ood/config/clusters.d/<cluster>.yml` | Automatic (`cluster: "*"`) | Automatically selects your site's configured cluster(s). |
| **EESSI mount path** | `/etc/default/eessi-ood` (`EESSI_ROOT`) | `/cvmfs/software.eessi.io` | Override if CVMFS is mounted at a custom prefix. |
| **EESSI release** | `/etc/default/eessi-ood` (`EESSI_VERSION_OVERRIDE`) | `2025.06` | Override default EESSI stack version. |
| **Dynamic module list** | `/var/cache/eessi-ood/eessi_catalog_2025.06.json` | Built-in fallback list | Optionally refreshed every 12h from `https://www.eessi.io/api_data/data/eessi_api_metadata_software.json` via an unprivileged cron job. |


| **Bind address** | `/etc/default/eessi-ood` (`OOD_APP_BIND_HOST`) | `${host}` (`127.0.0.1` on `systemd`) | Set to `127.0.0.1` on single-node `systemd` hosts; leave unset on multi-node Slurm clusters (use compute-node firewall rules). |



## License

Apache-2.0

