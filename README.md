<p align="center">
  <img src="https://via.placeholder.com/800x200/0A2540/FFFFFF?text=Axios+Compromise+Scanner" alt="Axios Compromise Scanner" width="800"/>
</p>

# Axios Compromise Scanner

A simple, fast bash script to detect the **March 31, 2026 Axios npm supply chain attack**.

### What it checks
- Compromised Axios versions (`1.14.1` and `0.30.4`)
- Malicious dependency `plain-crypto-js`
- Linux payload (`/tmp/ld.py`)
- Connections to the C2 server `sfrclak.com`

### How to use

```bash
# Clone the repo
git clone https://github.com/YOURUSERNAME/axios-compromise-scanner.git
cd axios-compromise-scanner

# Make executable and run
chmod +x scan_axios_compromise.sh
./scan_axios_compromise.sh

# Or scan a specific folder
./scan_axios_compromise.sh ~/Projects
```
If anything is found (red output):
Immediately remove the packages, clean the cache, and rotate all your credentials.
Made for the community after the Axios incident on 2026-03-31.
