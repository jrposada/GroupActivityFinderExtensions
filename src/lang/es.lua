local GAFE = GroupActivityFinderExtensions




SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_TRIAL], "Normal", 1)
SafeAddString(_G["SI_LFGACTIVITY" .. GAFE_LFG_ACTIVITY_MASTER_TRIAL], "Veterano", 1)

GAFE.Localization = {
    Settings_Description = "Añade un poco más de funcionalidad e información a la IU de «Grupo» y «Buscador de actividades».", -- MACHINE TRANSLATION, REVIEW
    Settings_AutoConfirm = "Botón de «Confirmar autom.»",
    Settings_AutoConfirmDelay = "Retraso de «Confirmar autom.»",
    Settings_LoopQueueCompletedNotification = "Repetir el sonido de una actividad encontrada", -- MACHINE TRANSLATION, REVIEW
    Settings_TrialsChest = "Restablecer los temporizadores del cofres", -- MACHINE TRANSLATION, REVIEW
    Settings_ResetChestWarning = "¡Esto reiniciará el temporizador a una semana!", -- MACHINE TRANSLATION, REVIEW
    Settings_AutoMarkPledges = "Marcar autom. los compromisos disponibles", -- MACHINE TRANSLATION, REVIEW
    Settings_MarkPledgesWithIcon = "Utilizar el icono para los compromisos", -- MACHINE TRANSLATION, REVIEW
    Settings_TextureSize = "Tamaño del icono",
    Settings_AutoInvite = "BETA Invitación automática",
    Settings_HandleQuest = "Aceptar automáticamente la misión de compromiso", -- MACHINE TRANSLATION, REVIEW
    Settings_CompatibilityTitle = "Compatibilidad",
    Settings_PerfectPixelAddon = "PerfectPixel",
    Settings_ResetPremiumRewards = "Restablecer los temporizadores premium", -- MACHINE TRANSLATION, REVIEW
    Settings_ResetReward = "Esto restablecerá el temporizador de 20 horas", -- MACHINE TRANSLATION, REVIEW
    Settings_Difficulty = "Modo de dificultad",
    CheckActivePledges = "Compromisos",
    CheckMissingQuests = "Misiones",
    CheckMissingSets = "Conjuntos",
    AutoConfirm = "Confirmar autom.",
    TrialsCategoryHeader = "Pruebas",
    TrialsSpecificFilterText = "Pruebas concretos",
    TrialAetherianArchive = "Archivo Aetérico",
    TrialHelRaCitadel = "Ciudadela de Hel Ra",
    TrialSanctumOphidia = "Sanctum Ophidia",
    TrialMawOfLorkhaj = "Fauces de Lorkhaj",
    TrialHallsOfFabrication = "Salones de Fabricación",
    TrialAsylumSanctorium = "Santuario del Amparo",
    TrialCloudrest = "Nubelia",
    TrialSunspire = "Cúspide del Sol",
    TrialKynesAegis = "Égida de Kyne",
    TrialRockgrove = "Arboleda Pétrea",
    TrialDreadsailReef = "Arrecife Temible",
    LookForGroup = "LFG",
    LookForMore = "LFM",
    LookForGroupDisabled = "Ya estás en un grupo",
    LookForMoreDisabled = "Debes ser líder del grupo",
    AutoInvite = "Invitación automática",
    Debug_QueuedList = "Queued: ",
    Debug_NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Grupo",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Veteranía",
    NextReward = "Siguiente en",
    InXDays = "<<1[Hoy/En $d día/En $d días]>>",
    ActivitySchedule = "Programación",
    DailiesSchedule = "Diarias",
    PledgesSchedule = "Compromisos"
}

--- This translations have to match pledge quest name in ingame journal
GAFE_DUNGEON_PLEDGE_QUEST_NAME = {
    [GAFE_PLEDGE_ID.FungalGrottoI] = "Gruta de los Hongos 1",
    [GAFE_PLEDGE_ID.FungalGrottoII] = "Gruta de los Hongos 2",
    [GAFE_PLEDGE_ID.SpindleclutchI] = "El Espiráculo I",
    [GAFE_PLEDGE_ID.SpindleclutchII] = "El Espiráculo II",
    [GAFE_PLEDGE_ID.BanishedCellsI] = "Celdas del Destierro I",
    [GAFE_PLEDGE_ID.BanishedCellsII] = "Celdas del Destierro II",
    [GAFE_PLEDGE_ID.DarkshadeCavernsI] = "Cavernas Sombra Oscura 1",
    [GAFE_PLEDGE_ID.DarkshadeCavernsII] = "Cavernas Sombra Oscura II",
    [GAFE_PLEDGE_ID.EldenHollowI] = "Hondonada de Elden 1",
    [GAFE_PLEDGE_ID.EldenHollowII] = "Hondonada de Elden 2",
    [GAFE_PLEDGE_ID.WayrestSewersI] = "Cloacas de Quietud 1",
    [GAFE_PLEDGE_ID.WayrestSewersII] = "Cloacas de Quietud 2",
    [GAFE_PLEDGE_ID.ArxCorinium] = "Arx Corinium",
    [GAFE_PLEDGE_ID.CityOfAshI] = "Ciudad de Ceniza I",
    [GAFE_PLEDGE_ID.CityOfAshII] = "Ciudad de Ceniza II",
    [GAFE_PLEDGE_ID.CryptOfHeartsI] = "Cripta de los Corazones 1",
    [GAFE_PLEDGE_ID.CryptOfHeartsII] = "Cripta de los Corazones 2",
    [GAFE_PLEDGE_ID.DirefrostKeep] = "Bastión Escarcha Aviesa",
    [GAFE_PLEDGE_ID.TempestIsland] = "Isla de la Tempestad",
    [GAFE_PLEDGE_ID.Volenfell] = "Volenfell",
    [GAFE_PLEDGE_ID.BlackheartHaven] = "Refugio del Corazón Negro",
    [GAFE_PLEDGE_ID.BlessedCrucible] = "Crisol Sagrado",
    [GAFE_PLEDGE_ID.SelenesWeb] = "Telaraña de Selene",
    [GAFE_PLEDGE_ID.VaultsOfMadness] = "Cámaras de la Locura",
    [GAFE_PLEDGE_ID.BlackDrakeVilla] = "Villa del Draco Negro",
    [GAFE_PLEDGE_ID.BloodrootForge] = "Forja Sanguinaria",
    [GAFE_PLEDGE_ID.CastleThorn] = "Castillo Espina",
    [GAFE_PLEDGE_ID.Cauldron] = "El Caldero",
    [GAFE_PLEDGE_ID.CoralAerie] = "Nido de Coral",
    [GAFE_PLEDGE_ID.CradleOfShadows] = "Cuna de Sombras",
    [GAFE_PLEDGE_ID.DepthsOfMalatar] = "Profundidades de Malatar",
    [GAFE_PLEDGE_ID.DreadCellar] = "el Sótano Pavoroso",
    [GAFE_PLEDGE_ID.EarthenRootEnclave] = "Enclave de Raíz Terrosa",
    [GAFE_PLEDGE_ID.FalkreathHold] = "Comarca de Falkreath",
    [GAFE_PLEDGE_ID.FangLair] = "Guarida de los Colmillos",
    [GAFE_PLEDGE_ID.Frostvault] = "Cripta Helada",
    [GAFE_PLEDGE_ID.GravenDeep] = "Sima Mortuoria",
    [GAFE_PLEDGE_ID.Icereach] = "Cuenca Glacial",
    [GAFE_PLEDGE_ID.ImperialCityPrison] = "Prisión de la Ciudad Imperial",
    [GAFE_PLEDGE_ID.LairOfMaarselok] = "Guarida de Maarselok",
    [GAFE_PLEDGE_ID.MarchOfSacrifices] = "Marcha de los Sacrificios",
    [GAFE_PLEDGE_ID.MoonHunterKeep] = "Bastión del Cazador de la Luna",
    [GAFE_PLEDGE_ID.MoongraveFane] = "Sepulcro Lunar",
    [GAFE_PLEDGE_ID.RedPetalBastion] = "Bastión del Pétalo Rojo",
    [GAFE_PLEDGE_ID.RuinsOfMazzatun] = "Ruinas de Mazzatun",
    [GAFE_PLEDGE_ID.ScalecallerPeak] = "Cumbre de la Invocadora de Escamas",
    [GAFE_PLEDGE_ID.ShipwrightsRegret] = "el Lamento del Armador",
    [GAFE_PLEDGE_ID.StoneGarden] = "Jardín de Piedra",
    [GAFE_PLEDGE_ID.UnhallowedGrave] = "Sepulcro Profano",
    [GAFE_PLEDGE_ID.WhiteGoldTower] = "Torre Blanca y Dorada"
}

GAFE_PLEDGE_NPC_NAME = {
    ["Maj al-Ragath"] = true,
    ["Glirion el Barbarroja"] = true,
    ["Urgarlag la Castradora"] = true,
}
