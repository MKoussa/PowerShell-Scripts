echo ""
echo "          /\                                       _         _      "
echo "         /**\                                     |_|  | |  |_      "
echo "        /****\   /\                               |  . |_|. |  .    "
echo "       /      \ /**\                                                "
echo "      /  /\    /    \        /\    /\  /\      /\            /\/\/\ "
echo "     /  /  \  /      \      /  \/\/  \/  \  /\/  \/\  /\  /\/ / /  \"
echo "    /  /    \/ /\     \    /    \ \  /    \/ /   /  \/  \/  \  /    "  
echo "   /  /      \/  \/\   \  /      \    /   /    \                    "
echo "__/__/_______/___/__\___\___________________________________________"
echo "*                                                                  *"
echo "*                  P O W E R - U S E R - F I N D                   *"
echo "*                                                                  *"
echo "*Find the computers a user has logged into between a specific range*"
echo "*                                                                  *"
echo "*   Must be run on the AD DC to work, or a PSSession into the AD   *"
echo "*                                                                  *"
echo "*        Date format MUST BE in mm/dd/yyyy HH:MM:SS AM/PM          *"
echo "*                Example: 02/13/2014 10:40:14 PM                   *"
echo "*                                                                  *"
echo "* No Warranty or guarantees. This can take a long time to complete *"
echo "*                                                                  *"
echo "*                        by Matthew Koussa                         *"
echo "*                                                                  *"
echo "********************************************************************"
echo ""

$domainName = Read-Host -Prompt 'Enter Domain Name'
echo ""
$firstOU = Read-Host -Prompt 'Enter OU'
echo ""
$userName = Read-Host -Prompt 'Enter the username'
echo ""
$startDate = Read-Host -Prompt 'Enter the Start Date'
echo ""
$endDate = Read-Host -Prompt 'Enter the End Date'
echo ""
echo "Starting Search..."

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