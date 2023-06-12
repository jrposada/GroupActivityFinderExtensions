local GAFE = GroupActivityFinderExtensions




SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Vétéran", 1)

GAFE.lang = "fr"
GAFE.Localization = {
    Settings_Description = "Ajoute un peu de fonctionnalité et d'information a IU de Groupe et Recherche d'activités",
    Settings_AutoConfirm = "Bouton 'Auto confirmer'",
    Settings_AutoConfirmDelay = "Délai de 'Auto confirmer'",
    Settings_Difficulty = "Difficulté",
    Settings_FavouriteLocation = "Lieu préféré",
    Settings_LoopQueueCompletedNotification = "L'activité de la boucle a trouvé du son",
    Settings_TrialsChest = "Réinitialiser la minuterie des coffres",
    Settings_ResetChestWarning = "Cela réinitialisera la minuterie à 1 semaine!",
    Settings_AutoMarkPledges = "Marquer automatiquement les serment actifs",
    Settings_MarkPledgesWithIcon = "Utiliser l'icône pour les serment",
    Settings_TextureSize = "Taille de l'icône",
    Settings_AutoInvite = "BETA Auto invite",
    Settings_HandleQuest = "Automatisez les quêtes prises en charge",
    Settings_CompatibilityTitle = "Compatibility",
    Settings_PerfectPixelAddon = "PerfectPixel",
    Settings_ResetPremiumRewards = "Réinitialiser les minuteurs de récompense premium",
    Settings_ResetReward = "Cela réinitialisera la minuterie de 20 heures",
    CheckActivePledges = "Serments",
    CheckMissingQuests = "Quêtes",
    CheckMissingSets = "Sets", -- TODO: translate
    AutoConfirm = "Auto confirmer",
    TrialsCategoryHeader = "Épreuve",
    TrialsSpecificFilterText = "Épreuve spécifique",
    TrialAetherianArchive = "Archive æthérienne",
    TrialHelRaCitadel = "Citadelle d'Hel Ra",
    TrialSanctumOphidia = "Sanctum Ophidia",
    TrialMawOfLorkhaj = "Gueule de Lorkhaj",
    TrialHallsOfFabrication = "Salles de la fabrication",
    TrialAsylumSanctorium = "Asile sanctuaire",
    TrialCloudrest = "Pas-des-Nuées",
    TrialSunspire = "Sollance",
    TrialKynesAegis = "l'Égide de Kyne",
    TrialRockgrove = "Rochebosque",
    TrialDreadsailReef = "Dreadsail Reef",
    LookForGroup = "LFG",
    LookForMore = "LFM",
    LookForGroupDisabled = "Vous êtes déjà groupé",
    LookForMoreDisabled = "Vous devez être chef du parti",
    AutoInvite = "Invitation automatique",
    Debug_QueuedList = "Queued: ",
    Debug_NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Grouper",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Vétéran",
    NextReward = "Suivant dans",
    InXDays = "<<1[Aujourd'hui/En $d jour/Dans $d jours]>>",
    ActivitySchedule = "Calendrier",
    DailiesSchedule = "Quotidiennes",
    PledgesSchedule = "Serments",
    Available = "Disponible"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Maj al-Ragath"] = true,
    ["Glirion Barbe-Rousse"] = true,
    ["Urgarlag l'Émasculatrice"] = true,
}

-- TODO: translate
GAFE_DIALY_NPC_NAME = {
    -- Fargrave Dialies
    ["Luna Beriel"] = true,
    ["Vaveli Indavel"] = true,
    --
    ["Justiciar Farowel"] = true
}
