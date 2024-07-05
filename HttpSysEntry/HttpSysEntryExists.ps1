<#
.SYNOPSIS
This script will run the command netsh http show urlacl

.DESCRIPTION
This script will run the command netsh http show urlacl
You will need to specify the url to search by giving a value in url=
Depending on the return value length we can tell if it does or does not exist

# return value if it does not exist will look like this:
# output consists of 5 lines (3 of which are simply new lines)
<#

URL Reservations:
-----------------


#>
# the return value we want can vary depending on users
# however, it should look something like this:
<#

URL Reservations: 
----------------- 

Reserved URL            : {URL}
User: BUILTIN\Users
Listen: Yes
Delegate: No
User: NT AUTHORITY\LOCAL SERVICE
Listen: Yes
Delegate: No
SDDL: {Security Descriptor Definition Language}


#>
<#
.EXAMPLE
PS> ./HttpSysEntryExists.ps1
> True
#>

# replace the namespace reservation you would like to search for
# url=http://+
$commandOutput = & netsh http show urlacl url=

if ($commandOutput.Length -eq 5) {
    # uri does not exist
    return $false
}
else {
    # uri exists
    return $true
}