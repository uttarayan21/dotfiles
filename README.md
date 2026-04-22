# Machines

1. Ryu Dektop (Intel i9-14900KS / Nvidia RTX 5090 / DDR5 64GB CL36@6000MTs) 
    ```
    deploy -s .#ryu
    ```
2. Tako Server (Intel Xeon E-2236 / DDR5 64GB)
    ```
    deploy -s .#tako
    ```
3. Tsuba Server  (Raspberry Pi 5 / 8GB)
    ```
    deploy -s .#tsuba
    ```
4. Kuro Laptop (Apple M4 Pro macbook / 24GB)
    ```
    deploy -s .#kuro
    ```
5. Shiro Desktop (Apple M4 macmini / 16GB)
    ```
    deploy -s .#shiro
    ```

## Troubleshooting

### BB_Launcher: "Only one instance of app can be opened"

BB_Launcher uses shared memory (shm) for single-instance detection. If it crashes or is killed without cleanup, stale shm segments remain and block relaunch.

**Fix:** Remove the orphaned shared memory segments:
```bash
# List segments to identify BB_Launcher's (owned by your user)
ipcs -m

# Remove by shmid (replace 0 and 1 with actual shmid values)
ipcrm -m 0
ipcrm -m 1
```
