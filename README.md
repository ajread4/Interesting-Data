# Interesting-Data 

Search for interesting data within network shares or drives. 

## Description

Interesting-Data searches for credentials, passwords, or other secret information on a network share or drive. 

## Install 

1. Download the repository.
    - ```git clone https://github.com/ajread4/Interesting-Data.git```
2. Move the entire folder into one of your PowerShell module directories. 
3. Import the module
    - ```Import-Module Interesting-Data```
4. Run the Module based on [Usage](#Usage)

## Usage

Usage can be found within the ```.EXAMPLE``` section of the module and below. 

1. Find all files with extension .txt,.md,.doc,.xlsx,.csv,.pptx,.sh,.config,.json,.yaml, or .ssh on \\\\172.20.20.12\test that contain a long list of default matching strings. 

    - ```Interesting-Data -Share 172.20.20.12 -Drives test -Content $True```

2. Find all files with the .txt extension located in the share drive at 172.20.20.12 (\\\\172.20.20.12\share). 

    - ```Interesting-Data -Share 172.20.20.12 -Drives share -Extensions *.txt -Names $True ```

3. Find all files with the .txt extension located in the share drive at 172.20.20.12 (\\\\172.20.20.12\share) and returns matches with the word "creds" or "passwords."

    - ```Interesting-Data -Share 172.20.20.12 -Drives share -Extensions *.txt -Content $True -Patterns 'creds|passwords'```

4. Find all files with extension '.csv' and contain the pattern "password" on a remote share \\\\10.11.23.13\Fileshare that requires credentials. Prior to running, you must set [Credentials](#Credentials)

    - ```Interesting-Data -Share 10.1.23.13 -Content $True -Credential $Cred -Drives "Fileshare" -Extensions *.csv -Patterns "password" ```

5. Output to a file called results.txt all files with extension '.csv' and contain the pattern "password" on a remote share "\\10.1.3.16\Documents Repo" that requires credentials. Prior to running, you must set [Credentials](#Credentials)

    - ```Interesting-Data -Share 10.1.3.16 -Content $True -Credential $Cred -Drives "Documents Repo" -Extensions *.csv -Patterns "password" -OutFile results.txt```

6. Output to a file called results.txt all filenames with extension '.csv' on a remote share \\10.1.3.16 that requires credentials. Prior to running, you must set [Credentials](#Credentials)

    - ```Interesting-Data -Share 10.1.3.16 -Names $True -Drives Documents -Extensions *.csv -OutFile results.txt```

### Credentials

The PowerShell module utilizes [PSCredential](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential?view=powershellsdk-7.4.0). To connect to shares that require credentials, you must: 

1. ```$Password = ConvertTo-SecureString 'SecretPassword' -AsPlainText -Force```
2. ```$Cred = New-Object System.Management.Automation.PSCredential('DOMAIN\ajread', $Password)```

## Author 
All code was written by me, AJ Read. 
