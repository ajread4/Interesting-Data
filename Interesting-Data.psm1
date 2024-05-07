function Interesting-Data {

<#
.SYNOPSIS

Searches for interesting data within network shares or drives

Author: AJ Read
Required Dependencies: None
Optional Dependencies: None

.DESCRIPTION

This function recursively searches within a provided share or drive for interesting files that may include credentials, passwords, or other secret information. 
By default, the tool searches for .txt, .md, .doc, and .xlsx files with the pattern "creds" or "passwords" within the current directory. 

.EXAMPLE

Interesting-Data -Share 172.20.20.12 -Drives share -Extensions *.txt -Names $True 

Finds all files with the .txt extension located in the share drive at 172.20.20.12. 

.EXAMPLE 

Interesting-Data -Share 172.20.20.12 -Drives share -Extensions *.txt -Content $True -Patterns 'creds|passwords'

Finds all files with the .txt extension located in the share drive at 172.20.20.12 and returns matches with 

.EXAMPLE

Interesting-Data -Share 172.20.20.12 -Drives test -Extensions *.txt -Content $True 

Finds all files with extension .txt on \\172.20.20.12\test that contain the word "creds" or "passwords"

#>
    param(

        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Share = '.\',

        [Parameter(Position = 1, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]
        $Drives = '.\',

        [Parameter(Position = 2, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Extensions=('*.txt','*.md','*.doc','*.xlsx','*.csv','*.pptx','*.sh','*.config','*.json','*.yaml','*.ssh'),

        [Parameter(Position = 3, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Patterns='creds|password|username|credentials|pass|login|user|pwd|passcode|passphrase|secret|token|key|login|signin|auth|authenticate|authorization|access|pin|security code|access code|encrypted|decryption|secure|unlock|protected|confidential|verification|verify|api_key|private_key|public_key|encryption_key|passphrase|account|user_id|username|security_question|recovery_question|master_password|root_password|admin_password|backup_password|secret_key|entry_code|ssl_cert|ssl_key|auth_token|cipher|crypt|hash',

        [bool] $Names=$False,
        [bool] $Content=$False,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    foreach ($Drive in $Drives){

        if (New-PSDrive -Name "Interesting-Data" -PSProvider "FileSystem" -Root "\\$Share\$Drive" -Credential $Credential){

            Write-Host "Path Tested Successfully for \\$Share\$Drive"
            Write-Host "-------------------------------------"

            $PatternFiles = Get-ChildItem -Path \\$Share\$Drive -Include $Extensions -Recurse -Name -Force
            Write-Host "Number of Files To Parse" $PatternFiles.Count
            foreach($PatternFile in $PatternFiles){
                if ($Names){ <# Retrieve files with only specific extensions#>
                    Write-Host $PatternFile
                }
                elseif($Content){ <# Retrieve files with possible credential patterns within specific extensions#>
                    $Results = Get-Content -Path \\$Share\$Drive\$PatternFile | Select-String -Pattern $Patterns
                    if ($Results -ne $null){
                        Write-Host "Pattern File" $PatternFile
                        Write-Host "Results:" $Results.Line
                        $Result_Matches=@($Results.Matches) | sort -Unique
                        Write-Host "Pattern(s):" $Result_Matches
                        Write-Host "-------------------------------------"
                    }
                
                }else{
                    Write-Host "No option selected (Names or Content)"
                    Write-Host "-------------------------------------"
                }                
            }
            Remove-PSDrive -Name "Interesting-Data"
        }
        else{
            Write-Host "Incorrect Path for Network Share \\$Share\$Drive"
        }
    }
} 