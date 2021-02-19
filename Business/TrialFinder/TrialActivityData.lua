local GAFE = GroupActivityFinderExtensions

local ActivityId = GAFE.Constants.ActivityId
local TrialQuest = GAFE.TrialChestTimer.TrialQuest

-- https://esoitem.uesp.net/viewlog.php
GAFE.TrialActivityData={
    --Normal
    [ActivityId.NormalAetherianArchive]     = {  lf="nAA",	node=231,	q=TrialQuest.AetherianArchive,		id=990,		hm=1137,	tt=1081,	nd=false },
    [ActivityId.NormalHelRaCitadel]         = {  lf="nHRC",	node=230,	q=TrialQuest.HelRaCitadel,			id=991,		hm=1136,	tt=1080,	nd=false },
    [ActivityId.NormalSanctumOphidia]       = {  lf="nSO",	node=232,	q=TrialQuest.SanctumOphidia,		id=1123,	hm=1138,	tt=1124,	nd=false },
    [ActivityId.NormalMawOfLorkhaj]         = {  lf="nMOL",	node=258,	q=TrialQuest.MawOfLorkhaj,			id=nil },
    [ActivityId.NormalHallsOfFabrication]   = {  lf="nHOF",	node=331,	q=TrialQuest.HallsOfFabrication,	id=nil },
    [ActivityId.NormalAsylumSanctorium]     = {  lf="nAS",	node=346,	q=TrialQuest.AsylumSanctorium,		id=nil },
    [ActivityId.NormalCloudrest]            = {  lf="nCR",	node=364,	q=TrialQuest.Cloudrest,				id=nil },
    [ActivityId.NormalSunspire]             = {  lf="nSS",	node=399,	q=TrialQuest.Sunspire,				id=nil },
    [ActivityId.NormalKynesAegis]           = {  lf="nKA",	node=434,	q=TrialQuest.KynesAegis,			id=nil },
    --Veteran
    [ActivityId.VeteranAetherianArchive]     = { lf="vAA",	node=231,	q=TrialQuest.AetherianArchive,		id=1503,	hm=false,	tt=false,	nd=false },
    [ActivityId.VeteranHelRaCitadel]         = { lf="vHRC",	node=230,	q=TrialQuest.HelRaCitadel,			id=1474,	hm=870,		tt=false,	nd=false },
    [ActivityId.VeteranSanctumOphidia]       = { lf="vSO",	node=232,	q=TrialQuest.SanctumOphidia,		id=1462,	hm=false,	tt=false,	nd=false },
    [ActivityId.VeteranMawOfLorkhaj]         = { lf="vMOL",	node=258,	q=TrialQuest.MawOfLorkhaj,			id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranHallsOfFabrication]   = { lf="vHOF",	node=331,	q=TrialQuest.HallsOfFabrication,	id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranAsylumSanctorium]     = { lf="vAS",	node=346,	q=TrialQuest.AsylumSanctorium,		id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranCloudrest]            = { lf="vCR",	node=364,	q=TrialQuest.Cloudrest,				id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranSunspire]             = { lf="vSS",	node=399,	q=TrialQuest.Sunspire,				id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranKynesAegis]           = { lf="vKA",	node=434,	q=TrialQuest.KynesAegis,			id=nil,	hm=nil,	tt=nil,	nd=nil }
}