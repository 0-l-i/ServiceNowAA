Disable-AzContextAutosave -Scope Process
# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context
# Set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext   
Set-AzContext -SubscriptionName "sub-git-prdcommon-01"
$AzureContext.identity



$AzSQLServerName = Get-AutomationVariable -Name 'AzureSqlServerName'
$AzSQLDBName = "NilfiskAutomation"

$AzOrchUser = Get-AutomationVariable -Name 'AzureFormOrchServ'
$AzOrchUserPass = Get-AutomationVariable -Name 'AzureFormOrchServPass'

$SNuser = Get-AutomationVariable -Name 'SNTestUser'
$pass = Get-AutomationVariable -Name 'SNTestPassword'

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SNuser, $pass)))
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
$method   = "GET"
#"Add user to the group: USR-GLB-APPDEP-WIN-AccessDirector2.5-R"
$SNTableUri = "https://nilfisk.service-now.com/api/now/table/"



######################################################################
## Create SQL connection, write to SQL table
######################################################################

$Token = (Get-AZAccessToken -ResourceUrl https://database.windows.net).Token
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Data Source = sqlsrv-weeu-nilfiskautomation-01.database.windows.net; Initial Catalog = NilfiskAutomation; Encrypt=True;"
$SqlConnection.AccessToken = $token
$SqlConnection.Open()

$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "SELECT * FROM dbo.SN_TempAccessDirectorAddSCTASKs"

$AccessDirectorTicketsDataAdapter = new-object System.Data.SqlClient.SqlDataAdapter($sqlCommand)
$AccessDirectorTicketsDataTable = New-Object System.Data.DataTable

$AccessDirectorTicketsDataAdapter.Fill($AccessDirectorTicketsDataTable)


Try
{
    $AccessDirectorTicketsDataAdapter.Fill($AccessDirectorTicketsDataTable)
}
Catch
{
    write-host "Error during querying SN_TempAccessDirectorAddSCTASKs"
    write-host $_.Exception.Message
    write-host "Fatal error during execution, terminating process"
    $errorCount = $errorCount + 1
    write-host "-----------------------------------------------"
    write-host $endDate
    write-host "ErrorCount = $errorCount"
    exit
}
