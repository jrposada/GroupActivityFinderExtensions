local GAFE = GroupActivityFinderExtensions
local PledgeId = GAFE.Constants.PledgeId




SafeAddString(_G["SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Vétéran", 1)

GAFE.Localization = {
    Settings_Description = "Ajoute un peu de fonctionnalité et d'information a IU de Groupe et Recherche d'activités",
    Settings_AutoConfirm = "Bouton 'Auto confirmer'",
    Settings_AutoConfirmDelay = "Délai de 'Auto confirmer'",
    Settings_LoopQueueCompletedNotification = "L'activité de la boucle a trouvé du son",
    Settings_TrialsChest = "Réinitialiser la minuterie des coffres",
    Settings_ResetChestWarning = "Cela réinitialisera la minuterie à 1 semaine!",
    Settings_AutoMarkPledges = "Marquer automatiquement les serment actifs",
    Settings_MarkPledgesWithIcon = "Utiliser l'icône pour les serment",
    Settings_TextureSize = "Taille de l'icône",
    Settings_AutoInvite = "BETA Auto invite",
    Settings_HandleQuest = "Accepter automatiquement la quête d'engagement",
    Settings_CompatibilityTitle = "Compatibility",
    Settings_PerfectPixelAddon = "PerfectPixel",
	Settings_ResetPremiumRewards = "Réinitialiser les minuteurs de récompense premium",
	Settings_Dungeon = "Donjon",
	Settings_Battleground = "Battleground", -- translate
	Settings_ResetReward = "Cela réinitialisera la minuterie de 20 heures",
    CheckActivePledges = "Sélect serment activ",
    CheckMissingQuests = "Sélect quêtes incompl",
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
    TrialRockgrave = "Rochebosque",
    LookForGroup = "LFG",
    LookForMore = "LFM",
    LookForGroupDisabled = "Vous êtes déjà groupé",
    LookForMoreDisabled = "Vous devez être chef du parti",
    AutoInvite = "Invitation automatique",
    QueuedList = "Queued: ", -- Translate
    NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Grouper",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Vétéran",
	NextReward = "Suivant dans",
	InXDays = "<<1[Aujourd'hui/En $d jour/Dans $d jours]>>",
	ActivitySchedule = "Calendrier",
	DailiesSchedule = "Quotidiennes",
	PledgesSchedule = "Serments"
}

-- This translations have to match pledge quest name in ingame journal
GAFE.DungeonPledgeQuestName = {
	[PledgeId.FungalGrottoI] = "Champignonnière I",
	[PledgeId.FungalGrottoII] = "Champignonnière II",
	[PledgeId.SpindleclutchI] = "Tressefuseau I",
	[PledgeId.SpindleclutchII] = "Tressefuseau II",
	[PledgeId.BanishedCellsI] = "Cachot interdit I",
	[PledgeId.BanishedCellsII] = "Cachot interdit II",
	[PledgeId.DarkshadeCavernsI] = "Cavernes d'Ombre-noire I",
	[PledgeId.DarkshadeCavernsII] = "Cavernes d'Ombre-noire II",
	[PledgeId.EldenHollowI] = "Creuset des aînés I",
	[PledgeId.EldenHollowII] = "Creuset des aînés II",
	[PledgeId.WayrestSewersI] = "Égouts d'Haltevoie I",
	[PledgeId.WayrestSewersII] = "Égouts d'Haltevoie II",
	[PledgeId.ArxCorinium] = "Arx Corinium",
	[PledgeId.CityOfAshI] = "Cité des cendres I",
	[PledgeId.CityOfAshII] = "Cité des cendres II",
	[PledgeId.CryptOfHeartsI] = "Crypte des cœurs I",
	[PledgeId.CryptOfHeartsII] = "Crypte des cœurs II",
	[PledgeId.DirefrostKeep] = "Donjon d'Affregivre",
	[PledgeId.TempestIsland] = "Île des Tempêtes",
	[PledgeId.Volenfell] = "Volenfell",
	[PledgeId.BlackheartHaven] = "Havre de Cœurnoir",
	[PledgeId.BlessedCrucible] = "Creuset béni",
	[PledgeId.SelenesWeb] = "Toile de Sélène",
	[PledgeId.VaultsOfMadness] = "Chambres de la folie",
	[PledgeId.BlackDrakeVilla] = "Villa du Dragon noir",
	[PledgeId.BloodrootForge] = "Forge de Sangracine",
	[PledgeId.CastleThorn] = "Bastion-les-Ronce", 
	[PledgeId.CradleOfShadows] = "Berceau des ombres",
	[PledgeId.DepthsOfMalatar] = "Profondeurs de Malatar",
	[PledgeId.FalkreathHold] = "Forteresse d'Épervine",
	[PledgeId.FangLair] = "Repaire du croc",
	[PledgeId.Frostvault] = "Arquegivre",
	[PledgeId.Icereach] = "Crève-Nève",
	[PledgeId.ImperialCityPrison] = "Prison de le cité impériale",
	[PledgeId.LairOfMaarselok] = "Repaire de Maarselok",
	[PledgeId.MarchOfSacrifices] = "Procession des Sacrifiés",
	[PledgeId.MoonHunterKeep] = "Fort du Chasseur lunaire",
	[PledgeId.MoongraveFane] = "reliquaire des Lunes funèbres",
	[PledgeId.RedPetalBastion] = "Le Bastion du Pétale Rouge",
	[PledgeId.RuinsOfMazzatun] = "Ruines de Mazzatun",
	[PledgeId.ScalecallerPeak] = "Pic de la Mandécailles",
	[PledgeId.StoneGarden] = "Jardin de pierre",
	[PledgeId.Cauldron] = "Le Chaudron",
	[PledgeId.DreadCellar] = "La Cave d'effroi",
	[PledgeId.UnhallowedGrave] = "Sépulcre profane",
	[PledgeId.WhiteGoldTower] = "Tour d'Or Blanc"
}

GAFE.PledgeChatterOptions = {
    "Quel est le serment d'aujourd'hui ?",
    "Quel est le serment, aujourd'hui ?"
}