Param(
  [Parameter(
    Mandatory
  )]
  [ValidateNotNullOrEmpty()]
  [string] $VPK,
  [string] $Out
)

## set out to current folder if null
if($Null -eq $Out){$Out = '.\ExtractedVPK'}

class VitaVPK{
  [string] $InFile
  [string] $OutFile
  [string] $TitleID
  VitaVPK(
    [string] $IF,
    [string] $OF,
    [string] $TID
  ){
    $This.InFile  = $IF
    $This.OutFile = $OF
    $This.TitleID = $TID
  }
}

#region   |v [functions]
function ExtractVPK{
  Param(
    [Parameter(
      Mandatory
    )]
    [ValidateNotNullOrEmpty()]
    [string] $VPK,
    [string] $Out,
    [switch] $MultiMode
  )
  
  Expand-Archive -Path $VPK -DestinationPath "$Out\temp\" -Force
  $VPKTemp = "$Out\temp\"
  $ParamSFO = Get-Content -Path "$Out\temp\sce_sys\param.sfo" -asbytestream
  ## complicated way of grabbing the 9-byte title id
  $TitleID = $Null ## reset $TitleID before building it  ## reset $TitleID before building it
  ($ParamSFO[($ParamSFO.count - 20)..($ParamSFO.count - 12)]).foreach({
    [string] $TitleID += ($_ | Format-Hex).ascii
    Write-Debug $TitleID
  })
  Write-Debug $TitleID
  [Array] $TotalList += [VitaVPK]::New($VPK,"$Out$TitleID",$TitleID)
  $ParamSFO = $Null
  Start-Sleep -Seconds 2
  Rename-Item -Path $VPKTemp -NewName "$TitleID" -Force
  if(!$MultiMode){$TotalList | Format-Table | Write-Output}
}

function ExtractVPKs{
  Param(
    [Parameter(
      Mandatory
    )]
    [ValidateNotNullOrEmpty()]
    [string] $VPK,
    [string] $Out
  )
  (Get-ChildItem -Path $VPK -Force -File).foreach({
    ExtractVPK -VPK $_.FullName -Out $Out -MultiMode
  })
  $TotalList | Format-Table | Write-Output
}
#endregion|^ [functions]

if((Get-Item $VPK).PSIsContainer){ ## if $VPK is a folder, run the batch function
  ExtractVPKs -VPK $VPK -Out $Out
}else{ ## if $VPK is a file, run ExtractVPK on it
  ExtractVPK -VPK $VPK -Out $Out
}
$TotalList | Format-Table