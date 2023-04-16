# Some stuff related to the PS Vita
Miscellaneous pwsh scripts for PS Vita stuff
(Written in pwsh7; Windows only ships with 5.1 as of writing, but <span title="PowerShell 7">pwsh7</span> is super easy to install~)  

## VPK "installer"
**Untested if the extracted VPKs will actually run due to no working Vita at the moment.**  
**if ^this message^ is still here after 2023-05-07, create an issue so I get notified!**  
Usage: `.\InstallVPK.ps1 -VPK '[vpk file or folder containing vpk files]'`  
Written in PowerShell 7, definitely doesn't work on 5.1  
Extracts VPK files to folders with their Title IDs.  
If it throws any errors, restart explorer.exe.
Copy the folders it outputs to your Vita's `app` folder and use the `Refresh LiveArea` option in VitaShell.

## PS Vita Game/App Lister

Usage: `.\VitaLister.ps1 -GamePath '[app]' -GameTSV [PSV_GAMES.tsv]`  
***`-GameTSV` is optional if `PSV_GAMES.tsv` located in the same directory!**  
Written in PowerShell 7, might work on 5.1.  
<span title="hint: google 'nps vita'">Requires a valid PSV_GAMES.tsv file.</span>


Shotout to [AzimovParviz's](https://github.com/AzimovParviz) [PSVitaGameLister](https://github.com/AzimovParviz/PSVitaGameLister) for inspiring this <s>blatant ripoff</s>
### In memory of my beloved PS Vita OLED model...
I wrote this because I wanted to recover the list of games installed on my PS Vita's <span title="Yes, microSD card. SD2Vita adapters are awesome!">microSD card</span> after it died.  
<center>
  <img
    src=".vitarip.jpg"
    alt="RIP my Vita OLED, 2017-2023"
    width=50%
    height=50%
  ></img><br>
  <b>RIP 2017-2023</b>
</center>