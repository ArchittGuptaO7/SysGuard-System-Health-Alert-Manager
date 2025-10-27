#!/usr/bin/env bash
# SysGuard - UNIX Lab Project
# Roll No: 241033038
# System Health Monitor with Colors, Menu, and Email Alerts

set -o errexit
set -o pipefail

LOG_DIR="./reports"
mkdir -p "$LOG_DIR"
MEMORY_ALERT_THRESHOLD=80
ALERT_EMAIL="your@email.com"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

timestamp() { date +"%Y-%m-%d %H:%M:%S %Z"; }

get_cpu_usage() {
  read -r _ u1 n1 s1 i1 io1 ir1 si1 st1 g1 gn1 < /proc/stat
  total1=$((u1 + n1 + s1 + i1 + io1 + ir1 + si1 + st1 + g1 + gn1))
  idle1=$((i1 + io1))
  sleep 1
  read -r _ u2 n2 s2 i2 io2 ir2 si2 st2 g2 gn2 < /proc/stat
  total2=$((u2 + n2 + s2 + i2 + io2 + ir2 + si2 + st2 + g2 + gn2))
  idle2=$((i2 + io2))
  diff_total=$((total2 - total1))
  diff_idle=$((idle2 - idle1))
  if [ "$diff_total" -eq 0 ]; then echo "0.0"; return; fi
  awk -v dt="$diff_total" -v di="$diff_idle" 'BEGIN { printf "%.1f", (dt - di)/dt*100 }'
}

get_memory_info() {
  mem_total_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  mem_avail_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo || echo 0)
  mem_used_kb=$((mem_total_kb - mem_avail_kb))
  mem_total_gb=$(awk -v t="$mem_total_kb" 'BEGIN{printf "%.2f", t/1024/1024}')
  mem_used_gb=$(awk -v u="$mem_used_kb" 'BEGIN{printf "%.2f", u/1024/1024}')
  mem_percent=$(awk -v u="$mem_used_kb" -v t="$mem_total_kb" 'BEGIN{ if(t==0) print "0.0"; else printf "%.1f", (u/t)*100}')
  printf "%s|%s|%s\n" "$mem_used_gb" "$mem_total_gb" "$mem_percent"
}

get_disk_info() {
  df -P / | awk 'NR==2 {print $3 "|" $2 "|" $5}'
}

get_uptime() {
  uptime -p 2>/dev/null | sed 's/^up //' || awk '{up=$1; days=int(up/86400); hrs=int((up%86400)/3600); mins=int((up%3600)/60); printf "%d days %d hours %d minutes\n", days, hrs, mins}' /proc/uptime
}

get_user_info() {
  user_count=$(who | wc -l)
  users=$(who | awk '{print $1}' | sort | uniq | tr '\n' ' ')
  echo "$user_count|$users"
}

colorize_usage() {
  val=$1
  if (( $(echo "$val < 50" | bc -l) )); then
    echo -e "${GREEN}${val}%${NC}"
  elif (( $(echo "$val < 80" | bc -l) )); then
    echo -e "${YELLOW}${val}%${NC}"
  else
    echo -e "${RED}${val}%${NC}"
  fi
}

print_report() {
  cpu="$1"; mem_used_gb="$2"; mem_total_gb="$3"; mem_percent="$4"
  disk_used="$5"; disk_total="$6"; disk_percent="$7"
  uptime="$8"; user_count="$9"; users="${10}"

  cpu_colored=$(colorize_usage "$cpu")
  mem_colored=$(colorize_usage "$mem_percent")
  disk_colored=$(colorize_usage "$(echo "$disk_percent" | tr -d '%')")

  report_file="${LOG_DIR}/report_$(date +%Y%m%d_%H%M%S).txt"

  {
    echo "SysGuard - System Health Report"
    echo "Generated: $(timestamp)"
    echo "Users Logged In: ${user_count} (${users})"
    echo "-----------------------------------"
    echo "CPU Load: ${cpu}%"
    echo "Memory Used: ${mem_used_gb} GB / ${mem_total_gb} GB (${mem_percent}%)"
    echo "Disk Used: ${disk_used}K / ${disk_total}K (${disk_percent})"
    echo "Uptime: ${uptime}"
  } > "$report_file"

  echo -e "${BLUE}==========================================${NC}"
  echo -e "${GREEN}        SYSTEM HEALTH REPORT${NC}"
  echo -e "Generated: $(timestamp)"
  echo -e "Users Logged In: ${user_count} (${users})"
  echo -e "${BLUE}==========================================${NC}"
  echo -e "CPU Load: $cpu_colored"
  echo -e "Memory Used: ${mem_used_gb} GB / ${mem_total_gb} GB ($mem_colored)"
  echo -e "Disk Used: ${disk_used}K / ${disk_total}K ($disk_colored)"
  echo -e "Uptime: ${uptime}"
  echo -e "${BLUE}------------------------------------------${NC}"
  echo -e "${YELLOW}Report saved to ${report_file}${NC}"
}

send_memory_alert() {
  mem_percent="$1"
  if (( $(echo "$mem_percent > $MEMORY_ALERT_THRESHOLD" | bc -l) )); then
    echo -e "${RED}Memory Usage High: ${mem_percent}%${NC}"
    echo "Memory usage exceeded ${MEMORY_ALERT_THRESHOLD}% on $(hostname) at $(timestamp)" | mail -s "System Alert: High Memory" "$ALERT_EMAIL"
  fi
}

top_processes() {
  echo -e "${YELLOW}Top 3 Processes by CPU:${NC}"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 4
  echo -e "\n${YELLOW}Top 3 Processes by Memory:${NC}"
  ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 4
}

lowest_processes() {
  echo -e "${YELLOW}Lowest 3 Processes by CPU:${NC}"
  ps -eo pid,comm,%cpu,%mem --sort=%cpu | head -n 4
  echo -e "\n${YELLOW}Lowest 3 Processes by Memory:${NC}"
  ps -eo pid,comm,%cpu,%mem --sort=%mem | head -n 4
}

main_menu() {
  while true; do
    echo -e "${GREEN}\n========== SYS GUARD MENU ==========${NC}"
    echo "1) Generate System Health Report"
    echo "2) Show Top 3 CPU/Memory Processes"
    echo "3) Show Lowest 3 CPU/Memory Processes"
    echo "4) Send Memory Alert Email (if > ${MEMORY_ALERT_THRESHOLD}%)"
    echo "5) Exit"
    read -rp "Enter your choice: " choice

    cpu=$(get_cpu_usage)
    mem_info=$(get_memory_info)
    IFS='|' read -r mem_used_gb mem_total_gb mem_percent <<< "$mem_info"
    disk_info=$(get_disk_info)
    IFS='|' read -r disk_used disk_total disk_percent <<< "$disk_info"
    uptime=$(get_uptime)
    user_info=$(get_user_info)
    IFS='|' read -r user_count users <<< "$user_info"

    case "$choice" in
      1) print_report "$cpu" "$mem_used_gb" "$mem_total_gb" "$mem_percent" "$disk_used" "$disk_total" "$disk_percent" "$uptime" "$user_count" "$users" ;;
      2) top_processes ;;
      3) lowest_processes ;;
      4) send_memory_alert "$mem_percent" ;;
      5) echo -e "${GREEN}Exiting...${NC}"; exit 0 ;;
      *) echo -e "${RED}Invalid choice, try again.${NC}" ;;
    esac
  done
}

main_menu
