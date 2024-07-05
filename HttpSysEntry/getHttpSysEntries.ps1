<#
.SYNOPSIS
This script will run the command netsh http show urlacl

.DESCRIPTION
This script will run the command netsh http show urlacl
Initialize variables and an accumulative sum/index
while loop iterating through each line from the output of initial command
regular expression switch cases for each line of output
after assigning  all property values we trim whitespace and add to CustomObject

if uncommented and specify a url
for loop to iterate through each object to see if the entry exists

return entries

.NOTES
Chances are you will need to tweak this code depending on the output you want
#>

function getHttpSysEntries {

    $commandOutput = & netsh http show urlacl
    $entries = $commandOutput -split "`n"
    
    $URIentry = $null
    $UserEntry = $null
    $ListenEntry = $null
    $DelegateEntry = $null
    
    $index = 0
    $formattedOutput = @()

while ($index -lt $entries.Length) {
    $line = $entries[$index]
    switch -Regex ($line) {
        "Reserved URL\s+:\s+(.*)" {
   
            if ($null -ne $UserEntry) {
                $formattedOutput += [PSCustomObject]@{
                    URL = $URIentry.Trim()
                    User = $UserEntry.Trim()
                    Listen = $ListenEntry.Trim()
                    Delegate = $DelegateEntry.Trim()
                }
            }
            $URIentry = $matches[1]
            $UserEntry = $null
            $ListenEntry = $null
            $DelegateEntry = $null
        }
        "User:\s+(.*)" { $UserEntry = $matches[1] }
        "Listen:\s+(\w+)" { $ListenEntry = $matches[1] }
        "Delegate:\s+(\w+)" { $DelegateEntry = $matches[1] }
    }
    $index++
}

# catch any missed entries
if ($null -ne $UserEntry) {
    $formattedOutput += [PSCustomObject]@{
        URL = $URIentry
        User = $UserEntry
        Listen = $ListenEntry
        Delegate = $DelegateEntry
    }
}
<# 
# uncomment to check if a specific entry exists
# otherwise this will return all entries
# enter URL reservation to check
$checkURL = ""

for($a=0; $a -le $formattedOutput.Length; $a++) {
    if ($formattedOutput[$a].URL -eq "$checkURL") {
        Write-Output "URL: $($formattedOutput[$a].URL) exists"
        $a = $formattedOutput.Length
    }   
}
Write-Output "URL does not exist"
#>
return $formattedOutput

}

getHttpSysEntries
