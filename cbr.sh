#!/bin/bash

# Check if required software dependencies are installed
declare -a dependencies=("nmap" "gnuplot")

for dependency in "${dependencies[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "$dependency is not installed."
        exit 1
    fi
done

# Ask the user for the IP address range
read -p "Enter the IP address range (e.g., 192.168.1.0/24): " ip_address_range

# Network Reconnaissance - Host Discovery
echo "Performing host discovery..."
nmap -sn "$ip_address_range" -oG hosts.txt > /dev/null
host_list=$(grep "Status: Up" hosts.txt | cut -d " " -f 2)

# Check if any hosts are discovered
if [[ -z "$host_list" ]]; then
    echo "No hosts found. Exiting..."
    rm hosts.txt
    exit 1
fi

# Vulnerability Assessment
echo "Performing vulnerability assessment on discovered hosts..."
for host in $host_list; do
    echo "Assessing vulnerabilities on $host..."
    nmap -p 1-65535 --script vuln "$host" > "$host"_vulnerability_assessment.txt
done

# Reporting and Recommendations
echo "Compiling the report..."

# Generate tables for hosts and vulnerabilities
echo "Hosts and Vulnerabilities:" > report.txt
echo "------------------------" >> report.txt
echo "" >> report.txt
for host in $host_list; do
    echo "Host: $host" >> report.txt
    echo "Vulnerabilities:" >> report.txt
    grep "VULNERABLE:" "$host"_vulnerability_assessment.txt | cut -d ":" -f 2- >> report.txt
    echo "" >> report.txt
done

# Generate graph of time taken per host
echo "Time Taken per Host:" >> report.txt
echo "--------------------" >> report.txt
echo "" >> report.txt
echo "Host,Time (seconds)" > time_taken.csv
for host in $host_list; do
    time_taken=$(grep "Nmap done" "$host"_vulnerability_assessment.txt | awk '{print $(NF-1)}' | cut -d ")" -f 1)
    echo "$host,$time_taken" >> time_taken.csv
done

# Check if there are valid data points for the histogram
if [[ -s "time_taken.csv" ]]; then
    gnuplot <<-EOFMarker
        set term pngcairo
        set output 'time_taken.png'
        set title "Time Taken per Host"
        set xlabel "Host"
        set ylabel "Time (seconds)"
        set style data histograms
        set style fill solid
        plot 'time_taken.csv' using 2 with histogram
EOFMarker
    echo "Graph of Time Taken per Host saved as time_taken.png" >> report.txt
else
    echo "No valid data points found for the histogram. Skipping graph generation." >> report.txt
fi

echo "Project completed!"

