# EESSI Interactive Applications for Open OnDemand (AppVerse Collection)

A collection of **25 standalone Open OnDemand Batch Connect applications** powered by the [European Environment for Scientific Software Installations (EESSI)](https://www.eessi.io/).

Each `bc_eessi_*` directory is a self-contained Open OnDemand application that mounts and executes software directly from `/cvmfs/software.eessi.io`—requiring **no local containers, no root daemons, and no open service ports**.

## Included Applications

### Web Applications (`batch-connect-basic`)
| App Directory | Application | EESSI Release |
| :--- | :--- | :--- |
| `bc_eessi_jupyter` | JupyterLab | `2025.06` |
| `bc_eessi_jupyter_notebook` | Jupyter Notebook | `2025.06` |
| `bc_eessi_rstudio` | RStudio Server | `2025.06` |
| `bc_eessi_mlflow` | MLflow | `2025.06` |
| `bc_eessi_tensorboard` | TensorBoard | `2025.06` |
| `bc_eessi_bokeh` | Bokeh | `2025.06` |

### Graphical / VNC Applications (`batch-connect-vnc`)
| App Directory | Application | EESSI Release |
| :--- | :--- | :--- |
| `bc_eessi_paraview` | ParaView | `2025.06` |
| `bc_eessi_gmsh` | Gmsh | `2025.06` |
| `bc_eessi_gnuplot` | gnuplot | `2025.06` |
| `bc_eessi_feh` | feh | `2025.06` |
| `bc_eessi_xterm` | xterm | `2025.06` |
| `bc_eessi_jgmenu` | jgmenu | `2025.06` |
| `bc_eessi_vispy` | VisPy | `2025.06` |
| `bc_eessi_vulkan_tools` | Vulkan Tools (`vkcube`, `vulkaninfo`) | `2025.06` |
| `bc_eessi_opengl_mesa_demos` | OpenGL / Mesa Demos (`glxgears`, `glxinfo`) | `2025.06` |
| `bc_eessi_paraver` | Paraver (`wxparaver`) | `2023.06` |
| `bc_eessi_lavavu` | LavaVu | `2023.06` |
| `bc_eessi_fastqc` | FastQC | `2023.06` |
| `bc_eessi_root` | CERN ROOT (`TRootBrowser` + Cling) | `2023.06` |
| `bc_eessi_grass` | GRASS GIS (`wxGUI`) | `2023.06` |
| `bc_eessi_octave` | GNU Octave | `2023.06` |
| `bc_eessi_imagemagick_display` | ImageMagick Display | `2023.06` |
| `bc_eessi_ipython_qtconsole` | IPython QtConsole | `2023.06` |
| `bc_eessi_graphviz` | Graphviz (`gvedit`) | `2023.06` |
| `bc_eessi_valgrind` | Valgrind (Memcheck, Massif, Callgrind, Helgrind) | `2023.06` |

---

## Architecture & Dynamic Module Discovery

1. **Zero Root Services or Open Ports:** Applications resolve available module versions directly inside `form.yml.erb` at render time—no background daemon or listening port is required.
2. **Three-Tier Module Resolution:**
   - **Tier 1 (Optional Local JSON Cache):** Reads `/var/cache/eessi-ood/eessi_catalog_<version>.json`, which sites can refresh every 12 hours via an unprivileged user cron job fetching EESSI's published metadata (`[https://www.eessi.io/api_data/data/eessi_api_metadata_software.json](https://www.eessi.io/api_data/data/eessi_api_metadata_software.json)`).
   - **Tier 2 (Built-in Fallback List):** If no local JSON cache is configured, `form.yml.erb` automatically falls back to the verified module list bundled in the app—so apps work out-of-the-box immediately after installation.
   - **Tier 3 (Optional CVMFS Lmod Spider Cache Symlink):** Sites using OOD's native `auto_modules` can symlink EESSI's pre-built Lmod cache directly from CVMFS (`$EESSI_SOFTWARE_PATH/.lmod/cache`) without running `lmod spider` locally.
3. **Runtime Execution-Node Validation:** Every app's `before.sh.erb` verifies `/cvmfs/software.eessi.io` availability on the compute node before sourcing `init/lmod/bash` and loading the user-selected module.

---

## Site Configuration Reference

All applications are site-agnostic (`cluster: "*"`) and inherit cluster-level settings from `/etc/ood/config/clusters.d/<cluster>.yml`. Sites can customize behavior without modifying application source files:

| Parameter | Where to Configure | Default | Purpose |
| :--- | :--- | :--- | :--- |
| **Cluster Name** | `/etc/ood/config/clusters.d/<cluster>.yml` | Automatic (`cluster: "*"`) | OOD automatically routes to your configured cluster(s). |
| **EESSI Mount Root** | `/etc/default/eessi-ood` (`EESSI_ROOT`) or `/etc/ood/config/apps/<app>/env` | `/cvmfs/software.eessi.io` | Override if CVMFS is mounted under a custom path. |
| **EESSI Release Version** | `/etc/default/eessi-ood` (`EESSI_VERSION_OVERRIDE`) | `2025.06` (or `2023.06` for legacy apps) | Override the default EESSI stack release per site or per app. |
| **EESSI CPU Target Override** | `/etc/default/eessi-ood` (`EESSI_SOFTWARE_SUBDIR_OVERRIDE`) | Auto-detected by EESSI | Set (e.g., `x86_64/generic`) on VMs or nodes where hypervisor CPU flags differ from physical host microarchitecture. |
| **Websockify Path** | `/etc/ood/config/clusters.d/<cluster>.yml` (`v2.batch_connect.vnc.websockify_cmd`) | `/usr/bin/websockify` | Required on execution nodes for `vnc` template apps (use a websockify build supporting `--heartbeat` for OOD 4.x). |
| **TurboVNC Path** | `/etc/ood/config/clusters.d/<cluster>.yml` (`v2.batch_connect.vnc.script_wrapper`) | `/opt/TurboVNC/bin` | Prepend TurboVNC `bin` directory to `PATH` in your cluster's `script_wrapper`. |
| **XDG / gdk-pixbuf / Theme Paths** | `/etc/ood/config/clusters.d/<cluster>.yml` (`v2.batch_connect.vnc.script_wrapper`) | `XDG_DATA_DIRS=/usr/local/share:/usr/share` | Ensures Openbox themes, system icons, and GTK/gdk-pixbuf loaders resolve cleanly alongside EESSI. |
| **Web App Bind Address** | `/etc/default/eessi-ood` (`OOD_APP_BIND_HOST`) | `${host}` | Controls bind address for web apps (`bc_eessi_bokeh`, `bc_eessi_mlflow` proxy, `bc_eessi_tensorboard`); set `127.0.0.1` on single-node or NAT-addressed VMs. |
| **Bokeh WebSocket Origin** | `/etc/default/eessi-ood` (`OOD_PUBLIC_HOST`) | `$(hostname -f)` | Set to your external OOD portal hostname if behind a reverse proxy or load balancer. |
| **IPython QtConsole Venv** | `/etc/default/eessi-ood` (`QTCONSOLE_VENV`) | `~/.local/share/eessi-ood/ipython-qtconsole-<version>` | Optional path to a shared pre-built QtConsole environment (falls back to `/opt/ood-apps/ipython-qtconsole` or per-user auto-bootstrap). |

### Example Cluster VNC Configuration (`/etc/ood/config/clusters.d/my_cluster.yml`)

```yaml
v2:
  batch_connect:
    vnc:
      websockify_cmd: "/usr/bin/websockify"
      script_wrapper: |
        export PATH="/opt/TurboVNC/bin:$PATH"
        export XDG_DATA_DIRS="/usr/local/share:/usr/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
        %s
```

## Operational Recommendations

Copy any subset (or all 25) of the bc_eessi_<app> directories into /var/www/ood/apps/sys/ (or install directly via the Open OnDemand AppVerse catalog using appverse.yml):

```bash
git clone [https://github.com/doitnowgroup/eessi-ood-appverse.git](https://github.com/doitnowgroup/eessi-ood-appverse.git)
sudo cp -r eessi-ood-appverse/bc_eessi_* /var/www/ood/apps/sys/
```

## License

This project is licensed under the Apache License 2.0.
