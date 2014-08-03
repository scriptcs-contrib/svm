$scriptPath       = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)  # \.svm\shim
$svmPath          = [System.IO.Directory]::GetParent($scriptPath).FullName                  # \.svm\
$versionsPath     = [System.IO.Path]::Combine($svmPath, 'versions')                         # \.svm\versions
$versionFilePath  = [System.IO.Path]::Combine($svmPath, 'version')                          # \.svm\version

#
# helper functions
#
function Write-InfoMessage
{
  param (
    [string] $message
  )
  Write-Host $("{0}" -f "[SVM] $message")
}

function Write-ErrorMessage
{
  param (
    [string] $message
  )
  Write-Host $("{0}" -f "[SVM] $message") -BackgroundColor DarkRed -ForegroundColor White
}

function String-IsEmptyOrWhitespace
{
  param (
    [string] $str
  )
  return [string]::IsNullOrEmpty($str) -or $str.Trim().length -eq 0
}

function Get-ActiveVersion
{
  if (!(Test-Path $versionFilePath))
  {
    return [String]::Empty
  }

  $activeVersion = Get-Content $versionFilePath
  if (-not String-IsEmptyOrWhitespace($activeVersion))
  {
    $activeVersion = $activeVersion.Trim()
  }

  return $activeVersion
}

function Get-ScriptCsExecutable
{
  param (
    [string] $version
  )
  $scriptcs = [System.IO.Path]::Combine($versionsPath, $version, 'scriptcs.exe')
  return $scriptcs
}

try
{
  $version = Get-ActiveVersion
  if ($version -eq [String]::Empty -or $version -eq $null)
  {
    Write-ErrorMessage "No active scriptcs found. Use 'svm use <version>' to set the active scriptcs version."
    exit
  }

  $scriptcs = Get-ScriptCsExecutable $version
  if (!(Test-Path $scriptcs))
  {
    Write-ErrorMessage "The active scriptcs could not be found at '$scriptcs'. Use 'svm use <version>' to correctly set the active scriptcs version."
    exit
  }

  &$scriptcs $args
}
catch
{
  Write-ErrorMessage $_
}
