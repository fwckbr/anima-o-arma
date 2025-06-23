Config = {}

Config.DropWeaponWhenHitHand = true -- If you want to drop the weapon when you hit the hand, you can change it to true. If you don't want to drop the weapon, you can change it to false.

Config.ThrowWeapon = true

Config.WeaponAnimation = "always" -- always, key

Config.WhenDeadDropGun = false    -- If you want to drop the weapon when you die, you can change it to true. If you don't want to drop the weapon, you can change it to false.

Config.ShoulderSwap = true        -- If you want to use the shoulder swap feature, you can change it to true. If you don't want to use the shoulder swap feature, you can change it to false.

Config.Framework = "qb"           -- oldesx, qb, oldqb, esx ---------> (must be lowercase)

Config.PickUpMenu = "drawtext"    -- drawtext, textui

Config.TextUI = "qb-textui"       -- qb-textui, ox-textui

Config.NewQBInventory = false
-- if your qb inventory is not new please change it to false. server_noescrow.lua 54th line
-- if you dont get what it means, please open ticket - @aw3rque

Config.TakeWeaponText = {
    ["TargetText"] = "Pegar arma",
    ["DrawText"] = "[E] Pegar arma",
    ["TextUI"] = "[E] Pegar arma",
}

-- For now, only [E] key is supported for the Take Weapon text. We'll change it soon!

Config.Inventory = "ox-inventory"     -- qb-inventory, ox-inventory, lj-inventory, qs-inventory, esx-inventory

Config.NotificationType = "qb-notify" -- qb-notify, esx-notify and custom-notify

-- if you decide to use custom-notify go utils.lua > 25th line.

Config.Weapons = {
    ["-1075685676"] = "WEAPON_PISTOL_MK2",
    ["126349499"] = "WEAPON_SNOWBALL",
    ["-270015777"] = "WEAPON_ASSAULTSMG",
    ["615608432"] = "WEAPON_MOLOTOV",
    ["2024373456"] = "WEAPON_SMG_MK2",
    ["-1810795771"] = "WEAPON_POOLCUE",
    ["-1813897027"] = "WEAPON_GRENADE",
    ["-598887786"] = "WEAPON_MARKSMANPISTOL",
    ["-1654528753"] = "WEAPON_BULLPUPSHOTGUN",
    ["-72657034"] = "GADGET_PARACHUTE",
    ["-102323637"] = "WEAPON_BOTTLE",
    ["2144741730"] = "WEAPON_COMBATMG",
    ["-1121678507"] = "WEAPON_MINISMG",
    ["-1652067232"] = "WEAPON_SWEEPERSHOTGUN",
    ["961495388"] = "WEAPON_ASSAULTRIFLE_MK2",
    ["-86904375"] = "WEAPON_CARBINERIFLE_MK2",
    ["-1786099057"] = "WEAPON_BAT",
    ["177293209"] = "WEAPON_HEAVYSNIPER_MK2",
    ["600439132"] = "WEAPON_BALL",
    ["1432025498"] = "WEAPON_PUMPSHOTGUN_MK2",
    ["-1951375401"] = "WEAPON_FLASHLIGHT",
    ["171789620"] = "WEAPON_COMBATPDW",
    ["1593441988"] = "WEAPON_COMBATPISTOL",
    ["-2009644972"] = "WEAPON_SNSPISTOL_MK2",
    ["2138347493"] = "WEAPON_FIREWORK",
    ["1649403952"] = "WEAPON_COMPACTRIFLE",
    ["-619010992"] = "WEAPON_MACHINEPISTOL",
    ["-952879014"] = "WEAPON_MARKSMANRIFLE",
    ["317205821"] = "WEAPON_AUTOSHOTGUN",
    ["-1420407917"] = "WEAPON_PROXMINE",
    ["-1045183535"] = "WEAPON_REVOLVER",
    ["94989220"] = "WEAPON_COMBATSHOTGUN",
    ["-1658906650"] = "WEAPON_MILITARYRIFLE",
    ["1198256469"] = "WEAPON_RAYCARBINE",
    ["2132975508"] = "WEAPON_BULLPUPRIFLE",
    ["1627465347"] = "WEAPON_GUSENBERG",
    ["984333226"] = "WEAPON_HEAVYSHOTGUN",
    ["1233104067"] = "WEAPON_FLARE",
    ["-1716189206"] = "WEAPON_KNIFE",
    ["940833800"] = "WEAPON_STONE_HATCHET",
    ["1305664598"] = "WEAPON_GRENADELAUNCHER_SMOKE",
    ["727643628"] = "WEAPON_CERAMICPISTOL",
    ["-1074790547"] = "WEAPON_ASSAULTRIFLE",
    ["-1169823560"] = "WEAPON_PIPEBOMB",
    ["324215364"] = "WEAPON_MICROSMG",
    ["-1834847097"] = "WEAPON_DAGGER",
    ["-1466123874"] = "WEAPON_MUSKET",
    ["-1238556825"] = "WEAPON_RAYMINIGUN",
    ["-1063057011"] = "WEAPON_SPECIALCARBINE",
    ["1470379660"] = "WEAPON_GADGETPISTOL",
    ["584646201"] = "WEAPON_APPISTOL",
    ["-494615257"] = "WEAPON_ASSAULTSHOTGUN",
    ["-771403250"] = "WEAPON_HEAVYPISTOL",
    ["1672152130"] = "WEAPON_HOMINGLAUNCHER",
    ["338557568"] = "WEAPON_PIPEWRENCH",
    ["1785463520"] = "WEAPON_MARKSMANRIFLE_MK2",
    ["-1355376991"] = "WEAPON_RAYPISTOL",
    ["101631238"] = "WEAPON_FIREEXTINGUISHER",
    ["1119849093"] = "WEAPON_MINIGUN",
    ["883325847"] = "WEAPON_PETROLCAN",
    ["-102973651"] = "WEAPON_HATCHET",
    ["-275439685"] = "WEAPON_DBSHOTGUN",
    ["-1746263880"] = "WEAPON_DOUBLEACTION",
    ["-879347409"] = "WEAPON_REVOLVER_MK2",
    ["125959754"] = "WEAPON_COMPACTLAUNCHER",
    ["911657153"] = "WEAPON_STUNGUN",
    ["-2066285827"] = "WEAPON_BULLPUPRIFLE_MK2",
    ["-538741184"] = "WEAPON_SWITCHBLADE",
    ["100416529"] = "WEAPON_SNIPERRIFLE",
    ["-656458692"] = "WEAPON_KNUCKLE",
    ["-1768145561"] = "WEAPON_SPECIALCARBINE_MK2",
    ["1737195953"] = "WEAPON_NIGHTSTICK",
    ["2017895192"] = "WEAPON_SAWNOFFSHOTGUN",
    ["-2067956739"] = "WEAPON_CROWBAR",
    ["-1312131151"] = "WEAPON_RPG",
    ["-1568386805"] = "WEAPON_GRENADELAUNCHER",
    ["205991906"] = "WEAPON_HEAVYSNIPER",
    ["1834241177"] = "WEAPON_RAILGUN",
    ["-1716589765"] = "WEAPON_PISTOL50",
    ["736523883"] = "WEAPON_SMG",
    ["1317494643"] = "WEAPON_HAMMER",
    ["453432689"] = "WEAPON_PISTOL",
    ["1141786504"] = "WEAPON_GOLFCLUB",
    ["-1076751822"] = "WEAPON_SNSPISTOL",
    ["-2084633992"] = "WEAPON_CARBINERIFLE",
    ["487013001"] = "WEAPON_PUMPSHOTGUN",
    ["-1168940174"] = "WEAPON_HAZARDCAN",
    ["-38085395"] = "WEAPON_DIGISCANNER",
    ["-1853920116"] = "WEAPON_NAVYREVOLVER",
    ["-37975472"] = "WEAPON_SMOKEGRENADE",
    ["-1600701090"] = "WEAPON_BZGAS",
    ["-1357824103"] = "WEAPON_ADVANCEDRIFLE",
    ["-581044007"] = "WEAPON_MACHETE",
    ["741814745"] = "WEAPON_STICKYBOMB",
    ["-608341376"] = "WEAPON_COMBATMG_MK2",
    ["137902532"] = "WEAPON_VINTAGEPISTOL",
    ["-1660422300"] = "WEAPON_MG",
    ["1198879012"] = "WEAPON_FLAREGUN",
}


Config.MaxWeaponThrowDistance = 25.0

Config.Lasers = {
    ["Text"] = "Arremessar arma (E)",
    ["R"] = 200,
    ["G"] = 100,
    ["B"] = 100,
    ["A"] = 255,
}

Config.ThrowWeaponMenuOpenKey =
"J"                                          -- K is default key, you can change from here ->  Settings > Key Bindings > FiveM > (0r-weaponReality) Throw Weapon

Config.ChangeWeaponRunningAnimationKey =
"L"                                          -- L is default key, you can change from here -> Settings > Key Bindings > FiveM > (0r-weaponReality) Change Weapon Running Animation

Config.DefaultShoulderSwapKey = "F"          --

Config.Debug = true

Config.Notifications = {
    ['tookweaponfromground'] = { message = "Você pegou uma arma do chão." },
    ['changedanimationsTrue'] = { message = "Você mudou sua animação." },
    ['changedanimationsFalse'] = { message = "Você voltou para a animação padrão." },
    ['tooLongDistance'] = { message = "Você não pode jogar sua arma tão longe." },
    ['NoWeapon'] = { message = "Você não pode jogar uma arma quando não tem uma na mão." },
    ['weaponThrown'] = { message = "Você jogou sua arma com sucesso." },
    ['checkSpotsAdmin'] = { message = "As coordenadas dos pontos de arremesso de armas estão no console do servidor." },
    ['changedAnimationsAlways'] = { message = "A animação de arma está sempre ativa > config.lua linha 7" },
    ['shoulderSwapDisabled'] = { message = "Este recurso está desativado. Se você quiser ativá-lo, verifique > config.lua linha 11" },
    ['toofast_throw'] = { message = "Muito rápido." }
}
