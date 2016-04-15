echo
echo "********************************************************************"
echo "*Find the computers a user has logged into between a specific range*"
echo "*Must be run on the AD DC to work, or a PSSession into the AD      *"
echo "*Date format MUST BE in mm/dd/yyyy HH:MM:SS AM/PM                  *"
echo "*Example: 02/13/2014 10:40:14 PM                                   *"
echo "*No Warranty or guarantees. This can take a long time to complete  *"
echo "*                      by Matthew Koussa                           *"
echo "********************************************************************"
echo 

$domainName = Read-Host -Prompt 'Enter Domain Name'

$firstOU = Read-Host -Prompt 'Enter OU'

$userName = Read-Host -Prompt 'Enter the username'

$startDate = Read-Host -Prompt 'Enter the Start Date'

$endDate = Read-Host -Prompt 'Enter the End Date'

$Computers = Get-ADComputer -filter * -Searchbase "OU=$firstOU,DC=$domainName,DC=local" | % {$_.Name}

Foreach($Computer in $Computers) {

  if (Test-Path "\\$Computer\c$\Users\$userName") {
    if (Get-Item "\\$Computer\c$\Users\$userName" | Select-Object LastWriteTime| Where-Object -Property lastwritetime -gt "$startDate" | Where-Object -Property lastwritetime -lt "$endDate"){
   

      $lastLogin = Get-Item "\\$Computer\c$\Users\$userName" | Select-Object LastWriteTime| Where-Object -Property lastwritetime -gt "$startDate" | Where-Object -Property lastwritetime -lt "$endDate"
      echo "FOUND: $Computer has account $userName. Last logged in: $lastLogin"

      }
  }
}

echo "Finished Searching Computers"