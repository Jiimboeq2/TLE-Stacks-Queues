# TLE Stacks & Queues

OgreBot cast stacks and OgreCraft craft queues for EverQuest II, by expansion.
Browse them on [isxjhub.com](https://isxjhub.com), or take them straight from here.

Every file comes in two kinds: one for the **old** OgreBot / OgreCraft and one for the **new** (Ogre's new native bot).
Use the one that matches yours.

## Cast stacks (the .zip packs)

Each pack holds the stack twice: the `.xml` for the old OgreBot and `New OgreBot/<name>.json` for the new one.
`How to install.txt` inside the pack says the same as this page.

**New OgreBot**
1. Copy the `.json` from the pack's `New OgreBot` folder into
   `C:\Program Files (x86)\InnerSpace\Scripts\OgreSave\EQ2\OgreBot\Profiles\Import`
2. In OgreBot, open the **Admin** tab and press **Refresh List**.
3. Click the profile under **Profiles you can import**, then press **Import Profile**.
   It is added beside your own profiles (renamed _1, _2 if the name is taken) and is not loaded until you pick it.

**Old OgreBot**
1. Copy the `.xml` into `C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreBot\Save\ProfilesToImport`
   (or into `C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreBot\Save`).
2. In OgreBot, open the **Admin** tab, find it there and load it; it is then in your drop down.

**With ISXJQB** (new OgreBot): type `jb csimport <EXP>` in game, e.g. `jb csimport DOF`. It takes your class's stack
for that expansion from isxjhub.com and imports it for you.

**AA builds** (the `.aa` in a pack): put it in your EverQuest II folder named `<your character>_<build name>.aa`
(the AA window lists the files that start with your character's name), then **Load** it in the game's AA window.

Scripts that come with a pack go in `C:\Program Files (x86)\InnerSpace\Scripts`.

## Craft queues (the Craft-Queues folders)

Each queue is there twice: `<name>.xml` for the old OgreCraft and `<name>.json` for the new OgreCraft.

**New OgreCraft:** copy the `.json` into `C:\Program Files (x86)\InnerSpace\Scripts\OgreSave\EQ2\Craft\queues`.
It is listed on OgreCraft's **Queues** tab under **Save / load a queue**: click its name, then **Load Queue**.
With ISXJQB, the Queues tab also has **Find on isxjhub**: every queue here, by expansion and class.

**Old OgreCraft:** copy the `.xml` into `C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreCraft\RecipeQueues`.

## Temp adorns

`C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreCommon\OgreTempAdorns`

---

These stacks are intended for isxogre but can be converted to isxri via cb import.

InnerSpace installed somewhere else? Use your own InnerSpace folder in the paths above.
