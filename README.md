# 🧾 Unix Lab Project  
**Roll No:** 241033038  
**Project Title:** SysGuard — Unix System Health & Performance Monitor  
**Link** https://archittguptao7.github.io/SysGuard-System-Health-Alert-Manager/

---

# 🛡️ SysGuard — Unix System Health & Performance Monitor

## 📖 Overview
**SysGuard** is a comprehensive Unix-based **System Health Monitoring Tool** designed as part of a **Unix Lab Project**.  
It provides a detailed, color-coded report of the system's **CPU load, memory usage, disk space, uptime**, and other performance indicators.  

SysGuard offers a **menu-driven interface** to make interaction easy and intuitive for users. It can also **send email alerts** when system resources (like memory) exceed safe limits, helping users maintain optimal system health.

---

## 🎯 Project Objectives
- To understand **Unix system resource management** and **process monitoring**.  
- To implement a **menu-driven shell/C program** that interacts with system utilities.  
- To generate **automated system health reports** in color for visual clarity.  
- To explore **email automation** using Unix tools (`mail`, `sendmail`, or `ssmtp`).  
- To build a **practical, real-world utility** using Unix programming concepts.

---

## ⚙️ Key Functionalities

### 🧠 Technologies Used

- Unix Shell Scripting (bash)
- System commands: df, uptime, who, ps, ip, ping, mail
- /proc filesystem for CPU and memory statistics
- ANSI Color Codes for terminal formatting
- Enscript + Ghostscript for PDF report generation

---

### 🧩 1. System Health Report

Displays detailed system statistics:

- 🖥️ CPU Load
- 💾 Memory Used / Total
- 📂 Disk Usage
- ⏱️ System Uptime
- 👤 Logged-in Users
- 🧮 Report Timestamp

Generates color-coded outputs:

- 🟢 Healthy Range
- 🟡 Moderate Load
- 🔴 Critical Usage

Automatically saves a .txt report in the /reports folder.

Offers an option to generate the same report as a PDF file.

---

### 🌐 2. Network Status Check

Displays all active network interfaces and their IP addresses.

Performs a connectivity test by pinging 8.8.8.8 (Google DNS).

Reports:

- ✅ Network is UP and Internet reachable
- ❌ Network DOWN or unreachable

---

### 💽 3. Detailed Disk Usage

Lists all mounted partitions and their usage using `df -h`

Displays device names, sizes, used/free space, and mount points.

Highlights the system's root partition (/) clearly.

---

### 💡 4. Performance Rating

Calculates an average performance score based on:

- CPU load
- Memory usage
- Disk utilization

Outputs performance status:

- 🟢 Excellent → Avg Load < 40%
- 🟡 Moderate → 40–70%
- 🔴 Poor → Avg Load > 70%

---

### ✉️ 5. Email Alert Feature

Automatically checks if memory usage exceeds the set threshold (default 80%).

Sends an email alert to the configured address:

- Subject: System Alert - High Memory

Content includes hostname, timestamp, and memory usage details.

Uses standard Unix mailing utilities (mail or sendmail).

---

### 📋 6. Top & Lowest Resource Usage

**Top 3 CPU/Memory Processes:**
```
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 4
```

**Lowest 3 CPU/Memory Processes:**
```
ps -eo pid,comm,%cpu,%mem --sort=%cpu | head -n 4
```

---

### 🧭 7. Menu-Driven Interface

SysGuard provides a user-friendly terminal menu for easy interaction:

```
========== SYS GUARD MENU ==========
1) Generate System Health Report
2) Show Top 3 CPU/Memory Processes
3) Show Lowest 3 CPU/Memory Processes
4) Send Memory Alert Email (if > 80%)
5) Check Network Status
6) Show Detailed Disk Usage
7) Performance Rating
8) Generate PDF System Report
9) Exit
```

Each option calls a dedicated function to display, save, or analyze the system data dynamically.

---

### 🧾 8. PDF Report Generation

Converts the plain text report into a beautifully formatted PDF automatically using:

```
enscript -B -p report.ps report.txt
ps2pdf report.ps report.pdf
```

The generated PDF is stored in ./reports/ with a timestamp.

If the required tools (enscript, ghostscript) are missing, SysGuard displays a setup instruction

---

## 📖 Code Overview

**START SysGuard**

---

### 1️⃣ INITIALIZATION
- Enable error handling (exit if command fails).  
- Define key variables:
  - `LOG_DIR = "./reports"`
  - `MEMORY_ALERT_THRESHOLD = 80%`
  - `ALERT_EMAIL = "your@email.com"`
- Create `LOG_DIR` if not exists.  
- Define ANSI color codes (GREEN, YELLOW, RED, BLUE, NC) for colored terminal output.

---

### 2️⃣ DEFINE `timestamp()`
- Returns the current system date and time in format:  
  `YYYY-MM-DD HH:MM:SS`

---

### 3️⃣ DEFINE `get_cpu_usage()`
- Read CPU usage stats from `/proc/stat`.  
- Wait 1 second and read again.  
- Compute total CPU time and idle time differences.  
- Calculate CPU usage percentage:  
  `CPU% = ((total_diff - idle_diff) / total_diff) * 100`

---

### 4️⃣ DEFINE `get_memory_info()`
- Read data from `/proc/meminfo`.  
- Extract `MemTotal` and `MemAvailable`.  
- Compute:
  - `Used = Total - Available`  
  - Convert values to GB.  
  - `Usage% = (Used / Total) * 100`
- **Return:** `used_gb | total_gb | percent`

---

### 5️⃣ DEFINE `get_disk_info()`
- Use `df -h /` to fetch root partition statistics.  
- Extract `used`, `total`, and `percent` fields.  
- **Return:** `used_space | total_space | percent_used`

---

### 6️⃣ DEFINE `get_uptime()`
- Read uptime seconds from `/proc/uptime`.  
- Convert to human-readable format:  
  `"X days Y hours Z minutes"`

---

### 7️⃣ DEFINE `get_user_info()`
- Use `who` command.  
- Count logged-in users and list their usernames.  
- **Return:** `user_count | usernames`

---

### 8️⃣ DEFINE `top_processes()`
- Use `ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 4`  
  → Display top 3 CPU-consuming processes.  
- Repeat with `--sort=-%mem` for top 3 memory-consuming processes.

---

### 9️⃣ DEFINE `lowest_processes()`
- Use `ps -eo pid,comm,%cpu,%mem --sort=%cpu | head -n 4`  
  → Display bottom 3 CPU processes.  
- Repeat with `--sort=%mem` for memory.

---

### 🔟 DEFINE `check_network_status()`
- Use `ping -c 3 8.8.8.8`.  
- If packets lost = 100%, show **🔴 Network Down**.  
- Else, show **🟢 Network Active** with latency info.

---

### 1️⃣1️⃣ DEFINE `show_disk_usage()`
- Use `df -h` to list all partitions and mount points.  
- Highlight partitions >80% usage in red.  
- Show used, total, and available disk space.

---

### 1️⃣2️⃣ DEFINE `performance_rating()`
- Fetch CPU, Memory, and Disk usage.  
- Compute **performance score**.

---

### 1️⃣3️⃣ DEFINE `print_report(cpu, mem_used, mem_total, mem_percent, disk_used, disk_total, disk_percent, uptime, user_count, users)`
- Print formatted, color-coded report showing:
  - Timestamp  
  - Active Users  
  - CPU Load  
  - Memory Usage  
  - Disk Usage  
  - Uptime  
  - Save report to `reports/`

![SysGuard Report](https://github.com/user-attachments/assets/b3bd21d9-0d42-44f8-b53b-af296dd4f7b7)

---

### Enhancements

- Schedule automatic report generation using cron.
- Export reports as .txt or .html.
