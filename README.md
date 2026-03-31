
<img width="1342" height="447" alt="624de949df5a11680ab170b9_Axios logo - RGB - minimum space" src="https://github.com/user-attachments/assets/95882864-80f5-458c-8133-5d5607f139a2" />

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
git clone https://github.com/atraxsrc/axios-compromise-scanner.git
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
<img width="625" height="918" alt="Sc" src="https://github.com/user-attachments/assets/7518a124-0a7c-4e8c-a574-1cf27009078a" />


