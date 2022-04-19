$servers = 'srv1', 'srv2', 'srv3', 'srv4'

# Checks for registry keys that denote reboot pending on $servers
Try{
    invoke-command -computername $servers -ErrorAction Stop -ScriptBlock {if (Get-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) {Return 'Reboot is needed'}}
    |Select-Object -property PSComputerName, PSShowComputerName
        | export-csv -Path ‘C:\ServerManagement\results.csv’ 
}
#sends error logs to folder
Catch{
    $_.Exception | Out-File 'C:\ServerManagement\log\errorlogs.log' -Append
    Break
}
#this will send an email to IT Admins with Pending Reboot report
$sendMailProperties = @{
    Body = "This is a report of servers that are in reboot pending status"
    Subject = "Pending Reboots"
    To = "To@email.com"
    From = "From@email.com"
    SmtpServer = 'SMTP Server Address'
    Port = "25"
    ErrorAction = 'Stop'
    
    Attachments = 'C:\ServerManagement\results.csv'
    }
    
    #sends error logs to folder
    Try{ 
        Send-MailMessage @sendMailProperties -ErrorAction Stop
    }
    #sends error logs to folder
    Catch{
        $_.Exception | Out-File 'C:\ServerManagement\log' -Append
        Break
    }
