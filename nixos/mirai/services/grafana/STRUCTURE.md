# Grafana Dashboard Structure

## Directory Layout

```
dotfiles/nixos/mirai/services/grafana/
├── README.md                           # Main documentation
├── STRUCTURE.md                        # This file - structure overview
├── homepage/
│   └── homepage-dashboard.json         # Main homepage dashboard
├── multi-device/
│   ├── multi-device-system-dashboard.json     # System metrics across devices
│   └── multi-device-processes-dashboard.json  # Process monitoring across devices
├── device-specific/
│   └── device-specific-system-dashboard.json  # Single device detailed view
└── legacy/
    ├── system-dashboard.json           # Original system dashboard
    └── processes-dashboard.json        # Original process dashboard
```

## Dashboard Hierarchy

```
🏠 Homepage (monitoring-homepage)
├── Device Status Overview Table
├── Quick Dashboard Links
└── Action Buttons
    │
    ├── 📊 Multi-Device Monitoring/
    │   ├── Multi-Device System (multi-device-system)
    │   └── Multi-Device Processes (multi-device-processes)
    │
    ├── 🔍 Device-Specific/
    │   └── Device System Dashboard (device-system-${device})
    │
    └── 📚 Legacy Dashboards/
        ├── Legacy System (system-metrics)
        └── Legacy Processes (process-metrics)
```

## Dashboard Features Matrix

| Dashboard | Device Filter | Comparison | Time Series | Status | Process Data |
|-----------|--------------|------------|-------------|---------|--------------|
| Homepage | ❌ | ✅ | ❌ | ✅ | ❌ |
| Multi-Device System | ✅ | ✅ | ✅ | ✅ | ❌ |
| Multi-Device Processes | ✅ | ✅ | ✅ | ❌ | ✅ |
| Device-Specific | ✅ | ❌ | ✅ | ✅ | ❌ |
| Legacy System | ❌ | ❌ | ✅ | ✅ | ❌ |
| Legacy Processes | ❌ | ❌ | ✅ | ❌ | ✅ |

## User Journey Flow

```
1. User visits grafana.darksailor.dev
   ↓
2. Homepage loads automatically
   ↓
3. User sees device status overview
   ↓
4. User clicks dashboard tile based on need:
   │
   ├── Multi-Device System → Compare all devices
   ├── Device-Specific → Deep dive single device
   ├── Multi-Device Processes → Process monitoring
   └── Legacy → Original dashboards
   ↓
5. User uses template variables to filter data
   ↓
6. User navigates between dashboards using links
```

## Configuration Mapping

| Grafana Folder | File Path | Provision Path |
|----------------|-----------|----------------|
| Root | `homepage/` | `/etc/grafana/dashboards/homepage/` |
| Multi-Device Monitoring | `multi-device/` | `/etc/grafana/dashboards/multi-device/` |
| Device-Specific | `device-specific/` | `/etc/grafana/dashboards/device-specific/` |
| Legacy Dashboards | `legacy/` | `/etc/grafana/dashboards/legacy/` |

## Metrics Coverage

### System Metrics (Node Exporter - Port 9100)
- ✅ CPU usage and load average
- ✅ Memory utilization (used/total)
- ✅ Disk usage and I/O operations
- ✅ Network interface statistics
- ✅ SystemD service status
- ✅ System uptime and boot time

### Process Metrics (Process Exporter - Port 9256)
- ✅ CPU usage per process group
- ✅ Memory usage (resident/virtual)
- ✅ Process I/O operations (read/write)
- ✅ Process count and lifecycle
- ✅ Process resource trends

## Device Labels

| Device | Type | Architecture | Services |
|--------|------|--------------|----------|
| mirai | server | x86_64 | Grafana, Prometheus, Caddy |
| tsuba | server | aarch64 | Media services, NAS |
| ryu | desktop | x86_64 | Gaming, Development |

## Color Coding

### Dashboard Categories
- 🔵 **Blue**: Multi-Device System monitoring
- 🟢 **Green**: Device-Specific detailed monitoring
- 🟣 **Purple**: Multi-Device Process monitoring
- 🟠 **Orange**: Legacy single-device dashboards

### Status Indicators
- 🟢 **Green**: Service UP / Normal operation
- 🔴 **Red**: Service DOWN / Critical threshold
- 🟡 **Yellow**: Warning threshold
- 🔵 **Blue**: Information / Navigation

## Dashboard UIDs Reference

| Dashboard | UID | URL Path |
|-----------|-----|----------|
| Homepage | `monitoring-homepage` | `d/monitoring-homepage` |
| Multi-Device System | `multi-device-system` | `d/multi-device-system` |
| Multi-Device Processes | `multi-device-processes` | `d/multi-device-processes` |
| Device-Specific | `device-system-${device}` | `d/device-system-mirai` |
| Legacy System | `system-metrics` | `d/system-metrics` |
| Legacy Processes | `process-metrics` | `d/process-metrics` |

## Refresh Rates

- Homepage: 30 seconds
- Multi-Device dashboards: 30 seconds
- Device-Specific: 30 seconds  
- Legacy dashboards: 30 seconds

## Template Variables

### Device Selection ($device)
- **Type**: Query variable
- **Query**: `label_values(up, device)`
- **Multi-select**: Yes (for multi-device dashboards)
- **Include All**: Yes
- **Current Values**: mirai, tsuba, ryu

## Quick Access URLs

- Homepage: `https://grafana.darksailor.dev/d/monitoring-homepage`
- Multi-Device System: `https://grafana.darksailor.dev/d/multi-device-system`
- Prometheus Targets: `https://prometheus.darksailor.dev/targets`
- Dashboard Browser: `https://grafana.darksailor.dev/dashboards`

## Maintenance Notes

- Dashboards auto-update from provisioned files
- New devices appear automatically when exporters are configured
- Template variables refresh every page load
- Dashboard folders are recreated on Grafana restart
- Homepage is set as default landing page for all users