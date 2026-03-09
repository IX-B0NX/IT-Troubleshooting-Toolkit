# **IT Troubleshooting Toolkit v1.2.0**

A professional-grade, all-in-one batch script designed for IT administrators to automate Windows diagnostics, system repairs, and administrative tasks. 

---

## **🚀 Key Features**

### **🔍 Diagnostics**
* **Network Refresher:** Automated IP release/renew, DNS flush, and Winsock reset.
* **System Repair:** Sequential execution of `SFC` and `DISM` with safety confirmations.
* **Hardware & Battery:** Pulls BIOS serials and generates HTML battery health reports.
* **Drive Health:** PowerShell-based S.M.A.R.T. status check for physical disks.

### **🛠️ Admin & Emergency Tools**
* **App Updates (Winget):** One-click update for all third-party software (Chrome, Zoom, etc.).
* **Explorer Refresh:** Instantly restarts `explorer.exe` to resolve UI hangs.
* **Windows Update Reset:** Clears corrupted caches and restarts update services.
* **Remote Desktop (RDP):** Automated Registry and Firewall provisioning for RDP access.
* **Wi-Fi Recovery:** Retrieve clear-text passwords for saved wireless profiles.

---

## **🖥️ System Quick-Look**
The main menu provides an instant snapshot of the machine:
* **Internal IPv4 Address** (Filters for 192.x, 10.x, and 172.x ranges).
* **Active Network Adapter:** Identifies if you are on Wi-Fi or Ethernet.
* **Last Boot Time:** Professional uptime verification.

---

## **📂 Version History**
| Version | Status | Key Changes |
| :--- | :--- | :--- |
| **v1.2.0** | **Gold Master** | Integrated Quick-Look, Winget, RDP, BIOS, Manual, and memory hygiene. |
| **v1.1.0** | Stable | Added Battery Reports, Hardware IDs, and Print Spooler management. |
| **v1.0.0** | Initial | Core Network and System Repair tools. |
