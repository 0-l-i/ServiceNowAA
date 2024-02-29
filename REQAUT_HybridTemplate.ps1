Import-Module ActiveDirectory -ErrorAction SilentlyContinue

$AzOrchUser = "SVC_SC_Orch@niladv.org"
$AzOrchUserPass = "pHNy8NzDfadFgFZu"
$SNuser = "MSOrchestrator"
$pass = "Nilfisk2021!"

$AzSQLServerName = "sqlsrv-weeu-nilfiskautomation-tst-01.database.windows.net"
$AzSQLDBName = "NilfiskAutomation"

######################################################################
# Build Header
######################################################################

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SNuser, $pass)))
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
$method   = "GET"
#"Add user to the group: USR-GLB-APPDEP-WIN-AccessDirector2.5-R"
$SNTableUri = "https://nilfisk.service-now.com/api/now/table/"
$TempTicketsUri = $SNTableUri + "sc_task?sysparm_query=short_description%3DAdd%20user%20to%20the%20group%3A%20USR-GLB-APPDEP-WIN-AccessDirector2.5-R&state=2" 

