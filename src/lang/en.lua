local GAFE = GroupActivityFinderExtensions

-- List header text in activity finder are set by zo with GetString("SI_LFGACTIVITY", activityType).
-- This means we have the same prefix plus our custom activity type id.
-- Since we use LFG_ACTIVITY_ITERATION_END + 1 it should never overwrite and actual zo string.
ZO_CreateStringId("SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL, "Normal")
ZO_CreateStringId("SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Veteran")

GAFE.lang = "en"
GAFE.Localization = {
    Settings_Description = "Adds a bit of extra functionality and information to the Group & Activity Finder UI",
    Settings_AutoConfirm = "'Auto confirm' button",
    Settings_AutoConfirmDelay = "'Auto confirm' delay",
    Settings_Difficulty = "Difficulty",
    Settings_FavouriteLocation = "Favourite location",
    Settings_LoopQueueCompletedNotification = "Loop activity found sound",
    Settings_TrialsChest = "Reset chest timers",
    Settings_ResetChestWarning = "This will reset the timer to 1 week!",
    Settings_AutoMarkPledges = "Automatically mark available pledges",
    Settings_MarkPledgesWithIcon = "Use icon for pledges",
    Settings_TextureSize = "Icon size",
    Settings_AutoInvite = "BETA Auto invite",
    Settings_HandleQuest = "Automate supported quests",
    Settings_CompatibilityTitle = "Compatibility",
    Settings_PerfectPixelAddon = "PerfectPixel",
    Settings_ResetPremiumRewards = "Reset premium reward timers",
    Settings_ResetReward = "This will reset the 20 hours timer",
    CheckActivePledges = "Pledges",
    CheckMissingQuests = "Quests",
    CheckMissingSets = "Sets",
    AutoConfirm = "Auto confirm",
    TrialsCategoryHeader = "Trials",
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
    TrialRockgrove = "Rockgrove",
    TrialDreadsailReef = "Dreadsail Reef",
    LookForGroup = "Look for group",
    LookForMore = "Look for more",
    LookForGroupDisabled = "You are already grouped",
    LookForMoreDisabled = "You must be party leader",
    AutoInvite = "Auto invite",
    Debug_QueuedList = "Queued: ",
    Debug_NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Group",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Veteran",
    NextReward = "Next in",
    InXDays = "<<1[Today/In $d day/In $d days]>>",
    ActivitySchedule = "Schedule",
    DailiesSchedule = "Dailies Random",
    PledgesSchedule = "Pledges",
    Available = "Available"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Maj al-Ragath"] = true,
    ["Glirion the Redbeard"] = true,
    ["Urgarlag Chief-bane"] = true,
}

GAFE_DIALY_NPC_NAME = {
    -- Fargrave Dialies
    ["Luna Beriel"] = true,
    ["Vaveli Indavel"] = true,
    --
    ["Justiciar Farowel"] = true,
    ["Justiciar Tanorian"] = true,
    -- Battlegrounds
    ["Battlemaster Rivyn"] = true,
}
