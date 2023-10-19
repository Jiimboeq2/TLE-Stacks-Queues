/*
Configure assassin cast stack in this order at the TOP of the list
Assassinate
Concealment
Stealth Assault
Jugular Slice
Eviscerate
Mortal Blade
Massacre ; this needs to be last to tell the script when we are done with the concealment attack chain
*/

function main()
{
	echo (${Time}) Assassin Companion Script 69420
	call variables
	call StealthOff
	while 1
    {
		while ${Me.InCombat}==TRUE
		{
			{
                call refresh
                call StealthOn
                while (((${Target.Type.Equal["NamedNPC"]} || ${Target.Type.Equal["NPC"]}) && ${TargetDist}<=15) || ((${Target.Target.Type.Equal["NamedNPC"]} || ${Target.Target.Type.Equal["NPC"]}) && ${TargetTargetDist}<=15))
                    wait 10
                call StealthOff
                wait 10
            }
        }

    }
}
function StealthOn()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Stealth Assault" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Jugular Slice" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Eviscerate" TRUE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Mortal Blade" TRUE TRUE
	wait 55
}
function StealthOff()
{
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Concealment" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Jugular Slice" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Eviscerate" FALSE TRUE
    OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Mortal Blade" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Assassinate" FALSE TRUE
	OgreBotAtom aExecuteAtom ${Me.Name} a_QueueCommand ChangeCastStackListBoxItem "Massacre" FALSE TRUE
	wait 25
}
function variables()
{
	declare TargetTargetDist float script
	declare TargetDist float script
	declare MimicryTime int script 0
	declare PFTtimer int script 0
	declare CombatStart uint script
	declare NewFight bool script TRUE
	declare SHTime uint global
	declare SwapTime uint global
	declare TempPrimary string Script
	declare PrimaryEth bool script FALSE
}
function refresh()
{
	TargetDist:Set[${Math.Calc[${Target.Distance}-(${Actor[${Target.ID}].CollisionRadius}*${Actor[${Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
	TargetTargetDist:Set[${Math.Calc[${Target.Target.Distance}-(${Actor[${Target.Target.ID}].CollisionRadius}*${Actor[${Target.Target.ID}].CollisionScale}+${Me.CollisionRadius}*${Me.CollisionScale})]}]
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;     LIST OF ID'S           
;	Stealth Assault		204218481                      #
;   In Plain Sight	    3633058267                     #
;   FFU V			    3051745403                     #
;   Bleedout		    872584025                      #
;   Carnage		        4179643856                     #
;   Bloodflurry 		3085956600                     #
;   Stealth Assault	    866089504                      #
;   Gut		            971949777                      #
;   Assassinate VII     1493017401                     #
;   PFT                 2305497779                     #
;   concealment         3008295138                     #
;   Eviscerate          3949617436                     #
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;