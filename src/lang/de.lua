local GAFE = GroupActivityFinderExtensions




SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Veteranen", 1)

GAFE.Localization = {
    Settings_Description = "Fügt der Benutzeroberfläche von Group & Activity Finder zusätzliche Funktionen und UI",
    Settings_AutoConfirm = "'Autom. bestätigen' Knopf",
    Settings_AutoConfirmDelay = "'Autom. bestätigen' verzögern",
    Settings_LoopQueueCompletedNotification = "Loop-Aktivität hat Sound gefunden",
    Settings_TrialsChest = "Setzen Sie den Timer für Truhen zurück",
    Settings_ResetChestWarning = "Dadurch wird der Timer auf 1 Woche zurückgesetzt!",
    Settings_AutoMarkPledges = "Wähle Gelöbnisse automatisch",
    Settings_MarkPledgesWithIcon = "Verwenden Sie das Symbol für Gelöbnisse",
    Settings_HandleQuest = "Versprechen-Quest automatisch annehmen",
    Settings_CompatibilityTitle = "Compatibility",
    Settings_PerfectPixelAddon = "PerfectPixel",
    Settings_TextureSize = "Symbolgröße",
    Settings_AutoInvite = "BETA Auto invite",
    Settings_ResetPremiumRewards = "Premium-Belohnungstimer zurücksetzen",
    Settings_ResetReward = "Dadurch wird der 20-Stunden-Timer zurückgesetzt",
    CheckActivePledges = "Gelöbnisse",
    CheckMissingQuests = "Quests",
    CheckMissingSets = "Sets", -- TODO: translate
    AutoConfirm = "Autom. bestätigen",
    TrialsCategoryHeader = "Prüfung",
    TrialsSpecificFilterText = "Spezifischer prüfung",
    TrialAetherianArchive = "Ätherische Archive",
    TrialHelRaCitadel = "Die Zitadelle von Hel Ra",
    TrialSanctumOphidia = "Sanctum Ophidia",
    TrialMawOfLorkhaj = "Schlund von Lorkhaj",
    TrialHallsOfFabrication = "Die Hallen der Fertigung",
    TrialAsylumSanctorium = "Die Anstalt Sanctorium",
    TrialCloudrest = "Wolkenruh",
    TrialSunspire = "Sonnspitz",
    TrialKynesAegis = "Kynes Ägis",
    TrialRockgrave = "Felshain", -- TODO: translate
    TrialDreadsailReef = "Dreadsail Reef",
    LookForGroup = "LFG",
    LookForMore = "LFM",
    LookForGroupDisabled = "Sie sind bereits gruppiert",
    LookForMoreDisabled = "Sie müssen Parteiführer sein",
    AutoInvite = "Automatisch einladen",
    Debug_QueuedList = "Queued: ",
    Debug_NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Gruppe",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Veteranen",
    NextReward = "Weiter in",
    InXDays = "<<1[Heute/An $d Tag/In $d Tagen]>>",
    ActivitySchedule = "Kalender",
    DailiesSchedule = "DailiTägliche",
    PledgesSchedule = "Gelöbnisse"
}

-- This translations have to match pledge quest name in ingame journal
GAFE_DUNGEON_PLEDGE_QUEST_NAME = {
    [GAFE_PLEDGE_ID.FungalGrottoI] = "Pilzgrotte I",
    [GAFE_PLEDGE_ID.FungalGrottoII] = "Pilzgrotte II",
    [GAFE_PLEDGE_ID.SpindleclutchI] = "Spindeltiefen I",
    [GAFE_PLEDGE_ID.SpindleclutchII] = "Spindeltiefen II",
    [GAFE_PLEDGE_ID.BanishedCellsI] = "Verbannungszellen I",
    [GAFE_PLEDGE_ID.BanishedCellsII] = "Verbannungszellen II",
    [GAFE_PLEDGE_ID.DarkshadeCavernsI] = "Dunkelschattenkavernen I",
    [GAFE_PLEDGE_ID.DarkshadeCavernsII] = "Dunkelschattenkavernen II",
    [GAFE_PLEDGE_ID.EldenHollowI] = "Eldengrund I",
    [GAFE_PLEDGE_ID.EldenHollowII] = "Eldengrund II",
    [GAFE_PLEDGE_ID.WayrestSewersI] = "Kanalisation von Wegesruh I",
    [GAFE_PLEDGE_ID.WayrestSewersII] = "Kanalisation von Wegesruh II",
    [GAFE_PLEDGE_ID.ArxCorinium] = "Arx Corinium",
    [GAFE_PLEDGE_ID.CityOfAshI] = "Stadt der Asche I",
    [GAFE_PLEDGE_ID.CityOfAshII] = "Stadt der Asche II",
    [GAFE_PLEDGE_ID.CryptOfHeartsI] = "Krypta der Herzen I",
    [GAFE_PLEDGE_ID.CryptOfHeartsII] = "Krypta der Herzen II",
    [GAFE_PLEDGE_ID.DirefrostKeep] = "Burg Grauenfrost",
    [GAFE_PLEDGE_ID.TempestIsland] = "Orkaninsel",
    [GAFE_PLEDGE_ID.Volenfell] = "Volenfell",
    [GAFE_PLEDGE_ID.BlackheartHaven] = "Schwarzherz-Unterschlupf",
    [GAFE_PLEDGE_ID.BlessedCrucible] = "Gesegnete Feuerprobe",
    [GAFE_PLEDGE_ID.SelenesWeb] = "Selenes Netz",
    [GAFE_PLEDGE_ID.VaultsOfMadness] = "Kammern des Wahnsinns",
    [GAFE_PLEDGE_ID.BlackDrakeVilla] = "Schwarzdrachenvilla",
    [GAFE_PLEDGE_ID.BloodrootForge] = "Blutquellschmiede",
    [GAFE_PLEDGE_ID.CastleThorn] = "Kastell Dorn",
    [GAFE_PLEDGE_ID.CoralAerie] = "Korallenhorst", -- TODO: Review
    [GAFE_PLEDGE_ID.CradleOfShadows] = "Wiege der Schatten",
    [GAFE_PLEDGE_ID.DepthsOfMalatar] = "Tiefen von Malatar",
    [GAFE_PLEDGE_ID.FalkreathHold] = "Falkenring",
    [GAFE_PLEDGE_ID.FangLair] = "Krallenhort",
    [GAFE_PLEDGE_ID.Frostvault] = "Frostgewölbe",
    [GAFE_PLEDGE_ID.Icereach] = "Eiskap",
    [GAFE_PLEDGE_ID.ImperialCityPrison] = "Gefängnis der Kaiserstadt",
    [GAFE_PLEDGE_ID.LairOfMaarselok] = "Hort von Maarselok",
    [GAFE_PLEDGE_ID.MarchOfSacrifices] = "Marsch der Aufopferung",
    [GAFE_PLEDGE_ID.MoonHunterKeep] = "Mondjägerfeste",
    [GAFE_PLEDGE_ID.MoongraveFane] = "Mondgrab-Tempelstadt",
    [GAFE_PLEDGE_ID.RedPetalBastion] = "Die Rotblütenbastion",
    [GAFE_PLEDGE_ID.RuinsOfMazzatun] = "Ruinen von Mazzatun",
    [GAFE_PLEDGE_ID.ScalecallerPeak] = "Gipfel der Schuppenruferin",
    [GAFE_PLEDGE_ID.ShipwrightsRegret] = "Shrekenskeller", -- TODO: Review
    [GAFE_PLEDGE_ID.StoneGarden] = "Steingarten",
    [GAFE_PLEDGE_ID.Cauldron] = "Der Kessel",
    [GAFE_PLEDGE_ID.DreadCellar] = "Der Schreckenskeller",
    [GAFE_PLEDGE_ID.UnhallowedGrave] = "Unheiliges Grab",
    [GAFE_PLEDGE_ID.WhiteGoldTower] = "Weißgoldturm"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Maj al-Ragath"] = true,
    ["Glirion der Rotbart"] = true,
    ["Urgarlag Häuptlingsfluch"] = true,
}
