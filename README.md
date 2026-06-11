# iKVM viewer launcher for Apple Silicon

A small wrapper to launch the **ATEN / Supermicro iKVM** Java viewer from a
`launch.jnlp` file on modern macOS — including Apple Silicon — without needing a
system Java install or a browser that can still run JNLP/Java Web Start applets.

Supermicro (and other ATEN-based) BMC "remote console / KVM" pages hand you a
`launch.jnlp` file. Current macOS ships no Java, and browsers dropped applet
support years ago, so that file normally won't open. This repo ships the viewer
jars and a launcher that runs them directly with a Java 8 runtime you provide.

## What's here

| Path | What it is |
|---|---|
| `run-jnlp.sh` | The launcher script (the only original code here). |
| `iKVM.jar`, `libmac.jar`, `pack200.jar`, `*.pack.gz` | ATEN/Supermicro viewer binaries. |
| `natives/*.jnilib` | ATEN native libraries used by the viewer. |

## Requirements

- An **x86_64 Java 8** runtime. The ATEN viewer and its native libraries are
  x86_64, so the JRE must match. [Temurin 8 (x64)](https://adoptium.net/) works
  well. The launcher finds Java in this order: `$IKVM_JAVA` →
  `jdk8u492-b09-jre/` (if you drop a JRE in the repo) → `$JAVA_HOME` → `java` on
  `PATH`. To point at a specific JRE:
  ```sh
  IKVM_JAVA=/path/to/jdk8/Contents/Home/bin/java ./run-jnlp.sh
  ```
- macOS. On **Apple Silicon** the x86_64 JRE and native libs run under
  **Rosetta 2**. Install it once if you haven't:
  ```sh
  softwareupdate --install-rosetta --agree-to-license
  ```
- A `launch.jnlp` file downloaded from your BMC's remote-console page.

## Usage

1. In the BMC web UI, open the remote console / iKVM page and download the
   `launch.jnlp` file (it usually lands in `~/Downloads`).
2. Run the launcher:
   ```sh
   ./run-jnlp.sh                       # uses ~/Downloads/launch.jnlp
   ./run-jnlp.sh /path/to/launch.jnlp  # or pass an explicit path
   ```

The script reads the `<argument>` values out of the JNLP (host, ports,
session token, etc.) and starts `tw.com.aten.ikvm.KVMMain` with your Java 8
runtime and the native library path. JNLP session tokens are short-lived, so
download a fresh `launch.jnlp` each time.

## Notes & licensing

- **`run-jnlp.sh`** is the only original work here and is released under the MIT
  License (see [`LICENSE`](LICENSE)).
- The **viewer jars and native libraries** (`tw.com.aten.ikvm`, ATEN ©) are the
  property of their respective owners and are redistributed here only for
  convenience. They are **not** covered by the MIT License above. The Java 8
  runtime is not bundled; get Temurin from <https://adoptium.net/>.
- This project is not affiliated with, or endorsed by, ATEN or Supermicro.
