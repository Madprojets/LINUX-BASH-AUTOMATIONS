# LINUX-BASH-AUTOMATIONS
Bash scripts for cybersecurity professionals
Network Reconnaissance and Vulnerability Assessment

This script performs network reconnaissance and vulnerability assessment on a given IP address range. It utilizes the nmap tool and requires the following software dependencies to be installed: nmap and gnuplot.
Prerequisites

Make sure you have the following software dependencies installed:

    nmap
    gnuplot

Usage

    Clone the repository and navigate to the directory containing the script.

    bash

git clone https://github.com/your-username/repository.git
cd repository

Make the script executable.

bash

chmod +x script.sh

Run the script.

bash

    ./script.sh

    Follow the instructions provided by the script.
        You will be prompted to enter the IP address range (e.g., 192.168.1.0/24).

    After the script completes, a report will be generated in the current directory.
        The report includes a list of discovered hosts, their vulnerabilities, and a graph showing the time taken per host.

Explanation

The script performs the following steps:

    Checks if the required software dependencies (nmap and gnuplot) are installed.
    Prompts the user to enter an IP address range.
    Performs host discovery using nmap and saves the results in hosts.txt.
    Checks if any hosts are discovered. If not, the script exits.
    Performs vulnerability assessment on the discovered hosts using nmap and saves the results in separate files for each host.
    Compiles a report that includes a list of hosts, their vulnerabilities, and a graph showing the time taken per host.
    Saves the report in report.txt.
    If valid data points are available, generates a histogram graph using gnuplot and saves it as time_taken.png.
    Prints a completion message.

Please make sure you have the necessary permissions and dependencies installed before running this script.
