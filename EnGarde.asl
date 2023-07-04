/*
Values are actually loaded object count? But they're consistent so should work.
Level IDs:
24 = Main Menu
427 = 1st Cutscene
501 = level1 (Tutorial)
578 = level2 (First Trial)
575 = level2.2 (changes on dodge/box tutorial)
539 = level3 (Docks)
517 = level4 (Escape)
531 = level5 (Final Fight)
413 = EndCutscene
*/

state("EnGarde-Win64-Shipping")
{
	bool loading : 0x074BF4D0, 0x108, 0x78;
    int levelId : 0x74A0EF8, 0x30, 0x18;
}

startup
  {
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | En Garde!",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    // To prevent double/triple splits that happen quite often, loaded instead of completed so resetting can be done more easily
    vars.loadedLevels = new HashSet<int>();
    vars.Levels = new List<int>() {501, 575, 539, 517, 531};
}

onStart {
    vars.loadedLevels.Clear();
}

isLoading
{
	return current.loading;
}

start {
    // Old method: started on cutscene, but bad for RTA & verification
    //return !current.loading && old.levelId == 24 && current.levelId == 427;

    return current.loading && current.levelId == 24;
}

split {
    return
        (old.levelId != current.levelId && vars.loadedLevels.Add(current.levelId) && vars.Levels.Contains(old.levelId) && current.levelId != 24)
        || (!old.loading && current.loading && current.levelId == 531); // Final split
}

reset {
    return current.levelId == 24 && vars.loadedLevels.Contains(501);
}

update
{
//DEBUG CODE
/*
if (old.levelId != current.levelId) {
    print("Transition: " + old.levelId.ToString() + " -> " + current.levelId.ToString());
}*/
//print(current.levelId.ToString() + " " + current.loading.ToString());
//print("Current Mission is " + current.mission.ToString());
//print(modules.First().ModuleMemorySize.ToString());
}
