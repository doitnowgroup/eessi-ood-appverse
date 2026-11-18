# VisPy - EESSI

Launch an interactive VisPy visualization environment using EESSI.
VisPy provides high-performance interactive 2D and 3D visualization
using OpenGL and can run custom Python visualization scripts.

This Open OnDemand Batch Connect application launches **VisPy** directly from the [European Environment for Scientific Software Installations (EESSI)](https://www.eessi.io/) (`EESSI/2025.06`) without requiring local container builds or privileged background services.

## Prerequisites

1. **CVMFS & EESSI:** `/cvmfs/software.eessi.io` mounted on execution nodes with release `2025.06`.
2. **Open OnDemand 3.1 / 4.x** configured with at least one cluster in `/etc/ood/config/clusters.d/<cluster>.yml`.

3. **VNC & X11 Runtime on Execution Nodes:** TurboVNC (`vncserver`), `websockify`, `openbox`, and `xterm` available on `PATH` (configured under `batch_connect.vnc` in `/etc/ood/config/clusters.d/<cluster>.yml`).


## Installation

1. Copy or clone this application directory into your Open OnDemand system apps directory (typically `/var/www/ood/apps/sys/bc_bc_eessi_vispy`):
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

| **Websockify & TurboVNC** | `/etc/ood/config/clusters.d/<cluster>.yml` (`batch_connect.vnc`) | `websockify`, `vncserver` on `PATH` | Set `websockify_cmd` and prepend TurboVNC `bin` to `PATH` in `script_wrapper`. |
| **XDG / gdk-pixbuf paths** | `/etc/ood/config/clusters.d/<cluster>.yml` (`script_wrapper`) | `/usr/local/share:/usr/share` | Export `XDG_DATA_DIRS` so Openbox themes and icons load cleanly. |




## Known Limitations

- **CVMFS Cold-Cache Latency:** Initial module loads on a node with an empty CVMFS cache may take 15–30 seconds while libraries stream from Stratum-1 mirrors.
- **Per-App EESSI Release Pinning:** The dropdown fallback module list in `form.yml.erb` is generated for `EESSI/2025.06`; override `EESSI_VERSION_OVERRIDE` per app rather than globally across mixed `2023.06` and `2025.06` apps.



## License

Apache-2.0

