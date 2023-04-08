# PS Vita Game Lister

Usage: `.\VitaGameLister.ps1 -GamePath '[app]' -GameTSV [PSV_GAMES.tsv]`  <sup>***`-GameTSV` is optional if `PSV_GAMES.tsv` located in the same directory!**</sup>  
Written in PowerShell 7, might work on 5.1.  
(Windows only ships with 5.1 as of writing, but <span title="PowerShell 7">pwsh7</span> is super easy to install~)

I wrote this because I wanted to recover the list of games installed on my PS Vita's <span title="Yes, microSD card. SD2Vita adapters are awesome!">microSD card</span> after the console died.  
<span title="hint: google 'nps vita'">Requires a valid PSV_GAMES.tsv file.</span>

---

I did see [this thing](https://github.com/AzimovParviz/PSVitaGameLister) written in Python, but trying to run it just gave me an error.  
(No offense to [AzimovParviz](https://github.com/AzimovParviz)!)