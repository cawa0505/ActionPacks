﻿#Requires -Version 5.0
#Requires -Modules Az.Resources

<#
    .SYNOPSIS
        Gets resource groups
    
    .DESCRIPTION  
        
    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Az
        Requires Library script AzureAzLibrary.ps1

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Azure        

    .Parameter AzureCredential
        The PSCredential object provides the user ID and password for organizational ID credentials, or the application ID and secret for service principal credentials

    .Parameter Tenant
        Tenant name or ID

    .Parameter Name
        Specifies the name of the resource group to get. 
        This parameter supports wildcards at the beginning and/or the end of the string   
        
    .Parameter Tag
        The tag to filter resource groups 

    .Parameter Identifier
        Specifies the ID of the resource group to get. Wildcard characters are not permitted

    .Parameter Location
        Specifies the location of the resource group to get
#>

param( 
    [Parameter(Mandatory = $true, ParameterSetName="byName")]
    [Parameter(Mandatory = $true, ParameterSetName="byID")]
    [pscredential]$AzureCredential,
    [Parameter(ParameterSetName="byName")]
    [string]$Name,
    [Parameter(Mandatory = $true,ParameterSetName="byID")]
    [string]$Identifier,
    [Parameter(ParameterSetName="byName")]
    [Parameter(ParameterSetName="byID")]
    [string]$Tag,
    [Parameter(ParameterSetName="byName")]
    [Parameter(ParameterSetName="byID")]
    [string]$Location,
    [Parameter(ParameterSetName="byName")]
    [Parameter(ParameterSetName="byID")]
    [string]$Tenant
)

Import-Module Az

try{
#    ConnectAzure -AzureCredential $AzureCredential -Tenant $Tenant

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'}
    
    if([System.String]::IsNullOrWhiteSpace($Name) -eq $false){
        $cmdArgs.Add('Name',$Name)
    }
    if($PSCmdlet.ParameterSetName -eq "byID"){
        $cmdArgs.Add('ID',$Identifier)
    }
    if([System.String]::IsNullOrWhiteSpace($Tag) -eq $false){
        $cmdArgs.Add('Tag',$Tag)
    }
    if([System.String]::IsNullOrWhiteSpace($Location) -eq $false){
        $cmdArgs.Add('Location',$Location)
    }

    $ret = Get-AzResourceGroup @cmdArgs

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $ret 
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw
}
finally{
#    DisconnectAzure -Tenant $Tenant
}