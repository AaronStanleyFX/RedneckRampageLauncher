# Generates rrtrainer.con (CON add-on for Raze / Redneck Rampage)
# Tiles 29100-29106 are free tile numbers used as "command" actors spawned from the console.

TILE_CTL, TILE_HEALTH, TILE_AMMO, TILE_INV, TILE_FLY, TILE_BUILD, TILE_STATUS = range(29100, 29107)
SECT_MAX = 4096      # sectors scanned (RR maps use far fewer)
WALL_MAX = 16384     # walls scanned
SECT_PER_TICK = 128
WALL_PER_TICK = 256

L = []
a = L.append

a("""// =====================================================================
//  Redneck Rampage Trainer - add-on CON pour Raze
//  Charge par le launcher : -file Trainer\\addon -addcon rrtrainer.con
//  Les options sont stockees dans MARKER (bits) :
//    1 = sante illimitee   2 = munitions illimitees
//    4 = inventaire illimite   8 = mode vol
//  Commandes console (liees aux touches par rrtrainer.cfg) :
//    spawn 29101..29106
// =====================================================================

gamevar TR_ALIVE 0 0
gamevar TR_PING 0 0
gamevar TR_T 0 0
gamevar TR_U 0 0
gamevar TR_V 0 0
gamevar TR_W 0 0
gamevar TR_A 0 0
gamevar TR_C 0 0
gamevar TR_S 0 0
gamevar TR_H 0 0
gamevar TR_F 0 0
gamevar TR_I 0 0
gamevar TR_MAX 0 0
gamevar TR_PL 0 0
gamevar TR_HOVER 0 0
gamevar TR_LAND 0 0
gamevar TR_FLYZ 0 0
gamevar TR_LASTV 0 0
gamevar TR_G 256 0
gamevar TR_BIDX 0 0
gamevar TR_BREF 0 0
gamevar TR_BCEIL 0 0
gamevar TR_BSKY -1 0
gamevar TR_BPHASE 0 0
gamevar TR_ISCTL 0 2
gamevar TR_WAIT 0 2
gamevar TR_DONE 0 2

definequote 9001 TRAINER : INFINITE HEALTH [ON]
definequote 9002 TRAINER : INFINITE HEALTH [OFF]
definequote 9003 TRAINER : INFINITE AMMO [ON]
definequote 9004 TRAINER : INFINITE AMMO [OFF]
definequote 9005 TRAINER : INFINITE INVENTORY [ON]
definequote 9006 TRAINER : INFINITE INVENTORY [OFF]
definequote 9007 TRAINER : FLY MODE [ON] (JUMP TO TAKE OFF, LOOK UP/DOWN WHILE MOVING)
definequote 9008 TRAINER : FLY MODE [OFF]
definequote 9009 TRAINER : ERASING BUILDINGS...
definequote 9010 TRAINER : BUILDINGS ERASED [ON]
definequote 9011 TRAINER : ACTIVE
""")

# ---------------------------------------------------------------- health
a("""
// ---------------------------------------------------------------- sante
state rrtr_health
  getplayer[THISACTOR].dead_flag TR_T
  ifvare TR_T 0
  {
    setvar TR_T 1
    setuserdef .god TR_T
    getactor[TR_PL].extra TR_T
    ifvarl TR_T 100
    {
      setvar TR_T 100
      setactor[TR_PL].extra TR_T
    }
    setvar TR_T 0
    setplayer[THISACTOR].falling_counter TR_T
  }
ends

state rrtr_nohealth
  setvar TR_T 0
  setuserdef .god TR_T
ends
""")

# ---------------------------------------------------------------- ammo
a("""
// ---------------------------------------------------------------- munitions
state rrtr_ammo1
  gmaxammo TR_I TR_MAX
  ifvarg TR_MAX 0
  {
    getplayer[THISACTOR].ammo_amount TR_I TR_T
    ifvarvarl TR_T TR_MAX
      setplayer[THISACTOR].ammo_amount TR_I TR_MAX
  }
  addvar TR_I 1
ends

state rrtr_ammo
  setvar TR_I 1
""" + "  state rrtr_ammo1\n" * 15 + "ends\n")

# ---------------------------------------------------------------- inventory
inv = [("firstaid_amount", 100), ("holoduke_amount", 2400), ("jetpack_amount", 600),
       ("scuba_amount", 6400), ("boot_amount", 2000), ("shield_amount", 100)]
s = ["\n// ---------------------------------------------------------------- inventaire",
     "state rrtr_inv"]
for lab, mx in inv:
    s += [f"  getplayer[THISACTOR].{lab} TR_T",
          f"  ifvarl TR_T {mx}",
          "  {",
          f"    setvar TR_T {mx}",
          f"    setplayer[THISACTOR].{lab} TR_T",
          "  }"]
# moonshine (steroids) is "in use" while 0 < amount < 400 -> only refill once used up
s += ["  getplayer[THISACTOR].steroids_amount TR_T",
      "  ifvare TR_T 0",
      "  {",
      "    setvar TR_T 400",
      "    setplayer[THISACTOR].steroids_amount TR_T",
      "  }",
      "ends"]
a("\n".join(s) + "\n")

# ---------------------------------------------------------------- fly
a("""
// ---------------------------------------------------------------- mode vol
// Le controleur s'execute apres le mouvement du joueur a chaque tick :
// il impose la vitesse verticale pour rester a l'altitude TR_FLYZ.
// L'altitude change en avancant tout en regardant vers le haut / le bas.
state rrtr_fly
  setvar TR_U 0
  ifonmoto setvar TR_U 1
  ifonboat setvar TR_U 1
  getplayer[THISACTOR].dead_flag TR_T
  ifvarn TR_T 0 setvar TR_U 1
  getplayer[THISACTOR].on_ground TR_T
  ifvarn TR_T 0
  {
    setvar TR_U 1
    setvar TR_LAND 0
  }
  ifvare TR_LAND 1 setvar TR_U 1

  ifvare TR_U 1
  {
    setvar TR_HOVER 0
  }
  else
  {
    getplayer[THISACTOR].posz TR_T
    ifvare TR_HOVER 0
    {
      // decollage : on part de l'altitude actuelle (+24 si on vient de sauter)
      setvar TR_HOVER 1
      setvarvar TR_FLYZ TR_T
      getplayer[THISACTOR].jumping_counter TR_V
      ifvarg TR_V 0 subvar TR_FLYZ 6144
      setvar TR_LASTV -999999
    }
    else
    {
      // mesure de la gravite reelle (ajustement automatique)
      ifvarn TR_LASTV -999999
      {
        getplayer[THISACTOR].poszv TR_V
        subvarvar TR_V TR_LASTV
        ifvarg TR_V 63
        {
          ifvarl TR_V 769
          {
            mulvar TR_G 3
            addvarvar TR_G TR_V
            divvar TR_G 4
          }
        }
      }
    }

    // vitesse vers l'avant (dans la direction du regard)
    getplayer[THISACTOR].posxv TR_V
    divvar TR_V 256
    getplayer[THISACTOR].posyv TR_W
    divvar TR_W 256
    getplayer[THISACTOR].ang TR_A
    sin TR_S TR_A
    setvarvar TR_C TR_A
    addvar TR_C 512
    sin TR_C TR_C
    mulvarvar TR_V TR_C
    mulvarvar TR_W TR_S
    addvarvar TR_V TR_W
    divvar TR_V 16384
    ifvarl TR_V 0 setvar TR_V 0
    // inclinaison du regard
    getplayer[THISACTOR].horiz TR_H
    mulvarvar TR_V TR_H
    divvar TR_V 192
    mulvar TR_V -1
    addvarvar TR_FLYZ TR_V

    // plafond
    getplayer[THISACTOR].truecz TR_F
    addvar TR_F 4096
    ifvarvarl TR_FLYZ TR_F setvarvar TR_FLYZ TR_F

    // sol : si on descend jusqu'au sol, on atterrit
    getplayer[THISACTOR].truefz TR_F
    subvar TR_F 11264
    ifvarvarg TR_FLYZ TR_F
    {
      setvar TR_LAND 1
      setvar TR_HOVER 0
    }
    else
    {
      setvarvar TR_V TR_FLYZ
      subvarvar TR_V TR_T
      ifvarg TR_V 2048 setvar TR_V 2048
      ifvarl TR_V -2048 setvar TR_V -2048
      subvarvar TR_V TR_G
      setplayer[THISACTOR].poszv TR_V
      setvarvar TR_LASTV TR_V
      setvar TR_V 0
      setplayer[THISACTOR].jumping_counter TR_V
      setplayer[THISACTOR].falling_counter TR_V
    }
  }
ends
""")

# ---------------------------------------------------------------- controller
a("""
// ---------------------------------------------------------------- controleur
state rrtr_apply
  getplayer[THISACTOR].i TR_PL
  ifvarand MARKER 1 state rrtr_health
  else state rrtr_nohealth
  ifvarand MARKER 2 state rrtr_ammo
  ifvarand MARKER 4 state rrtr_inv
  ifvarand MARKER 8 state rrtr_fly
  else setvar TR_HOVER 0
ends

// Un seul controleur actif a la fois (battement de coeur TR_ALIVE).
state rrtr_ctl
  cstat 32768
  ifvare TR_ISCTL 1
  {
    setvar TR_ALIVE 4
    setvar TR_PING 0
    state rrtr_apply
  }
  else
  {
    ifvarg TR_ALIVE 0
    {
      subvar TR_ALIVE 1
      addvar TR_WAIT 1
      ifvarg TR_WAIT 8 killit
    }
    else
    {
      setvar TR_ISCTL 1
      setvar TR_ALIVE 4
      setvar TR_HOVER 0
    }
  }
ends

// Appelee par les actions du joueur : relance le controleur apres un
// changement de niveau, une mort ou un chargement.
state rrtr_ping
  ifvarand MARKER 15
  {
    ifvarg TR_PING 0
    {
      spawn """ + str(TILE_CTL) + """
      setvar TR_PING 0
    }
    else addvar TR_PING 1
  }
ends
""")

# ---------------------------------------------------------------- buildings (flatten)
sect = ["\n// ---------------------------------------------------------------- batiments",
        "// phase 1 : cherche une texture de ciel ; phase 2 : aplatit les secteurs ; phase 3 : murs",
        "state rrtr_sky1",
        "  ifvare TR_BSKY -1",
        "  {",
        "    getsector[TR_BIDX].ceilingstat TR_T",
        "    ifvarand TR_T 1 getsector[TR_BIDX].ceilingpicnum TR_BSKY",
        "  }",
        "  addvar TR_BIDX 1",
        "ends",
        "state rrtr_sec1",
        "  getsector[TR_BIDX].wallnum TR_T",
        "  ifvarg TR_T 0",
        "  {",
        "    setsector[TR_BIDX].floorz TR_BREF",
        "    setsector[TR_BIDX].ceilingz TR_BCEIL",
        "    getsector[TR_BIDX].floorstat TR_T",
        "    andvar TR_T -3",
        "    setsector[TR_BIDX].floorstat TR_T",
        "    getsector[TR_BIDX].ceilingstat TR_T",
        "    andvar TR_T -3",
        "    ifvarn TR_BSKY -1",
        "    {",
        "      orvar TR_T 1",
        "      setsector[TR_BIDX].ceilingpicnum TR_BSKY",
        "    }",
        "    setsector[TR_BIDX].ceilingstat TR_T",
        "  }",
        "  addvar TR_BIDX 1",
        "ends",
        "state rrtr_wall1",
        "  getwall[TR_BIDX].cstat TR_T",
        "  andvar TR_T -114",
        "  setwall[TR_BIDX].cstat TR_T",
        "  addvar TR_BIDX 1",
        "ends"]

def unroll(name, sub, n):
    out = []
    # build x8 blocks then the requested count
    out.append(f"state {name}8")
    out += [f"  state {sub}"] * 8
    out.append("ends")
    out.append(f"state {name}64")
    out += [f"  state {name}8"] * 8
    out.append("ends")
    out.append(f"state {name}N")
    out += [f"  state {name}64"] * (n // 64)
    out.append("ends")
    return out

sect += unroll("rrtr_skyb", "rrtr_sky1", 512)
sect += unroll("rrtr_secb", "rrtr_sec1", SECT_PER_TICK)
sect += unroll("rrtr_wallb", "rrtr_wall1", WALL_PER_TICK)
a("\n".join(sect) + "\n")

a(f"""
state rrtr_build
  cstat 32768
  ifvare TR_DONE 0
  {{
    setvar TR_DONE 1
    quote 9009
    getplayer[THISACTOR].cursectnum TR_T
    getsector[TR_T].floorz TR_BREF
    setvarvar TR_BCEIL TR_BREF
    subvar TR_BCEIL 131072
    setvar TR_BSKY -1
    // ciel de reference : celui du secteur du joueur s'il est a ciel ouvert
    getsector[TR_T].ceilingstat TR_U
    ifvarand TR_U 1 getsector[TR_T].ceilingpicnum TR_BSKY
    setvar TR_BIDX 0
    setvar TR_BPHASE 1
  }}
  else
  {{
    ifvare TR_BPHASE 1
    {{
      state rrtr_skybN
      ifvarg TR_BIDX {SECT_MAX - 1}
      {{
        setvar TR_BIDX 0
        setvar TR_BPHASE 2
      }}
    }}
    else ifvare TR_BPHASE 2
    {{
      state rrtr_secbN
      ifvarg TR_BIDX {SECT_MAX - 1}
      {{
        setvar TR_BIDX 0
        setvar TR_BPHASE 3
      }}
    }}
    else ifvare TR_BPHASE 3
    {{
      state rrtr_wallbN
      ifvarg TR_BIDX {WALL_MAX - 1}
      {{
        setvar TR_BPHASE 0
        quote 9010
        killit
      }}
    }}
    else killit
  }}
ends
""")

# ---------------------------------------------------------------- toggles
def toggle(tile, bit, q, on, extra=""):
    op = f"orvar MARKER {bit}" if on else f"andvar MARKER {~bit}"
    return f"""
useractor 0 {tile} 0
  cstat 32768
  ifvare TR_DONE 0
  {{
    setvar TR_DONE 1
    {op}
    quote {q}{extra}
  }}
  state rrtr_ctl
enda
"""

a("""
// ---------------------------------------------------------------- acteurs-commandes
useractor 0 """ + str(TILE_CTL) + """ 0
  state rrtr_ctl
enda
""")
fx = "\n    setvar TR_HOVER 0\n    setvar TR_LAND 0"
for t, bit, qon, qoff, ex in [(TILE_HEALTH,1,9001,9002,""),(TILE_AMMO,2,9003,9004,""),(TILE_INV,4,9005,9006,""),(TILE_FLY,8,9007,9008,fx)]:
    a(toggle(t, bit, qon, True, ex))       # 29101..29104 : activer
    a(toggle(t + 10, bit, qoff, False, ex))  # 29111..29114 : desactiver
a(f"""
useractor 0 {TILE_BUILD} 0
  state rrtr_build
enda

// etat : reaffiche l'etat de chaque option (synchronisation du trainer)
useractor 0 {TILE_STATUS} 0
  cstat 32768
  ifvare TR_DONE 0
  {{
    setvar TR_DONE 1
    quote 9011
    ifvarand MARKER 1 quote 9001 else quote 9002
    ifvarand MARKER 2 quote 9003 else quote 9004
    ifvarand MARKER 4 quote 9005 else quote 9006
    ifvarand MARKER 8 quote 9007 else quote 9008
  }}
  state rrtr_ctl
enda

// ---------------------------------------------------------------- evenements joueur
onevent 9
  state rrtr_ping
endevent
onevent 10
  state rrtr_ping
endevent
onevent 12
  state rrtr_ping
endevent
onevent 13
  state rrtr_ping
endevent
onevent 15
  state rrtr_ping
endevent
onevent 16
  state rrtr_ping
endevent
onevent 28
  state rrtr_ping
endevent
""")

open("../Trainer/addon/rrtrainer.con", "w", newline="\r\n").write("".join(L))
print("ok", sum(x.count("\n") for x in L), "lines")
