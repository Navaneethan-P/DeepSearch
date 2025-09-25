@echo off
setlocal enabledelayedexpansion

:: ================================
:: 1. Consent / Disclaimer Prompt
:: ================================
echo WARNING: This scan collects system and user data.
echo Unauthorized use is prohibited. Press Y to continue, N to exit.
choice /c YN /n /m "Your choice: "
if errorlevel 2 exit

:: ================================
:: 2. Create Timestamped Output Directory
:: ================================
set "output_dir=%~dp0_output_%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
mkdir "%output_dir%"
echo Scan executed by %username% on %date% %time% >> "%output_dir%\scan_log.txt"

:: ================================
:: 3. Initialize Risk Score
:: ================================
set /a risk_score=0
echo Risk Summary > "%output_dir%\risk_summary.txt"
echo ========================== >> "%output_dir%\risk_summary.txt"

:: ================================
:: 4. System Information
:: ================================
echo Collecting System Information...
systeminfo > "%output_dir%\system_info.txt" 2>> "%output_dir%\errors.log"

:: ================================
:: 5. .NET Versions
:: ================================
echo Collecting DotNet versions...
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s | findstr /i /c:"Version" > "%output_dir%\dotnet_versions.txt"

:: ================================
:: 6. AMSI Providers
:: ================================
echo Collecting AMSI Providers...
reg query "HKLM\SOFTWARE\Microsoft\AMSI\Providers" /s > "%output_dir%\amsi_providers.txt"

:: ================================
:: 7. Registered Antivirus
:: ================================
echo Collecting Registered Antivirus...
wmic /namespace:\\root\SecurityCenter2 path AntiVirusProduct get * /value > "%output_dir%\registered_antivirus.txt"
findstr /i "ProductName" "%output_dir%\registered_antivirus.txt" >nul
if errorlevel 1 (
    echo Antivirus not detected >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=5
)

:: ================================
:: 8. Installed Updates / Hotfixes
:: ================================
echo Collecting Installed Updates...
wmic qfe list > "%output_dir%\installed_updates.txt"
for /f %%i in ('wmic qfe list ^| find /c /v ""') do set updates=%%i
if %updates% LSS 5 (
    echo Less than 5 updates found >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=5
)

:: ================================
:: 9. Open RDP Ports
:: ================================
echo Checking Open RDP Ports...
netstat -ano | findstr /i "LISTENING" | findstr "3389" >nul
if not errorlevel 1 (
    echo RDP port open >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=3
)
netstat -ano > "%output_dir%\open_ports.txt"

:: ================================
:: 10. Auto Run Executables
:: ================================
echo Collecting Auto Run Executables...
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /s > "%output_dir%\auto_run_executables.txt"
for /f %%i in ('type "%output_dir%\auto_run_executables.txt" ^| find /c " " ') do set autorun_count=%%i
if %autorun_count% GTR 5 (
    echo More than 5 autorun apps detected >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=2
)

:: ================================
:: 11. NTLM Settings
:: ================================
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LmCompatibilityLevel" > "%output_dir%\ntlm_authentication_settings.txt"
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LmCompatibilityLevel" ^| find "LmCompatibilityLevel"') do set lmlevel=%%b
if %lmlevel% LSS 3 (
    echo Weak NTLM authentication >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=2
)

:: ================================
:: 12. Windows Defender & Firewall Check
:: ================================
echo Checking Windows Defender Status...
powershell -Command "Get-MpComputerStatus | Select-Object AMServiceEnabled,RealTimeProtectionEnabled" > "%output_dir%\defender_status.txt"
for /f "tokens=1,2 delims= " %%a in ('type "%output_dir%\defender_status.txt"') do (
    if "%%b"=="False" (
        echo Windows Defender disabled >> "%output_dir%\risk_summary.txt"
        set /a risk_score+=4
    )
)
echo Collecting Firewall Rules...
netsh advfirewall show allprofiles > "%output_dir%\firewall_rules.txt"
netsh advfirewall show allprofiles | findstr /i "OFF" >nul
if not errorlevel 1 (
    echo Firewall disabled >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=4
)

:: ================================
:: 13. File Scan (Executables Only)
:: ================================
echo Scanning executables for version & AMSI info...
for /r "C:\Windows" %%i in (*.exe *.dll) do (
    echo %%~fi >> "%output_dir%\file_scan.txt"
    "%SystemRoot%\System32\sigcheck.exe" -q -a -d -c -r %%~fi >> "%output_dir%\file_scan_versions.txt"
)

:: ================================
:: 14. PowerShell History
:: ================================
powershell -Command "Get-Content (Get-PSReadlineOption).HistorySavePath" > "%output_dir%\powershell_console_history.txt"
findstr /i "Invoke-Expression" "%output_dir%\powershell_console_history.txt" >nul
if not errorlevel 1 (
    echo Suspicious PowerShell commands found >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=3
)

:: ================================
:: 15. Local Users & Groups
:: ================================
net localgroup > "%output_dir%\local_groups.txt"
net user > "%output_dir%\local_users.txt"
for /f "tokens=1" %%u in ('net localgroup Administrators ^| findstr /v "Alias"') do (
    echo Admin account detected: %%u >> "%output_dir%\risk_summary.txt"
    set /a risk_score+=2
)

:: ================================
:: 16. Final Risk Score
:: ================================
echo. >> "%output_dir%\risk_summary.txt"
echo Final Risk Score: %risk_score% >> "%output_dir%\risk_summary.txt"
if %risk_score% GEQ 15 (
    echo HIGH RISK >> "%output_dir%\risk_summary.txt"
) else if %risk_score% GEQ 8 (
    echo MEDIUM RISK >> "%output_dir%\risk_summary.txt"
) else (
    echo LOW RISK >> "%output_dir%\risk_summary.txt"
)

:: ================================
:: 17. Completion Message
:: ================================
echo Done. Risk summary available at "%output_dir%\risk_summary.txt"
pause
:: ================================
:: 18. Generate PDF Report
:: ================================
echo Generating PDF report from risk summary...

:: Create a temporary HTML file
set "html_file=%output_dir%\scan_report.html"
(
echo ^<html^>
echo ^<head^>^<title^>Vulnerability Scan Report^</title^>^</head^>
echo ^<body^>
echo ^<h2^>Vulnerability Scan Report^</h2^>
echo ^<p^>Scan executed by %username% on %date% %time%^</p^>
echo ^<pre^>
type "%output_dir%\risk_summary.txt"
echo ^</pre^>
echo ^</body^>
echo ^</html^>
) > "%html_file%"

:: Use PowerShell to convert HTML to PDF via Word (requires MS Word)
powershell -Command ^
" $word = New-Object -ComObject Word.Application; ^
  $doc = $word.Documents.Add(); ^
  $selection = $word.Selection; ^
  Get-Content '%html_file%' | ForEach-Object { $selection.TypeText($_ + \"`r`n\") }; ^
  $pdfPath = '%output_dir%\scan_report.pdf'; ^
  $doc.SaveAs([ref]$pdfPath, [ref]17); ^
  $doc.Close(); ^
  $word.Quit() "

echo PDF report generated at "%output_dir%\scan_report.pdf"
