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

$scriptPath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) # \.svm\bin
$svmPath = [System.IO.Directory]::GetParent($scriptPath).FullName # \.svm\
$versionsPath = [System.IO.Path]::Combine($svmPath, 'versions')
$versionFilePath = [System.IO.Path]::Combine($svmPath, 'version')

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

function Get-ActiveVersion
{
  if (!(Test-Path $versionFilePath))
  {
    Write-ErrorMessage "The version file cannot be found at '$($versionFilePath)'."
    return [String]::Empty
  }

  $activeVersion = Get-Content $versionFilePath
  if ($activeVersion -ne [String]::Empty -and $activeVersion -ne $null)
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

function Confirm-ElevatedRole
{
    $user = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $elevated = $user.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    return $elevated
}

#
# svm commands
#
function Svm-Help
{
$helpMessage = @"
 USAGE: svm <command> [options]

  svm install <version>
    install scriptcs version indicated by <version>
    examples:
    > svm install 0.10.0
    > svm install 0.10.1

  svm install <version> -from <path>
    install scriptcs version from local path <path> as version <version>
    examples:
    > svm install mybuild -from C:\scriptcs\bin\Debug

  svm install <-l|-list>
    list the scriptcs versions avaiable to install
    examples:
    > svm install -l

  svm remove <version>
    remove installed scriptcs version indicated by <version>
    examples:
    > svm remove 0.9.0

  svm list [-a|-active]
    list the installed scriptcs versions
    -a|-active       list the active version
    examples:
    > svm list
    > svm list -a

  svm use <version>
    use the installed scriptcs version indicated by <version>
    examples:
    > svm use 0.10.0

"@
  Write-InfoMessage $helpMessage
}

function Svm-InstallList
{
  Write-ErrorMessage "svm install <-l|-list> - not yet implemented ..."
}

function Svm-InstallVersionFromPath
{
  param(
    [string] $version,
    [string] $path
  )
  Write-ErrorMessage "svm install <version> -from <path> - not yet implemented ..."
}

function Svm-InstallVersion
{
  param(
    [string] $version
  )

  Write-ErrorMessage "svm install <version> - not yet implemented ..."
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
      if (-not $active -and -not $list -and [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "install <version>" }
      elseif (-not $active -and -not $list -and -not [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "install <version> -from <path>" }
      elseif (-not $active -and $list -and [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 0)
      { $parsedCommand = "install -list" }
    }

    "remove"
    {
      if (-not $active -and -not $list -and [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "remove <version>" }
    }

    "list"
    {
      if (-not $active -and -not $list -and [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 0)
      { $parsedCommand = "list" }
      elseif ($active)
      { $parsedCommand = "list -active" }
    }

    "use"
    {
      if (-not $active -and -not $list -and [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 1)
      { $parsedCommand = "use <version>" }
    }

    "help"
    {
      if (-not $active -and -not $list -and [String]::IsNullOrEmpty($from) -and $scriptArgs.Count -eq 0)
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
    "install <version>"               { Svm-InstallVersion $scriptArgs[0] }
    "install <version> -from <path>"  { Svm-InstallVersionFromPath $scriptArgs[0] $from }
    "install -list"                   { Svm-InstallList }
    "remove <version>"                { Svm-RemoveVersion $scriptArgs[0] }
    "list"                            { Svm-List }
    "list -active"                    { Svm-ListActive }
    "use <version>"                   { Svm-UseVersion $scriptArgs[0] }
    "help"                            { Svm-Help }
    default                           { Svm-Help }
  }
}
catch
{
  Write-ErrorMessage $_
}
