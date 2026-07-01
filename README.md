# 🧾 Unix Lab Project  
**Roll No:** 241033038  
**Project Title:** SysGuard — Unix System Health & Performance Monitor  

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

### 🧩 1. System Health Report
- Displays detailed system performance information:
  - **CPU Load**
  - **Memory Used / Total**
  - **Disk Space Used / Available**
  - **System Uptime**
  - **Number of Running Processes**
  - **Active Logged-in User**
  - **Report Generated Date & Time**

- Output is **color-coded** for better readability:
  - 🟢 *Healthy Range*
  - 🟡 *Moderate Load*
  - 🔴 *Critical Usage*

---

### 📈 2. Top & Bottom Usage Statistics
- **Top 3 Processes:**  
  Displays the three processes consuming the highest CPU or memory.

- **Lowest 3 Processes:**  
  Shows the three least resource-consuming processes currently running.

---

### ✉️ 3. Email Alert Feature
- Sends an automated **email notification** to a configured user if memory usage exceeds a defined threshold (e.g., 80%).  
- Helps in proactive system management and avoiding overloads.  
- Uses standard Unix utilities like `mail` or `sendmail`.

---

### 🧭 4. Menu-Driven Interface
The tool provides an easy-to-navigate menu for selecting different operations and viewing system stats efficiently.
