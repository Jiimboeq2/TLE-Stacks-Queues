;Noxious Grasp = 1445084966
;Draconic Breath = 3514428257
;Silent Talon = 1098690833
;Brutal Beatdown = 1293186266
;Shadow Leap = 537731132
;Savage ravaging = 1565311848
;Unchained Ferocity = 542764934
function main()
{
	call variables
	call InitializeCaststack
	call refresh
	
	while 1
	{
		while ${Me.InCombat}==TRUE
		{
			call refresh
			while (((${Target.Type.Equal["NamedNPC"]}==TRUE || ${Target.Type.Equal["NPC"]}==TRUE) && ${TargetDist}<=5) || ((${Target.Target.Type.Equal["NamedNPC"]}==TRUE || ${Target.Target.Type.Equal["NPC"]}==TRUE) && ${TargetTargetDist}<=5)) && ${Me.InCombat}==TRUE
			{
				if ${Me.GetGameData[Self.SavageryLevel].Label}==6 && ${Me.Maintained[Unchained](exists)}==FALSE
				{
					if (${Me.Ability[id, 1445084966].IsReady}==TRUE || ${Me.Ability[id, 3514428257].IsReady}==TRUE || ${Me.Ability[id, 1098690833].IsReady}==TRUE || ${Me.Ability[id, 1293186266].IsReady}==TRUE || ${Me.Ability[id, 537731132].IsReady}==TRUE || ${Me.Ability[id, 3514428257].IsReady}==TRUE) && ${Me.InCombat}==TRUE
					{
						call PrebuffOn
						wait 15
						call PrimalOn
						while ${Me.InCombat}==TRUE && (${Me.Ability[id, 1445084966].TimeUntilReady}<=5 || ${Me.Ability[id, 3514428257].TimeUntilReady}<=5 || ${Me.Ability[id, 1098690833].TimeUntilReady}<=5 || ${Me.Ability[id, 1293186266].TimeUntilReady}<=5 || ${Me.Ability[id, 537731132].TimeUntilReady}<=5 || ${Me.Ability[id, 3514428257].TimeUntilReady}<=5)
						{
							wait 10
						}
						wait 10
						call AllOff
					}
				}
				;This still needs id's, but Unchained Ferocity is not in the current AA spec, so I am commenting out.
				;if ${Me.Ability[Unchained Ferocity].IsReady}==TRUE && echo ${Me.GetGameData[Self.SavageryLevel].Label}<=5 && echo ${Me.GetGameData[Self.SavageryLevel].Label}>=1
				;{
				;	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Unchained Ferocity" TRUE TRUE
				;	wait 10
				;	while (${Me.Ability[Unchained Ferocity].IsReady}==TRUE || ${Me.Maintained[Unchained](exists)}==TRUE) && ${Me.InCombat}==TRUE
				;	{
				;			OgreBotAtom a_CastFromUplink ${Me.Name} "Feral Rending" TRUE
				;			wait 7
				;	}
				;	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Unchained Ferocity" TRUE TRUE
				;}
				wait 5
				call refresh
			}
			wait 7
		}
		wait 10
	}
}

function PrebuffOn()
{
	;commenting out, add what ever item you want below.
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Unchained Ferocity" TRUE TRUE
	if ${Math.Calc[${Time.SecondsSinceMidnight}-${MimicryTime}]}>=90
	{
		MimicryTime:Set[${Time.SecondsSinceMidnight}]
		irc !c all -CastOn all "Temporal Mimicry" ${Me.Name}
		relay all OgreBotAtom a_CastFromUplink All "Combat Mastery"
		relay all OgreBotAtom a_CastFromUplinkOnPlayer All "Temporal Mimicry" ${Me.Name}
		echo (${Time})#Mimicry!
	}
}
function PrimalOn()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savagery Freeze"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Primal Assault"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savage Howl"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Noxious Grasp"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Sonic Screech"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Draconic Breath"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Silent Talon"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Brutal Beatdown"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shadow Leap"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savage Ravaging"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Draconic Breath"  TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savage Ravaging"  TRUE TRUE
}
function AllOff()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Dragon Claws"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savagery Freeze"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Primal Assault"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savage Howl"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Noxious Grasp"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Sonic Screech"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Draconic Breath"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Silent Talon"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Brutal Beatdown"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Shadow Leap"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Savage Ravaging"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Draconic Breath"  FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Fabled Awakened Effigy of Vyemm's Power" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Revenant's Call" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Item:Spiteful Archaic Idol" FALSE TRUE
}
function variables()
{
	declare TargetTargetDist float script
	declare TargetDist float script
	declare MimicryTime int script 0
}
function refresh()
{
	TargetDist:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
	TargetTargetDist:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
}
function InitializeCaststack()
{
	call AllOff
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Unchained Ferocity" FALSE TRUE
}