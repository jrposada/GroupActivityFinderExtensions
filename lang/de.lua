local GAFE = GroupActivityFinderExtensions
local PledgeId = GAFE.Constants.PledgeId




SafeAddString(_G["SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Veteranen", 1)

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
	Settings_ResetPremiumRewards = "Reset premium reward timers", -- translate
	Settings_Dungeon = "Dungeon", -- translate
	Settings_Battleground = "Battleground", -- translate
	Settings_ResetReward = "This will reset the 20 ours timer", -- translate
    CheckActivePledges = "Wähle Gelöbnisse",
    CheckMissingQuests = "Wähle fehl. Quests",
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
    TrialRockgrave = "Felshain",
    LookForGroup = "LFG",
    LookForMore = "LFM",
    LookForGroupDisabled = "Sie sind bereits gruppiert",
    LookForMoreDisabled = "Sie müssen Parteiführer sein",
    AutoInvite = "Automatisch einladen",
    QueuedList = "Queued: ", -- Translate
    NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Gruppe",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Veteranen",
	NextReward = "Weiter in"
}

-- This translations have to match pledge quest name in ingame journal
GAFE.DungeonPledgeQuestName = {
	[PledgeId.FungalGrottoI] = "Pilzgrotte I",
	[PledgeId.FungalGrottoII] = "Pilzgrotte II",
	[PledgeId.SpindleclutchI] = "Spindeltiefen I",
	[PledgeId.SpindleclutchII] = "Spindeltiefen II",
	[PledgeId.BanishedCellsI] = "Verbannungszellen I",
	[PledgeId.BanishedCellsII] = "Verbannungszellen II",
	[PledgeId.DarkshadeCavernsI] = "Dunkelschattenkavernen I",
	[PledgeId.DarkshadeCavernsII] = "Dunkelschattenkavernen II",
	[PledgeId.EldenHollowI] = "Eldengrund I",
	[PledgeId.EldenHollowII] = "Eldengrund II",
	[PledgeId.WayrestSewersI] = "Kanalisation von Wegesruh I",
	[PledgeId.WayrestSewersII] = "Kanalisation von Wegesruh II",
	[PledgeId.ArxCorinium] = "Arx Corinium",
	[PledgeId.CityOfAshI] = "Stadt der Asche I",
	[PledgeId.CityOfAshII] = "Stadt der Asche II",
	[PledgeId.CryptOfHeartsI] = "Krypta der Herzen I",
	[PledgeId.CryptOfHeartsII] = "Krypta der Herzen II",
	[PledgeId.DirefrostKeep] = "Burg Grauenfrost",
	[PledgeId.TempestIsland] = "Orkaninsel",
	[PledgeId.Volenfell] = "Volenfell",
	[PledgeId.BlackheartHaven] = "Schwarzherz-Unterschlupf",
	[PledgeId.BlessedCrucible] = "Gesegnete Feuerprobe",
	[PledgeId.SelenesWeb] = "Selenes Netz",
	[PledgeId.VaultsOfMadness] = "Kammern des Wahnsinns",
	[PledgeId.BlackDrakeVilla] = "Schwarzdrachenvilla",
	[PledgeId.BloodrootForge] = "Blutquellschmiede",
	[PledgeId.CastleThorn] = "Kastell Dorn",
	[PledgeId.CradleOfShadows] = "Wiege der Schatten",
	[PledgeId.DepthsOfMalatar] = "Tiefen von Malatar",
	[PledgeId.FalkreathHold] = "Falkenring",
	[PledgeId.FangLair] = "Krallenhort",
	[PledgeId.Frostvault] = "Frostgewölbe",
	[PledgeId.Icereach] = "Eiskap",
	[PledgeId.ImperialCityPrison] = "Gefängnis der Kaiserstadt",
	[PledgeId.LairOfMaarselok] = "Hort von Maarselok",
	[PledgeId.MarchOfSacrifices] = "Marsch der Aufopferung",
	[PledgeId.MoonHunterKeep] = "Mondjägerfeste",
	[PledgeId.MoongraveFane] = "Mondgrab-Tempelstadt",
	[PledgeId.RedPetalBastion] = "Die Rotblütenbastion",
	[PledgeId.RuinsOfMazzatun] = "Ruinen von Mazzatun",
	[PledgeId.ScalecallerPeak] = "Gipfel der Schuppenruferin",
	[PledgeId.StoneGarden] = "Steingarten",
	[PledgeId.Cauldron] = "Der Kessel",
	[PledgeId.DreadCellar] = "Der Schreckenskeller",
	[PledgeId.UnhallowedGrave] = "Unheiliges Grab",
	[PledgeId.WhiteGoldTower] = "Weißgoldturm"
}

GAFE.PledgeChatterOptions = {
    "Was ist das heutige Gelöbnis?"
}