# Author: Asad Ansari
# See README.md for instructions


# VARIABLES
$slmgr_vbs_loc = $env:SystemDrive + "\Windows\System32\"
$ospp_vbs_32_loc = ${env:ProgramFiles(x86)} + "\Microsoft Office\Office16\"
$ospp_vbs_64_loc = ${env:ProgramFiles} + "\Microsoft Office\Office16\"
$km_server = "your_kms.com"


# Return the number of days remaining until Windows activation expires.
function Get-Win-Activation-Days-Remaining {
    Invoke-Expression "cd $slmgr_vbs_loc"
    $win_activation_expires_on = Invoke-Expression "cscript slmgr.vbs /xpr"
    $win_activation_expires_on = [DateTime]$win_activation_time_remaining.Split(' ')[-4]
    $the_date = Get-Date -Format "MM/dd/yyyy"
    $days_remaining = (New-TimeSpan -Start $the_date -End $win_activation_expires_on).Days
    return $days_remaining
}


# Precondition: Either the 32-bit or 64-bit version of Office is installed.
# Sets the right directory for OSPP.vbs (Office Software Protection Platform script)
# OSPP.vbs is stored under "ProgramFiles(x86)\Microsoft Office\Office16\" for 32-bit installations and
# under "ProgramFiles\Microsoft Office\Office16\" for 64-bit installations.
function Set-OSPP-Directory {
    $ospp_32 = $ospp_vbs_32_loc + "ospp.vbs"
    $ospp_64 = $ospp_vbs_64_loc + "ospp.vbs"
    
    if (Test-Path $ospp_32 -PathType leaf) {
        Invoke-Expression "cd '$ospp_vbs_32_loc'"    
    }
    
    if (Test-Path $ospp_64 -PathType leaf) {
        Invoke-Expression "cd '$ospp_vbs_64_loc'"
    }
}


# Precondition: Either the 32-bit or 64-bit version of Office is installed.
# Return the number of days remaining until Office activation expires.
function Get-Office-Activation-Days-Remaining {
    Set-OSPP-Directory
    $office_activation_time_remaining = Invoke-Expression "cscript ospp.vbs /dstatus"
    $office_activation_time_remaining = $office_activation_time_remaining.split(' ')
    return $office_activation_time_remaining[42]
}


# Reset Windows activation.
function Set-Windows-Activation {
    Invoke-Expression "cd $slmgr_vbs_loc"
    Invoke-Expression "cscript //B %windir%\system32\slmgr.vbs /skms $km_server"
    Invoke-Expression "cscript //B %windir%\system32\slmgr.vbs /ato"
}


# Reset Office activation.
function Set-Office-Activation {
    Set-OSPP-Directory
    Invoke-Expression "cscript //B ospp.vbs /sethst:$km_server"
    Invoke-Expression "cscript //B ospp.vbs /act"
}


$win_days_to_expiration = Get-Win-Activation-Days-Remaining
$office_days_to_expiration = Get-Office-Activation-Days-Remaining


# Run the activation commands if Windows activation expires in 10 days or less.
# Change the number of days as per your needs.
if ($win_days_to_expiration -le 10) {
    Write-Host "Activating Windows"
    Set-Windows-Activation
}


# Run the activation commands if Office activation expires in 10 days or less.
# Change the number of days as per your needs.
if ($office_days_to_expiration -le 10) {
    Write-Host "Activating Office"
    Set-Office-Activation
}
