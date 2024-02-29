Import-Module ActiveDirectory -ErrorAction SilentlyContinue

#$AzOrchUser = "SVC_SC_Orch@niladv.org"
#$AzOrchUserPass = "pHNy8NzDfadFgFZu"
$SNuser = "MSOrchestrator"
$pass = "Nilfisk2021!"

#$AzSQLServerName = "sqlsrv-weeu-nilfiskautomation-tst-01.database.windows.net"
#$AzSQLDBName = "NilfiskAutomation"

######################################################################
# Build Header
######################################################################

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SNuser, $pass)))
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
$method   = "GET"


$SNTableUri = "https://nilfisk.service-now.com/api/now/table/"
$JiraSCTASKSURI = $SNTableUri + "sc_task?sysparm_query=number%3DSCTASK0138803&sysparm_limit=1"

$JiraSCTASK = Invoke-RestMethod -Method $method -Headers $headers -uri $JiraSCTASKSURI

$JiraSCTASK.result

$JiraRITM = Invoke-RestMethod -Method $method -Headers $headers -uri $JiraSCTASK.result.parent.link