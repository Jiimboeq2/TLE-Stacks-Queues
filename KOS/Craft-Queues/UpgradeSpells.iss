variable bool bLogVerbose=FALSE

function main(int iMinLevel=1, int iMaxLevel=999, string sExportTier="none", bool bExportMaxLevelOnly=TRUE)
{
  ; Make sure we are near a depo; why are you runing this if you aren't near one?
  if ${Actor[Scroll Depot](exists)}
	{
		target ${Me.Name}
		wait 10
        ; move to depo
		ogre move loc ${Actor[Scroll Depot].X} ${Actor[Scroll Depot].Y} ${Actor[Scroll Depot].Z}
		wait 5
        ; wait until we are done moving
		while ${Script[OgreMove](exists)}
		{
			wait 5
		}
		wait 10
        ; open the depo
		Actor[Scroll Depot]:DoubleClick
		wait 10

    call LogMessage "[AbilityUpgrade]  This script uses the exported ability list from Ogre Export. Default - Last 10 levels" TRUE TRUE
    call LogMessage "[AbilityUpgrade]  Use: runscript upgradespells <minlevel> <maxlevel> <exporttier>" TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  Param: <MinLevel>, int, The minimum level you want to check for upgrades" TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  Param: <MaxLevel>, int, The maximum level you want to check for upgrades" TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  Param: <ExportTier>, string, will create a crafting list of all abilities below this value [apprentice,adept,expert,master,grandmaster,ancient]" TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  Param: <ExportMaxLevelOnly>, bool, Used with ExportTier. TRUE (default) will export highest level of each spell, FALSE will export all levels for each spell." TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  Example: runscrip upgradespells 50 70 Expert TRUE  | This will check all abilities between 50 and 70 and create a crafting export list for anything that is below Expert." TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  Example: runscrip upgradespells | This will check the last 10 levels worth of abilities, if you exported, in the scroll depot." TRUE ${bLogVerbose}
    call LogMessage "[AbilityUpgrade]  .Importing last Ogre Export ability file"

    ; create a settingset for the ability crafting export of skills below <user input> tier
    LavishSettings:AddSet[cAbilityUpgrades]
    LavishSettings[cAbilityUpgrades]:Clear

    ; import the ability export from ogre
    LavishSettings[AbilityInformation]:Clear
    LavishSettings:AddSet[AbilityInformation]
    LavishSettings[AbilityInformation]:Import["${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/Ability_Information/V2_${Me.Name}_${Me.SubClass}_${EQ2.ServerName}_AbilityExport.xml"]
    ; basic error checking for min and max range
    ; todo eventually add to check the type !(char) and make sure the min is actually lower than the max
    if ${iMinLevel} < 1
        iMinLevel:Set[1]
    if ${iMaxLevel} > 999
        iMaxLevel:Set[999]
    if ${iMaxLevel} == 999
    {
        iMinLevel:Set[${Math.Calc[${Me.Level}-10]}]
        iMaxLevel:Set[${Me.Level}]
    }

    ; using a switch to handle case insensitive inputs; will default to Expert if an unknown value is provided
    if !(${sExportTier.Equal["none"]})
    {
        Switch ${sExportTier}
        {
            case apprentice
                sExportTier:Set["Apprentice"]
                break
            case adept
                sExportTier:Set["Adept"]
                break
            case expert
                sExportTier:Set["Expert"]
                break
            case master
                sExportTier:Set["Master"]
                break
            case grandmaster
                sExportTier:Set["Grandmaster"]
                break
            case ancient
                sExportTier:Set["Ancient"]
                break
            default
                sExportTier:Set["Expert"]
        }
    }
    ; converting tier values to integers for simpler calculations in the script of which is tier is 'lower' than another tier
    variable int iExportTier
    variable int iActualTier
    call ConvertTierToINT "${sExportTier}"
    iExportTier:Set[${Return}]

    ; variables to hold the values for the 'highest level' of an ability
    variable string sHighestLevelAbilityName="none"
    variable string sHighestLevelAbilityTier="none"
    variable int iHighestLevelAbilityLevel=0

    ; setup our variables for processing the abilities and load the abilities for our class
    variable settingsetref setSpell
    variable settingsetref spell
    setSpell:Set[${LavishSettings[AbilityInformation].FindSet[${Me.SubClass}]}]
    ; setup our iteration variables
    variable uint ID
    variable collection:string spells
    variable iterator SpellSetIterator
    variable iterator SpellIterator
    setSpell:GetSetIterator[SpellSetIterator]

    ;variables for scroll depo searching and temporary storage of ability details
    variable string cAbilityName = None
    variable string cTier = Apprentice
    variable string sDesiredTier = Adept
    variable bool bAbilityFound = FALSE

    call LogMessage "[AbilityUpgrade]  .Checking spells between ${iMinLevel} and ${iMaxLevel}" FALSE TRUE

    ; each ability has a 'set' that contains each version of the ability.  We will step through each set one at a time.
    if ${SpellSetIterator:First(exists)}
    {
      do
      {
        ; Now that the set is loaded, lets step through each ability version within the set; ie I, II, III, IV, V, VI, ect...
        spell:Set[${setSpell.FindSet[${SpellSetIterator.Key}]}]
        spell:GetSettingIterator[SpellIterator]
        if ${SpellIterator:First(exists)}
        {
          ; If export max level; Maxreset the highest level of the set back to level 0
          iHighestLevelAbilityLevel:Set[0]
          do
          {
            ; check to make sure the ability has a level attached.  All of the abilities we want to search in the depo will have a level attached.
            if ${spell[${SpellIterator.Key}].FindAttribute[Level](exists)}
            {
              ; validate the level range of the ability against user input
              ; todo, combine with the above level check, no need to do it twice
              if ${spell[${SpellIterator.Key}].FindAttribute[Level]} >= ${iMinLevel} && ${spell[${SpellIterator.Key}].FindAttribute[Level]} <= ${iMaxLevel}
              {
                ; note: we may not need the cache since we are pulling in the ogre export; should test
                ; configure our variables with the ability details
                bAbilityFound:Set[FALSE]
                cAbilityName:Set[${SpellIterator.Key}]
                cTier:Set[${spell[${SpellIterator.Key}].FindAttribute[Tier]}]
                call LogMessage "[AbilityUpgrade]  .Processing (Tier: ${cTier}, Name: ${cAbilityName})" TRUE
                ; step through some if statements. We check the highest tier match in the box first and use a boolean flag to determine if we have found a matching ability.
                ; one found, we flip our bool and skip checking for lower tier upgrades of the same ability.
                if !${bAbilityFound} && (${cTier.Equal["Grandmaster"]} || ${cTier.Equal["Master"]} || ${cTier.Equal["`"]} || ${cTier.Equal["Adept"]} || ${cTier.Equal["Apprentice"]})
                {
                    sDesiredTier:Set[Ancient]
                    call LogMessage "[AbilityUpgrade]    Checking for ${sDesiredTier} in the Box" ${bLogVerbose}
                    if ${ContainerWindow.Item["${cAbilityName} (${sDesiredTier})"](exists)}
                    {
                        call GrabFromDepot "${cAbilityName}" "${sDesiredTier}"
                        if ${Return}
                        {
                            bAbilityFound:Set[TRUE]
                        }
                    }
                    
                }
                if !${bAbilityFound} && (${cTier.Equal["Master"]} || ${cTier.Equal["Expert"]} || ${cTier.Equal["Adept"]} || ${cTier.Equal["Apprentice"]})
                {
                    sDesiredTier:Set[GrandMaster]
                    call LogMessage "[AbilityUpgrade]  ..Checking for ${sDesiredTier} in the Box" ${bLogVerbose}
                    if ${ContainerWindow.Item["${cAbilityName} (${sDesiredTier})"](exists)}
                    {
                        call GrabFromDepot "${cAbilityName}" "${sDesiredTier}"
                        if ${Return}
                        {
                            bAbilityFound:Set[TRUE]
                        }
                    }
                }
                if !${bAbilityFound} && (${cTier.Equal["Expert"]} || ${cTier.Equal["Adept"]} || ${cTier.Equal["Apprentice"]})
                {
                    sDesiredTier:Set[Master]
                    call LogMessage "[AbilityUpgrade]  ..Checking for ${sDesiredTier} in the Box" ${bLogVerbose}
                    if ${ContainerWindow.Item["${cAbilityName} (${sDesiredTier})"](exists)}
                    {
                        call GrabFromDepot "${cAbilityName}" "${sDesiredTier}"
                        if ${Return}
                        {
                            bAbilityFound:Set[TRUE]
                        }
                    }
                }
                if !${bAbilityFound} && (${cTier.Equal["Adept"]} || ${cTier.Equal["Apprentice"]})
                {
                    sDesiredTier:Set[Expert]
                    call LogMessage "[AbilityUpgrade]  ..Checking for ${sDesiredTier} in the Box" ${bLogVerbose}
                    if ${ContainerWindow.Item["${cAbilityName} (${sDesiredTier})"](exists)}
                    {
                        call GrabFromDepot "${cAbilityName}" "${sDesiredTier}"
                        if ${Return}
                        {
                            bAbilityFound:Set[TRUE]
                        }
                    }
                }
                if !${bAbilityFound} && (${cTier.Equal["Apprentice"]})
                {
                    sDesiredTier:Set[Adept]
                    call LogMessage "[AbilityUpgrade]  ..Checking for ${sDesiredTier} in the Box" ${bLogVerbose}
                    if ${ContainerWindow.Item["${cAbilityName} (${sDesiredTier})"](exists)}
                    {
                        call GrabFromDepot "${cAbilityName}" "${sDesiredTier}"
                        if ${Return}
                        {
                            bAbilityFound:Set[TRUE]
                        }
                    }
                }
                ; export all abilities below the ExportTier
                if !${bExportMaxLevelOnly} && !${sExportTier.Equal["none"]}
                {
                    call AddSettingsToSet "${cAbilityName}" "${cTier}" ${iExportTier}
                    call LogMessage "[AUCraftingExport]  Adding Ability to Export Set: ${cAbilityName} (${cTier})" ${bLogVerbose} FALSE
                }
              }
            }
            ; If export max level; we will check each ability to find the highest level of that ability and store them as temporary variables
            if (${bExportMaxLevelOnly} && !${sExportTier.Equal["none"]})
            {
                if ${iHighestLevelAbilityLevel} < ${spell[${SpellIterator.Key}].FindAttribute[Level]}
                {
                    call LogMessage "[AUCraftingExport]  New Highest Value found: ${sHighestLevelAbilityName} (${sHighestLevelAbilityTier}): Previous Level: ${iHighestLevelAbilityLevel}, New Level: ${spell[${SpellIterator.Key}].FindAttribute[Level]}" ${bLogVerbose} FALSE
                    sHighestLevelAbilityName:Set[${cAbilityName}]
                    sHighestLevelAbilityTier:Set[${cTier}]
                    iHighestLevelAbilityLevel:Set[${spell[${SpellIterator.Key}].FindAttribute[Level]}]
                }
            }            
          }
          ; step through to the next ability level in the set
          while ${SpellIterator:Next(exists)}
        }
        ; If export max level; once the set is complete, store the highest level into the Settings Set from our temporary variable
        if !(${sExportTier.Equal["none"]}) && ${bExportMaxLevelOnly}
        {
            call LogMessage "Adding highest level to the crafting ability set: ${sHighestLevelAbilityName} ${sHighestLevelAbilityTier} ${iExportTier}" ${bLogVerbose} FALSE
            call AddSettingsToSet "${sHighestLevelAbilityName}" "${sHighestLevelAbilityTier}" ${iExportTier}
        }
      }
      while ${SpellSetIterator:Next(exists)}
    }
    ; close the depot
    eq2execute container deposit_all ${Actor[Scroll Depot].ID} 0
    wait 10
    EQ2UIPage[Inventory,container].Child[button,Container.WindowFrame.Close]:LeftClick
    if !(${sExportTier.Equal["none"]})
    {
        variable iterator SettingIterator
        LavishSettings[cAbilityUpgrades]:GetSettingIterator[SettingIterator]
        call LogMessage "[AUCraftingExport]  Exporting the following abilities to a crafting list"
        if ${SettingIterator:First(exists)}
        {
            do
            {
                echo "${SettingIterator.Key}, ${SettingIterator.Value}"
            }
            while "${SettingIterator:Next(exists)}"
        }
        call LogMessage "[AUCraftingExport]  Ogre crafting list for ${Me.Name}: ${LavishScript.HomeDirectory}/Scripts/EQ2OgreCraft/RecipeQueues/${Me.Name}-${Me.Class}.xml"
        LavishSettings[cAbilityUpgrades]:Export[${LavishScript.HomeDirectory}/Scripts/EQ2OgreCraft/RecipeQueues/${Me.Name}-${Me.Class}.xml]
    }
  }
  else
  {
      call LogMessage "[AbilityUpgrade]  .No Scroll Depot detected.  Please ensure you have one nearby." TRUE TRUE TRUE
  }
}

atom atexit()
{
  LavishSettings[AbilityInformation]:Clear
  ;call LogMessage "[AbilityUpgrade]  Note: You may have pulled abilities with the similar name but wrong class.  Please check and place back in the depot." TRUE TRUE ${bDingComplete}
  ;call LogMessage "[AbilityUpgrade]  Note: You should rerun -ogre export- if this script upgraded any abilities" TRUE TRUE ${bDingComplete}
  call LogMessage "[AbilityUpgrade]  End: UpgradeSpells" TRUE TRUE ${bDingComplete}
}

function:bool GrabFromDepot(string abilityName, string tierLevel)
{
	; remove the matching spell from the depot
    call LogMessage "[AbilityUpgrade]  	     - Upgrade found for ${abilityName} (${tierLevel})" ${bLogVerbose} FALSE
    ContainerWindow:RemoveItem[${ContainerWindow.Item[${abilityName} (${tierLevel})].ID},1]
	wait 10
    ; check inventory and scribe the spell
	if ${Me.Inventory["${abilityName} (${tierLevel})"](exists)}
	{
		call LogMessage "[AbilityUpgrade]  	     - Successfully removed ${abilityName} (${tierLevel}) from the box" ${bLogVerbose} FALSE
        call LogMessage "[AbilityUpgrade]  	     - Upgrading ${abilityName} - ${tierLevel}" ${bLogVerbose} FALSE
		Me.Inventory["${abilityName} (${tierLevel})"]:Scribe
		wait 10
        ;// We can export after each upgrade, but it restarts Ogre in the process.  Would be better to do it once complete.
        call LogMessage "[AbilityUpgrade]  	     - ${Me.Name} - Successfully tried to upgrade ${abilityName}, updating ogre export" ${bLogVerbose} FALSE
        if ${tierLevel.Equal["Master"]}
        {
            ogre export "${abilityName}" -noreloadbot
            wait 30
        }
        return TRUE
	}
}

function LogMessage(string sMessage="missing message", bool bLogToISConsole=TRUE, bool bLogToOC=FALSE, bool bDing=FALSE, bool bLoud=FALSE)
{
    if ${bLogToISConsole}
    {
        echo ${sMessage}
    }
    if ${bLogToOC} && !${bDing}
    {
        oc ${sMessage}
    }
    if ${bDing}
    {
        OgreBotAPI:Message[${Me.Name}, ${sMessage}, TRUE]
    }
    if ${bLoud}
    {
        OgreBotAPI:Message[${Me.Name}, ${sMessage}, TRUE, loud]
    }    
}

function:int ConvertTierToINT(string sTier="missing")
{
    variable int iTier
    Switch ${sTier}
    {
        case Apprentice
            iTier:Set[0]
            break
        case Adept
            iTier:Set[1]
            break
        case Expert
            iTier:Set[2]
            break
        case Master
            iTier:Set[3]
            break
        case Grandmaster
            iTier:Set[4]
            break
        case Ancient
            iTier:Set[5]
            break
        default
            iTier:Set[2]
    }
    call LogMessage "[Debug:ConvertTierToINT] Conversion returning value ${iTier}" ${bLogVerbose} FALSE
    return ${iTier}
}

function AddSettingsToSet(string sAbilityName, string sAbilityTier, int iExportTierCompare)
{
    variable int iActualTier
    call LogMessage "[Debug:AddSettingsToSet]  Processing ${sAbilityName} (${sAbilityTier}) ${iExportTierCompare}" ${bLogVerbose} FALSE
    call ConvertTierToINT "${sAbilityTier}"
    iActualTier:Set[${Return}]
    call LogMessage "[Debug:AddSettingsToSet]  Received AbilityTierConversion ${iActualTier}" ${bLogVerbose} FALSE
    if ${iActualTier} < ${iExportTierCompare}
    {
        call LogMessage "[AUCraftingExport]  Adding [${sAbilityName} (${sAbilityTier}),1] to the Settings Set" ${bLogVerbose} FALSE
        call LogMessage "[AUCraftingExport]  .Actual Tier ${iActualTier}, Export Tier ${iExportTierCompare}" ${bLogVerbose} FALSE
        LavishSettings[cAbilityUpgrades]:AddSetting["${sAbilityName} (Expert)",1]
    }
}