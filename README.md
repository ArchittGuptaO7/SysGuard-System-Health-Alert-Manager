# 🧾 Unix Lab Project  
**Roll No:** 241033038  
**Project Title:** SysGuard — Unix System Health & Performance Monitor  

---

# 🛡️ SysGuard — Unix System Health & Performance Monitor

## 📖 Overview
**SysGuard** is a comprehensive Unix-based **System Health Monitoring Tool** designed as part of a **Unix Lab Project**.  
It provides a detailed, color-coded report of the system’s **CPU load, memory usage, disk space, uptime**, and other performance indicators.  

SysGuard offers a **menu-driven interface** to make interaction easy and intuitive for users. It can also **send email alerts** when system resources (like memory) exceed safe limits, helping users take preventive action before the system slows down or crashes.

---

## 🎯 Project Objectives
- To understand **Unix system resource management** and **process monitoring**.  
- To implement a **menu-driven shell/C program** that interacts with system utilities.  
- To generate **automated system health reports** in color for visual clarity.  
- To explore **email automation** using Unix tools (`mail`, `sendmail`, or `ssmtp`).  
- To build a **practical, real-world utility** using Unix programming concepts.

---

## ⚙️ Key Functionalities
Technologies Used:

Unix Shell Scripting (bash)
System commands: df, uptime, who, awk, ps, mail
Linux /proc filesystem
ANSI Color Codes for terminal formatting

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
The tool provides an easy-to-navigate menu:
<img width="539" height="172" alt="image" src="https://github.com/user-attachments/assets/35618d6c-24c0-40e8-9e91-fa552392661f" />


## 📖 Code
START SysGuard

1. INITIALIZATION
   - Enable error handling (exit if command fails)
   - Define variables:
       LOG_DIR = "./reports"
       MEMORY_ALERT_THRESHOLD = 80%
       ALERT_EMAIL = "your@email.com"
   - Create LOG_DIR if not exists
   - Define color codes for terminal output

2. DEFINE timestamp()
   - Return current date and time

3. DEFINE get_cpu_usage()
   - Read CPU stats from /proc/stat
   - Wait 1 second and read again
   - Compute total CPU and idle differences
   - Calculate CPU load percentage = ((total - idle_diff) / total_diff) * 100

4. DEFINE get_memory_info()
   - Read MemTotal and MemAvailable from /proc/meminfo
   - Calculate used memory = total - available
   - Convert to GB
   - Calculate percentage usage = (used / total) * 100
   - RETURN used_gb | total_gb | percent

5. DEFINE get_disk_info()
   - Use df command to get root (/) partition usage
   - RETURN used_space | total_space | percent_used

6. DEFINE get_uptime()
   - Use uptime command or read /proc/uptime
   - Format as “X days Y hours Z minutes”

7. DEFINE get_user_info()
   - Use ‘who’ command
   - Count total logged-in users and their usernames
   - RETURN user_count | usernames

8. DEFINE top_processes()
   - Display top 3 processes sorted by CPU usage
   - Display top 3 processes sorted by Memory usage

9. DEFINE lowest_processes()
   - Display bottom 3 processes by CPU and Memory

10. DEFINE print_report(cpu, mem_used, mem_total, mem_percent, disk_used, disk_total, disk_percent, uptime, user_count, users)
    - Print report header (colored)
    - Display:
        Generated timestamp
        Logged-in users
        CPU load
        Memory used / total / percent
        Disk usage
        System uptime
    - Print formatted separator

11. DEFINE send_memory_alert(mem_percent)
    - IF mem_percent > MEMORY_ALERT_THRESHOLD THEN
         Print alert in red
         Send email to ALERT_EMAIL with alert message
      ELSE
         Do nothing

12. DEFINE main_menu()
    LOOP FOREVER
      Display menu options:
        1. Generate System Health Report
        2. Show Top 3 CPU/Memory Processes
        3. Show Lowest 3 CPU/Memory Processes
        4. Send Memory Alert Email (if > threshold)
        5. Exit
      Read user choice

      Gather all metrics using the above functions:
        cpu, memory_info, disk_info, uptime, user_info

      CASE choice OF
         1: Call print_report()
         2: Call top_processes()
         3: Call lowest_processes()
         4: Call send_memory_alert()
         5: EXIT program
         Default: Print "Invalid Choice"
    END LOOP

13. START PROGRAM
    - Call main_menu()

END SysGuard

==========================================
        SYSTEM HEALTH REPORT
Generated: 2025-10-27 08:55:12 IST
Users Logged In: 2 (architt root)
==========================================
CPU Load: 34.5 %
Memory Used: 2.56 GB / 8.00 GB (32.0%)
Disk (/) Used: 45%
Uptime: 3 hours 25 minutes
------------------------------------------


## Enhancements

Add log file for past reports (reports/ folder).
Include network bandwidth statistics.
Schedule automatic report generation using cron.
Export reports as .txt or .html.

