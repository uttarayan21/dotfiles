# Troubleshooting

## BB_Launcher: "Only one instance of app can be opened"

BB_Launcher uses shared memory (shm) for single-instance detection. If it crashes or is killed without cleanup, stale shm segments remain and block relaunch.

**Fix:** Remove the orphaned shared memory segments:
```bash
# List segments to identify BB_Launcher's (owned by your user)
ipcs -m

# Remove by shmid (replace 0 and 1 with actual shmid values)
ipcrm -m 0
ipcrm -m 1
```
