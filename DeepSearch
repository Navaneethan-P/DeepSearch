@echo off
setlocal enabledelayedexpansion

:: Create output directory
set "output_dir=%~dp0_output"
if not exist "%output_dir%" mkdir "%output_dir%"

:: System Information
echo Collecting System Information...
systeminfo > "%output_dir%\system_info.txt"

:: DotNet versions
echo Collecting DotNet versions...
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s | findstr /i /c:"Version" > "%output_dir%\dotnet_versions.txt"

:: AMSI Providers
echo Collecting AMSI Providers...
reg query "HKLM\SOFTWARE\Microsoft\AMSI\Providers" /s > "%output_dir%\amsi_providers.txt"

:: Registered Antivirus
echo Collecting Registered Antivirus...
wmic /namespace:\\root\SecurityCenter2 path AntiVirusProduct get * /value > "%output_dir%\registered_antivirus.txt"

:: Audit Policy Settings
echo Collecting Audit Policy Settings...
auditpol /get /category:* > "%output_dir%\audit_policy_settings.txt"

:: Auto Run Executables
echo Collecting Auto Run Executables...
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /s > "%output_dir%\auto_run_executables.txt"

:: Firewall Rules
echo Collecting Firewall Rules...
netsh advfirewall firewall show rule name=all > "%output_dir%\firewall_rules.txt"

:: Windows Defender Settings
echo Collecting Windows Defender Settings...
md "%output_dir%\Windows Defender"
attrib "%output_dir%\Windows Defender" +h
cd "%output_dir%\Windows Defender"
md "Exclusions"
attrib "Exclusions" +h
cd "Exclusions"
md "Path"
md "Process"
md "File"
cd ..
cd ..
cd ..
reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "%output_dir%\Windows Defender\Windows Defender.reg" /y

:: Personal Certificates
echo Collecting Personal Certificates...
dir /s /b "%USERPROFILE%\*.pfx" > "%output_dir%\personal_certificates.txt"

:: Environment Information
echo Collecting Environment Information...
set > "%output_dir%\environment_variables.txt"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /s > "%output_dir%\environment_variables_registry.txt"

:: User Folders
echo Collecting User Folders...
dir /s /b "%USERPROFILE%\Downloads" > "%output_dir%\user_folders_downloads.txt"
dir /s /b "%USERPROFILE%\Documents" > "%output_dir%\user_folders_documents.txt"
dir /s /b "%USERPROFILE%\Desktop" > "%output_dir%\user_folders_desktop.txt"

:: File Information
echo Collecting File Information...
for /r "%SystemDrive%" %%i in (*.*) do (
    echo %%~fi >> "%output_dir%\file_information.txt"
    echo %%~fi >> "%output_dir%\file_information_versions.txt"
    echo %%~fi >> "%output_dir%\file_information_amsi.txt"
    "%SystemRoot%\System32\sigcheck.exe" -a -q -d -c -r %%~fi >> "%output_dir%\file_information_versions.txt"
    "%SystemRoot%\System32\sigcheck.exe" -a -q -d -c -y -r %%~fi >> "%output_dir%\file_information_amsi.txt"
)

:: Installed Hotfixes
echo Collecting Installed Hotfixes...
wmic qfe list > "%output_dir%\installed_hotfixes.txt"

:: Installed Products
echo Collecting Installed Products...
wmic product get name,version,vendor > "%output_dir%\installed_products.txt"

:: Local Group Policy Settings
echo Collecting Local Group Policy Settings...
gpresult /h "%output_dir%\local_group_policy_settings.html"

:: Local Groups
echo Collecting Local Groups...
net localgroup > "%output_dir%\local_groups.txt"

:: Local Users
echo Collecting Local Users...
net user > "%output_dir%\local_users.txt"

:: Updates (via WMI)
echo Collecting Installed Updates...
wmic qfe list > "%output_dir%\installed_updates.txt"

:: NTLM Authentication Settings
echo Collecting NTLM Authentication Settings...
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LmCompatibilityLevel" > "%output_dir%\ntlm_authentication_settings.txt"

:: RDP Connections
echo Collecting RDP Connections...
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /s > "%output_dir%\rdp_connections.txt"

:: Remote Desktop Settings
echo Collecting Remote Desktop Settings...
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" "%output_dir%\remote_desktop_settings.reg" /y

:: Secure Boot Configuration
echo Collecting Secure Boot Configuration...
bcdedit > "%output_dir%\secure_boot_configuration.txt"

:: Sysmon Configuration
echo Collecting Sysmon Configuration...
reg export "HKLM\SYSTEM\CurrentControlSet\Services\SysmonLog" "%output_dir%\sysmon_configuration.reg" /y

:: UAC System Policies
echo Collecting UAC System Policies...
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "%output_dir%\uac_system_policies.reg" /y

:: Windows Defender Exclusions
echo Collecting Windows Defender Exclusions...
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /s > "%output_dir%\windows_defender_exclusions.txt"

:: PowerShell Console History
echo Collecting PowerShell Console History...
powershell -Command "Get-Content (Get-PSReadlineOption).HistorySavePath" > "%output_dir%\powershell_console_history.txt"

:: Network Information
echo Collecting Network Information...

:: ARP Table
echo Collecting ARP Table...
arp -a > "%output_dir%\arp_table.txt"

:: DNS Cache
echo Collecting DNS Cache...
ipconfig /displaydns > "%output_dir%\dns_cache.txt"

:: Network Profiles
echo Collecting Network Profiles...
netsh wlan show profiles > "%output_dir%\network_profiles.txt"

:: Network Shares
echo Collecting Network Shares...
net share > "%output_dir%\network_shares.txt"

:: TCP/UDP Connections
echo Collecting TCP/UDP Connections...
netstat -ano > "%output_dir%\tcp_udp_connections.txt"

:: RPC Endpoints
echo Collecting RPC Endpoints...
sc query rpcendpoint > "%output_dir%\rpc_endpoints.txt"

:: Open Ports
echo Collecting Open Ports...
netstat -ano | findstr /i "LISTENING" > "%output_dir%\open_ports.txt"

:: Network Diagram
echo Generating Network Diagram...
:: Use a tool like Wireshark or NetworkMiner to capture and analyze network traffic
:: and generate a diagram based on the captured traffic

:: Generate Report
echo Generating Report...
:: Use a tool like PDFCreator or similar to generate a PDF report from the collected data
:: and include the report in the output directory

echo Done. Please check the "%output_dir%" directory for the collected information.
