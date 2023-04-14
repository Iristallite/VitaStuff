Param(
  [Parameter(
    Position=1,
    Mandatory
  )]
  [ValidateNotNullOrEmpty()]
  [string] $GamePath,
  [Parameter(
    Position=2
  )]
  [string] $GameTSV
)

class VitaGame{
  [string] $ID
  [string] $Name
  [string] $Index
  VitaGame(
    [string] $ID,
    [string] $N,
    [string] $I
  ){
    $this.ID    = $ID
    $this.Name  = $N
    $this.Index = $I
  }
}

if($null -eq $GameTSV){ ## error handling
  if(Test-Path -Path '.\PSV_GAMES.tsv'){
    $GameTSV = ".\PSV_GAMES.tsv"
  }else{
    throw 'You can''t expect me to determine the names if I don''t have them!! [PSV_GAME.tsv not found]'
  }
}

#region   |v [build master list]
$MBase1 = Import-Csv -Path $GameTSV -Delimiter "`t" ## import tsv file with delimiter specified
$MBaseCount = $MBase1.count ## count of all games
$MBaseIndex = 0 ## index
$MBase1.foreach({
  $MBaseIndex ++
  [Array] $MBase2 += [VitaGame]::New($_.'Title ID',$_.'Name',$MBaseIndex)
  @{
    ID = 00
    ParentID = (-1)
    Status = "$([Math]::Round($MBaseIndex / $MBaseCount * 100))% [$MBaseIndex of $MBaseCount]"
    Activity = "Building master game list"
    PercentComplete = ($MBaseIndex / $MBaseCount * 100)
  }.foreach({Write-Progress @_})
})
# Write-Output $MBase2
#throw
#endregion|^ [build master list]

#region   |v [build installed list]
$IBase1 = Get-ChildItem -Path "$GamePath" -Force -Name
$IBaseCount = $IBase1.count ## count of installed games
$IBaseIndex = 0 ## index
$IBase1.foreach({
  $IBaseIndex ++
  [Array] $IBase2 += [VitaGame]::new($_,$null,$IBaseIndex)
  @{
    ID = 00
    ParentID = (-1)
    Status = "$([Math]::Round($IBaseIndex / $IBaseCount * 100))% [$IBaseIndex of $IBaseCount]"
    Activity = "Building installed game list"
    PercentComplete = ($IBaseIndex / $IBaseCount * 100)
  }.foreach({Write-Progress @_})
})
#endregion|^ [build installed list]

Write-Output 'It will take a few minutes to list all your games due to the horribly ineffecient way I programmed this. Sorry!'

$IBaseIndex = 0 ## reset IBase index
$IBase2.foreach({ ## check installed game list
  $IBaseIndex ++
  $IBaseID = $_.ID ## store the current id
  @{ ## progress bar for checking IBase
    ID = 00
    ParentID = (-1)
    Status = "$([Math]::Round($IBaseIndex / $IBaseCount * 100))% [$IBaseIndex of $IBaseCount]"
    Activity = "Checking installed games"
    PercentComplete = ($IBaseIndex / $IBaseCount * 100)
  }.foreach({Write-Progress @_})
  $MBaseIndex = 0 ## reset MBase index
  #$MBaseCount = $MBase2.count
  #echo "$mbasecount";break
  if($MBaseIndex -gt $MBaseCount){$MBaseIndex = 0} ## conditinal: reset index if it's greater than the count
  ($MBase2).foreach({ ## check against master list (checking against MBase for each item in IBase is faster than checking against IBase for each item in MBase)
    $MBaseID   = $_.ID ## get title ID from tsv
    $MBaseName = $_.Name ## get name from tsv
    $MBaseIndex = $_.Index
    if($IBaseID -like $MBaseID){ ## check against tsv
      [array] $GameList += [VitaGame]::new($IBaseID,$MBaseName,$IBaseIndex) ## if match, add to list
      $GameFound = $True
    }
    @{ ## progress bar for comparing IBase with MBase
      ID = 10
      ParentID = (00)
      Status = "$([Math]::Round($MBaseIndex / $MBaseCount * 100))% [$MBaseIndex of $MBaseCount]"
      Activity = "Checking against master game list"
      PercentComplete = ($MBaseIndex / $MBaseCount * 100)
    }.foreach({Write-Progress @_})
  })
  if($GameList.ID -notcontains $_.ID){[array] $GameList += [VitaGame]::new($IBaseID,'Unknown',$null)}
})
$GameList | Format-Table | Out-String | Set-Content -Path '.\GameList.txt'
Write-Output 'Done! Game list output to GameList.txt in the current path.'