#requires -Version 5.1
# =====================================================================
#  REDNECK RAMPAGE - LAUNCHER NATIF (sans DOSBox / sans émulateur MS-DOS)
#  Moteur : Raze (port moderne du moteur Build) - téléchargé automatiquement
#  Windows 10 / 11 - HD / 1080p / 1440p / 4K - Français / English
#  Interface animée (fond, fumée, poussières, braises) + musique de fond
# =====================================================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$LauncherDir  = $PSScriptRoot
$Root         = Split-Path -Parent $LauncherDir
$EngineDir    = Join-Path $LauncherDir 'engine'
$SettingsFile = Join-Path $LauncherDir 'launcher_settings.json'
$CfgFile      = Join-Path $LauncherDir 'rr_config.cfg'
$BgFile       = Join-Path $LauncherDir 'background.jpg'
$MusicFile    = Join-Path $LauncherDir 'music.mp3'

# ---------- Couleurs / polices ----------
$cBg     = [Drawing.Color]::FromArgb(24,20,17)
$cPanel  = [Drawing.Color]::FromArgb(40,33,28)
$cAccent = [Drawing.Color]::FromArgb(214,120,30)
$cAccent2= [Drawing.Color]::FromArgb(240,150,50)
$cText   = [Drawing.Color]::FromArgb(238,228,212)
$cDim    = [Drawing.Color]::FromArgb(160,148,132)
$fTitle  = New-Object Drawing.Font('Impact',30)
$fBtn    = New-Object Drawing.Font('Segoe UI',14,[Drawing.FontStyle]::Bold)
$fNorm   = New-Object Drawing.Font('Segoe UI',10)
$fSmall  = New-Object Drawing.Font('Segoe UI',9)

# ---------- Traductions ----------
$Tr = @{
 fr = @{
  sub='Collection - version native Windows 10 / 11, sans émulateur MS-DOS'
  game='Choix du jeu :'; g_rr='Redneck Rampage'; g_r66="Redneck Rampage : Suckin' Grits on Route 66"; g_again='Redneck Rampage Rides Again'
  play='JOUER'; options='OPTIONS'; quit='QUITTER'
  choose='CHOIX DU JEU'; m_lbl='MUSIQUE'; m_on='ON'; m_off='OFF'
  hint='Entrée : jouer   ←/→ : jeu   M : musique   Échap : quitter'
  lmusic='Musique du launcher (Launcher\music.mp3)'; lmusicvol='Volume launcher :'
  st_ok='Moteur moderne : installé   |   Résolution : '; st_dl='Moteur moderne : sera téléchargé au premier lancement (Raze)'
  t_video='Vidéo'; t_game='Jeu'; t_ctl='Commandes'; t_audio='Audio'
  res='Résolution :'; native='Natif (résolution du bureau)'; full='Plein écran'; vsync='Synchronisation verticale (V-Sync)'
  backend='Moteur de rendu :'; b_auto='Automatique'; fps='Limite d''images/s :'; unl='Illimitée'
  smooth='Textures lissées (sinon pixels nets, rendu rétro)'
  cine='Cinématiques HD (lissage des vidéos, sans déformation)'
  up_grp=' Upscale Résolution HD '; up_on='Activer l''upscale HD (rendu interne en haute définition)'; up_tgt='Résolution cible :'
  up_note='Le jeu est rendu à cette résolution puis adapté à votre écran (supersampling).'
  up_warn='Les hautes résolutions demandent une carte graphique puissante.'
  nointro='Désactiver l''introduction et les logos'; nomon='Sans monstres'; cross='Afficher le viseur'; showfps='Afficher les images/s (FPS)'
  autoaim='Visée automatique'; bob='Balancement de la vue en marchant'; sway='Balancement de l''arme'; autorun='Course automatique'
  msens='Sensibilité souris :'; invert='Inverser la souris (haut/bas)'; closel='Fermer le launcher au lancement'; extra='Arguments avancés :'
  master='Volume général :'; music='Volume musique :'
  ctl_on='Utiliser mes touches personnalisées'; c_act='Action'; c_key='Touche'; c_chg='Modifier la touche'; c_rst='Touches par défaut (ZQSD/WASD)'
  c_press='Appuyez sur la nouvelle touche...   (Échap = annuler)'; c_hint='Sélectionnez une action, cliquez "Modifier" puis appuyez sur la touche voulue. Les touches par défaut du jeu restent actives en plus. Le menu du jeu (Échap > Options) permet aussi de régler les commandes.'
  save='Enregistrer'; cancel='Annuler'
  ask_dl="Le moteur moderne (Raze) n'est pas encore installé.`nLe télécharger maintenant (environ 20 Mo) ?"; ask_t='Premier lancement'
  miss='Fichier de jeu introuvable :'; err='Erreur'; fail_start='Impossible de lancer le jeu :'
  inst_t='Installation du moteur'; inst_s='Recherche de la dernière version de Raze...'; inst_d='Téléchargement de'; inst_x='Extraction...'
  inst_e="Impossible d'installer le moteur automatiquement :"; inst_m='Téléchargez Raze manuellement sur https://github.com/ZDoom/Raze/releases puis extrayez-le dans :'
  a_forward='Avancer'; a_backward='Reculer'; a_strafel='Pas de côté gauche'; a_strafer='Pas de côté droit'; a_turnl='Tourner à gauche'; a_turnr='Tourner à droite'
  a_run='Courir'; a_jump='Sauter'; a_crouch='S''accroupir'; a_lookup='Regarder en haut'; a_lookdown='Regarder en bas'
  a_fire='Tirer'; a_kick='Coup de pied'; a_use='Ouvrir / Utiliser'; a_wprev='Arme précédente'; a_wnext='Arme suivante'
  a_invprev='Inventaire précédent'; a_invnext='Inventaire suivant'; a_invuse='Utiliser l''objet'; a_slot='Arme n°'
 }
 en = @{
  sub='Native Windows 10 / 11 version - no MS-DOS emulator'
  game='Select game:'; g_rr='Redneck Rampage'; g_r66="Suckin' Grits on Route 66"; g_again='Redneck Rampage Rides Again'
  play='PLAY'; options='OPTIONS'; quit='QUIT'
  choose='SELECT GAME'; m_lbl='MUSIC'; m_on='ON'; m_off='OFF'
  hint='Enter: play   ←/→: game   M: music   Esc: quit'
  lmusic='Launcher music (Launcher\music.mp3)'; lmusicvol='Launcher volume:'
  st_ok='Modern engine: installed   |   Resolution: '; st_dl='Modern engine: will be downloaded on first launch (Raze)'
  t_video='Video'; t_game='Game'; t_ctl='Controls'; t_audio='Audio'
  res='Resolution:'; native='Native (desktop resolution)'; full='Fullscreen'; vsync='Vertical sync (V-Sync)'
  backend='Renderer:'; b_auto='Automatic'; fps='Frame rate limit:'; unl='Unlimited'
  smooth='Smooth textures (otherwise sharp pixels, retro look)'
  cine='HD cinematics (smoothed videos, no stretching)'
  up_grp=' HD Resolution Upscale '; up_on='Enable HD upscale (high-definition internal rendering)'; up_tgt='Target resolution:'
  up_note='The game is rendered at this resolution then fitted to your screen (supersampling).'
  up_warn='High resolutions require a powerful graphics card.'
  nointro='Disable intro and logos'; nomon='No monsters'; cross='Show crosshair'; showfps='Show frames per second (FPS)'
  autoaim='Auto-aim'; bob='View bobbing while walking'; sway='Weapon sway'; autorun='Auto-run'
  msens='Mouse sensitivity:'; invert='Invert mouse (up/down)'; closel='Close launcher when the game starts'; extra='Advanced arguments:'
  master='Master volume:'; music='Music volume:'
  ctl_on='Use my custom keys'; c_act='Action'; c_key='Key'; c_chg='Change key'; c_rst='Default keys (WASD)'
  c_press='Press the new key...   (Esc = cancel)'; c_hint='Select an action, click "Change key", then press the desired key. The game''s default keys stay active as well. The in-game menu (Esc > Options) can also set controls.'
  save='Save'; cancel='Cancel'
  ask_dl="The modern engine (Raze) is not installed yet.`nDownload it now (about 20 MB)?"; ask_t='First launch'
  miss='Game file not found:'; err='Error'; fail_start='Could not start the game:'
  inst_t='Engine installation'; inst_s='Looking for the latest Raze version...'; inst_d='Downloading'; inst_x='Extracting...'
  inst_e='Could not install the engine automatically:'; inst_m='Download Raze manually from https://github.com/ZDoom/Raze/releases then extract it into:'
  a_forward='Move forward'; a_backward='Move backward'; a_strafel='Strafe left'; a_strafer='Strafe right'; a_turnl='Turn left'; a_turnr='Turn right'
  a_run='Run'; a_jump='Jump'; a_crouch='Crouch'; a_lookup='Look up'; a_lookdown='Look down'
  a_fire='Fire'; a_kick='Kick'; a_use='Open / Use'; a_wprev='Previous weapon'; a_wnext='Next weapon'
  a_invprev='Previous item'; a_invnext='Next item'; a_invuse='Use item'; a_slot='Weapon #'
 }
}

# ---------- Réglages ----------
$DefKeys = [ordered]@{
 forward='w'; backward='s'; strafel='a'; strafer='d'; turnl='leftarrow'; turnr='rightarrow'; run='shift'; jump='space'; crouch='c'
 lookup='pgup'; lookdown='pgdn'; fire='ctrl'; kick='f'; use='e'; wprev='q'; wnext='r'; invprev='['; invnext=']'; invuse='enter'
 slot1='1'; slot2='2'; slot3='3'; slot4='4'; slot5='5'; slot6='6'; slot7='7'; slot8='8'; slot9='9'; slot0='0'
}
$Cmds = @{
 forward='+move_forward'; backward='+move_backward'; strafel='+strafe_left'; strafer='+strafe_right'; turnl='+turn_left'; turnr='+turn_right'
 run='+run'; jump='+jump'; crouch='+crouch'; lookup='+look_up'; lookdown='+look_down'; fire='+fire'; kick='+quick_kick'; use='+open'
 wprev='weapprev'; wnext='weapnext'; invprev='invprev'; invnext='invnext'; invuse='invuse'
}
$Defaults = [ordered]@{
 Lang='fr'; Game='rr'; Fullscreen=$true; Resolution='native'; UpscaleHD=$false; UpscaleTarget='3840x2160'
 Backend='auto'; VSync=$true; MaxFps=0; Smooth=$false; CineHD=$false
 MasterVol=80; MusicVol=60; NoIntro=$false; NoMonsters=$false; Crosshair=$true; ShowFps=$false; AutoAim=$true
 ViewBob=$true; Sway=$true; AutoRun=$false; MouseSens=10; InvertMouse=$false
 CustomKeys=$true; CloseLauncher=$false; ExtraArgs=''
 LauncherMusic=$true; LauncherMusicVol=50
}
$S = @{}
foreach($k in $Defaults.Keys){ $S[$k] = $Defaults[$k] }
$S.KeyMap = @{}
foreach($k in $DefKeys.Keys){ $S.KeyMap[$k] = $DefKeys[$k] }
if(Test-Path $SettingsFile){
    try{
        $j = Get-Content $SettingsFile -Raw | ConvertFrom-Json
        foreach($p in $j.PSObject.Properties){
            if($p.Name -eq 'KeyMap'){ foreach($q in $p.Value.PSObject.Properties){ if($DefKeys.Contains($q.Name)){ $S.KeyMap[$q.Name] = [string]$q.Value } } }
            elseif($Defaults.Contains($p.Name)){ $S[$p.Name] = $p.Value }
        }
    }catch{}
}
# interface entièrement en anglais
$S.Lang = 'en'
function Save-Settings { $S | ConvertTo-Json -Depth 4 | Set-Content -Path $SettingsFile -Encoding UTF8 }
function T($k){ $d=$Tr[[string]$S.Lang]; if($d.ContainsKey($k)){ return $d[$k] } else { return $Tr['fr'][$k] } }

# ---------- Utilitaires ----------
function Find-Engine {
    if(-not (Test-Path $EngineDir)){ return $null }
    $f = Get-ChildItem -Path $EngineDir -Filter 'raze.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if($f){ return $f.FullName } else { return $null }
}
function Get-GameInfo($g){
    switch($g){
        'rr'      { return @{ Grp=(Join-Path $Root 'REDNECK.GRP');        Dir=$Root;                     Extra='' } }
        'again'   { return @{ Grp=(Join-Path $Root 'AGAIN\REDNECK.GRP'); Dir=(Join-Path $Root 'AGAIN'); Extra='' } }
        'route66' { return @{ Grp=(Join-Path $Root 'REDNECK.GRP');        Dir=$Root;                     Extra='-con GAME66.CON' } }
    }
}
function Show-Msg($text,$title='Redneck Rampage Launcher',$icon='Information'){ [void][Windows.Forms.MessageBox]::Show($text,$title,'OK',$icon) }

# ---------- Musique CD en jeu ----------
# Les versions GOG stockent la bande-son (pistes audio CD de Mojo Nixon / The Beat Farmers)
# dans une image CD (.inst = fiche CUE, .gog = BIN). Raze ne lit pas cette image : on extrait
# une seule fois les pistes audio dans Launcher\music\<jeu>\trackNN.ogg (données PCM/WAV,
# reconnues automatiquement par le moteur). Raze les enchaîne ensuite en boucle (pistes 2 à 9).
function Get-CdImage($g){
    if($g -eq 'again'){ return @{ Inst=(Join-Path $Root 'AGAIN\RRRAGAIN.inst'); Key='again' } }
    return @{ Inst=(Join-Path $Root 'REDNECK.inst'); Key='rr' }
}
$AltDir = Join-Path $env:LOCALAPPDATA 'RedneckRampageLauncher'
$script:Rippers = @{}
# Extraction lancée en arrière-plan dès l'ouverture du launcher (aucune fenêtre, aucune attente)
function Start-CdRips {
    $order = @('rr','again'); if($S.Game -eq 'again'){ $order = @('again','rr') }
    $jobs = New-Object System.Collections.Generic.List[RRFx.CdRipper]
    foreach($k in $order){
        $ci = Get-CdImage $k
        if(-not (Test-Path $ci.Inst)){ continue }
        $dirs = [string[]]@((Join-Path $LauncherDir "music\$k"), (Join-Path $AltDir "music\$k"))
        $r = New-Object RRFx.CdRipper($ci.Inst, $dirs)
        $script:Rippers[$k] = $r; $jobs.Add($r)
    }
    if($jobs.Count -gt 0){ [RRFx.CdRipper]::StartQueue($jobs.ToArray()) }
}
function Get-CdMusicDir($g){
    $k = (Get-CdImage $g).Key
    $r = $script:Rippers[$k]; if(-not $r){ return $null }
    # au besoin, très courte attente silencieuse (l'animation continue)
    $sw = [Diagnostics.Stopwatch]::StartNew()
    while(-not $r.Done -and $sw.ElapsedMilliseconds -lt 2500){ [Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 20 }
    if(-not $r.Done){ Write-Log "Soundtrack still being prepared - game started without CD music this time."; return $null }
    if($r.Error){ Write-Log "Soundtrack: $($r.Error)" }
    return $r.OutDir
}

# ---------- Journal (diagnostic) ----------
function Write-Log($msg){
    $line = "[{0:yyyy-MM-dd HH:mm:ss}] {1}" -f (Get-Date), $msg
    try{ Add-Content -Path (Join-Path $LauncherDir 'launcher_log.txt') -Value $line -Encoding UTF8 -ErrorAction Stop }
    catch{ try{ New-Item -ItemType Directory -Path $AltDir -Force | Out-Null; Add-Content -Path (Join-Path $AltDir 'launcher_log.txt') -Value $line -Encoding UTF8 }catch{} }
}

# ---------- Option "No monsters" ----------
# Raze remet "monstres actifs" à chaque nouvelle partie lancée depuis son menu, ce qui annule
# le paramètre -nomonsters. Un petit script CON chargé en plus force MONSTERS_OFF à chaque
# entrée dans un niveau (événement EVENT_ENTERLEVEL = 1), avant l'apparition des ennemis.
function Ensure-NoMonstersAddon {
    $txt = "// Redneck Rampage Launcher - option No monsters`r`nonevent 1`r`n  setvar MONSTERS_OFF 1`r`nendevent`r`n"
    foreach($base in @($LauncherDir, $AltDir)){
        $dir = Join-Path $base 'addons\nomonsters'
        $con = Join-Path $dir 'rrlauncher_nomonsters.con'
        try{
            New-Item -ItemType Directory -Path $dir -Force -ErrorAction Stop | Out-Null
            if(-not (Test-Path $con) -or ((Get-Content $con -Raw) -ne $txt)){ [IO.File]::WriteAllText($con, $txt, [Text.Encoding]::ASCII) }
            return $dir
        }catch{ Write-Log "No-monsters addon ($base): $($_.Exception.Message)" }
    }
    return $null
}

function Install-Engine {
    $f = New-Object Windows.Forms.Form
    $f.Text=(T 'inst_t'); $f.Size='480,170'; $f.StartPosition='CenterScreen'
    $f.FormBorderStyle='FixedDialog'; $f.ControlBox=$false; $f.BackColor=$cBg; $f.ForeColor=$cText; $f.Font=$fNorm
    $l = New-Object Windows.Forms.Label; $l.Text=(T 'inst_s'); $l.Location='20,20'; $l.Size='430,25'
    $b = New-Object Windows.Forms.ProgressBar; $b.Location='20,60'; $b.Size='430,26'; $b.Style='Marquee'
    $f.Controls.AddRange(@($l,$b)); $f.Show(); [Windows.Forms.Application]::DoEvents()
    $script:dlBar = $b
    try{
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $rel = Invoke-RestMethod 'https://api.github.com/repos/ZDoom/Raze/releases/latest' -Headers @{'User-Agent'='RR-Launcher'}
        $asset = $rel.assets | Where-Object { $_.name -match 'win' -and $_.name -match '\.zip$' } | Select-Object -First 1
        if(-not $asset){ throw 'No Windows archive found in the latest Raze release.' }
        $l.Text = "$(T 'inst_d') $($asset.name) ..."
        $b.Style='Continuous'; $b.Minimum=0; $b.Maximum=100
        $zip = Join-Path $env:TEMP $asset.name
        $wc = New-Object Net.WebClient
        $wc.Headers.Add('User-Agent','RR-Launcher')
        $wc.add_DownloadProgressChanged({ param($s,$e) $script:dlBar.Value = $e.ProgressPercentage })
        $wc.DownloadFileAsync([Uri]$asset.browser_download_url,$zip)
        while($wc.IsBusy){ [Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 40 }
        $l.Text=(T 'inst_x'); $b.Style='Marquee'; [Windows.Forms.Application]::DoEvents()
        if(Test-Path $EngineDir){ Remove-Item $EngineDir -Recurse -Force }
        New-Item -ItemType Directory -Path $EngineDir -Force | Out-Null
        Expand-Archive -Path $zip -DestinationPath $EngineDir -Force
        Remove-Item $zip -Force -ErrorAction SilentlyContinue
        $f.Close()
        return [bool](Find-Engine)
    }catch{
        $f.Close()
        Show-Msg ("$(T 'inst_e')`n`n$($_.Exception.Message)`n`n$(T 'inst_m')`n$EngineDir") (T 'err') 'Error'
        return $false
    }
}

function Get-Screen { $b=[Windows.Forms.Screen]::PrimaryScreen.Bounds; return @($b.Width,$b.Height) }
function Get-TargetRes {
    $r = $S.Resolution; if($S.UpscaleHD){ $r = $S.UpscaleTarget }
    if($r -match '^(\d+)x(\d+)$'){ return @([int]$Matches[1],[int]$Matches[2]) }
    return Get-Screen
}
function Inv($v){ return ([double]$v).ToString([Globalization.CultureInfo]::InvariantCulture) }

function Write-Config {
    $o = New-Object System.Collections.Generic.List[string]
    $o.Add('// Généré par le launcher Redneck Rampage - ne pas modifier (réécrit à chaque lancement)')
    if($S.CustomKeys){
        foreach($id in $Cmds.Keys){ $k=$S.KeyMap[$id]; if($k){ $o.Add("bind `"$k`" `"$($Cmds[$id])`"") } }
        foreach($n in 1..9 + 0){ $k=$S.KeyMap["slot$n"]; if($k){ $o.Add("bind `"$k`" `"slot $n`"") } }
    }
    $o.Add("cl_crosshair $([int][bool]$S.Crosshair)")
    $o.Add("vid_fps $([int][bool]$S.ShowFps)")
    $o.Add("cl_autoaim $([int][bool]$S.AutoAim)")
    $o.Add("cl_viewbob $([int][bool]$S.ViewBob)")
    $o.Add("cl_weaponsway $([int][bool]$S.Sway)")
    $o.Add("cl_autorun $([int][bool]$S.AutoRun)")
    $sens = (Inv ([double]$S.MouseSens/10)); if($S.InvertMouse){ $o.Add('in_mouseflip 1') } else { $o.Add('in_mouseflip 0') }
    $o.Add("in_mousesensitivity $sens")
    Set-Content -Path $CfgFile -Value $o -Encoding ASCII
}

function Start-Game {
    $gi = Get-GameInfo $S.Game
    if(-not (Test-Path $gi.Grp)){ Show-Msg "$(T 'miss')`n$($gi.Grp)" (T 'err') 'Error'; return }
    $eng = Find-Engine
    if(-not $eng){
        $r = [Windows.Forms.MessageBox]::Show((T 'ask_dl'),(T 'ask_t'),'YesNo','Question')
        if($r -ne 'Yes'){ return }
        if(-not (Install-Engine)){ return }
        $eng = Find-Engine
    }
    Write-Config
    $musicDir = Get-CdMusicDir $S.Game
    $scr = Get-Screen; $tgt = Get-TargetRes
    $a = New-Object System.Collections.Generic.List[string]
    $a.Add("-gamegrp `"$($gi.Grp)`"")
    if($gi.Extra){ $a.Add($gi.Extra) }
    if($S.UpscaleHD){
        # fenêtre/écran natif + rendu interne à la résolution cible (supersampling)
        $a.Add("-width $($scr[0]) -height $($scr[1])")
        $a.Add("+vid_scalemode 5 +vid_scale_customwidth $($tgt[0]) +vid_scale_customheight $($tgt[1])")
    } else { $a.Add("-width $($tgt[0]) -height $($tgt[1])") }
    $a.Add("+vid_fullscreen $([int][bool]$S.Fullscreen)")
    $a.Add("+vid_vsync $([int][bool]$S.VSync)")
    if($S.Backend -eq 'opengl'){ $a.Add('+vid_preferbackend 0') }
    if($S.Backend -eq 'vulkan'){ $a.Add('+vid_preferbackend 1') }
    if([int]$S.MaxFps -gt 0){ $a.Add("+vid_maxfps $([int]$S.MaxFps)") }
    $filter = 0; if($S.Smooth -or $S.UpscaleHD -or $S.CineHD){ $filter = 4 }
    $a.Add("+gl_texture_filter $filter")
    if($S.CineHD){ $a.Add('+vid_cropaspect 0') }
    $a.Add("+snd_mastervolume $(Inv ([double]$S.MasterVol/100))")
    $a.Add("+snd_musicvolume $(Inv ([double]$S.MusicVol/100))")
    if($musicDir){
        # bande-son CD : pistes extraites, lues et enchaînées en boucle par Raze
        $a.Add("-file `"$musicDir`"")
        $a.Add('+mus_enabled 1 +mus_redbook 1')
    }
    if($S.NoIntro){ $a.Add('-nologo -nointro') }
    if($S.NoMonsters){
        $a.Add('-nomonsters')
        $nm = Ensure-NoMonstersAddon
        if($nm){ $a.Add("-file `"$nm`" -addcon rrlauncher_nomonsters.con") }
    }
    $a.Add("-exec `"$CfgFile`"")
    # ---------- Trainer (dossier Trainer à côté du launcher) ----------
    $trDir = Join-Path $Root 'Trainer'
    $trSrc = Join-Path $trDir 'rrtrainer_con.txt'
    if(Test-Path $trSrc){
        # le script de jeu est livré en .txt : on le (re)copie en .con pour Raze
        try{ New-Item -ItemType Directory -Path (Join-Path $trDir 'addon') -Force | Out-Null; Copy-Item $trSrc (Join-Path $trDir 'addon\rrtrainer.con') -Force }catch{ Write-Log "Trainer: $($_.Exception.Message)" }
    }
    if((Test-Path (Join-Path $trDir 'addon\rrtrainer.con')) -and -not (Test-Path (Join-Path $trDir 'disabled.flag'))){
        $a.Add("-file `"$(Join-Path $trDir 'addon')`" -addcon rrtrainer.con")
        # Raze ne lit que le premier -exec : on chaîne les touches du trainer depuis rr_config.cfg
        $trCfg = Join-Path $trDir 'rrtrainer.cfg'
        if(Test-Path $trCfg){ try{ Add-Content -Path $CfgFile -Value ("exec `"" + ($trCfg -replace '\\','/') + "`"") -Encoding ASCII }catch{ Write-Log "Trainer cfg: $($_.Exception.Message)" } }
        $a.Add("+logfile `"$(Join-Path $trDir 'rrtrainer.log')`"")
    }
    if($S.ExtraArgs){ $a.Add($S.ExtraArgs) }
    try{
        Write-Log ("Start: `"$eng`" " + ($a -join ' '))
        $script:GameProc = Start-Process -FilePath $eng -ArgumentList ($a -join ' ') -WorkingDirectory $gi.Dir -PassThru
        if($S.CloseLauncher){ Save-Settings; $script:MainForm.Close(); return }
        # le jeu tourne : fondu de sortie de la musique + animation en pause
        if($script:Music){ $script:Music.Suspended = $true }
        if($script:Scene){ $script:Scene.Paused = $true }
    }catch{ Show-Msg "$(T 'fail_start')`n$($_.Exception.Message)" (T 'err') 'Error' }
}

# ---------- Aides UI ----------
function New-Button($text,$x,$y,$w,$h,$primary=$false){
    $b = New-Object Windows.Forms.Button
    $b.Text=$text; $b.Location = New-Object Drawing.Point($x,$y); $b.Size = New-Object Drawing.Size($w,$h)
    $b.FlatStyle='Flat'; $b.Font=$fBtn; $b.Cursor='Hand'; $b.ForeColor=$cText
    $b.FlatAppearance.BorderColor=$cAccent; $b.FlatAppearance.BorderSize=2
    if($primary){ $b.BackColor=$cAccent; $b.ForeColor=[Drawing.Color]::White; $b.FlatAppearance.MouseOverBackColor=$cAccent2 }
    else { $b.BackColor=$cPanel; $b.FlatAppearance.MouseOverBackColor=[Drawing.Color]::FromArgb(70,55,42) }
    return $b
}
function New-Label($text,$x,$y,$w=200,$dim=$false){
    $l = New-Object Windows.Forms.Label; $l.Text=$text; $l.Location = New-Object Drawing.Point($x,$y)
    $l.Size = New-Object Drawing.Size($w,24); $l.Font=$fNorm; $l.BackColor=[Drawing.Color]::Transparent
    if($dim){ $l.ForeColor=$cDim; $l.Font=$fSmall } else { $l.ForeColor=$cText }
    return $l
}
function New-Combo($items,$x,$y,$w){
    $c = New-Object Windows.Forms.ComboBox; $c.DropDownStyle='DropDownList'; $c.Font=$fNorm
    $c.Location = New-Object Drawing.Point($x,$y); $c.Size = New-Object Drawing.Size($w,28)
    $c.FlatStyle='Flat'; $c.BackColor=$cPanel; $c.ForeColor=$cText
    foreach($i in $items){ [void]$c.Items.Add($i) }
    return $c
}
function New-Check($text,$x,$y,$w=380){
    $c = New-Object Windows.Forms.CheckBox; $c.Text=$text; $c.Location = New-Object Drawing.Point($x,$y)
    $c.Size = New-Object Drawing.Size($w,26); $c.Font=$fNorm; $c.ForeColor=$cText; $c.BackColor=[Drawing.Color]::Transparent
    return $c
}
function New-Track($x,$y,$w,$min,$max,$val){
    $t = New-Object Windows.Forms.TrackBar; $t.Location = New-Object Drawing.Point($x,$y); $t.Size = New-Object Drawing.Size($w,40)
    $t.Minimum=$min; $t.Maximum=$max; $t.TickFrequency=[math]::Max(1,[int](($max-$min)/10)); $t.BackColor=$cBg
    $t.Value=[math]::Min($max,[math]::Max($min,[int]$val)); return $t
}
function New-Group($text,$x,$y,$w,$h){
    $g = New-Object Windows.Forms.GroupBox; $g.Text=$text; $g.Location=New-Object Drawing.Point($x,$y); $g.Size=New-Object Drawing.Size($w,$h); $g.ForeColor=$cAccent2; return $g
}
function New-Page { $p=New-Object Windows.Forms.Panel; $p.Location='0,58'; $p.Size='600,650'; $p.BackColor=$cBg; $p.Visible=$false; return $p }

$ResVals = @('native','1280x720','1600x900','1920x1080','2560x1440','3840x2160')
$UpVals  = @('1920x1080','2560x1440','3840x2160')
$ResLbl = @{ '1280x720'='1280 x 720  (HD)'; '1600x900'='1600 x 900'; '1920x1080'='1920 x 1080  (Full HD / 1080p)'; '2560x1440'='2560 x 1440  (2K / 1440p)'
             '3840x2160'='3840 x 2160  (4K UHD)' }
function Res-Text($v){ if($v -eq 'native'){ return (T 'native') } else { return $ResLbl[$v] } }

# ---------- Touches ----------
function Convert-Key($k){
    $n = $k.ToString()
    if($n -match '^[A-Z]$'){ return $n.ToLower() }
    if($n -match '^D(\d)$'){ return $Matches[1] }
    if($n -match '^F\d{1,2}$'){ return $n.ToLower() }
    if($n -match '^NumPad(\d)$'){ return 'kp' + $Matches[1] }
    $m = @{ Left='leftarrow'; Right='rightarrow'; Up='uparrow'; Down='downarrow'; Space='space'; Return='enter'; Tab='tab'; Back='backspace'
            ControlKey='ctrl'; LControlKey='ctrl'; RControlKey='ctrl'; ShiftKey='shift'; LShiftKey='shift'; RShiftKey='shift'; Menu='alt'; LMenu='alt'; RMenu='alt'
            Prior='pgup'; PageUp='pgup'; Next='pgdn'; PageDown='pgdn'; Home='home'; End='end'; Insert='ins'; Delete='del'
            OemSemicolon=';'; Oem1=';'; Oemplus='='; Oemcomma=','; OemMinus='-'; OemPeriod='.'; OemQuestion='/'; Oem2='/'; Oemtilde='`'; Oem3='`'
            OemOpenBrackets='['; Oem4='['; OemPipe='\'; Oem5='\'; OemCloseBrackets=']'; Oem6=']'; OemQuotes=''''; Oem7='''' }
    if($m.ContainsKey($n)){ return $m[$n] }
    return $null
}
$ActionOrder = @('forward','backward','strafel','strafer','turnl','turnr','run','jump','crouch','lookup','lookdown','fire','kick','use','wprev','wnext','invprev','invnext','invuse','slot1','slot2','slot3','slot4','slot5','slot6','slot7','slot8','slot9','slot0')
function Action-Text($id){ if($id -like 'slot*'){ return ((T 'a_slot') + $id.Substring(4)) } else { return (T "a_$id") } }

# ---------- Menu Options (intégré à l'écran animé du launcher) ----------
$FpsVals = @(0,60,120,144,240)
function Find-Index($arr,$val,$def=0){ for($i=0;$i -lt $arr.Count;$i++){ if([string]$arr[$i] -eq [string]$val){ return $i } }; return $def }

function Open-Options {
    $sc = $script:Scene; if(-not $sc){ return }
    $sc.ClearOptions()
    $sc.OptionsTitle = 'OPTIONS'; $sc.SaveText = 'SAVE'; $sc.CancelText = 'CANCEL'; $sc.PressKeyText = 'PRESS A KEY...  (ESC = CANCEL)'
    $tV = $sc.AddTab('VIDEO'); $tG = $sc.AddTab('GAME'); $tC = $sc.AddTab('CONTROLS'); $tA = $sc.AddTab('AUDIO')

    # ----- Vidéo -----
    [void]$sc.AddOpt($tV,'header','h_disp','Display')
    $o = $sc.AddOpt($tV,'choice','res',(T 'res')); $o.Choices = [string[]]@($ResVals | ForEach-Object { Res-Text $_ }); $o.Index = Find-Index $ResVals $S.Resolution 0
    $o.DependsOn = 'upscale'; $o.DependsInverse = $true
    $o = $sc.AddOpt($tV,'check','full',(T 'full')); $o.Check = [bool]$S.Fullscreen
    $o = $sc.AddOpt($tV,'check','vsync',(T 'vsync')); $o.Check = [bool]$S.VSync
    $o = $sc.AddOpt($tV,'choice','backend',(T 'backend')); $o.Choices = [string[]]@((T 'b_auto'),'OpenGL','Vulkan'); $o.Index = Find-Index @('auto','opengl','vulkan') $S.Backend 0
    $o = $sc.AddOpt($tV,'choice','fps',(T 'fps')); $o.Choices = [string[]]@((T 'unl'),'60','120','144','240'); $o.Index = Find-Index $FpsVals ([int]$S.MaxFps) 0
    $o = $sc.AddOpt($tV,'check','smooth',(T 'smooth')); $o.Check = [bool]$S.Smooth
    $o = $sc.AddOpt($tV,'check','cine',(T 'cine')); $o.Check = [bool]$S.CineHD
    [void]$sc.AddOpt($tV,'header','h_up','HD Resolution Upscale')
    $o = $sc.AddOpt($tV,'check','upscale',(T 'up_on')); $o.Check = [bool]$S.UpscaleHD
    $o = $sc.AddOpt($tV,'choice','uptarget',(T 'up_tgt')); $o.Choices = [string[]]@($UpVals | ForEach-Object { Res-Text $_ }); $o.Index = Find-Index $UpVals $S.UpscaleTarget 2
    $o.DependsOn = 'upscale'
    [void]$sc.AddOpt($tV,'note','n_up1',(T 'up_note'))
    $o = $sc.AddOpt($tV,'note','n_up2',(T 'up_warn')); $o.Warn = $true

    # ----- Jeu -----
    [void]$sc.AddOpt($tG,'header','h_game','Gameplay')
    foreach($p in @(@('nointro','NoIntro'),@('nomon','NoMonsters'),@('cross','Crosshair'),@('showfps','ShowFps'),@('autoaim','AutoAim'),@('bob','ViewBob'),@('sway','Sway'),@('autorun','AutoRun'))){
        $o = $sc.AddOpt($tG,'check',$p[0],(T $p[0])); $o.Check = [bool]$S[$p[1]]
    }
    [void]$sc.AddOpt($tG,'header','h_mouse','Mouse')
    $o = $sc.AddOpt($tG,'slider','msens',(T 'msens')); $o.Min = 1; $o.Max = 30; $o.Value = [int]$S.MouseSens
    $o = $sc.AddOpt($tG,'check','invert',(T 'invert')); $o.Check = [bool]$S.InvertMouse
    [void]$sc.AddOpt($tG,'header','h_launch','Launcher')
    $o = $sc.AddOpt($tG,'check','closel',(T 'closel')); $o.Check = [bool]$S.CloseLauncher
    $o = $sc.AddOpt($tG,'text','extra',(T 'extra')); $o.Text = [string]$S.ExtraArgs

    # ----- Commandes -----
    $o = $sc.AddOpt($tC,'check','custkeys',(T 'ctl_on')); $o.Check = [bool]$S.CustomKeys
    $o = $sc.AddOpt($tC,'button','resetkeys','Default keys'); $o.Text = 'DEFAULT KEYS'
    [void]$sc.AddOpt($tC,'note','n_keys','Click an action, then press the new key. The game''s default keys stay active too.')
    [void]$sc.AddOpt($tC,'header','h_keys','Key bindings')
    foreach($id in $ActionOrder){
        $o = $sc.AddOpt($tC,'key',"key_$id",(Action-Text $id)); $o.Text = [string]$S.KeyMap[$id]; $o.DependsOn = 'custkeys'
    }

    # ----- Audio -----
    [void]$sc.AddOpt($tA,'header','h_game_audio','In-game')
    $o = $sc.AddOpt($tA,'slider','master',(T 'master')); $o.Min = 0; $o.Max = 100; $o.Value = [int]$S.MasterVol; $o.Suffix = '%'
    $o = $sc.AddOpt($tA,'slider','music',(T 'music')); $o.Min = 0; $o.Max = 100; $o.Value = [int]$S.MusicVol; $o.Suffix = '%'
    [void]$sc.AddOpt($tA,'note','n_cd','The CD soundtrack plays in a loop during the game.')
    [void]$sc.AddOpt($tA,'header','h_launch_audio','Launcher')
    $o = $sc.AddOpt($tA,'check','lmusic',(T 'lmusic')); $o.Check = [bool]$S.LauncherMusic
    $o = $sc.AddOpt($tA,'slider','lmusicvol',(T 'lmusicvol')); $o.Min = 0; $o.Max = 100; $o.Value = [int]$S.LauncherMusicVol; $o.Suffix = '%'

    $sc.ShowOptions()
}

function Save-Options {
    $sc = $script:Scene; if(-not $sc){ return }
    $g = { param($id) $sc.FindOpt($id) }
    $S.Resolution    = $ResVals[(& $g 'res').Index]
    $S.UpscaleHD     = (& $g 'upscale').Check
    $S.UpscaleTarget = $UpVals[(& $g 'uptarget').Index]
    $S.Fullscreen    = (& $g 'full').Check
    $S.VSync         = (& $g 'vsync').Check
    $S.Backend       = @('auto','opengl','vulkan')[(& $g 'backend').Index]
    $S.MaxFps        = $FpsVals[(& $g 'fps').Index]
    $S.Smooth        = (& $g 'smooth').Check
    $S.CineHD        = (& $g 'cine').Check
    $S.NoIntro = (& $g 'nointro').Check; $S.NoMonsters = (& $g 'nomon').Check; $S.Crosshair = (& $g 'cross').Check
    $S.ShowFps = (& $g 'showfps').Check; $S.AutoAim = (& $g 'autoaim').Check; $S.ViewBob = (& $g 'bob').Check
    $S.Sway = (& $g 'sway').Check; $S.AutoRun = (& $g 'autorun').Check
    $S.MouseSens     = (& $g 'msens').Value
    $S.InvertMouse   = (& $g 'invert').Check
    $S.CloseLauncher = (& $g 'closel').Check
    $S.ExtraArgs     = ([string](& $g 'extra').Text).Trim()
    $S.CustomKeys    = (& $g 'custkeys').Check
    foreach($id in $ActionOrder){ $S.KeyMap[$id] = [string](& $g "key_$id").Text }
    $S.MasterVol = (& $g 'master').Value; $S.MusicVol = (& $g 'music').Value
    $S.LauncherMusic = (& $g 'lmusic').Check; $S.LauncherMusicVol = (& $g 'lmusicvol').Value
    Save-Settings
}

function Handle-OptionEvent($id){
    $sc = $script:Scene
    switch -regex ($id){
        '^opt_save$'   { Save-Options; $sc.HideOptions(); Apply-Music; Update-SceneTexts }
        '^opt_cancel$' { $sc.HideOptions(); Apply-Music }
        '^optbtn:resetkeys$' { foreach($k in $ActionOrder){ $o = $sc.FindOpt("key_$k"); if($o){ $o.Text = [string]$DefKeys[$k] } }; $sc.Invalidate() }
        '^optchg:lmusicvol$' { if($script:Music){ $script:Music.Volume = $sc.FindOpt('lmusicvol').Value / 100.0 } }
        '^optchg:lmusic$'    { if($script:Music){ $script:Music.Enabled = $sc.FindOpt('lmusic').Check } }
    }
}

# ---------- Moteur d'animation + musique (C# compilé une fois puis mis en cache) ----------
$FxSource = @'
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;

namespace RRFx
{
    public class UiEventArgs : EventArgs
    {
        public string Id;
        public UiEventArgs(string id) { Id = id; }
    }

    // ------------------------------------------------------------------
    //  Musique de fond (MCI / winmm) : boucle infinie + fondu entrant/sortant
    // ------------------------------------------------------------------
    public class Music : IDisposable
    {
        [DllImport("winmm.dll", CharSet = CharSet.Unicode)]
        static extern int mciSendString(string cmd, StringBuilder ret, int retLen, IntPtr cb);
        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
        static extern int GetShortPathName(string longPath, StringBuilder shortPath, int len);

        const string A = "rrlaunchermusic";
        bool opened, playing;
        float level;
        int lastVol = -1;
        Timer timer;
        Stopwatch sw;
        double last, pollAcc;

        public bool Enabled = true;
        public bool Suspended = false;
        public float Volume = 0.5f;
        public float FadeSeconds = 1.5f;

        public bool IsOpen { get { return opened; } }
        public float Level { get { return level; } }

        int Send(string c) { return mciSendString(c, null, 0, IntPtr.Zero); }
        string Query(string c)
        {
            StringBuilder sb = new StringBuilder(128);
            mciSendString(c, sb, sb.Capacity, IntPtr.Zero);
            return sb.ToString().Trim().ToLowerInvariant();
        }

        public bool Open(string path)
        {
            if (!File.Exists(path)) return false;
            string p = path;
            StringBuilder sb = new StringBuilder(1024);
            if (GetShortPathName(path, sb, sb.Capacity) > 0) p = sb.ToString();
            Send("close " + A);
            if (Send("open \"" + p + "\" type mpegvideo alias " + A) != 0)
            {
                if (Send("open \"" + path + "\" type mpegvideo alias " + A) != 0) return false;
            }
            opened = true;
            SetVol(0f);
            sw = Stopwatch.StartNew();
            timer = new Timer();
            timer.Interval = 40;
            timer.Tick += OnTick;
            timer.Start();
            return true;
        }

        void SetVol(float v)
        {
            int n = (int)Math.Round(Math.Max(0f, Math.Min(1f, v)) * 1000f);
            if (n == lastVol) return;
            lastVol = n;
            Send("setaudio " + A + " volume to " + n);
        }

        void OnTick(object s, EventArgs e)
        {
            if (!opened) return;
            double now = sw.Elapsed.TotalSeconds;
            double dt = now - last; last = now;
            if (dt > 0.5) dt = 0.5;
            bool want = Enabled && !Suspended;
            float target = want ? Math.Max(0f, Math.Min(1f, Volume)) : 0f;
            if (want && !playing)
            {
                Send("play " + A + " repeat");
                playing = true;
            }
            float step = (float)(dt / Math.Max(0.05f, FadeSeconds));
            if (level < target) level = Math.Min(target, level + step);
            else if (level > target) level = Math.Max(target, level - step);
            // courbe perceptive (fondu plus naturel)
            SetVol(level * level * (3f - 2f * level));
            if (!want && playing && level <= 0.0001f)
            {
                Send("pause " + A);
                playing = false;
            }
            // filet de sécurité pour la boucle
            pollAcc += dt;
            if (pollAcc >= 1.0)
            {
                pollAcc = 0;
                if (playing && Query("status " + A + " mode") == "stopped")
                {
                    Send("seek " + A + " to start");
                    Send("play " + A + " repeat");
                }
            }
        }

        public void Dispose()
        {
            if (timer != null) { timer.Stop(); timer.Dispose(); timer = null; }
            if (opened) { Send("stop " + A); Send("close " + A); opened = false; }
        }
    }

    // ------------------------------------------------------------------
    //  Scène animée : fond Ken Burns, fumée, brouillard, poussières,
    //  braises, scintillement de la lampe + interface dessinée
    // ------------------------------------------------------------------
    class Particle
    {
        public float X, Y, VX, VY, Size, Depth, Phase, Life, MaxLife, Alpha, Grow;
    }

    public class Scene : Control
    {
        // ----- Textes / état fournis par le script PowerShell -----
        public string[] Games = new string[] { "Redneck Rampage" };
        public int GameIndex = 0;
        public string Subtitle = "", ChooseLabel = "", PlayText = "PLAY", OptionsText = "OPTIONS", QuitText = "QUIT";
        public string Status = "", Hint = "", LangText = "EN", MusicText = "MUSIC", OnText = "ON", OffText = "OFF";
        public Music Music;
        public event EventHandler<UiEventArgs> UiAction;

        // image source = 1920x1080 ; positions utiles en coordonnées normalisées
        const float MINF = 0.95f;
        Image src;
        Bitmap cache, vignette, fogA, fogB;
        Bitmap[] glowW, glowO, smokeS;
        float cacheScale, cacheOX, cacheOY;
        float viewX, viewY, viewW, viewH;
        int W, H;
        float s = 1f;

        readonly List<Particle> dust = new List<Particle>();
        readonly List<Particle> bokeh = new List<Particle>();
        readonly List<Particle> embers = new List<Particle>();
        readonly List<Particle> smoke = new List<Particle>();
        readonly Random rnd = new Random();
        readonly Dictionary<string, Font> fonts = new Dictionary<string, Font>();
        readonly List<KeyValuePair<string, RectangleF>> hits = new List<KeyValuePair<string, RectangleF>>();
        SolidBrush[] dustBrush, emberCore;

        Timer timer;
        Stopwatch sw = Stopwatch.StartNew();
        double t, last;
        double flickerStart = 6, flickerEnd = 6.8, nextFlicker = 6;
        double smokeAcc, emberAcc;
        float uiHover;
        string hover, pressed;
        bool paused;

        public Scene()
        {
            SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.OptimizedDoubleBuffer |
                     ControlStyles.UserPaint | ControlStyles.ResizeRedraw | ControlStyles.Selectable, true);
            DoubleBuffered = true;
            BackColor = Color.Black;
            TabStop = true;
            dustBrush = new SolidBrush[24];
            emberCore = new SolidBrush[24];
            for (int i = 0; i < 24; i++)
            {
                int a = (int)(255f * (i + 1) / 24f);
                dustBrush[i] = new SolidBrush(Color.FromArgb(a, 255, 238, 210));
                emberCore[i] = new SolidBrush(Color.FromArgb(a, 255, 214, 120));
            }
        }

        public bool Paused
        {
            get { return paused; }
            set
            {
                paused = value;
                if (timer != null) { if (paused) timer.Stop(); else { last = sw.Elapsed.TotalSeconds; timer.Start(); } }
            }
        }

        public void LoadBackground(string path)
        {
            byte[] bytes = File.ReadAllBytes(path);
            using (MemoryStream ms = new MemoryStream(bytes))
            using (Image img = Image.FromStream(ms))
            {
                src = new Bitmap(img);
            }
            Rebuild();
        }

        protected override void OnHandleCreated(EventArgs e)
        {
            base.OnHandleCreated(e);
            timer = new Timer();
            timer.Interval = 15;
            timer.Tick += delegate { Step(); };
            last = sw.Elapsed.TotalSeconds;
            if (!paused) timer.Start();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (timer != null) { timer.Stop(); timer.Dispose(); }
                DisposeBitmaps();
                foreach (Font f in fonts.Values) f.Dispose();
                fonts.Clear();
            }
            base.Dispose(disposing);
        }

        void DisposeBitmaps()
        {
            if (cache != null) cache.Dispose();
            if (vignette != null) vignette.Dispose();
            if (fogA != null) fogA.Dispose();
            if (fogB != null) fogB.Dispose();
            if (glowW != null) foreach (Bitmap b in glowW) b.Dispose();
            if (glowO != null) foreach (Bitmap b in glowO) b.Dispose();
            if (smokeS != null) foreach (Bitmap b in smokeS) b.Dispose();
            cache = vignette = fogA = fogB = null;
        }

        protected override void OnResize(EventArgs e)
        {
            base.OnResize(e);
            Rebuild();
        }

        float Rf(float a, float b) { return a + (float)rnd.NextDouble() * (b - a); }

        // ---------------- Pré-calculs ----------------
        void Rebuild()
        {
            if (ClientSize.Width < 16 || ClientSize.Height < 16) return;
            W = ClientSize.Width; H = ClientSize.Height;
            s = W / 1280f;
            DisposeBitmaps();
            foreach (Font f in fonts.Values) f.Dispose();
            fonts.Clear();
            ClearTextCache();

            // fond mis à l'échelle (couvre W/MINF x H/MINF)
            int cw = (int)Math.Ceiling(W / MINF) + 2, ch = (int)Math.Ceiling(H / MINF) + 2;
            cache = new Bitmap(cw, ch, PixelFormat.Format32bppPArgb);
            using (Graphics g = Graphics.FromImage(cache))
            {
                g.Clear(Color.Black);
                if (src != null)
                {
                    cacheScale = Math.Max((float)cw / src.Width, (float)ch / src.Height);
                    float dw = src.Width * cacheScale, dh = src.Height * cacheScale;
                    cacheOX = (dw - cw) / 2f; cacheOY = (dh - ch) / 2f;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.DrawImage(src, -cacheOX, -cacheOY, dw, dh);
                }
            }

            // vignette + assombrissement côté interface
            vignette = new Bitmap(W, H, PixelFormat.Format32bppPArgb);
            using (Graphics g = Graphics.FromImage(vignette))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                using (GraphicsPath p = new GraphicsPath())
                {
                    p.AddEllipse(-0.25f * W, -0.30f * H, 1.5f * W, 1.6f * H);
                    using (PathGradientBrush b = new PathGradientBrush(p))
                    {
                        b.CenterColor = Color.FromArgb(0, 0, 0, 0);
                        b.SurroundColors = new Color[] { Color.FromArgb(235, 0, 0, 0) };
                        Blend bl = new Blend();
                        bl.Factors = new float[] { 0f, 0.55f, 0.92f, 1f };
                        bl.Positions = new float[] { 0f, 0.22f, 0.55f, 1f };
                        b.Blend = bl;
                        g.FillRectangle(b, 0, 0, W, H);
                    }
                }
                using (LinearGradientBrush lb = new LinearGradientBrush(new RectangleF(W * 0.45f, 0, W * 0.55f + 2, H),
                    Color.FromArgb(0, 0, 0, 0), Color.FromArgb(110, 0, 0, 0), LinearGradientMode.Horizontal))
                    g.FillRectangle(lb, W * 0.45f + 1, 0, W * 0.55f, H);
                using (LinearGradientBrush lb = new LinearGradientBrush(new RectangleF(0, H * 0.7f, W, H * 0.3f + 2),
                    Color.FromArgb(0, 0, 0, 0), Color.FromArgb(120, 0, 0, 0), LinearGradientMode.Vertical))
                    g.FillRectangle(lb, 0, H * 0.7f + 1, W, H * 0.3f);
            }

            fogA = MakeFog(Math.Max(64, W / 4), Math.Max(32, H / 4), 1337, 26, Color.FromArgb(205, 196, 188));
            fogB = MakeFog(Math.Max(64, W / 4), Math.Max(32, H / 4), 4242, 20, Color.FromArgb(150, 120, 110));

            glowW = MakeSprites(32, Color.FromArgb(255, 244, 226), 16, 2.2f);
            glowO = MakeSprites(32, Color.FromArgb(255, 140, 40), 16, 1.6f);
            smokeS = MakeSprites(64, Color.FromArgb(200, 196, 192), 16, 1.2f);

            InitParticles();
            UpdateView();
        }

        Bitmap MakeFog(int fw, int fh, int seed, int maxA, Color c)
        {
            Random r = new Random(seed);
            Bitmap b = new Bitmap(fw, fh, PixelFormat.Format32bppPArgb);
            using (Graphics g = Graphics.FromImage(b))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                for (int i = 0; i < 46; i++)
                {
                    float rw = fw * (0.12f + (float)r.NextDouble() * 0.30f);
                    float rh = rw * (0.25f + (float)r.NextDouble() * 0.35f);
                    float x = (float)r.NextDouble() * fw;
                    float y = fh * (0.15f + (float)Math.Pow(r.NextDouble(), 0.6) * 0.85f) - rh / 2f;
                    int a = 6 + r.Next(maxA);
                    for (int k = -1; k <= 1; k++)
                    {
                        RectangleF rc = new RectangleF(x - rw / 2f + k * fw, y, rw, rh);
                        if (rc.Right < 0 || rc.Left > fw) continue;
                        using (GraphicsPath p = new GraphicsPath())
                        {
                            p.AddEllipse(rc);
                            using (PathGradientBrush br = new PathGradientBrush(p))
                            {
                                br.CenterColor = Color.FromArgb(a, c);
                                br.SurroundColors = new Color[] { Color.FromArgb(0, c) };
                                g.FillPath(br, p);
                            }
                        }
                    }
                }
            }
            return b;
        }

        Bitmap[] MakeSprites(int size, Color c, int levels, float gamma)
        {
            Bitmap[] arr = new Bitmap[levels];
            for (int i = 0; i < levels; i++)
            {
                int amax = (int)(255f * (i + 1) / levels);
                Bitmap b = new Bitmap(size, size, PixelFormat.Format32bppPArgb);
                BitmapData d = b.LockBits(new Rectangle(0, 0, size, size), ImageLockMode.WriteOnly, PixelFormat.Format32bppPArgb);
                int[] px = new int[size * size];
                float rr = size / 2f;
                for (int y = 0; y < size; y++)
                    for (int x = 0; x < size; x++)
                    {
                        float dx = (x + 0.5f - rr) / rr, dy = (y + 0.5f - rr) / rr;
                        float dd = (float)Math.Sqrt(dx * dx + dy * dy);
                        float v = Math.Max(0f, 1f - dd);
                        v = (float)Math.Pow(v, gamma);
                        int a = (int)(amax * v);
                        int pr = c.R * a / 255, pg = c.G * a / 255, pb = c.B * a / 255;
                        px[y * size + x] = (a << 24) | (pr << 16) | (pg << 8) | pb;
                    }
                Marshal.Copy(px, 0, d.Scan0, px.Length);
                b.UnlockBits(d);
                arr[i] = b;
            }
            return arr;
        }

        void InitParticles()
        {
            dust.Clear(); bokeh.Clear(); embers.Clear(); smoke.Clear();
            for (int i = 0; i < 190; i++)
            {
                Particle p = new Particle();
                p.Depth = (float)Math.Pow(rnd.NextDouble(), 1.6) * 0.85f + 0.15f;
                p.X = Rf(0, W); p.Y = Rf(0, H);
                p.VX = Rf(4f, 16f) * p.Depth * s; p.VY = Rf(-5f, 5f) * p.Depth * s;
                p.Size = (0.7f + 2.3f * p.Depth) * Math.Max(0.8f, s);
                p.Phase = Rf(0, 6.283f); p.Alpha = Rf(0.35f, 1f);
                dust.Add(p);
            }
            for (int i = 0; i < 12; i++)
            {
                Particle p = new Particle();
                p.X = Rf(0, W); p.Y = Rf(0, H);
                p.VX = Rf(5f, 14f) * s; p.VY = Rf(-4f, 3f) * s;
                p.Size = Rf(14f, 34f) * s; p.Phase = Rf(0, 6.283f); p.Alpha = Rf(0.07f, 0.16f);
                bokeh.Add(p);
            }
            for (int i = 0; i < 9; i++) { Particle p = NewEmber(); p.Life = Rf(0, p.MaxLife); p.Y += p.VY * p.Life; embers.Add(p); }
            for (int i = 0; i < 14; i++) { Particle p = NewSmoke(); float adv = Rf(0, p.MaxLife); for (float k = 0; k < adv; k += 0.1f) MoveSmoke(p, 0.1f); smoke.Add(p); }
        }

        Particle NewEmber()
        {
            Particle p = new Particle();
            p.X = Rf(0.02f, 0.98f) * W; p.Y = H + Rf(0, 20) * s;
            p.VX = Rf(-6f, 10f) * s; p.VY = -Rf(22f, 55f) * s;
            p.Size = Rf(1.2f, 2.6f) * Math.Max(0.8f, s);
            p.Phase = Rf(0, 6.283f); p.MaxLife = Rf(5f, 10f); p.Life = 0;
            return p;
        }

        // image -> écran (coordonnées image 1920x1080 normalisées)
        PointF ImgToScreen(float nx, float ny)
        {
            if (src == null) return new PointF(nx * W, ny * H);
            float cx = nx * src.Width * cacheScale - cacheOX;
            float cy = ny * src.Height * cacheScale - cacheOY;
            return new PointF((cx - viewX) * W / viewW, (cy - viewY) * H / viewH);
        }

        Particle NewSmoke()
        {
            Particle p = new Particle();
            // fumée qui s'échappe des canons du fusil (en coordonnées image)
            bool left = rnd.NextDouble() < 0.72;
            p.X = left ? Rf(0.285f, 0.335f) : Rf(0.50f, 0.56f);
            p.Y = left ? Rf(0.765f, 0.80f) : Rf(0.745f, 0.775f);
            p.VX = Rf(0.0015f, 0.006f); p.VY = -Rf(0.012f, 0.022f);
            p.Size = Rf(0.018f, 0.03f); p.Grow = Rf(0.010f, 0.018f);
            p.Phase = Rf(0, 6.283f); p.MaxLife = Rf(5f, 8.5f); p.Life = 0;
            p.Alpha = Rf(0.18f, 0.32f);
            return p;
        }

        void MoveSmoke(Particle p, float dt)
        {
            p.Life += dt;
            p.X += (p.VX + (float)Math.Sin(p.Life * 0.9f + p.Phase) * 0.0035f) * dt;
            p.Y += p.VY * dt;
            p.VY *= (float)Math.Pow(0.93, dt);
            p.Size += p.Grow * dt;
        }

        // ---------------- Animation ----------------
        void UpdateView()
        {
            if (cache == null) return;
            float cw = cache.Width - 2, ch = cache.Height - 2;
            double z = 0.5 + 0.5 * Math.Sin(t * 2 * Math.PI / 38.0 - Math.PI / 2);
            float f = (float)(MINF + (0.99 - MINF) * (1 - z));
            float baseW = W / MINF, baseH = H / MINF;
            viewW = baseW * f; viewH = baseH * f;
            float mx = (cw - viewW) / 2f, my = (ch - viewH) / 2f;
            viewX = 1 + mx + mx * 0.8f * (float)Math.Sin(t * 2 * Math.PI / 53.0);
            viewY = 1 + my + my * 0.8f * (float)Math.Sin(t * 2 * Math.PI / 41.0 + 1.0);
        }

        void Step()
        {
            double now = sw.Elapsed.TotalSeconds;
            float dt = (float)(now - last); last = now;
            if (dt > 0.1f) dt = 0.1f;
            if (dt <= 0f) return;
            t += dt;
            if (W == 0) return;
            UpdateView();

            foreach (Particle p in dust)
            {
                p.X += (p.VX + (float)Math.Sin(t * 0.7 + p.Phase) * 6f * p.Depth * s) * dt;
                p.Y += (p.VY + (float)Math.Cos(t * 0.5 + p.Phase * 1.3) * 5f * p.Depth * s) * dt;
                if (p.X > W + 10) p.X = -10; if (p.X < -10) p.X = W + 10;
                if (p.Y > H + 10) p.Y = -10; if (p.Y < -10) p.Y = H + 10;
            }
            foreach (Particle p in bokeh)
            {
                p.X += (p.VX + (float)Math.Sin(t * 0.3 + p.Phase) * 4f * s) * dt;
                p.Y += (p.VY + (float)Math.Cos(t * 0.25 + p.Phase) * 3f * s) * dt;
                if (p.X > W + p.Size) p.X = -p.Size; if (p.X < -p.Size) p.X = W + p.Size;
                if (p.Y > H + p.Size) p.Y = -p.Size; if (p.Y < -p.Size) p.Y = H + p.Size;
            }
            for (int i = embers.Count - 1; i >= 0; i--)
            {
                Particle p = embers[i];
                p.Life += dt;
                p.X += (p.VX + (float)Math.Sin(p.Life * 2.1 + p.Phase) * 14f * s) * dt;
                p.Y += p.VY * dt;
                if (p.Life >= p.MaxLife || p.Y < -20) embers.RemoveAt(i);
            }
            emberAcc += dt;
            while (emberAcc > 0.55) { emberAcc -= 0.55; if (embers.Count < 14) embers.Add(NewEmber()); }

            for (int i = smoke.Count - 1; i >= 0; i--)
            {
                MoveSmoke(smoke[i], dt);
                if (smoke[i].Life >= smoke[i].MaxLife) smoke.RemoveAt(i);
            }
            smokeAcc += dt;
            while (smokeAcc > 0.42) { smokeAcc -= 0.42; if (smoke.Count < 22) smoke.Add(NewSmoke()); }

            // scintillement aléatoire de l'ampoule
            if (t > nextFlicker)
            {
                flickerStart = t; flickerEnd = t + Rf(0.35f, 0.9f);
                nextFlicker = t + Rf(7f, 16f);
            }
            optScroll += (optScrollTarget - optScroll) * Math.Min(1f, dt * 14f);
            float target = hover != null ? 1f : 0f;
            uiHover += (target - uiHover) * Math.Min(1f, dt * 10f);
            Invalidate();
        }

        // ---------------- Rendu ----------------
        protected override void OnPaintBackground(PaintEventArgs e) { }

        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            if (cache == null) { g.Clear(Color.Black); return; }

            // 1) fond (Ken Burns)
            g.CompositingMode = CompositingMode.SourceCopy;
            g.InterpolationMode = InterpolationMode.Bilinear;
            g.PixelOffsetMode = PixelOffsetMode.Half;
            g.DrawImage(cache, new RectangleF(0, 0, W, H), new RectangleF(viewX, viewY, viewW, viewH), GraphicsUnit.Pixel);
            g.CompositingMode = CompositingMode.SourceOver;
            g.CompositingQuality = CompositingQuality.HighSpeed;

            // 2) fumée des canons
            foreach (Particle p in smoke)
            {
                float k = p.Life / p.MaxLife;
                float a = p.Alpha * (k < 0.15f ? k / 0.15f : (1f - k) / 0.85f);
                if (a <= 0.01f) continue;
                PointF c = ImgToScreen(p.X, p.Y);
                float sz = p.Size * (src != null ? src.Width * cacheScale : W) * W / viewW;
                DrawSprite(g, smokeS, c.X, c.Y, sz, a);
            }

            // 3) brouillard qui défile
            float fy = H * 0.30f, fh = H * 0.70f;
            double offA = (t * 9.0 * s) % W, offB = (t * 15.0 * s) % W;
            g.DrawImage(fogA, new RectangleF((float)-offA, fy, W + 1, fh));
            g.DrawImage(fogA, new RectangleF((float)(W - offA), fy, W + 1, fh));
            g.DrawImage(fogB, new RectangleF((float)(offB - W), fy + H * 0.12f, W + 1, fh * 0.9f));
            g.DrawImage(fogB, new RectangleF((float)offB, fy + H * 0.12f, W + 1, fh * 0.9f));

            // 4) vignette
            g.DrawImageUnscaled(vignette, 0, 0);

            // 5) lumière vacillante
            double n = 0.5 + 0.25 * Math.Sin(t * 1.7) + 0.15 * Math.Sin(t * 4.3 + 1.2) + 0.10 * Math.Sin(t * 11.1);
            int dark = (int)(10 + 26 * n);
            if (t >= flickerStart && t <= flickerEnd)
            {
                double q = Math.Sin(t * 47.0) + Math.Sin(t * 23.0 + 0.5);
                if (q > 0.2) dark += 85;
            }
            using (SolidBrush b = new SolidBrush(Color.FromArgb(Math.Min(220, dark), 4, 2, 0)))
                g.FillRectangle(b, 0, 0, W, H);

            // 6) particules
            g.SmoothingMode = SmoothingMode.AntiAlias;
            foreach (Particle p in bokeh)
            {
                float a = p.Alpha * (0.6f + 0.4f * (float)Math.Sin(t * 0.8 + p.Phase));
                DrawSprite(g, glowW, p.X, p.Y, p.Size, a);
            }
            foreach (Particle p in dust)
            {
                float tw = 0.55f + 0.45f * (float)Math.Sin(t * (1.3 + p.Depth * 2.0) + p.Phase * 3.0);
                float a = p.Alpha * tw * (0.35f + 0.65f * p.Depth);
                if (p.Depth > 0.45f) DrawSprite(g, glowW, p.X, p.Y, p.Size * 3.4f, a * 0.45f);
                int bi = Math.Max(0, Math.Min(23, (int)(a * 23)));
                g.FillEllipse(dustBrush[bi], p.X - p.Size / 2f, p.Y - p.Size / 2f, p.Size, p.Size);
            }
            foreach (Particle p in embers)
            {
                float k = p.Life / p.MaxLife;
                float a = (k < 0.1f ? k / 0.1f : (1f - k) / 0.9f) * (0.65f + 0.35f * (float)Math.Sin(p.Life * 13 + p.Phase));
                if (a <= 0.02f) continue;
                DrawSprite(g, glowO, p.X, p.Y, p.Size * 7f, a * 0.8f);
                int bi = Math.Max(0, Math.Min(23, (int)(a * 23)));
                g.FillEllipse(emberCore[bi], p.X - p.Size / 2f, p.Y - p.Size / 2f, p.Size, p.Size);
            }

            // 7) interface
            DrawUi(g);

            // 8) fondu d'ouverture
            if (t < 1.6)
            {
                int a = (int)(255 * Math.Max(0, 1 - t / 1.6));
                using (SolidBrush b = new SolidBrush(Color.FromArgb(a, 0, 0, 0))) g.FillRectangle(b, 0, 0, W, H);
            }
        }

        void DrawSprite(Graphics g, Bitmap[] spr, float x, float y, float size, float alpha)
        {
            if (alpha <= 0.005f || size < 0.5f) return;
            int li = (int)Math.Round(alpha * spr.Length) - 1;
            if (li < 0) li = 0; if (li >= spr.Length) li = spr.Length - 1;
            g.DrawImage(spr[li], x - size / 2f, y - size / 2f, size, size);
        }

        // ---------------- Interface ----------------
        Font F(string fam, float pt, FontStyle st)
        {
            float px = Math.Max(6f, pt * s);
            string key = fam + "|" + px.ToString("0.0") + "|" + (int)st;
            Font f;
            if (!fonts.TryGetValue(key, out f))
            {
                f = new Font(fam, px, st, GraphicsUnit.Pixel);
                fonts[key] = f;
            }
            return f;
        }

        static GraphicsPath Round(RectangleF r, float rad)
        {
            GraphicsPath p = new GraphicsPath();
            float d = rad * 2;
            if (d > r.Height) d = r.Height;
            p.AddArc(r.X, r.Y, d, d, 180, 90);
            p.AddArc(r.Right - d, r.Y, d, d, 270, 90);
            p.AddArc(r.Right - d, r.Bottom - d, d, d, 0, 90);
            p.AddArc(r.X, r.Bottom - d, d, d, 90, 90);
            p.CloseFigure();
            return p;
        }

        RectangleF R(float x, float y, float w, float h) { return new RectangleF(x * s, y * s, w * s, h * s); }

        // ---------------- Typographie (police style logo) ----------------
        static PrivateFontCollection pfc;
        static FontFamily uiFamily, fallbackFamily;
        public static bool LoadFont(string path)
        {
            try
            {
                if (!File.Exists(path)) return false;
                pfc = new PrivateFontCollection();
                pfc.AddFontFile(path);
                if (pfc.Families.Length > 0 && pfc.Families[0].IsStyleAvailable(FontStyle.Regular)) { uiFamily = pfc.Families[0]; return true; }
            }
            catch { }
            return false;
        }
        static FontFamily Fam()
        {
            if (uiFamily != null) return uiFamily;
            if (fallbackFamily == null)
            {
                try { fallbackFamily = new FontFamily("Impact"); } catch { fallbackFamily = FontFamily.GenericSansSerif; }
            }
            return fallbackFamily;
        }

        GraphicsPath MakePath(string txt, float pt, RectangleF r, StringAlignment al, float minPt, bool allowWrap)
        {
            FontFamily ff = Fam();
            float px = pt * s, minPx = minPt * s;
            StringFormat sf = new StringFormat();
            sf.Alignment = al; sf.LineAlignment = StringAlignment.Center; sf.FormatFlags = StringFormatFlags.NoWrap;
            GraphicsPath p = new GraphicsPath();
            p.AddString(txt, ff, (int)FontStyle.Regular, px, r, sf);
            RectangleF b = p.GetBounds();
            float maxW = r.Width * 0.97f;
            if (b.Width > maxW && b.Width > 0)
            {
                float npx = px * maxW / b.Width;
                p.Dispose(); p = new GraphicsPath();
                if (npx >= minPx || !allowWrap)
                {
                    p.AddString(txt, ff, (int)FontStyle.Regular, npx, r, sf);
                }
                else
                {
                    sf.FormatFlags = 0; sf.Trimming = StringTrimming.None;
                    RectangleF big = new RectangleF(r.X, r.Y - r.Height * 2, r.Width, r.Height * 5);
                    float wpx = Math.Max(minPx, Math.Min(px, r.Height * 0.45f));
                    for (int i = 0; i < 8; i++)
                    {
                        p.AddString(txt, ff, (int)FontStyle.Regular, wpx, big, sf);
                        RectangleF wb = p.GetBounds();
                        if (wb.Height <= r.Height * 0.98f && wb.Width <= r.Width) break;
                        wpx *= 0.9f; p.Dispose(); p = new GraphicsPath();
                    }
                }
            }
            sf.Dispose();
            return p;
        }

        // texte façon logo "REDNECK" : dégradé orange/rouge, liseré chromé, extrusion 3D acier
        readonly Dictionary<string, Bitmap> textCache = new Dictionary<string, Bitmap>();
        void Cached(Graphics g, string key, RectangleF r, float pad, Action<Graphics, RectangleF> draw)
        {
            Bitmap bmp;
            if (!textCache.TryGetValue(key, out bmp))
            {
                if (textCache.Count > 400) ClearTextCache();
                int bw = (int)Math.Ceiling(r.Width + pad * 2), bh = (int)Math.Ceiling(r.Height + pad * 2);
                bmp = new Bitmap(Math.Max(1, bw), Math.Max(1, bh), PixelFormat.Format32bppPArgb);
                using (Graphics bg = Graphics.FromImage(bmp))
                {
                    bg.SmoothingMode = SmoothingMode.AntiAlias;
                    bg.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    bg.CompositingQuality = CompositingQuality.HighQuality;
                    draw(bg, new RectangleF(pad, pad, r.Width, r.Height));
                }
                textCache[key] = bmp;
            }
            g.DrawImage(bmp, new Rectangle((int)Math.Round(r.X - pad), (int)Math.Round(r.Y - pad), bmp.Width, bmp.Height));
        }
        void ClearTextCache() { foreach (Bitmap b in textCache.Values) b.Dispose(); textCache.Clear(); }

        void LogoText(Graphics g, string txt, float pt, RectangleF r, StringAlignment al, float depth, float minPt, bool wrap, bool hot)
        {
            if (string.IsNullOrEmpty(txt)) return;
            string key = "L|" + txt + "|" + pt + "|" + r.Width + "|" + r.Height + "|" + (int)al + "|" + depth + "|" + minPt + "|" + wrap + "|" + hot;
            Cached(g, key, r, (14f + depth) * s, delegate(Graphics bg, RectangleF lr) { LogoTextRaw(bg, txt, pt, lr, al, depth, minPt, wrap, hot); });
        }

        void LogoTextRaw(Graphics g, string txt, float pt, RectangleF r, StringAlignment al, float depth, float minPt, bool wrap, bool hot)
        {
            using (GraphicsPath p = MakePath(txt, pt, r, al, minPt, wrap))
            {
                RectangleF b = p.GetBounds();
                if (b.Width <= 0 || b.Height <= 0) return;
                float hpx = b.Height;
                float outline = Math.Max(1.5f, hpx * 0.14f);
                int steps = Math.Max(1, (int)Math.Round(depth * s));
                // ombre portée
                using (GraphicsPath sh = (GraphicsPath)p.Clone())
                using (Matrix mx = new Matrix())
                {
                    mx.Translate((steps + 2) * 0.8f, steps + 3f);
                    sh.Transform(mx);
                    using (Pen sp = new Pen(Color.FromArgb(150, 0, 0, 0), outline * 1.3f)) { sp.LineJoin = LineJoin.Round; g.DrawPath(sp, sh); }
                }
                // extrusion acier
                for (int i = steps; i >= 1; i--)
                {
                    float k = (float)i / steps;
                    int cr = (int)(150 - 80 * k), cg = (int)(158 - 82 * k), cb = (int)(178 - 80 * k);
                    using (GraphicsPath ex = (GraphicsPath)p.Clone())
                    using (Matrix mx = new Matrix())
                    {
                        mx.Translate(i * 0.55f, i * 1f);
                        ex.Transform(mx);
                        using (Pen ep = new Pen(Color.FromArgb(255, 18, 14, 16), outline)) { ep.LineJoin = LineJoin.Round; g.DrawPath(ep, ex); }
                        using (SolidBrush eb = new SolidBrush(Color.FromArgb(255, cr, cg, cb))) g.FillPath(eb, ex);
                    }
                }
                // contour sombre + liseré chromé
                using (Pen op = new Pen(Color.FromArgb(255, 22, 14, 10), outline)) { op.LineJoin = LineJoin.Round; g.DrawPath(op, p); }
                using (LinearGradientBrush cbr = new LinearGradientBrush(new RectangleF(b.X, b.Y - 2, b.Width, b.Height + 4),
                    Color.FromArgb(255, 236, 240, 248), Color.FromArgb(255, 92, 100, 122), LinearGradientMode.Vertical))
                using (Pen cp = new Pen(cbr, outline * 0.45f)) { cp.LineJoin = LineJoin.Round; g.DrawPath(cp, p); }
                // remplissage dégradé
                using (LinearGradientBrush fb = new LinearGradientBrush(new RectangleF(b.X, b.Y - 1, b.Width, b.Height + 2),
                    Color.White, Color.Black, LinearGradientMode.Vertical))
                {
                    ColorBlend bl = new ColorBlend();
                    if (hot)
                        bl.Colors = new Color[] { Color.FromArgb(255, 255, 238, 140), Color.FromArgb(255, 255, 180, 60), Color.FromArgb(255, 250, 100, 30), Color.FromArgb(255, 215, 45, 15) };
                    else
                        bl.Colors = new Color[] { Color.FromArgb(255, 255, 214, 96), Color.FromArgb(255, 252, 148, 38), Color.FromArgb(255, 232, 72, 20), Color.FromArgb(255, 178, 28, 10) };
                    bl.Positions = new float[] { 0f, 0.42f, 0.72f, 1f };
                    fb.InterpolationColors = bl;
                    g.FillPath(fb, p);
                }
                // reflet brillant sur le haut des lettres
                Region old = g.Clip;
                g.SetClip(p, CombineMode.Intersect);
                using (LinearGradientBrush gl = new LinearGradientBrush(new RectangleF(b.X, b.Y - 1, b.Width, b.Height * 0.45f + 2),
                    Color.FromArgb(hot ? 120 : 80, 255, 255, 255), Color.FromArgb(0, 255, 255, 255), LinearGradientMode.Vertical))
                    g.FillRectangle(gl, b.X, b.Y, b.Width, b.Height * 0.45f);
                g.Clip = old;
                old.Dispose();
            }
        }

        // petit texte (même police) : remplissage uni + contour sombre
        void SmallText(Graphics g, string txt, float pt, RectangleF r, Color c, StringAlignment al)
        {
            if (string.IsNullOrEmpty(txt)) return;
            string key = "S|" + txt + "|" + pt + "|" + r.Width + "|" + r.Height + "|" + (int)al + "|" + c.ToArgb();
            Cached(g, key, r, 6f * s, delegate(Graphics bg, RectangleF lr) { SmallTextRaw(bg, txt, pt, lr, c, al); });
        }

        void SmallTextRaw(Graphics g, string txt, float pt, RectangleF r, Color c, StringAlignment al)
        {
            using (GraphicsPath p = MakePath(txt, pt, r, al, 6f, false))
            {
                float ow = Math.Max(1.3f, pt * s * 0.13f);
                using (GraphicsPath sh = (GraphicsPath)p.Clone())
                using (Matrix mx = new Matrix())
                {
                    mx.Translate(1.2f * s, 1.6f * s); sh.Transform(mx);
                    using (SolidBrush sb = new SolidBrush(Color.FromArgb(170, 0, 0, 0))) g.FillPath(sb, sh);
                }
                using (Pen op = new Pen(Color.FromArgb(220, 16, 10, 6), ow)) { op.LineJoin = LineJoin.Round; g.DrawPath(op, p); }
                using (SolidBrush b = new SolidBrush(c)) g.FillPath(b, p);
            }
        }

        void Button(Graphics g, string id, RectangleF r, string text, bool primary, float pt)
        {
            Hit(id, r);
            bool hov = hover == id, prs = hov && pressed == id;
            if (prs) r.Offset(0, 2f * s);
            float rad = 8f * s;
            double pulse = 0.5 + 0.5 * Math.Sin(t * 2.4);
            int glowA = primary ? (int)(45 + 55 * pulse) : 0;
            if (hov) glowA = primary ? 150 : 110;
            if (glowA > 0)
            {
                for (int i = 4; i >= 1; i--)
                {
                    RectangleF gr = RectangleF.Inflate(r, i * 2.5f * s, i * 2.5f * s);
                    using (GraphicsPath gp = Round(gr, rad + i * 2.5f * s))
                    using (SolidBrush gb = new SolidBrush(Color.FromArgb(glowA / (i + 2), 255, 120, 25)))
                        g.FillPath(gb, gp);
                }
            }
            using (GraphicsPath p = Round(r, rad))
            {
                Color c1 = hov ? Color.FromArgb(240, 70, 46, 30) : Color.FromArgb(225, 44, 34, 28);
                Color c2 = hov ? Color.FromArgb(240, 26, 16, 10) : Color.FromArgb(230, 12, 9, 8);
                using (LinearGradientBrush lb = new LinearGradientBrush(new RectangleF(r.X, r.Y - 1, r.Width, r.Height + 2), c1, c2, LinearGradientMode.Vertical))
                    g.FillPath(lb, p);
                RectangleF hr = new RectangleF(r.X + 3 * s, r.Y + 3 * s, r.Width - 6 * s, r.Height * 0.42f);
                using (GraphicsPath hp = Round(hr, rad * 0.7f))
                using (LinearGradientBrush hb = new LinearGradientBrush(new RectangleF(hr.X, hr.Y - 1, hr.Width, hr.Height + 2),
                    Color.FromArgb(28, 255, 255, 255), Color.FromArgb(0, 255, 255, 255), LinearGradientMode.Vertical))
                    g.FillPath(hb, hp);
                // cadre chromé (comme le liseré du logo)
                using (LinearGradientBrush cb = new LinearGradientBrush(new RectangleF(r.X, r.Y - 1, r.Width, r.Height + 2),
                    Color.FromArgb(255, 232, 236, 246), Color.FromArgb(255, 84, 92, 112), LinearGradientMode.Vertical))
                using (Pen pen = new Pen(cb, Math.Max(1.5f, (primary ? 3f : 2.2f) * s)))
                    g.DrawPath(pen, p);
                if (hov || primary)
                    using (GraphicsPath ip = Round(RectangleF.Inflate(r, -3.5f * s, -3.5f * s), rad * 0.7f))
                    using (Pen ipen = new Pen(Color.FromArgb(hov ? 230 : (int)(110 + 80 * pulse), 255, 140, 40), Math.Max(1f, 1.4f * s)))
                        g.DrawPath(ipen, ip);
            }
            RectangleF tr = RectangleF.Inflate(r, -14 * s, -6 * s);
            LogoText(g, text, pt, tr, StringAlignment.Center, primary ? 6f : 4f, 8f, false, hov);
        }

        void Arrow(Graphics g, string id, RectangleF r, bool left)
        {
            Hit(id, r);
            bool hov = hover == id;
            float cx = r.X + r.Width / 2f, cy = r.Y + r.Height / 2f, a = 10f * s;
            if (hov && pressed == id) cy += 1.5f * s;
            PointF[] tri = left
                ? new PointF[] { new PointF(cx + a * 0.6f, cy - a), new PointF(cx - a * 0.7f, cy), new PointF(cx + a * 0.6f, cy + a) }
                : new PointF[] { new PointF(cx - a * 0.6f, cy - a), new PointF(cx + a * 0.7f, cy), new PointF(cx - a * 0.6f, cy + a) };
            if (hov)
                using (SolidBrush gb = new SolidBrush(Color.FromArgb(60, 255, 140, 40)))
                    g.FillEllipse(gb, cx - 17 * s, cy - 17 * s, 34 * s, 34 * s);
            using (GraphicsPath tp = new GraphicsPath())
            {
                tp.AddPolygon(tri);
                using (Pen op = new Pen(Color.FromArgb(255, 22, 14, 10), 3f * s)) { op.LineJoin = LineJoin.Round; g.DrawPath(op, tp); }
                using (Pen cp = new Pen(Color.FromArgb(255, 200, 206, 220), 1.3f * s)) { cp.LineJoin = LineJoin.Round; g.DrawPath(cp, tp); }
                using (LinearGradientBrush b = new LinearGradientBrush(new RectangleF(cx - a, cy - a - 1, 2 * a, 2 * a + 2),
                    hov ? Color.FromArgb(255, 255, 230, 130) : Color.FromArgb(255, 255, 200, 80), Color.FromArgb(255, 220, 60, 18), LinearGradientMode.Vertical))
                    g.FillPath(b, tp);
            }
        }

        void Pill(Graphics g, string id, RectangleF r)
        {
            Hit(id, r);
            bool hov = hover == id;
            if (hov && pressed == id) r.Offset(0, 1.5f * s);
            using (GraphicsPath p = Round(r, r.Height / 2f))
            {
                using (SolidBrush b = new SolidBrush(hov ? Color.FromArgb(230, 70, 46, 30) : Color.FromArgb(200, 16, 12, 9)))
                    g.FillPath(b, p);
                using (LinearGradientBrush cb = new LinearGradientBrush(new RectangleF(r.X, r.Y - 1, r.Width, r.Height + 2),
                    Color.FromArgb(255, 232, 236, 246), Color.FromArgb(255, 84, 92, 112), LinearGradientMode.Vertical))
                using (Pen pen = new Pen(cb, Math.Max(1f, 1.8f * s)))
                    g.DrawPath(pen, p);
            }
        }

        void DrawTopBar(Graphics g)
        {
            bool hasLang = !string.IsNullOrEmpty(LangText);
            // ----- bouton musique (+ langue optionnelle) -----
            RectangleF mr = hasLang ? R(1006, 16, 162, 38) : R(1072, 16, 162, 38);
            Pill(g, "music", mr);
            bool on = Music != null ? Music.Enabled : false;
            float lvl = Music != null ? Music.Level : 0f;
            float ix = mr.X + 17 * s, iy = mr.Y + mr.Height / 2f;
            Color ic = on ? Color.FromArgb(255, 250, 160, 50) : Color.FromArgb(255, 150, 140, 128);
            using (SolidBrush ib = new SolidBrush(ic))
            {
                g.FillRectangle(ib, ix - 2 * s, iy - 4 * s, 5 * s, 8 * s);
                g.FillPolygon(ib, new PointF[] { new PointF(ix + 2 * s, iy - 4 * s), new PointF(ix + 9 * s, iy - 10 * s), new PointF(ix + 9 * s, iy + 10 * s), new PointF(ix + 2 * s, iy + 4 * s) });
            }
            if (on)
            {
                using (SolidBrush eb = new SolidBrush(Color.FromArgb(255, 255, 200, 100)))
                    for (int i = 0; i < 3; i++)
                    {
                        float hgt = (3f + 9f * lvl * (0.5f + 0.5f * (float)Math.Abs(Math.Sin(t * (5.3 + i * 1.7) + i * 1.9)))) * s;
                        g.FillRectangle(eb, ix + (14 + i * 5) * s, iy + 7 * s - hgt, 3 * s, hgt);
                    }
            }
            else
            {
                using (Pen xp = new Pen(Color.FromArgb(255, 220, 60, 40), 2.2f * s))
                {
                    g.DrawLine(xp, ix + 14 * s, iy - 5 * s, ix + 24 * s, iy + 5 * s);
                    g.DrawLine(xp, ix + 24 * s, iy - 5 * s, ix + 14 * s, iy + 5 * s);
                }
            }
            SmallText(g, MusicText + " " + (on ? OnText : OffText), 15f,
                new RectangleF(mr.X + 46 * s, mr.Y, mr.Width - 56 * s, mr.Height),
                on ? Color.FromArgb(255, 255, 186, 70) : Color.FromArgb(255, 160, 150, 138), StringAlignment.Center);
            if (hasLang)
            {
                RectangleF lr = R(1176, 16, 58, 38);
                Pill(g, "lang", lr);
                SmallText(g, LangText, 16f, lr, Color.FromArgb(255, 255, 186, 70), StringAlignment.Center);
            }

        }

        void DrawUi(Graphics g)
        {
            hits.Clear();
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.InterpolationMode = InterpolationMode.Bilinear;
            g.PixelOffsetMode = PixelOffsetMode.HighQuality;

            DrawTopBar(g);
            if (optOpen) { DrawOptions(g); return; }

            // ----- panneau principal -----
            RectangleF pr = R(770, 268, 450, 368);
            using (GraphicsPath pp = Round(pr, 14 * s))
            {
                using (LinearGradientBrush pb = new LinearGradientBrush(new RectangleF(pr.X, pr.Y - 1, pr.Width, pr.Height + 2),
                    Color.FromArgb(185, 20, 14, 11), Color.FromArgb(215, 8, 6, 5), LinearGradientMode.Vertical))
                    g.FillPath(pb, pp);
                using (LinearGradientBrush cb = new LinearGradientBrush(new RectangleF(pr.X, pr.Y - 1, pr.Width, pr.Height + 2),
                    Color.FromArgb(200, 210, 216, 230), Color.FromArgb(120, 70, 78, 98), LinearGradientMode.Vertical))
                using (Pen pen = new Pen(cb, Math.Max(1f, 1.6f * s))) g.DrawPath(pen, pp);
            }

            SmallText(g, Subtitle, 14f, R(786, 277, 418, 28), Color.FromArgb(255, 214, 200, 180), StringAlignment.Center);
            LogoText(g, ChooseLabel, 20f, R(797, 305, 396, 30), StringAlignment.Near, 2f, 8f, false, false);

            // sélecteur de jeu
            RectangleF sr = R(795, 338, 400, 56);
            Hit("sel", sr);
            bool shov = hover == "sel";
            using (GraphicsPath sp = Round(sr, 8 * s))
            {
                using (SolidBrush sb = new SolidBrush(shov ? Color.FromArgb(230, 52, 38, 28) : Color.FromArgb(220, 30, 23, 18))) g.FillPath(sb, sp);
                using (Pen pen = new Pen(Color.FromArgb(shov ? 255 : 170, 214, 120, 30), Math.Max(1f, 1.5f * s))) g.DrawPath(pen, sp);
            }
            string gname = (Games != null && Games.Length > 0) ? Games[Math.Max(0, Math.Min(Games.Length - 1, GameIndex))] : "";
            LogoText(g, gname, 23f, R(843, 340, 304, 52), StringAlignment.Center, 2.5f, 17f, true, shov);
            Arrow(g, "prev", R(797, 342, 44, 48), true);
            Arrow(g, "next", R(1149, 342, 44, 48), false);
            int ng = Games != null ? Games.Length : 0;
            float dx0 = 995 - (ng - 1) * 9f;
            for (int i = 0; i < ng; i++)
            {
                RectangleF dr = R(dx0 + i * 18 - 4, 401, 8, 8);
                if (i == GameIndex) using (SolidBrush db = new SolidBrush(Color.FromArgb(255, 245, 150, 50))) g.FillEllipse(db, dr);
                else using (Pen dp = new Pen(Color.FromArgb(200, 214, 120, 30), Math.Max(1f, 1.3f * s))) g.DrawEllipse(dp, dr);
            }

            Button(g, "play", R(795, 420, 400, 80), PlayText, true, 46f);
            Button(g, "options", R(795, 512, 194, 54), OptionsText, false, 24f);
            Button(g, "quit", R(1001, 512, 194, 54), QuitText, false, 24f);

            SmallText(g, Status, 14f, R(786, 576, 418, 24), Color.FromArgb(255, 200, 186, 166), StringAlignment.Center);
            SmallText(g, Hint, 13f, R(786, 603, 418, 24), Color.FromArgb(255, 150, 138, 122), StringAlignment.Center);
        }

        // =================================================================
        //  MENU OPTIONS intégré (même style que le launcher)
        // =================================================================
        public bool OptionsOpen { get { return optOpen; } }
        public string OptionsTitle = "OPTIONS", SaveText = "SAVE", CancelText = "CANCEL", PressKeyText = "PRESS A KEY...  (ESC = CANCEL)";
        readonly List<string> optTabs = new List<string>();
        readonly List<List<OptItem>> optPages = new List<List<OptItem>>();
        bool optOpen;
        int optTab, optSel = -1;
        float optScroll, optScrollTarget;
        OptItem capture, editing, dragging;

        public void ClearOptions() { optTabs.Clear(); optPages.Clear(); optTab = 0; optSel = -1; optScroll = optScrollTarget = 0; capture = editing = dragging = null; }
        public int AddTab(string name) { optTabs.Add(name); optPages.Add(new List<OptItem>()); return optTabs.Count - 1; }
        public OptItem AddOpt(int tab, string kind, string id, string label)
        {
            OptItem it = new OptItem(); it.Kind = kind; it.Id = id; it.Label = label;
            optPages[tab].Add(it); return it;
        }
        public OptItem FindOpt(string id)
        {
            foreach (List<OptItem> pg in optPages) foreach (OptItem it in pg) if (it.Id == id) return it;
            return null;
        }
        public void ShowOptions() { optOpen = true; optTab = 0; optSel = -1; optScroll = optScrollTarget = 0; capture = editing = dragging = null; hover = null; Invalidate(); Focus(); }
        public void HideOptions() { optOpen = false; capture = editing = dragging = null; hover = null; Invalidate(); }

        bool OptEnabled(OptItem it)
        {
            if (string.IsNullOrEmpty(it.DependsOn)) return true;
            OptItem d = FindOpt(it.DependsOn);
            if (d == null) return true;
            return it.DependsInverse ? !d.Check : d.Check;
        }
        bool Interactive(OptItem it) { return it.Kind != "header" && it.Kind != "note"; }
        float RowH(OptItem it) { return it.Kind == "header" ? 46f : (it.Kind == "note" ? 30f : 44f); }

        static readonly RectangleF OptContent = new RectangleF(92, 204, 1096, 404);

        void DrawOptions(Graphics g)
        {
            // panneau
            RectangleF pr = R(60, 70, 1160, 626);
            using (GraphicsPath pp = Round(pr, 16 * s))
            {
                using (LinearGradientBrush pb = new LinearGradientBrush(new RectangleF(pr.X, pr.Y - 1, pr.Width, pr.Height + 2),
                    Color.FromArgb(205, 20, 14, 11), Color.FromArgb(228, 8, 6, 5), LinearGradientMode.Vertical))
                    g.FillPath(pb, pp);
                using (LinearGradientBrush cb = new LinearGradientBrush(new RectangleF(pr.X, pr.Y - 1, pr.Width, pr.Height + 2),
                    Color.FromArgb(220, 220, 226, 238), Color.FromArgb(130, 70, 78, 98), LinearGradientMode.Vertical))
                using (Pen pen = new Pen(cb, Math.Max(1f, 2f * s))) g.DrawPath(pen, pp);
            }
            LogoText(g, OptionsTitle, 40f, R(92, 80, 420, 56), StringAlignment.Near, 5f, 10f, false, false);

            // onglets
            float tx = 92, tw = optTabs.Count > 0 ? Math.Min(240f, (1096f - (optTabs.Count - 1) * 10f) / optTabs.Count) : 200f;
            for (int i = 0; i < optTabs.Count; i++)
            {
                RectangleF r = R(tx + i * (tw + 10), 142, tw, 46);
                string id = "tab:" + i;
                Hit(id, r);
                bool act = i == optTab, hov = hover == id;
                using (GraphicsPath p = Round(r, 8 * s))
                {
                    Color c1 = act ? Color.FromArgb(240, 92, 50, 20) : (hov ? Color.FromArgb(230, 64, 44, 30) : Color.FromArgb(215, 34, 26, 21));
                    Color c2 = act ? Color.FromArgb(240, 40, 18, 6) : Color.FromArgb(225, 14, 10, 8);
                    using (LinearGradientBrush lb = new LinearGradientBrush(new RectangleF(r.X, r.Y - 1, r.Width, r.Height + 2), c1, c2, LinearGradientMode.Vertical))
                        g.FillPath(lb, p);
                    using (LinearGradientBrush cb = new LinearGradientBrush(new RectangleF(r.X, r.Y - 1, r.Width, r.Height + 2),
                        act ? Color.FromArgb(255, 255, 200, 110) : Color.FromArgb(255, 210, 216, 230), act ? Color.FromArgb(255, 200, 90, 20) : Color.FromArgb(255, 84, 92, 112), LinearGradientMode.Vertical))
                    using (Pen pen = new Pen(cb, Math.Max(1f, (act ? 2.4f : 1.6f) * s))) g.DrawPath(pen, p);
                }
                LogoText(g, optTabs[i], 21f, RectangleF.Inflate(r, -10 * s, -4 * s), StringAlignment.Center, 3f, 9f, false, act || hov);
            }

            // contenu défilant
            RectangleF cr = R(OptContent.X, OptContent.Y, OptContent.Width, OptContent.Height);
            List<OptItem> page = optTab < optPages.Count ? optPages[optTab] : new List<OptItem>();
            float total = 0; foreach (OptItem it in page) total += RowH(it);
            float maxScroll = Math.Max(0, total - OptContent.Height);
            if (optScrollTarget > maxScroll) optScrollTarget = maxScroll;
            if (optScrollTarget < 0) optScrollTarget = 0;
            if (optScroll > maxScroll) optScroll = maxScroll;

            GraphicsState st = g.Save();
            g.SetClip(cr);
            float y = OptContent.Y - optScroll;
            for (int i = 0; i < page.Count; i++)
            {
                OptItem it = page[i];
                float h = RowH(it);
                if (y + h >= OptContent.Y - 2 && y <= OptContent.Bottom + 2) DrawRow(g, it, i, R(OptContent.X, y, OptContent.Width - 18, h), cr);
                y += h;
            }
            g.Restore(st);

            // barre de défilement
            if (maxScroll > 0)
            {
                RectangleF tr = R(OptContent.Right - 8, OptContent.Y + 4, 6, OptContent.Height - 8);
                using (SolidBrush tb = new SolidBrush(Color.FromArgb(120, 60, 50, 42))) g.FillRectangle(tb, tr);
                float th = tr.Height * OptContent.Height / total;
                float ty = tr.Y + (tr.Height - th) * (optScroll / maxScroll);
                using (SolidBrush kb = new SolidBrush(Color.FromArgb(230, 240, 140, 40))) g.FillRectangle(kb, tr.X, ty, tr.Width, th);
            }
            // fondus haut/bas
            using (Pen sep = new Pen(Color.FromArgb(120, 214, 120, 30), Math.Max(1f, 1.2f * s)))
            {
                g.DrawLine(sep, cr.X, cr.Y - 3 * s, cr.Right, cr.Y - 3 * s);
                g.DrawLine(sep, cr.X, cr.Bottom + 3 * s, cr.Right, cr.Bottom + 3 * s);
            }

            Button(g, "opt_save", R(410, 626, 220, 56), SaveText, true, 28f);
            Button(g, "opt_cancel", R(650, 626, 220, 56), CancelText, false, 26f);
        }

        void DrawRow(Graphics g, OptItem it, int idx, RectangleF r, RectangleF clip)
        {
            bool en = OptEnabled(it);
            string rid = "row:" + idx;
            Color txt = en ? Color.FromArgb(255, 238, 226, 206) : Color.FromArgb(255, 112, 104, 96);
            if (it.Kind == "header")
            {
                LogoText(g, it.Label, 22f, new RectangleF(r.X + 6 * s, r.Y + 8 * s, r.Width * 0.7f, r.Height - 10 * s), StringAlignment.Near, 2.5f, 9f, false, false);
                return;
            }
            if (it.Kind == "note")
            {
                SmallText(g, it.Label, 13f, new RectangleF(r.X + 14 * s, r.Y, r.Width - 28 * s, r.Height),
                    it.Warn ? Color.FromArgb(255, 245, 150, 60) : Color.FromArgb(255, 160, 148, 132), StringAlignment.Near);
                return;
            }
            bool hov = en && hover != null && (hover == rid || hover.EndsWith(":" + idx));
            bool sel = idx == optSel;
            RectangleF hr = RectangleF.Inflate(r, 0, -3 * s);
            if (hov || sel || it == capture || it == editing)
                using (GraphicsPath hp = Round(hr, 7 * s))
                {
                    using (SolidBrush hb = new SolidBrush(Color.FromArgb(hov ? 70 : 45, 255, 140, 40))) g.FillPath(hb, hp);
                    if (sel) using (Pen sp = new Pen(Color.FromArgb(160, 255, 150, 50), Math.Max(1f, 1.2f * s))) g.DrawPath(sp, hp);
                }
            if (en) AddClippedHit(rid, hr, clip);

            float lw = r.Width * 0.52f;
            SmallText(g, it.Label, 16f, new RectangleF(r.X + 14 * s, r.Y, lw - 14 * s, r.Height), txt, StringAlignment.Near);
            RectangleF cr = new RectangleF(r.X + lw + 10 * s, r.Y + 6 * s, r.Width - lw - 20 * s, r.Height - 12 * s);

            if (it.Kind == "check")
            {
                RectangleF sw = new RectangleF(cr.Right - 70 * s, cr.Y + (cr.Height - 28 * s) / 2f, 66 * s, 28 * s);
                using (GraphicsPath tp = Round(sw, sw.Height / 2f))
                {
                    Color on1 = Color.FromArgb(255, 250, 150, 45), on2 = Color.FromArgb(255, 190, 60, 15);
                    using (LinearGradientBrush tb = new LinearGradientBrush(new RectangleF(sw.X, sw.Y - 1, sw.Width, sw.Height + 2),
                        it.Check ? on1 : Color.FromArgb(255, 50, 42, 36), it.Check ? on2 : Color.FromArgb(255, 24, 19, 16), LinearGradientMode.Vertical))
                        g.FillPath(tb, tp);
                    using (LinearGradientBrush cb = new LinearGradientBrush(new RectangleF(sw.X, sw.Y - 1, sw.Width, sw.Height + 2),
                        Color.FromArgb(255, 232, 236, 246), Color.FromArgb(255, 84, 92, 112), LinearGradientMode.Vertical))
                    using (Pen pen = new Pen(cb, Math.Max(1f, 1.6f * s))) g.DrawPath(pen, tp);
                }
                float kx = it.Check ? sw.Right - sw.Height + 2 * s : sw.X + 2 * s;
                using (LinearGradientBrush kb = new LinearGradientBrush(new RectangleF(kx, sw.Y, sw.Height, sw.Height),
                    Color.FromArgb(255, 245, 246, 250), Color.FromArgb(255, 130, 136, 152), LinearGradientMode.Vertical))
                    g.FillEllipse(kb, kx, sw.Y + 2 * s, sw.Height - 4 * s, sw.Height - 4 * s);
                SmallText(g, it.Check ? "ON" : "OFF", 16f, new RectangleF(sw.X - 70 * s, cr.Y, 62 * s, cr.Height),
                    !en ? txt : (it.Check ? Color.FromArgb(255, 255, 186, 70) : Color.FromArgb(255, 150, 140, 128)), StringAlignment.Far);
                if (!en) DimRect(g, sw);
            }
            else if (it.Kind == "choice")
            {
                RectangleF bx = cr;
                using (GraphicsPath bp = Round(bx, 7 * s))
                {
                    using (SolidBrush bb = new SolidBrush(Color.FromArgb(220, 30, 23, 18))) g.FillPath(bb, bp);
                    using (Pen pen = new Pen(Color.FromArgb(en ? 200 : 90, 214, 120, 30), Math.Max(1f, 1.4f * s))) g.DrawPath(pen, bp);
                }
                string v = (it.Choices != null && it.Choices.Length > 0) ? it.Choices[Math.Max(0, Math.Min(it.Choices.Length - 1, it.Index))] : "";
                SmallText(g, v, 16f, RectangleF.Inflate(bx, -40 * s, 0), en ? Color.FromArgb(255, 255, 190, 80) : txt, StringAlignment.Center);
                if (en)
                {
                    Arrow(g, "cl:" + idx, new RectangleF(bx.X, bx.Y, 36 * s, bx.Height), true);
                    Arrow(g, "cr:" + idx, new RectangleF(bx.Right - 36 * s, bx.Y, 36 * s, bx.Height), false);
                    ClipLastHits(2, clip);
                }
            }
            else if (it.Kind == "slider")
            {
                RectangleF tr = new RectangleF(cr.X + 8 * s, cr.Y + cr.Height / 2f - 4 * s, cr.Width - 86 * s, 8 * s);
                float k = it.Max > it.Min ? (float)(it.Value - it.Min) / (it.Max - it.Min) : 0f;
                using (GraphicsPath tp = Round(tr, 4 * s))
                using (SolidBrush tb = new SolidBrush(Color.FromArgb(255, 40, 32, 27))) g.FillPath(tb, tp);
                if (k > 0)
                {
                    RectangleF fr = new RectangleF(tr.X, tr.Y, Math.Max(tr.Height, tr.Width * k), tr.Height);
                    using (GraphicsPath fp = Round(fr, 4 * s))
                    using (LinearGradientBrush fb = new LinearGradientBrush(new RectangleF(fr.X - 1, fr.Y, fr.Width + 2, fr.Height),
                        Color.FromArgb(255, 200, 70, 15), Color.FromArgb(255, 255, 180, 60), LinearGradientMode.Horizontal))
                        g.FillPath(fb, fp);
                }
                float kx = tr.X + tr.Width * k, kr = 11 * s;
                using (LinearGradientBrush kb = new LinearGradientBrush(new RectangleF(kx - kr, tr.Y + tr.Height / 2f - kr, 2 * kr, 2 * kr),
                    Color.FromArgb(255, 245, 246, 250), Color.FromArgb(255, 120, 126, 144), LinearGradientMode.Vertical))
                    g.FillEllipse(kb, kx - kr, tr.Y + tr.Height / 2f - kr, 2 * kr, 2 * kr);
                using (Pen kp = new Pen(Color.FromArgb(255, 30, 20, 14), Math.Max(1f, 1.5f * s))) g.DrawEllipse(kp, kx - kr, tr.Y + tr.Height / 2f - kr, 2 * kr, 2 * kr);
                SmallText(g, it.Value.ToString() + (it.Suffix ?? ""), 16f, new RectangleF(cr.Right - 72 * s, cr.Y, 72 * s, cr.Height),
                    en ? Color.FromArgb(255, 255, 190, 80) : txt, StringAlignment.Far);
                if (en) AddClippedHit("sl:" + idx, new RectangleF(tr.X - kr, cr.Y, tr.Width + 2 * kr, cr.Height), clip);
                it.TrackX = tr.X; it.TrackW = tr.Width;
                if (!en) DimRect(g, new RectangleF(tr.X - kr, tr.Y - kr, tr.Width + 2 * kr, 2 * kr + tr.Height));
            }
            else if (it.Kind == "text" || it.Kind == "key")
            {
                bool active = it == editing || it == capture;
                RectangleF bx = it.Kind == "key" ? new RectangleF(cr.Right - 230 * s, cr.Y, 230 * s, cr.Height) : cr;
                using (GraphicsPath bp = Round(bx, 7 * s))
                {
                    using (SolidBrush bb = new SolidBrush(active ? Color.FromArgb(235, 60, 36, 18) : Color.FromArgb(220, 26, 20, 16))) g.FillPath(bb, bp);
                    using (Pen pen = new Pen(active ? Color.FromArgb(255, 255, 170, 60) : Color.FromArgb(en ? 190 : 80, 214, 120, 30), Math.Max(1f, (active ? 2f : 1.4f) * s))) g.DrawPath(pen, bp);
                }
                if (it.Kind == "key")
                {
                    string v = it == capture ? (((int)(t * 2.5) % 2 == 0) ? "???" : "") : (string.IsNullOrEmpty(it.Text) ? "-" : it.Text.ToUpperInvariant());
                    SmallText(g, v, 16f, RectangleF.Inflate(bx, -10 * s, 0), Color.FromArgb(255, 255, 190, 80), StringAlignment.Center);
                    if (it == capture) SmallText(g, PressKeyText, 13f, new RectangleF(cr.X, cr.Y, bx.X - cr.X - 10 * s, cr.Height), Color.FromArgb(255, 255, 160, 60), StringAlignment.Far);
                }
                else
                {
                    string v = it.Text ?? "";
                    RectangleF tr = RectangleF.Inflate(bx, -12 * s, 0);
                    // texte brut (police lisible pour la saisie) + curseur clignotant
                    Font f = new Font(FontFamily.GenericMonospace, 15f * s, FontStyle.Bold, GraphicsUnit.Pixel);
                    try
                    {
                        string shown = v;
                        SizeF m = g.MeasureString(shown, f);
                        while (m.Width > tr.Width - 10 * s && shown.Length > 0) { shown = shown.Substring(1); m = g.MeasureString(shown, f); }
                        using (StringFormat sf = new StringFormat()) using (SolidBrush b = new SolidBrush(Color.FromArgb(255, 255, 214, 140)))
                        {
                            sf.LineAlignment = StringAlignment.Center; sf.FormatFlags = StringFormatFlags.NoWrap;
                            g.DrawString(shown, f, b, tr, sf);
                        }
                        if (it == editing && ((int)(t * 2.2) % 2 == 0))
                            using (Pen cp = new Pen(Color.FromArgb(255, 255, 170, 60), Math.Max(1f, 2f * s)))
                            {
                                float cx = tr.X + Math.Min(tr.Width - 4 * s, (shown.Length > 0 ? m.Width - 3 * s : 2 * s));
                                g.DrawLine(cp, cx, tr.Y + 8 * s, cx, tr.Bottom - 8 * s);
                            }
                    }
                    finally { f.Dispose(); }
                }
            }
            else if (it.Kind == "button")
            {
                Button(g, "ob:" + idx, new RectangleF(cr.Right - 300 * s, cr.Y - 1 * s, 300 * s, cr.Height + 2 * s), it.Text ?? it.Label, false, 17f);
                ClipLastHits(1, clip);
            }
        }

        void DimRect(Graphics g, RectangleF r)
        {
            using (SolidBrush b = new SolidBrush(Color.FromArgb(150, 12, 9, 7))) g.FillRectangle(b, RectangleF.Inflate(r, 2 * s, 2 * s));
        }

        void AddClippedHit(string id, RectangleF r, RectangleF clip)
        {
            RectangleF x = RectangleF.Intersect(r, clip);
            if (x.Width > 0 && x.Height > 0) Hit(id, x);
        }
        void ClipLastHits(int n, RectangleF clip)
        {
            for (int i = 0; i < n && hits.Count > 0; i++)
            {
                int k = hits.Count - 1 - i;
                RectangleF x = RectangleF.Intersect(hits[k].Value, clip);
                if (x.Width > 0 && x.Height > 0) hits[k] = new KeyValuePair<string, RectangleF>(hits[k].Key, x);
                else hits[k] = new KeyValuePair<string, RectangleF>(hits[k].Key, RectangleF.Empty);
            }
        }

        List<OptItem> Page() { return optTab < optPages.Count ? optPages[optTab] : new List<OptItem>(); }

        void ChangeOpt(OptItem it, int dir)
        {
            if (it == null || !OptEnabled(it)) return;
            switch (it.Kind)
            {
                case "check": it.Check = !it.Check; break;
                case "choice":
                    if (it.Choices == null || it.Choices.Length == 0) return;
                    it.Index = ((it.Index + (dir >= 0 ? 1 : -1)) % it.Choices.Length + it.Choices.Length) % it.Choices.Length; break;
                case "slider":
                    int step = Math.Max(1, (it.Max - it.Min) / 20);
                    it.Value = Math.Max(it.Min, Math.Min(it.Max, it.Value + (dir >= 0 ? step : -step))); break;
                default: return;
            }
            Fire("optchg:" + it.Id);
        }

        void ActivateOpt(OptItem it)
        {
            if (it == null || !OptEnabled(it)) return;
            switch (it.Kind)
            {
                case "check": case "choice": ChangeOpt(it, 1); break;
                case "key": capture = it; editing = null; break;
                case "text": editing = it; capture = null; break;
                case "button": Fire("optbtn:" + it.Id); break;
            }
            Invalidate();
        }

        void SetSliderFromX(OptItem it, float x)
        {
            if (it.TrackW <= 0) return;
            float k = Math.Max(0f, Math.Min(1f, (x - it.TrackX) / it.TrackW));
            int v = it.Min + (int)Math.Round(k * (it.Max - it.Min));
            if (v != it.Value) { it.Value = v; Fire("optchg:" + it.Id); }
        }

        void EnsureVisible(int idx)
        {
            List<OptItem> page = Page();
            float y = 0; for (int i = 0; i < idx && i < page.Count; i++) y += RowH(page[i]);
            float h = idx < page.Count ? RowH(page[idx]) : 40f;
            if (y < optScrollTarget) optScrollTarget = y;
            if (y + h > optScrollTarget + OptContent.Height) optScrollTarget = y + h - OptContent.Height;
        }

        void MoveSel(int dir)
        {
            List<OptItem> page = Page();
            if (page.Count == 0) return;
            int i = optSel;
            for (int n = 0; n < page.Count; n++)
            {
                i = i < 0 ? (dir > 0 ? 0 : page.Count - 1) : (i + dir + page.Count) % page.Count;
                if (Interactive(page[i]) && OptEnabled(page[i])) { optSel = i; EnsureVisible(i); return; }
            }
        }

        // nom de touche au format Raze
        public static string KeyName(Keys k)
        {
            string n = k.ToString();
            if (n.Length == 1 && n[0] >= 'A' && n[0] <= 'Z') return n.ToLowerInvariant();
            if (n.Length == 2 && n[0] == 'D' && char.IsDigit(n[1])) return n.Substring(1);
            if (n.Length >= 2 && n.Length <= 3 && n[0] == 'F' && char.IsDigit(n[1])) return n.ToLowerInvariant();
            if (n.StartsWith("NumPad") && n.Length == 7) return "kp" + n.Substring(6);
            switch (k)
            {
                case Keys.Left: return "leftarrow"; case Keys.Right: return "rightarrow"; case Keys.Up: return "uparrow"; case Keys.Down: return "downarrow";
                case Keys.Space: return "space"; case Keys.Enter: return "enter"; case Keys.Tab: return "tab"; case Keys.Back: return "backspace";
                case Keys.ControlKey: case Keys.LControlKey: case Keys.RControlKey: return "ctrl";
                case Keys.ShiftKey: case Keys.LShiftKey: case Keys.RShiftKey: return "shift";
                case Keys.Menu: case Keys.LMenu: case Keys.RMenu: return "alt";
                case Keys.PageUp: return "pgup"; case Keys.PageDown: return "pgdn"; case Keys.Home: return "home"; case Keys.End: return "end";
                case Keys.Insert: return "ins"; case Keys.Delete: return "del";
                case Keys.OemSemicolon: return ";"; case Keys.Oemplus: return "="; case Keys.Oemcomma: return ","; case Keys.OemMinus: return "-";
                case Keys.OemPeriod: return "."; case Keys.OemQuestion: return "/"; case Keys.Oemtilde: return "`";
                case Keys.OemOpenBrackets: return "["; case Keys.OemPipe: return "\\"; case Keys.OemCloseBrackets: return "]"; case Keys.OemQuotes: return "'";
            }
            return null;
        }

        // ---------------- Souris / clavier ----------------
        void Hit(string id, RectangleF r) { hits.Add(new KeyValuePair<string, RectangleF>(id, r)); }

        string HitAt(Point pt)
        {
            for (int i = hits.Count - 1; i >= 0; i--)
                if (hits[i].Value.Contains(pt)) return hits[i].Key;
            return null;
        }

        static int IdxOf(string id) { int c = id.LastIndexOf(':'); int v; return (c >= 0 && int.TryParse(id.Substring(c + 1), out v)) ? v : -1; }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            base.OnMouseMove(e);
            if (dragging != null) { SetSliderFromX(dragging, e.X); Invalidate(); return; }
            string h = HitAt(e.Location);
            if (h != hover) { hover = h; Cursor = h != null ? Cursors.Hand : Cursors.Default; if (paused) Invalidate(); }
        }

        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);
            hover = null; pressed = null; Cursor = Cursors.Default;
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            base.OnMouseDown(e);
            Focus();
            if (e.Button != MouseButtons.Left) return;
            pressed = HitAt(e.Location);
            if (optOpen && pressed != null && pressed.StartsWith("sl:"))
            {
                List<OptItem> page = Page(); int i = IdxOf(pressed);
                if (i >= 0 && i < page.Count) { dragging = page[i]; optSel = i; SetSliderFromX(dragging, e.X); }
            }
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            base.OnMouseUp(e);
            if (e.Button != MouseButtons.Left) return;
            if (dragging != null) { dragging = null; pressed = null; Invalidate(); return; }
            string h = HitAt(e.Location);
            string p = pressed; pressed = null;
            if (p == null || p != h) return;
            if (!optOpen)
            {
                if (p == "sel") Fire("next"); else Fire(p);
                return;
            }
            // ----- mode options -----
            List<OptItem> page = Page();
            int idx = IdxOf(p);
            OptItem it = (idx >= 0 && idx < page.Count) ? page[idx] : null;
            if (p.StartsWith("tab:")) { if (idx != optTab) { optTab = idx; optSel = -1; optScroll = optScrollTarget = 0; capture = editing = null; } }
            else if (p.StartsWith("cl:")) { optSel = idx; ChangeOpt(it, -1); }
            else if (p.StartsWith("cr:")) { optSel = idx; ChangeOpt(it, 1); }
            else if (p.StartsWith("ob:")) { optSel = idx; ActivateOpt(it); }
            else if (p.StartsWith("row:")) { optSel = idx; if (it != editing) editing = null; ActivateOpt(it); }
            else if (p == "opt_save" || p == "opt_cancel" || p == "music") { capture = editing = null; Fire(p); }
            Invalidate();
        }

        protected override void OnMouseWheel(MouseEventArgs e)
        {
            base.OnMouseWheel(e);
            if (!optOpen) { Fire(e.Delta > 0 ? "prev" : "next"); return; }
            optScrollTarget -= Math.Sign(e.Delta) * 44f * 2;
            Invalidate();
        }

        protected override bool IsInputKey(Keys keyData)
        {
            Keys k = keyData & Keys.KeyCode;
            if (k == Keys.Left || k == Keys.Right || k == Keys.Up || k == Keys.Down || k == Keys.Enter || k == Keys.Escape || k == Keys.Tab) return true;
            if (optOpen && capture != null) return true;
            return base.IsInputKey(keyData);
        }

        protected override bool ProcessDialogKey(Keys keyData)
        {
            if (optOpen && (capture != null || editing != null)) return false;
            return base.ProcessDialogKey(keyData);
        }

        protected override void OnKeyPress(KeyPressEventArgs e)
        {
            base.OnKeyPress(e);
            if (optOpen && editing != null)
            {
                if (e.KeyChar == '\b') { if (!string.IsNullOrEmpty(editing.Text)) editing.Text = editing.Text.Substring(0, editing.Text.Length - 1); }
                else if (!char.IsControl(e.KeyChar)) editing.Text = (editing.Text ?? "") + e.KeyChar;
                e.Handled = true; Invalidate();
            }
        }

        protected override void OnKeyDown(KeyEventArgs e)
        {
            base.OnKeyDown(e);
            if (optOpen)
            {
                if (capture != null)
                {
                    if (e.KeyCode != Keys.Escape)
                    {
                        string kn = KeyName(e.KeyCode);
                        if (kn != null) { capture.Text = kn; Fire("optchg:" + capture.Id); }
                    }
                    capture = null;
                }
                else if (editing != null)
                {
                    if (e.KeyCode == Keys.Enter || e.KeyCode == Keys.Escape || e.KeyCode == Keys.Tab) editing = null;
                    else return; // les caractères arrivent par OnKeyPress
                }
                else
                {
                    List<OptItem> page = Page();
                    OptItem it = (optSel >= 0 && optSel < page.Count) ? page[optSel] : null;
                    switch (e.KeyCode)
                    {
                        case Keys.Escape: Fire("opt_cancel"); break;
                        case Keys.Up: MoveSel(-1); break;
                        case Keys.Down: MoveSel(1); break;
                        case Keys.Left: ChangeOpt(it, -1); break;
                        case Keys.Right: ChangeOpt(it, 1); break;
                        case Keys.Enter: case Keys.Space: if (it != null) ActivateOpt(it); break;
                        case Keys.Tab:
                            if (optTabs.Count > 0) { optTab = (optTab + (e.Shift ? optTabs.Count - 1 : 1)) % optTabs.Count; optSel = -1; optScroll = optScrollTarget = 0; }
                            break;
                        case Keys.PageDown: optScrollTarget += OptContent.Height * 0.8f; break;
                        case Keys.PageUp: optScrollTarget -= OptContent.Height * 0.8f; break;
                        default: return;
                    }
                }
                e.Handled = true; e.SuppressKeyPress = true; Invalidate();
                return;
            }
            switch (e.KeyCode)
            {
                case Keys.Enter: case Keys.Space: Fire("play"); break;
                case Keys.Escape: Fire("quit"); break;
                case Keys.Left: case Keys.Up: Fire("prev"); break;
                case Keys.Right: case Keys.Down: Fire("next"); break;
                case Keys.M: Fire("music"); break;
                case Keys.O: Fire("options"); break;
                default: return;
            }
            e.Handled = true; e.SuppressKeyPress = true;
        }

        void Fire(string id)
        {
            int ng = Games != null ? Games.Length : 0;
            if (id == "prev" || id == "next")
            {
                if (ng == 0) return;
                GameIndex = (GameIndex + (id == "next" ? 1 : ng - 1)) % ng;
                id = "game";
            }
            Invalidate();
            EventHandler<UiEventArgs> h = UiAction;
            if (h != null) h(this, new UiEventArgs(id));
        }
    }

    public class OptItem
    {
        public string Id, Label, Kind, Text, Suffix, DependsOn;
        public bool Check, DependsInverse, Warn;
        public string[] Choices;
        public int Index, Min, Max = 100, Value;
        internal float TrackX, TrackW;
    }

    // ------------------------------------------------------------------
    //  Extraction silencieuse (en arrière-plan) des pistes audio du CD GOG
    //  (.inst = fiche CUE, .gog = BIN) en fichiers lisibles par Raze
    // ------------------------------------------------------------------
    public class CdRipper
    {
        public string Inst;
        public string[] Dirs;
        public volatile bool Done;
        public string OutDir;
        public string Error = "";

        public CdRipper(string inst, string[] dirs) { Inst = inst; Dirs = dirs; }

        class Track { public int Num; public bool Audio; public long Start = -1, Len; }

        public static void StartQueue(CdRipper[] jobs)
        {
            System.Threading.Thread th = new System.Threading.Thread(delegate ()
            {
                foreach (CdRipper j in jobs) { try { j.Run(); } catch (Exception ex) { j.Error += ex.Message; } finally { j.Done = true; } }
            });
            th.IsBackground = true;
            th.Priority = System.Threading.ThreadPriority.BelowNormal;
            th.Start();
        }

        void Run()
        {
            if (!File.Exists(Inst)) { Error = "CD image description not found: " + Inst; return; }
            string instDir = Path.GetDirectoryName(Inst);
            string bin = null;
            List<Track> tracks = new List<Track>();
            Track cur = null;
            foreach (string raw in File.ReadAllLines(Inst))
            {
                string l = raw.Trim();
                System.Text.RegularExpressions.Match m;
                if ((m = System.Text.RegularExpressions.Regex.Match(l, "^FILE\\s+\"(.+)\"", System.Text.RegularExpressions.RegexOptions.IgnoreCase)).Success)
                    bin = Path.Combine(instDir, m.Groups[1].Value);
                else if ((m = System.Text.RegularExpressions.Regex.Match(l, "^TRACK\\s+(\\d+)\\s+(\\S+)", System.Text.RegularExpressions.RegexOptions.IgnoreCase)).Success)
                {
                    cur = new Track(); cur.Num = int.Parse(m.Groups[1].Value);
                    cur.Audio = string.Equals(m.Groups[2].Value, "AUDIO", StringComparison.OrdinalIgnoreCase);
                    tracks.Add(cur);
                }
                else if (cur != null && (m = System.Text.RegularExpressions.Regex.Match(l, "^INDEX\\s+01\\s+(\\d+):(\\d+):(\\d+)", System.Text.RegularExpressions.RegexOptions.IgnoreCase)).Success)
                    cur.Start = ((long.Parse(m.Groups[1].Value) * 60 + long.Parse(m.Groups[2].Value)) * 75 + long.Parse(m.Groups[3].Value)) * 2352L;
            }
            if (bin == null || !File.Exists(bin)) { Error = "CD image not found: " + bin; return; }
            long binLen = new FileInfo(bin).Length;
            List<Track> audio = new List<Track>();
            for (int i = 0; i < tracks.Count; i++)
            {
                Track tr = tracks[i];
                if (!tr.Audio || tr.Start < 0) continue;
                long end = binLen;
                if (i + 1 < tracks.Count && tracks[i + 1].Start > tr.Start) end = tracks[i + 1].Start;
                tr.Len = (end - tr.Start) - ((end - tr.Start) % 4);
                if (tr.Len > 0) audio.Add(tr);
            }
            if (audio.Count == 0) { Error = "No audio tracks in " + Inst; return; }
            string sig = binLen + "|" + tracks.Count + "|v2";

            // déjà extrait ?
            foreach (string d in Dirs)
            {
                try
                {
                    string mk = Path.Combine(d, "extracted.txt");
                    if (File.Exists(mk) && File.ReadAllText(mk).Trim() == sig)
                    {
                        bool all = true;
                        foreach (Track tr in audio) if (!File.Exists(Path.Combine(d, string.Format("track{0:00}.ogg", tr.Num)))) all = false;
                        if (all) { OutDir = d; return; }
                    }
                }
                catch { }
            }

            // extraction (premier dossier accessible en écriture)
            byte[] buf = new byte[1 << 20];
            foreach (string d in Dirs)
            {
                try
                {
                    Directory.CreateDirectory(d);
                    string mk = Path.Combine(d, "extracted.txt");
                    if (File.Exists(mk)) File.Delete(mk);
                    using (FileStream input = new FileStream(bin, FileMode.Open, FileAccess.Read, FileShare.Read, 1 << 16))
                    {
                        foreach (Track tr in audio)
                        {
                            string final = Path.Combine(d, string.Format("track{0:00}.ogg", tr.Num));
                            string part = final + ".part";
                            using (FileStream o = new FileStream(part, FileMode.Create, FileAccess.Write, FileShare.None, 1 << 16))
                            using (BinaryWriter bw = new BinaryWriter(o))
                            {
                                // en-tête WAV : PCM 16 bits stéréo 44,1 kHz (audio CD)
                                bw.Write(Encoding.ASCII.GetBytes("RIFF")); bw.Write((uint)(36 + tr.Len));
                                bw.Write(Encoding.ASCII.GetBytes("WAVEfmt ")); bw.Write((uint)16);
                                bw.Write((ushort)1); bw.Write((ushort)2); bw.Write((uint)44100); bw.Write((uint)176400);
                                bw.Write((ushort)4); bw.Write((ushort)16);
                                bw.Write(Encoding.ASCII.GetBytes("data")); bw.Write((uint)tr.Len);
                                bw.Flush();
                                input.Seek(tr.Start, SeekOrigin.Begin);
                                long left = tr.Len;
                                while (left > 0)
                                {
                                    int n = input.Read(buf, 0, (int)Math.Min(buf.Length, left));
                                    if (n <= 0) break;
                                    o.Write(buf, 0, n); left -= n;
                                }
                            }
                            if (File.Exists(final)) File.Delete(final);
                            File.Move(part, final);
                        }
                    }
                    File.WriteAllText(mk, sig);
                    OutDir = d;
                    return;
                }
                catch (Exception ex) { Error += d + " : " + ex.Message + "  "; }
            }
        }
    }
}
'@
function Load-Fx {
    if('RRFx.Scene' -as [type]){ return $true }
    $sha = New-Object Security.Cryptography.SHA1Managed
    $hash = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($FxSource))) -replace '-','').Substring(0,12)
    $dll = Join-Path $LauncherDir "rr_fx_$hash.dll"
    if(Test-Path $dll){ try{ Add-Type -Path $dll -ErrorAction Stop }catch{} }
    if(-not ('RRFx.Scene' -as [type])){
        Get-ChildItem -Path $LauncherDir -Filter 'rr_fx_*.dll' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
        try{
            Add-Type -TypeDefinition $FxSource -ReferencedAssemblies 'System.Windows.Forms','System.Drawing' -OutputAssembly $dll -OutputType Library -IgnoreWarnings -ErrorAction Stop
            if(-not ('RRFx.Scene' -as [type])){ Add-Type -Path $dll -ErrorAction Stop }
        }catch{}
    }
    if(-not ('RRFx.Scene' -as [type])){
        try{ Add-Type -TypeDefinition $FxSource -ReferencedAssemblies 'System.Windows.Forms','System.Drawing' -IgnoreWarnings -ErrorAction Stop }catch{
            Show-Msg "$(T 'err') : $($_.Exception.Message)" (T 'err') 'Error'; return $false
        }
    }
    return [bool]('RRFx.Scene' -as [type])
}

# ---------- Musique ----------
$script:Music = $null
function Apply-Music {
    if(-not $script:Music){ return }
    $script:Music.Enabled = [bool]$S.LauncherMusic
    $script:Music.Volume  = [double]$S.LauncherMusicVol / 100.0
    if($script:Scene){ $script:Scene.Invalidate() }
}

# ---------- Fenêtre principale ----------
function Update-SceneTexts {
    $sc = $script:Scene; if(-not $sc){ return }
    $sc.Games       = [string[]]@((T 'g_rr'),(T 'g_r66'),(T 'g_again'))
    $sc.Subtitle    = (T 'sub')
    $sc.ChooseLabel = (T 'choose')
    $sc.PlayText    = (T 'play')
    $sc.OptionsText = (T 'options')
    $sc.QuitText    = (T 'quit')
    $sc.Hint        = (T 'hint')
    $sc.MusicText   = (T 'm_lbl'); $sc.OnText = (T 'm_on'); $sc.OffText = (T 'm_off')
    $sc.LangText    = ''
    if(Find-Engine){ $sc.Status = (T 'st_ok') + ((Get-TargetRes) -join ' x ') } else { $sc.Status = (T 'st_dl') }
    $sc.Invalidate()
}

function Show-Main {
    $m = New-Object Windows.Forms.Form
    $script:MainForm = $m
    $m.Text = 'Redneck Rampage - Launcher'
    $wa = [Windows.Forms.Screen]::PrimaryScreen.WorkingArea
    $k = [math]::Min(1.0, [math]::Min(($wa.Width * 0.92) / 1280.0, ($wa.Height * 0.90) / 720.0))
    $m.ClientSize = New-Object Drawing.Size([int](1280 * $k), [int](720 * $k))
    $m.StartPosition = 'CenterScreen'; $m.FormBorderStyle = 'FixedSingle'; $m.MaximizeBox = $false
    $m.BackColor = [Drawing.Color]::Black; $m.Font = $fNorm
    if($script:AppIcon){ $m.Icon = $script:AppIcon }

    $sc = New-Object RRFx.Scene
    $script:Scene = $sc
    $sc.Dock = 'Fill'
    $sc.Music = $script:Music
    $gk = @('rr','route66','again')
    $sc.GameIndex = [math]::Max(0, [array]::IndexOf($gk, [string]$S.Game))
    $m.Controls.Add($sc)
    if(Test-Path $BgFile){ try{ $sc.LoadBackground($BgFile) }catch{} }
    Update-SceneTexts

    $script:GameKeys = $gk
    $sc.add_UiAction({ param($src_, $e)
        switch($e.Id){
            'play'    { Save-Settings; Start-Game; Update-SceneTexts }
            'options' { Open-Options }
            'quit'    { Save-Settings; $script:MainForm.Close() }
            'game'    { $S.Game = $script:GameKeys[$script:Scene.GameIndex]; Save-Settings }
            'music'   { $S.LauncherMusic = -not [bool]$S.LauncherMusic; Apply-Music; Save-Settings
                        $lo = $script:Scene.FindOpt('lmusic'); if($lo){ $lo.Check = [bool]$S.LauncherMusic } }
            default   { if($e.Id -like 'opt*'){ Handle-OptionEvent $e.Id } }
            'lang'    { if($S.Lang -eq 'fr'){ $S.Lang = 'en' } else { $S.Lang = 'fr' }; Save-Settings; Update-SceneTexts }
        }
    })

    # surveillance du jeu : à sa fermeture, reprise de la musique et de l'animation
    $mon = New-Object Windows.Forms.Timer; $mon.Interval = 1000
    $mon.Add_Tick({
        if($script:GameProc){
            $ended = $true
            try{ $ended = $script:GameProc.HasExited }catch{}
            if($ended){
                $script:GameProc = $null
                if($script:Music){ $script:Music.Suspended = $false }
                if($script:Scene){ $script:Scene.Paused = $false }
            }
        }
    })
    $mon.Start()
    $m.Add_Shown({ $script:Scene.Focus() })
    $m.Add_Activated({ if($script:Scene){ $script:Scene.Focus() } })
    $m.Add_FormClosing({ Save-Settings })
    [void]$m.ShowDialog()
    $mon.Stop(); $mon.Dispose()
    $script:Scene = $null
    $sc.Dispose(); $m.Dispose()
}

# ---------- Démarrage ----------
$script:AppIcon = $null
$script:Scene = $null
$script:GameProc = $null
$icoPath = Join-Path $Root 'rampage.ico'
if(Test-Path $icoPath){ try{ $script:AppIcon = New-Object Drawing.Icon($icoPath) }catch{} }
if(-not (Load-Fx)){ return }
# police façon logo "REDNECK" (Ultra, licence Apache 2.0)
try{ [void][RRFx.Scene]::LoadFont((Join-Path $LauncherDir 'Ultra-Regular.ttf')) }catch{}
# bande-son CD : préparation silencieuse en arrière-plan
try{ Start-CdRips }catch{ Write-Log "Soundtrack: $($_.Exception.Message)" }
try{
    $script:Music = New-Object RRFx.Music
    if(-not $script:Music.Open($MusicFile)){ $script:Music = $null }
}catch{ $script:Music = $null }
Apply-Music
try{ Show-Main }
finally{ if($script:Music){ $script:Music.Dispose() } }
