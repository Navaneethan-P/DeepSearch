# Agent-less Windows System Vulnerability and Network Scanner
STEP 1 -  DOWNLOAD THE  .BAT FILE (NO INSTALLATION)
STEP 2 -  SAVE THIS .BAT FILE INSIDE A NEW FOLDER IN YOUR PC
STEP 3 -  RUN IT AS ADMINISTATOR 
STEP 4 -  CLOSE THE CMD AND GO AGAIN TO THE SAME NEW FOLDER
STEP 5 -  YOU CAN SEE THE REPORT THAT SCANNED

This is an open-source batch script designed to scan and collect system and network information from a Windows machine without requiring any external agents or software installations. The script gathers a wide range of data, including system information, installed software, network configurations, and more, which can be useful for vulnerability assessment and network analysis . developed by Navaneethan.P
## Features

The script collects various system and network details, including but not limited to:

- **System Information**: Detailed system specifications and environment variables.
- **DotNet Framework Versions**: Installed .NET Framework versions.
- **AMSI Providers**: Registered Anti-Malware Scan Interface (AMSI) providers.
- **Registered Antivirus**: Details of installed antivirus software.
- **Audit Policies**: Active audit policy configurations.
- **Auto-Run Executables**: Programs configured to run at startup.
- **Firewall Rules**: Configured Windows Firewall rules.
- **Windows Defender Settings**: Registry settings and exclusions for Windows Defender.
- **Personal Certificates**: Exported `.pfx` certificates from user profiles.
- **User Folders**: File listings from the Downloads, Documents, and Desktop directories.
- **Installed Updates and Hotfixes**: Installed updates and hotfixes via WMI.
- **Local Users and Groups**: Details about users and local groups on the system.
- **Network Information**: ARP table, DNS cache, active connections, and open ports.
- **RDP Connections and Settings**: Remote Desktop configuration and connection details.
- **Secure Boot Configuration**: Bootloader settings.
- **PowerShell History**: Command history from the PowerShell console.


## Output

The script generates a structured directory containing text files and registry exports that include:

- System configuration and software details.
- Network settings and vulnerabilities.
- Active security configurations and policies.
- system_info.txt: Detailed system information.
- dotnet_versions.txt: Installed .NET Framework versions.
- amsi_providers.txt: AMSI providers registered on the system.
- registered_antivirus.txt: List of registered antivirus products.
- audit_policy_settings.txt: Audit policy settings.
- auto_run_executables.txt: Executables set to run at startup.
- firewall_rules.txt: Firewall rules.
- Windows Defender\: Directory containing Windows Defender settings and exclusions.
- personal_certificates.txt: Personal certificates stored on the system.
- environment_variables.txt: Environment variables.
- user_folders_*.txt: Lists of files in user folders (Downloads, Documents, Desktop).
- file_information_*.txt: File information and versions.
- installed_hotfixes.txt: Installed hotfixes.
- installed_products.txt: Installed software products.
- local_group_policy_settings.html: Local group policy settings.
- local_groups.txt: Local groups.
- local_users.txt: Local users.
- installed_updates.txt: Installed updates.
- ntlm_authentication_settings.txt: NTLM authentication settings.
- rdp_connections.txt: RDP connections.
- remote_desktop_settings.reg: Remote desktop settings.
- secure_boot_configuration.txt: Secure boot configuration.
- sysmon_configuration.reg: Sysmon configuration.
- uac_system_policies.reg: UAC system policies.
- windows_defender_exclusions.txt: Windows Defender exclusions.
- powershell_console_history.txt: PowerShell console history.
- arp_table.txt: ARP table.
- dns_cache.txt: DNS cache.
- network_profiles.txt: Network profiles.
- network_shares.txt: Network shares.
- tcp_udp_connections.txt: TCP/UDP connections.
- rpc_endpoints.txt: RPC endpoints.
- open_ports.txt: Open ports.



