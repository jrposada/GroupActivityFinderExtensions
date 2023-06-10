local GAFE = GroupActivityFinderExtensions




SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Vétéran", 1)

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

-- This translations have to match pledge quest name in ingame journal
GAFE_DUNGEON_PLEDGE_QUEST_NAME = {
    [GAFE_PLEDGE_ID.FungalGrottoI] = "Champignonnière I",
    [GAFE_PLEDGE_ID.FungalGrottoII] = "Champignonnière II",
    [GAFE_PLEDGE_ID.SpindleclutchI] = "Tressefuseau I",
    [GAFE_PLEDGE_ID.SpindleclutchII] = "Tressefuseau II",
    [GAFE_PLEDGE_ID.BanishedCellsI] = "Cachot interdit I",
    [GAFE_PLEDGE_ID.BanishedCellsII] = "Cachot interdit II",
    [GAFE_PLEDGE_ID.DarkshadeCavernsI] = "Cavernes d'Ombre-noire I",
    [GAFE_PLEDGE_ID.DarkshadeCavernsII] = "Cavernes d'Ombre-noire II",
    [GAFE_PLEDGE_ID.EldenHollowI] = "Creuset des aînés I",
    [GAFE_PLEDGE_ID.EldenHollowII] = "Creuset des aînés II",
    [GAFE_PLEDGE_ID.WayrestSewersI] = "Égouts d'Haltevoie I",
    [GAFE_PLEDGE_ID.WayrestSewersII] = "Égouts d'Haltevoie II",
    [GAFE_PLEDGE_ID.ArxCorinium] = "Arx Corinium",
    [GAFE_PLEDGE_ID.CityOfAshI] = "Cité des cendres I",
    [GAFE_PLEDGE_ID.CityOfAshII] = "Cité des cendres II",
    [GAFE_PLEDGE_ID.CryptOfHeartsI] = "Crypte des cœurs I",
    [GAFE_PLEDGE_ID.CryptOfHeartsII] = "Crypte des cœurs II",
    [GAFE_PLEDGE_ID.DirefrostKeep] = "Donjon d'Affregivre",
    [GAFE_PLEDGE_ID.TempestIsland] = "Île des Tempêtes",
    [GAFE_PLEDGE_ID.Volenfell] = "Volenfell",
    [GAFE_PLEDGE_ID.BlackheartHaven] = "Havre de Cœurnoir",
    [GAFE_PLEDGE_ID.BlessedCrucible] = "Creuset béni",
    [GAFE_PLEDGE_ID.SelenesWeb] = "Toile de Sélène",
    [GAFE_PLEDGE_ID.VaultsOfMadness] = "Chambres de la folie",
    [GAFE_PLEDGE_ID.BalSunnar] = "Bal Sunnar", -- todo: translate
    [GAFE_PLEDGE_ID.BlackDrakeVilla] = "Villa du Dragon noir",
    [GAFE_PLEDGE_ID.BloodrootForge] = "Forge de Sangracine",
    [GAFE_PLEDGE_ID.CastleThorn] = "Bastion-les-Ronce",
    [GAFE_PLEDGE_ID.Cauldron] = "Le Chaudron",
    [GAFE_PLEDGE_ID.CoralAerie] = "Aire de corail",
    [GAFE_PLEDGE_ID.CradleOfShadows] = "Berceau des ombres",
    [GAFE_PLEDGE_ID.DepthsOfMalatar] = "Profondeurs de Malatar",
    [GAFE_PLEDGE_ID.DreadCellar] = "La Cave d'effroi",
    [GAFE_PLEDGE_ID.EarthenRootEnclave] = "Enclave des Racines de la terre",
    [GAFE_PLEDGE_ID.FalkreathHold] = "Forteresse d'Épervine",
    [GAFE_PLEDGE_ID.FangLair] = "Repaire du croc",
    [GAFE_PLEDGE_ID.Frostvault] = "Arquegivre",
    [GAFE_PLEDGE_ID.GravenDeep] = "Profondeurs mortuaires",
    [GAFE_PLEDGE_ID.Icereach] = "Crève-Nève",
    [GAFE_PLEDGE_ID.ImperialCityPrison] = "Prison de le cité impériale",
    [GAFE_PLEDGE_ID.LairOfMaarselok] = "Repaire de Maarselok",
    [GAFE_PLEDGE_ID.MarchOfSacrifices] = "Procession des Sacrifiés",
    [GAFE_PLEDGE_ID.MoonHunterKeep] = "Fort du Chasseur lunaire",
    [GAFE_PLEDGE_ID.MoongraveFane] = "reliquaire des Lunes funèbres",
    [GAFE_PLEDGE_ID.RedPetalBastion] = "Le Bastion du Pétale rouge",
    [GAFE_PLEDGE_ID.RuinsOfMazzatun] = "Ruines de Mazzatun",
    [GAFE_PLEDGE_ID.ScalecallerPeak] = "Pic de la Mandécailles",
    [GAFE_PLEDGE_ID.ScrivenersHall] = "Scrivener's Hall", -- todo: translate
    [GAFE_PLEDGE_ID.ShipwrightsRegret] = "Regret du charpentier",
    [GAFE_PLEDGE_ID.StoneGarden] = "Jardin de pierre",
    [GAFE_PLEDGE_ID.UnhallowedGrave] = "Sépulcre profane",
    [GAFE_PLEDGE_ID.WhiteGoldTower] = "Tour d'or blanc"
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
