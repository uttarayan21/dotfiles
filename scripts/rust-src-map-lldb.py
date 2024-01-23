import subprocess

# Get the default Rust toolchain
toolchain_command = "rustup toolchain list | grep '(default)' | cut -d' ' -f 1"
TOOLCHAIN = subprocess.check_output(
    toolchain_command, shell=True, text=True).strip()

# Get the commit hash of the installed Rust compiler
commit_hash_command = "rustc -Vv | grep commit-hash | cut -d' ' -f 2"
COMMIT_HASH = subprocess.check_output(
    commit_hash_command, shell=True, text=True).strip()

# Get the Rustup home directory
rustup_home_command = "rustup show home"
RUSTUP_HOME = subprocess.check_output(
    rustup_home_command, shell=True, text=True).strip()

# Create the settings string
settings = f"\nsettings set target.source-map /rustc/{COMMIT_HASH}/ {RUSTUP_HOME}/toolchains/{TOOLCHAIN}/lib/rustlib/src/rust/"
commands = f"{RUSTUP_HOME}/toolchains/{TOOLCHAIN}/lib/rustlib/etc/lldb_commands"

# Print or use the 'settings' variable as needed
print(settings)

# Append settings to commands file
with open(commands, "a") as f:
    f.write(settings)
