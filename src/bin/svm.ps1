param (
  [parameter(Position=0)]
  [string] $command,
  [alias("a")][switch] $active = $false,
  [alias("l")][switch] $list = $false,
  [alias("f")][string] $from = "",
  [parameter(Position=1, ValueFromRemainingArguments=$true)]
  [string[]]$scriptArgs=@()
)

#$svmVersion = "{{VERSION}}"
$svmVersion = "0.1.0"

$scriptPath       = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)  # \.svm\bin
$svmPath          = [System.IO.Directory]::GetParent($scriptPath).FullName                  # \.svm\
$tempPath         = [System.IO.Path]::Combine($svmPath, 'temp')                             # \.svm\temp
$versionsPath     = [System.IO.Path]::Combine($svmPath, 'versions')                         # \.svm\versions
$versionFilePath  = [System.IO.Path]::Combine($svmPath, 'version')                          # \.svm\version

#
# helper functions
#
function Write-TitleMessage
{
  param (
    [string] $message
  )
  Write-Host  $("{0}" -f "`n $message `n") -BackgroundColor DarkGray -ForegroundColor Black
}
function Write-InfoMessage
{
  param (
    [string] $message
  )
  Write-Host $("{0}" -f " $message ")
}

function Write-ErrorMessage
{
  param (
    [string] $message
  )
  Write-Host $("{0}" -f " $message ") -BackgroundColor DarkRed -ForegroundColor White
}

function String-IsEmptyOrWhitespace
{
  param (
    [string] $str
  )
  return [string]::IsNullOrEmpty($str) -or $str.Trim().length -eq 0
}

function Get-VersionsAvailableToInstall
{
  # TODO replace with call to svm web api (include release and nightly versions) ...
  # currently hard coded list
  $versions = @();

  $version = New-Object PSObject -Property @{
    Version               = "0.8.0"
    IsLatestVersion       = $false
    PublishedDate         = "2013-09-18T22:22:13.293"
    Platform              = @("Windows")
    URL                   = "http://chocolatey.org/api/v2/package/ScriptCs/0.8.0"
    PackageHashAlgorithm  = "SHA512"
    PackageHash           = "zxoQn+XY2MqRZlSiupdT7b6h+Xn04k1/AdS1dswJ2FJGTHUc2a0jgeMBltYFOjOWwaZdeNleDTQdFPbW01wqzw=="
  }
  $versions += $version

  $version = New-Object PSObject -Property @{
    Version               = "0.8.1"
    IsLatestVersion       = $false
    PublishedDate         = "2013-10-12T12:20:10.957"
    Platform              = @("Windows")
    URL                   = "http://chocolatey.org/api/v2/package/ScriptCs/0.8.1"
    PackageHashAlgorithm  = "SHA512"
    PackageHash           = "Btz11BN+i6+54I3r8/itfM49QZzjGVM3z7g8Fd6qHPRulKgv7WKdpNUDHrqnOxMo+h19rIyyDVX4ImgLny+AKg=="
  }
  $versions += $version

  $version = New-Object PSObject -Property @{
    Version               = "0.9.0"
    IsLatestVersion       = $false
    PublishedDate         = "2014-02-07T00:43:58.223"
    Platform              = @("Windows")
    URL                   = "http://chocolatey.org/api/v2/package/ScriptCs/0.9.0"
    PackageHashAlgorithm  = "SHA512"
    PackageHash           = "gtlte9gS+1WT3jjkAgUxuAF9SqrhVfYfqtKaQo3Sga/Q8JbpCPo1zHmN/694JApyg02Wn+PLMXYIHhwxxG3xsw=="
  }
  $versions += $version

  $version = New-Object PSObject -Property @{
    Version               = "0.10.0"
    IsLatestVersion       = $false
    PublishedDate         = "2014-07-30T02:22:35.907"
    Platform              = @("Linux", "Mac", "Windows")
    URL                   = "http://chocolatey.org/api/v2/package/ScriptCs/0.10.0"
    PackageHashAlgorithm  = "SHA512"
    PackageHash           = "ovPmZUIjpXgTcmR+xgVEEJ5O+Lynh50F5RMNHo0WZk4r0Jr9DakU6syhEbEluOQVLZ1em+8UFeOzaLzb0DjMlw=="
  }
  $versions += $version

  $version = New-Object PSObject -Property @{
    Version               = "0.10.1"
    IsLatestVersion       = $false
    PublishedDate         = "2014-07-30T22:24:13.01"
    Platform              = @("Linux", "Mac", "Windows")
    URL                   = "http://chocolatey.org/api/v2/package/ScriptCs/0.10.1"
    PackageHashAlgorithm  = "SHA512"
    PackageHash           = "sn3QtQaBrMZtOKjT2R5SvgEu0RqqFCdG6y2KZ2TSQfxsyk82GbzYgqQMJ4OrsfpmqOlMVHJSArGeZFDOVXAXbQ=="
  }
  $versions += $version

  $version = New-Object PSObject -Property @{
    Version               = "0.10.2"
    IsLatestVersion       = $true
    PublishedDate         = "2014-08-01T02:41:53.897"
    Platform              = @("Linux", "Mac", "Windows")
    URL                   = "http://chocolatey.org/api/v2/package/ScriptCs/0.10.2"
    PackageHashAlgorithm  = "SHA512"
    PackageHash           = "kL//M9qdjSW2frQUD6t9YRfviLsqMt2GtDvvXcZVr8WzpgbPIKeHjgQTj7Wx1r9LfRed2XA2h1t1RTKcP22mbA=="
  }
  $versions += $version

  return $versions
}

function Get-VersionToInstall
{
  param(
    [string] $version
  )

  # TODO replace with call to svm web api
  return Get-VersionsAvailableToInstall |? { $_.Version -eq $version }
}

function Download-ScriptCsNuGetPackage
{
  param (
    [string] $url,
    [string] $downloadPath
  )

  New-Item $([System.IO.Path]::GetDirectoryName($downloadPath)) -type Directory | Out-Null
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($url, $downloadPath)
}

function Install-ScriptCsFromNuGetPackage
{
  param(
    [string] $packagePath,
    [string] $installPath
  )

  New-Item $installPath -type Directory | Out-Null

  $packageZip = [System.IO.Path]::ChangeExtension($packagePath, "zip")
  Rename-Item $packagePath $packageZip
  $packageUnzipFolder = [System.IO.Path]::ChangeExtension($packagePath, $null)
  New-Item $packageUnzipFolder -type Directory | Out-Null

  # Use the shell to uncompress the zip file
  $shellApp = New-Object -com shell.application
  $zipFile = $shellApp.namespace($packageZip)
  $destination = $shellApp.namespace($packageUnzipFolder)
  $destination.CopyHere($zipFile.items(), 0x14) #0x4 = don't show UI, 0x10 = overwrite files

  # Only copy a specific sub folder ( tools\scriptcs\* ) from the .nupkg file into the install folder
  $zipFolderToExtract = [System.IO.Path]::Combine($packageUnzipFolder, 'tools', 'scriptcs', '*')
  Copy-Item -Path $zipFolderToExtract -Recurse -Destination $installPath
}

function Install-ScriptCsFromFolder
{
  param(
    [string] $sourcePath,
    [string] $installPath
  )

  New-Item $installPath -type Directory | Out-Null
  $sourceFiles = [System.IO.Path]::Combine($sourcePath, '*')
  Copy-Item -Path $sourceFiles -Recurse -Destination $installPath
}

function Get-ActiveVersion
{
  if (!(Test-Path $versionFilePath))
  {
    Set-Content -Path $versionFilePath -Force "__NO_ACTIVE_VERSION__"
    return [String]::Empty
  }

  $activeVersion = Get-Content $versionFilePath
  if (!$(String-IsEmptyOrWhitespace( $activeVersion )))
  {
    $activeVersion = $activeVersion.Trim()
  }

  return $activeVersion
}

function Get-InstalledVersions
{
  $versions = @()

  if (!(Test-Path $versionsPath))
  {
    Write-ErrorMessage "The versions folder cannot be found at '$($versionsPath)'."
    return $versions
  }

  $activeVersion = Get-ActiveVersion
  $versions = Get-ChildItem $versionsPath | ConvertTo-InstalledVersion $activeVersion
  return $versions
}

filter ConvertTo-InstalledVersion
{
  param(
    [string] $activeVersion
  )

  $active = $false
  if ($_.Name -eq $activeVersion)
  {
    $active = $true
  }
  $version = New-Object PSObject -Property @{
    Active = if ($active) { $true } else { $false }
    Version = $_.Name
    Location = $_.FullName
  }
  return $version
}

#
# svm commands
#
function Svm-Help
{
$helpMessage = @"
 USAGE: svm <command> [options]

  svm install <version>
    Install scriptcs version indicated by <version>.
    examples:
    > svm install 0.10.0
    > svm install 0.10.1

  svm install <version> -from <path>
    Install scriptcs version from path <path> as version <version>. Path may be a local folder or a local NuGet package.
    examples:
    > svm install mybuild-0.10.1 -from 'C:\scriptcs\bin\Debug'
    > svm install 0.10.1 -from 'C:\Downloads\ScriptCs.0.10.1.nupkg'

  svm install <-l|-list>
    List the scriptcs versions avaiable to install.
    examples:
    > svm install -l

  svm remove <version>
    Remove installed scriptcs version indicated by <version>.
    examples:
    > svm remove 0.9.0

  svm list [-a|-active]
    List the installed scriptcs versions.
    -a|-active       list the active version
    examples:
    > svm list
    > svm list -a

  svm use <version>
    Use the installed scriptcs version indicated by <version>.
    examples:
    > svm use 0.10.0

"@
  Write-InfoMessage $helpMessage
}

function Svm-InstallList
{
  $installVersions = Get-VersionsAvailableToInstall

  if ($installVersions.Count -eq 0)
  {
    Write-InfoMessage "No scriptcs versions could be found to install."
  }
  else
  {
    Write-InfoMessage "The following scriptcs versions are available for installation:`n"
    $installVersions | Sort-Object -Property PublishedDate -Descending |% {
      Write-InfoMessage $("  {0}" -f $_.Version)
    }
  }
}

function Svm-InstallVersionFromPath
{
  param(
    [string] $version,
    [string] $path
  )

  $version = $version.Trim()
  $installPath = [System.IO.Path]::Combine($versionsPath, $version)
  if (Test-Path $installPath)
  {
    Write-ErrorMessage "Version '$($version)' is already installed in versions folder '$($versionsPath)'."
    return
  }

  if (Test-Path -Path $path -PathType container)
  {
    Write-InfoMessage "Installing version '$version'."
    Install-ScriptCsFromFolder -sourcePath $path -installPath $installPath
  }
  elseif ([System.IO.Path]::GetExtension($path) -eq ".nupkg")
  {
    $nugetPackage = [System.IO.Path]::GetFileName($path)
    $workingPath = [System.IO.Path]::Combine($tempPath, [Guid]::NewGuid())
    $nuGetPackagePath = [System.IO.Path]::Combine($workingPath, $nugetPackage)

    New-Item $workingPath -type Directory | Out-Null
    Copy-Item -Path $path -Destination $nuGetPackagePath

    Write-InfoMessage "Installing version '$version'."
    Install-ScriptCsFromNuGetPackage -packagePath $nuGetPackagePath -installPath $installPath
    Remove-Item -Recurse -Force $workingPath
  }
  else
  {
    Write-ErrorMessage "Unrecognised option specified for the path."
    return
  }

  Write-InfoMessage "Version '$version' is now available."
  Write-InfoMessage "Consider using svm use <version> to set it as the active scriptcs version."
}

function Svm-InstallVersion
{
  param(
    [string] $version
  )

  $version = $version.Trim()
  $installPath = [System.IO.Path]::Combine($versionsPath, $version)
  if (Test-Path $installPath)
  {
    Write-ErrorMessage "Version '$($version)' is already installed in versions folder '$($versionsPath)'."
    return
  }

  $installVersion = Get-VersionToInstall -version $version

  Write-InfoMessage "Downloading version '$version' from '$($installVersion.URL)'."
  $nugetPackage = 'ScriptCs.{0}.nupkg' -f $version
  $downloadPath = [System.IO.Path]::Combine($tempPath, [Guid]::NewGuid())
  $nuGetPackagePath = [System.IO.Path]::Combine($downloadPath, $nugetPackage)
  Download-ScriptCsNuGetPackage -url $installVersion.URL -downloadPath $nuGetPackagePath

  Write-InfoMessage "Installing version '$version'."
  Install-ScriptCsFromNuGetPackage -packagePath $nuGetPackagePath -installPath $installPath
  Remove-Item -Recurse -Force $downloadPath

  Write-InfoMessage "Version '$version' is now available."
  Write-InfoMessage "Consider using svm use <version> to set it as the active scriptcs version."
}

function Svm-RemoveVersion
{
  param(
    [string] $version
  )

  $version = $version.Trim()
  $versions = Get-InstalledVersions
  $versionToRemove = $versions |? { $_.Version -eq $version }

  if ($versionToRemove)
  {
    Remove-Item $versionToRemove.Location -Recurse -ErrorAction SilentlyContinue
    Write-InfoMessage "The scriptcs version '$($version)' has been removed from versions folder '$($versionsPath)'."

    $newActiveVersion = $versions |? { $_.Version -ne $version } | select -First 1
    if ($newActiveVersion -ne $null)
    {
      Set-Content -Path $versionFilePath -Force "$($newActiveVersion[0].Version)"
      Write-InfoMessage "The active scriptcs version has been set to '$($newActiveVersion[0].Version)'."
    }
    else
    {
      Set-Content -Path $versionFilePath -Force "__NO_ACTIVE_VERSION__"
      Write-InfoMessage "No scriptcs versions left installed."
    }
  }
  else
  {
    Write-InfoMessage "No scriptcs version $version available to remove."
  }
}

function Svm-ListActive
{
  $versions = Get-InstalledVersions
  $activeVersion = $versions |? { $_.Active }
  if ($activeVersion -eq $null -and $versions.Count -gt 1)
  {
    Write-InfoMessage "No active scriptcs version found."
    Write-InfoMessage "`n Consider using svm use <version> to set the active scriptcs version."
  }
  elseif ($activeVersion -eq $null -and $versions.Count -eq 0)
  {
    Write-InfoMessage "No scriptcs versions found."
    Write-InfoMessage "`n Consider using svm install <version> to install a scriptcs version."
  }
  else
  {
    Write-InfoMessage "The following is the active scriptcs version:`n"
    Write-InfoMessage $("  {0}" -f $activeVersion.Version)
  }
}

function Svm-List
{
  $versions = Get-InstalledVersions

  if ($versions.Count -eq 0)
  {
    Write-InfoMessage "No scriptcs versions found."
    Write-InfoMessage "`n Consider using svm install <version> to install a scriptcs version."
  }
  else
  {
    Write-InfoMessage "The following scriptcs versions are installed:`n"
    $versions |% {
      Write-InfoMessage $("  {0,1}  {1}" -f $(if ($_.Active) { "*" } else { " " }), $_.Version)
    }
  }
}

function Svm-UseVersion
{
  param(
    [string] $version
  )

  $version = $version.Trim()
  $versions = Get-InstalledVersions
  if ($versions.Version -notcontains $version)
  {
    Write-ErrorMessage "Version '$($version)' cannot be found in versions folder '$($versionsPath)'."
    Write-InfoMessage "`n Consider using svm install <version> to install the scriptcs version."
    return
  }

  Set-Content -Path $versionFilePath -Force "$version"
  Write-InfoMessage "Active scriptcs version set to '$($version)'."
}

#
# command switching
#
function Parse-CommandParameters
{
  $parsedCommand = [String]::Empty

  switch ($command)
  {
    "install"
    {
      if (-not $active -and -not $list -and $(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "install <version>" }
      elseif (-not $active -and -not $list -and !$(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "install <version> -from <path>" }
      elseif (-not $active -and $list -and $(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 0)
      { $parsedCommand = "install -list" }
    }

    "remove"
    {
      if (-not $active -and -not $list -and $(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "remove <version>" }
    }

    "list"
    {
      if (-not $active -and -not $list -and $(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 0)
      { $parsedCommand = "list" }
      elseif ($active)
      { $parsedCommand = "list -active" }
    }

    "use"
    {
      if (-not $active -and -not $list -and $(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "use <version>" }
    }

    "help"
    {
      if (-not $active -and -not $list -and $(String-IsEmptyOrWhitespace($from)) -and $scriptArgs.Count -eq 0)
      { $parsedCommand = "help" }
    }
  }
  return $parsedCommand
}

try
{
  Write-TitleMessage "scriptcs version manager - $svmVersion"

  $parsedCommand = Parse-CommandParameters
  switch ($parsedCommand)
  {
    "install <version>"               { Svm-InstallVersion -version $scriptArgs[0] }
    "install <version> -from <path>"  { Svm-InstallVersionFromPath -version $scriptArgs[0] -path $from }
    "install -list"                   { Svm-InstallList }
    "remove <version>"                { Svm-RemoveVersion -version $scriptArgs[0] }
    "list"                            { Svm-List }
    "list -active"                    { Svm-ListActive }
    "use <version>"                   { Svm-UseVersion -version $scriptArgs[0] }
    "help"                            { Svm-Help }
    default                           { Svm-Help }
  }
}
catch
{
  Write-ErrorMessage $_
}
