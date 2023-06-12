local GAFE = GroupActivityFinderExtensions




SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Veteranen", 1)

GAFE.lang = "de"
GAFE.Localization = {
    Settings_Description = "Fügt der Benutzeroberfläche von Group & Activity Finder zusätzliche Funktionen und UI",
    Settings_AutoConfirm = "'Autom. bestätigen' Knopf",
    Settings_AutoConfirmDelay = "'Autom. bestätigen' verzögern",
    Settings_Difficulty = "Schwierigkeit",
    Settings_FavouriteLocation = "Lieblingsort",
    Settings_LoopQueueCompletedNotification = "Loop-Aktivität hat Sound gefunden",
    Settings_TrialsChest = "Setzen Sie den Timer für Truhen zurück",
    Settings_ResetChestWarning = "Dadurch wird der Timer auf 1 Woche zurückgesetzt!",
    Settings_AutoMarkPledges = "Wähle Gelöbnisse automatisch",
    Settings_MarkPledgesWithIcon = "Verwenden Sie das Symbol für Gelöbnisse",
    Settings_HandleQuest = "Unterstützte Quests automatisieren",
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
    TrialRockgrove = "Felshain",
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
    PledgesSchedule = "Gelöbnisse",
    Available = "Verfügbar"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Maj al-Ragath"] = true,
    ["Glirion der Rotbart"] = true,
    ["Urgarlag Häuptlingsfluch"] = true,
}

-- TODO: translate
GAFE_DIALY_NPC_NAME = {
    -- Fargrave Dialies
    ["Luna Beriel"] = true,
    ["Vaveli Indavel"] = true,
    --
    ["Justiciar Farowel"] = true
}
