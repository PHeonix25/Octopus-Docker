param (
  [Parameter(Mandatory=$true)]
  [string]$UserName,
  [Parameter(Mandatory=$true)]
  [string]$Password,
  [Parameter(Mandatory=$true)]
  [string]$OctopusVersion
)

. ./Scripts/build-common.ps1

Confirm-RunningFromRootDirectory

$imageVersion = Get-ImageVersion $OctopusVersion

Start-TeamCityBlock "Publish to private repo"

function Set-Tag($tag) {
  Write-Host "docker tag 'octopusdeploy/octopusdeploy-prerelease:$imageVersion-1803' '$tag'"
  & docker tag "octopusdeploy/octopusdeploy-prerelease:$imageVersion-1803" "$tag"
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Docker-Login

Push-Image "octopusdeploy/octopusdeploy-prerelease:$imageVersion-1803"

Stop-TeamCityBlock "Publish to private repo"
