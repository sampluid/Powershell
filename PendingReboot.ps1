$servers = 'SRV1', 'SRV2', 'SRV3','SRV4', 'SRV5', 'SRV6', 'SRV7', 'SRV8'

# Checks for registry keys that denote reboot pending on $servers
Try{
    invoke-command -computername $servers -ErrorAction Stop -ScriptBlock {(Get-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore)}
    |Select-Object -property PSComputerName, PSShowComputerName
        | export-csv -Path 'FilePath.csv'
}
#sends error logs to folder
Catch{
    $_.Exception | Out-File 'FilePath.logs' -Append
    Break
}
#this will send an email to IT Admins with Pending Reboot report
$sendMailProperties = @{
    Body = "This is a report of servers that are in reboot pending status"
    Subject = "Pending Reboots"
    To = "ToEmail@email.com"
    From = "FromEmail@email.com"
    SmtpServer = 'Server Address'
    Port = "25"
    ErrorAction = 'Stop'
    
    Attachments = 'FilePath.csv'
    }
    
    
    Try{ 
        Send-MailMessage @sendMailProperties -ErrorAction Stop
    }
    #sends error logs to folder
    Catch{
        $_.Exception | Out-File 'FilePath.logs' -Append
        Break
    }
