class Folder
{
 [string]$folderName
 [string[]]$filesExtentions
 
 Folder([string]$folderName,[string[]]$fileExtention)
 {
 $this.folderName = $folderName
 $this.filesExtentions = $fileExtention
 }
}

class JsonManager
{
    [Object] OpenFile([string] $filePath)
    {
    $json = [Object](Get-Content '$filePath' | ConvertFrom-Json)
    return New-Object ($json);
    }

    [Folder[]] GetConfigurationCasted($filePath)
    {
    
    $objects  = OpenFile($filePath);
    
    [Folder[]]$folderArray = @()
    
    foreach($folder in $objects)
    {
        $folderArray += New-Object Folder($folder.FolderName,$folder.Extentions)        
    }

    return $folderArray

    }
}

class Organize
{
    [Folder[]]$folders = @()

    Organize([Folder[]]$folders)
    {
    $this.folders = $folders
    }


    [bool] CreatePath()
    {

        foreach($folder in $this.folders)
        {
            if(-not $this.FolderExist($folder.folderName))
            {
            Write-Host "Creating Folder $folder.folderName" -ForegroundColor Red 
            New-Item -Path $folder.folderName -ItemType Directory
            Clear-Host
            }
            
        }
        return $true
    }

    [bool] FolderExist([string]$folderName)
    {
    return (Test-Path ".\$folderName" -PathType Any)
    }

    [void] VerifyIfConfigurationExist()
    {
    if(-not (Test-Path ".\Configuration\Configuration.Json" -PathType Any))
    {
     [Folder[]]$arrayFolder = @()
     $arrayFolder += New-Object Folder ("ExampleFolder",@("txt","doc"))   
     $arrayFolder += New-Object Folder ("ExampleFolder2",@("bmp","jpeg"))   
     $json = $arrayFolder | ConvertTo-Json
     New-Item -Path .\Configuration -ItemType Directory | Out-Host
     New-Item -Path .\Configuration\Configuration.Json -ItemType File | Out-Host
     Set-Content -Path .\Configuration\Configuration.Json -Value $json
    }
    }
}


$folders = [Folder[]]@(New-Object Folder("TesteA",@("a","b")))
$folders.ForEach({write-host $_.folderName})

$o = new-Object Organize ($folders)
$o.VerifyIfConfigurationExist()
$o.CreatePath()


