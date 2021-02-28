local GAFE = GroupActivityFinderExtensions




SafeAddString(_G["SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Vétéran", 1)

GAFE.Localization = {
    Settings_Description = "Ajoute un peu de fonctionnalité et d'information a IU de Groupe et Recherche d'activités",
    Settings_AutoConfirm = "Bouton 'Auto confirmer'",
    Settings_Trials = "Réinitialiser la minuterie des coffres",
    Settings_ResetChestWarning = "Cela réinitialisera la minuterie à 1 semaine!",
    Settings_AutoMarkPledges = "Marquer automatiquement les serment actifs",
    Settings_MarkPledgesWithIcon = "Utiliser l'icône pour les serment",
    Settings_TextureSize = "Taille de l'icône",
    CheckActivePledges = "Sélect serment activ",
    CheckMissingQuests = "Sélect quêtes incompl",
    AutoConfirm = "Auto confirmer",
    TrailsCategoryHeader = "Épreuve",
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
    LookForGroup = "LFG",
    LookForMore = "LFM",
    LookForGroupDisabled = "Vous êtes déjà groupé",
    LookForMoreDisabled = "Vous devez être chef du parti",
    AutoInvite = "Auto invite",-- translate
}