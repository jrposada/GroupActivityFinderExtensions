local GAFE = GroupActivityFinderExtensions

-- List header text in activity finder are set by zo with GetString("SI_LFGACTIVITY", activityType).
-- This means we have the same prefix plus our custom activity type id.
-- Since we use LFG_ACTIVITY_ITERATION_END + 1 it should never overwrite and actual zo string.
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL, "Normal")
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Veteran")

GAFE.Localization = {
    Settings_Description = "Adds a bit of extra functionality and information to the Group & Activity Finder UI",
    Settings_AutoConfirm = "'Auto confirm' button",
    CheckActivePledges = "Check active pledges",
    CheckMissingQuests = "Check missing quests",
    AutoConfirm = "Auto confirm",
    TrailsCategoryHeader = "Trails",
    TrialsSpecificFilterText = "Specific Trials",
    TrialAetherianArchive = "Aetherian Archive",
    TrialHelRaCitadel = "Hel Ra Citadel",
    TrialSanctumOphidia = "Sanctum Ophidia",
    TrialMawOfLorkhaj = "Maw of Lorkhaj",
    TrialHallsOfFabrication = "Halls of Fabrication",
    TrialAsylumSanctorium = "Asylum Sanctorium",
    TrialCloudrest = "Cloudrest",
    TrialSunspire = "Sunspire",
    TrialKynesAegis = "Kyne's Aegis",
    LookForGroup = "Look for group",
    LookForMore = "Look for more",
    LookForGroupTooltip = "Look for group",
    LookForMoreTooltip = "Look for more"
}