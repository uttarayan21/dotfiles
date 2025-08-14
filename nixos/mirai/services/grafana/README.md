# Multi-Device Grafana Dashboard Setup

This directory contains Grafana dashboards configured to monitor multiple NixOS devices: `mirai`, `tsuba`, and `ryu`.

## Homepage Dashboard

When you access Grafana at `grafana.darksailor.dev`, you'll be greeted with the **Monitoring Hub Homepage** that provides:

- **Device Status Overview**: Real-time status table showing CPU, memory, disk usage, and uptime for all devices
- **Dashboard Navigation**: Color-coded tiles linking to all monitoring dashboards
- **Quick Actions**: Direct links to Prometheus targets, dashboard management, and documentation
- **Organized Layout**: Dashboards are grouped by category for easy navigation

## Dashboard Organization

Dashboards are organized into folders for better management:

### **📊 Multi-Device Monitoring**
Located in `multi-device/` folder:

#### 1. Multi-Device System Metrics
- **Purpose**: Compare system metrics across all devices on a single dashboard
- **Features**:
  - Device filtering via template variable (can select one, multiple, or all devices)
  - CPU usage comparison by device
  - Memory usage comparison by device
  - Disk usage comparison by device
  - Network I/O comparison by device
  - Service status overview
  - System uptime tracking
  - Load average trends

#### 2. Multi-Device Process Monitoring
- **Purpose**: Monitor processes across all devices
- **Features**:
  - Device filtering for process metrics
  - Process resource usage table with device column
  - CPU usage trends by process and device
  - Memory usage (resident and virtual) by process
  - Process I/O throughput monitoring
  - Process count tracking per device

### **🔍 Device-Specific**
Located in `device-specific/` folder:

#### Device-Specific System Dashboard
- **Purpose**: Detailed system monitoring for a single selected device
- **Features**:
  - Device selection via template variable
  - Detailed CPU, memory, and disk metrics
  - Network and disk I/O operations
  - System status indicators
  - Load average trends (1m, 5m, 15m)
  - Enhanced visualizations with thresholds and color coding

### **📚 Legacy Dashboards**
Located in `legacy/` folder:
- `system-dashboard.json`: Original single-device system dashboard
- `processes-dashboard.json`: Original single-device process dashboard

## Device Labels

Each device is configured with specific labels for better organization:

- **mirai**: `device=mirai, type=server, arch=x86_64`
- **tsuba**: `device=tsuba, type=server, arch=aarch64`
- **ryu**: `device=ryu, type=desktop, arch=x86_64`

## Metrics Collection

### Node Exporter (Port 9100)
Collects system-level metrics:
- CPU usage and load average
- Memory utilization
- Disk usage and I/O
- Network interface statistics
- SystemD service status
- System uptime

### Process Exporter (Port 9256)
Collects process-level metrics:
- CPU usage per process
- Memory usage (resident and virtual)
- Process I/O operations
- Process count and lifecycle

## Template Variables

### Device Selection
All multi-device dashboards include a `$device` template variable that allows:
- **Single device selection**: Monitor one specific device
- **Multiple device selection**: Compare selected devices
- **All devices**: Monitor all available devices simultaneously

The variable automatically populates with available devices based on Prometheus metrics.

## Usage Guide

### Getting Started
1. **Homepage First**: Visit `grafana.darksailor.dev` to see the homepage with device overview
2. **Dashboard Navigation**: Click on the colored tiles to access different dashboard categories
3. **Quick Status Check**: Use the device status table on the homepage for immediate health overview

### Dashboard Navigation Tips
1. **Multi-Device Comparison**: Start with multi-device dashboards to compare all systems
2. **Deep Dive Analysis**: Use device-specific dashboards for detailed single-device monitoring
3. **Process Troubleshooting**: Use multi-device process dashboard to identify resource issues
4. **Template Variables**: Use the device dropdown to filter by specific devices
5. **Time Ranges**: Adjust time ranges based on your monitoring needs (default: last 1 hour)
6. **Folder Organization**: Browse dashboards by category using the folder structure

## Customization

### Adding New Devices
To add monitoring for new devices:
1. Configure Prometheus exporters on the new device
2. Add scrape targets to the Prometheus configuration in `grafana.nix`
3. Include appropriate device labels
4. The dashboards will automatically detect the new device

### Modifying Queries
All dashboard queries use the `device=~"$device"` filter to support multi-device functionality. When customizing:
- Ensure queries include the device filter
- Use `{{device}}` in legend formats to distinguish between devices
- Consider device-specific thresholds if needed

## Troubleshooting

### Device Not Appearing
1. Check if Prometheus can reach the device's exporters
2. Verify the device label is correctly configured
3. Check Prometheus targets at `prometheus.darksailor.dev/targets`

### Missing Metrics
1. Ensure the required exporters are running on the target device
2. Check firewall rules allow access to exporter ports (9100, 9256)
3. Verify network connectivity between devices

### Performance
- Limit the number of devices selected simultaneously for better performance
- Adjust refresh rates if dashboards become slow
- Consider shorter time ranges for detailed analysis

## Homepage Features

### Device Status Table
- Real-time overview of all monitored devices
- Color-coded status indicators (UP/DOWN)
- CPU, memory, and disk usage percentages
- System uptime tracking
- Automatically updates every 30 seconds

### Dashboard Categories
- **Blue**: Multi-Device System monitoring
- **Green**: Device-Specific detailed monitoring  
- **Purple**: Multi-Device Process monitoring
- **Orange**: Legacy single-device dashboards

### Quick Actions
- **Prometheus Targets**: Direct link to check scrape target health
- **Dashboard Management**: Access to Grafana's dashboard browser
- **Data Sources**: Manage Prometheus and other data sources
- **Documentation**: Link to setup and usage documentation