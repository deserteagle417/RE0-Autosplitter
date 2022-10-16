/*
By deserteagle417
Thanks to 0_yami_0 for making the original autosplitter which I used as a base for this.
Thanks to CursedToast for several pointers while making this and to Mysterion for inspiring 
some of the ideas here with the FF7R ASL script as well as contributions to this script, in 
particular the item splitter.
Tnanks to Mogul for testing several early drafts. Thanks to Keys for testing the later drafts 
and for doing a run so I could track room IDs along the route. Thanks to Pessimism for testing 
the pre-release version and giving some route feedback.
*/

state("re0hd")
{
	float time     : 0x9CDE9C, 0x3C;
	int roomIdCur  : 0x9CE070, 0x1FD4;
	int roomIdNext : 0x9CDEB8, 0x20;
	int cutsceneId : 0x9CE008, 0x20;
	byte menuId    : 0xA31688, 0x94, 0x14, 0x88, 0x14, 0xC;
	//byte menuId    : 0xA2F414, 0xD74, 0x14, 0x8, 0x34, 0xC, 0x47C;
	int activeHP   : 0x9CDF3C, 0x2C, 0x1030;
}

startup
{
	//Variables for our settings
	vars.KeyItems = new List<int>()
    {22, 103,  65, 125,  82,  59,  57, 104, 122,  58,
     75,  77,  86,   6, 133,   7, 132,  68,  63,  99,
	 88, 126, 130, 121, 100, 124,  89, 131, 120,  70,
	 79,  83,  80,  94,  81, 117,  71,  92,  72,  96,
	 66, 118,  93,  10,  73,  67,  87,  97, 129, 128,
	 95,  76, 102, 127};
	
	vars.KeyWeapons = new List<int>()
	{5, 17, 19};

	vars.EventSettingsValues = new List<String>()
	{"Scorp", "Clock", "Event36", "Event91", "Event90", "Event43", "Bat", "Hntrs", "Event111", "Event134", "Crate", "Event160", "Event174", "Event164"};

	vars.KeyItemSettings = new List<String>()
	{"Magnum Revolver (NG+)", "Dining Car Key", "Conductors Key", "Ice Pick", "Panel Opener", "Briefcase", "Gold Ring", "Hookshot", "Jewelery Box", "Silver Ring", 
	 "Blue Keycard", "Magnetic Card", "Crank Handle", "Shotgun", "Black Statue", "Grenade Launcher", "White Statue", "Fire Key", "Lighter Fluid", "Microfilm A", 
	 "Book of Good", "Iron Needle", "Angel Wings", "Statue of Good", "Microfilm B", "MO Disk", "Book of Evil", "Black Wing", "Statue of Evil", "Water Key", 
	 "Unity Tablet", "Vise Handle", "Obedience Tablet", "Battery", "Discipline Tablet", "Leech Capsule", "Blue Leech Charm", "Input Reg. Coil", "Green Leech Charm", "Sterlizing Agent", 
	 "Breeding Room Key", "Dial", "Output Reg. Coil", "Magnum (NG)", "Up Key", "Elevator Key", "Handle", "Motherboard", "Empty Battery", "Industrial Water", 
	 "Hi-Power Battery", "Keycard", "Shaft Key (L)", "Shaft Key (R)"};

	vars.KeyWeaponSettings = new List<String>()
	{"Hunting Gun", "Custom Handgun (Billy)", "Custom Handgun (Rebecca)"};

	vars.EventSettings = new List<String>()
	{"Scorpion", "Clock", "Center 1", "Rebecca Saved", "Underground", "Center 2", "Bat", "Cage Hunters", "Labratory", "Tyrant 1", "Crates", "Tyrant 2", "Treatment Plant", "Queen Leech 1"};
	
	settings.Add("tooltip", false, "Hover over splits below for further information.");
	//Event Split Options
	settings.Add("event", false, "Event Splits (Check below which events to split on)");
        settings.CurrentDefaultParent = "event";
		for(int i = 0; i < 14; i++){
        	settings.Add("" + vars.EventSettingsValues[i].ToString(), false, "" + vars.EventSettings[i].ToString());
    	}
		settings.SetToolTip("Scorp", "Splits upon going down ladder after scorpion fight. Will only split if you have the Panel Opener (either character).");
		settings.SetToolTip("Clock", "Splits upon leaving room after completing the clock puzzle. Requires you to have the Book of Good, Angel Wings, or Statue of Good in your inventory (either character) to split.");
		settings.SetToolTip("Event36", "Splits upon entering the underground.");
		settings.SetToolTip("Event91", "Splits upon leaving room after saving Rebecca.");
		settings.SetToolTip("Event90", "Splits upon leaving the underground from the 6 animal torch room.");
		settings.SetToolTip("Event43", "Splits upon exiting the training center toward the church.");
		settings.SetToolTip("Bat", "Splits upon using hookshot after bat fight.");
		settings.SetToolTip("Hntrs", "Splits upon leaving room after getting dial. Will only split if you have the dial (either character).");
		settings.SetToolTip("Event111", "Splits upon exiting tram after riding it.");
		settings.SetToolTip("Event134", "Splits upon entering elevator after first Tyrant fight.");
		settings.SetToolTip("Crate", "Splits upon leaving crate puzzle room. Will only split if you have the Handle in your inventory (either character).");
		settings.SetToolTip("Event160", "Splits upon climbing the ladder after the second Tyrant fight.");
		settings.SetToolTip("Event174", "Splits upon entering door to first Queen Leech fight.");
		settings.SetToolTip("Event164", "Splits upon entering dual key door.");
        settings.CurrentDefaultParent = null;
    
    //Cutscene Split Options
	settings.Add("cutscene", false, "Cutscene Splits (Check below which cutscenes to split on)");
        settings.CurrentDefaultParent = "cutscene";
		settings.Add("Train", false, "Train (Will not function with door splits active.)");
		settings.SetToolTip("Train", "Splits after train brake is pulled.");
		settings.Add("Centi", false, "Centipede");
		settings.SetToolTip("Centi", "Splits on centipede death cutscene.");
        settings.CurrentDefaultParent = null;

	//Item Split Options
	settings.Add("item", false, "Item Splits (Check below which items to split on)");
		settings.CurrentDefaultParent = "item";
		for(int i = 0; i < 54; i++){
        	settings.Add("" + vars.KeyItems[i].ToString(), false, "" + vars.KeyItemSettings[i].ToString());
    	}
		settings.CurrentDefaultParent = null;

	//Weapon Split Options
	settings.Add("weapon", false, "Unused Weapons (These aren't used normally, but are available to split on if you wish.)");
		settings.CurrentDefaultParent = "weapon";
		for(int i = 0; i < 3; i++){
        	settings.Add("" + vars.KeyWeapons[i].ToString(), false, "" + vars.KeyWeaponSettings[i].ToString());
    	}
		settings.CurrentDefaultParent = null;

    //Enable Door Splits
	settings.Add("doors", false, "Enable Door Splits. Only use one! Event splits and train cutscene split will not function if this box is checked.");
        settings.CurrentDefaultParent = "doors";
		settings.Add("NG", false, "New Game Door Splits (221 total splits)");
		settings.Add("NGDS", false, "New Game (Door Skip) Door Splits (223 total splits)");
		settings.Add("NGP", false, "New Game+/Wesker Mode Door Splits (223 total splits)");
		settings.Add("NGPDS", false, "New Game+/Wesker Mode (Door Skip) Door Splits (227 total splits)");
        settings.Add("Basic", false, "Basic Door Splits");
        settings.SetToolTip("Basic", "Splits on every door transition.");
        settings.CurrentDefaultParent = null;

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {        
        var timingMessage = MessageBox.Show (
            "This game uses In-Game Time (IGT) as the timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier.",
            "LiveSplit | Resident Evil Zero",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question);
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    vars.completedSplits = new List<string>();
	vars.completedSplitsInt = new List<int>();
	current.InventoryBilly = new byte[6];
	current.InventoryRebecca = new byte[6];
	vars.doorIterator = 0;

	//Door Skip room reload exception variables
	vars.scorpionReload = 0;
	vars.boxReload = 0;

    //Event splits
    vars.eventsCur = new List<int>()
    {36, 91, 90, 43, 111, 134, 160, 174, 164};

    vars.eventsNext = new List<int>()
    {86, 90, 42, 99, 132, 166, 159, 164, 173};

	//NG Door Splits
    vars.NGDoors = new List<Tuple<int, int, int>>
    {
		//Train - 42 doors
		Tuple.Create( 7,  6,  0), Tuple.Create( 6,  2,  1), Tuple.Create( 2,  6,  2), Tuple.Create( 6,  7,  3), Tuple.Create( 7,  8,  4),
		Tuple.Create( 8, 15,  5), Tuple.Create(15, 17,  6), Tuple.Create(15,  8,  7), Tuple.Create( 8,  7,  8), Tuple.Create( 7,  6,  9), //10
		Tuple.Create( 6,  2, 10), Tuple.Create( 2,  3, 11), Tuple.Create( 3, 11, 12), Tuple.Create(11, 12, 13), Tuple.Create(12, 11, 14), 
		Tuple.Create(11,  3, 15), Tuple.Create( 3,  2, 16), Tuple.Create( 2,  6, 17), Tuple.Create( 6,  7, 18), Tuple.Create( 7,  8, 19), //20
		Tuple.Create(17, 15, 20), Tuple.Create(15,  8, 21), Tuple.Create( 8,  9, 22), Tuple.Create( 9, 10, 23), Tuple.Create(10,  9, 24),
		Tuple.Create( 9,  8, 25), Tuple.Create( 8,  7, 26), Tuple.Create( 7,  6, 27), Tuple.Create( 6, 14, 28), Tuple.Create(14, 12, 29), //30
		Tuple.Create(12,  6, 30), Tuple.Create( 6,  2, 31), Tuple.Create( 2,  1, 32), Tuple.Create( 1,  0, 33), Tuple.Create( 0,  1, 34),
		Tuple.Create( 1,  2, 35), Tuple.Create( 2,  6, 36), Tuple.Create( 6,  7, 37), Tuple.Create( 7,  8, 38), Tuple.Create( 8,  9, 39), //40
		Tuple.Create( 9, 10, 40), Tuple.Create( 0, 66, 41), 
		
		//Training Center 1 - 52 doors
		                                                    Tuple.Create(66, 67, 42), Tuple.Create(67, 36, 43), Tuple.Create(36, 55, 44),
		Tuple.Create(55, 36, 45), Tuple.Create(36, 37, 46), Tuple.Create(37, 42, 47), Tuple.Create(42, 44, 48), Tuple.Create(44, 64, 49), //50
		Tuple.Create(64, 47, 50), Tuple.Create(47, 48, 51), Tuple.Create(48, 50, 52), Tuple.Create(50, 45, 53), Tuple.Create(45, 65, 54), 
		Tuple.Create(50, 48, 55), Tuple.Create(48, 47, 56), Tuple.Create(47, 36, 57), Tuple.Create(36, 65, 58), Tuple.Create(65, 57, 59), //60
		Tuple.Create(57, 65, 60), Tuple.Create(65, 36, 61), Tuple.Create(36, 37, 62), Tuple.Create(37, 38, 63), Tuple.Create(38, 37, 64),
		Tuple.Create(37, 36, 65), Tuple.Create(36, 47, 66), Tuple.Create(47, 48, 67), Tuple.Create(48, 50, 68), Tuple.Create(50, 52, 69), //70
		Tuple.Create(52, 50, 70), Tuple.Create(50, 48, 71), Tuple.Create(48, 51, 72), Tuple.Create(51, 48, 73), Tuple.Create(48, 47, 74),
		Tuple.Create(47, 36, 75), Tuple.Create(36, 65, 76), Tuple.Create(65, 45, 77), Tuple.Create(45, 50, 78), Tuple.Create(50, 45, 79), //80
		Tuple.Create(45, 65, 80), Tuple.Create(65, 36, 81), Tuple.Create(36, 56, 82), Tuple.Create(56, 36, 83), Tuple.Create(36, 40, 84),
		Tuple.Create(40, 39, 85), Tuple.Create(39, 40, 86), Tuple.Create(40, 36, 87), Tuple.Create(36, 47, 88), Tuple.Create(47, 53, 89), //90
		Tuple.Create(53, 54, 90), Tuple.Create(54, 53, 91), Tuple.Create(53, 47, 92), Tuple.Create(47, 36, 93), 
		
		//Underground - 19 doors
		                                                                                                            Tuple.Create(36, 86,  94),
		Tuple.Create(86, 89,  95), Tuple.Create(89, 97,  96), Tuple.Create(97, 88,  97), Tuple.Create(97, 89,  98), Tuple.Create(89, 86,  99), //100
		Tuple.Create(86, 36, 100), Tuple.Create(36, 37, 101), Tuple.Create(37, 42, 102), Tuple.Create(42, 90, 103), Tuple.Create(90, 91, 104),
		Tuple.Create(91, 90, 105), Tuple.Create(90, 95, 106), Tuple.Create(95, 96, 107), Tuple.Create(96, 95, 108), Tuple.Create(95, 90, 109), //110
		Tuple.Create(90, 93, 110), Tuple.Create(93, 90, 111), Tuple.Create(90, 42, 112), 
		
		//Training Center 2 - 21 doors
		                                                                                 Tuple.Create(42, 37, 113), Tuple.Create(37, 36, 114),
		Tuple.Create(36, 65, 115), Tuple.Create(65, 57, 116), Tuple.Create(57, 58, 117), Tuple.Create(58, 63, 118), Tuple.Create(63, 58, 119), //120
		Tuple.Create(58, 59, 120), Tuple.Create(59, 61, 121), Tuple.Create(61, 59, 122), Tuple.Create(59, 58, 123), Tuple.Create(58, 62, 124),
		Tuple.Create(62, 58, 125), Tuple.Create(58, 57, 126), Tuple.Create(57, 65, 127), Tuple.Create(65, 36, 128), Tuple.Create(36, 45, 129), //130
		Tuple.Create(45, 36, 130), Tuple.Create(36, 65, 131), Tuple.Create(65, 43, 132), Tuple.Create(43, 99, 133), 
		
		//Laboratory - 38 doors
		                                                                                                                    Tuple.Create( 99, 100, 134),
		Tuple.Create(100, 114, 135), Tuple.Create(114, 100, 136), Tuple.Create(100, 101, 137), Tuple.Create(101,  99, 138), Tuple.Create( 99, 131, 139), //140
		Tuple.Create(131, 103, 140), Tuple.Create(103, 112, 141), Tuple.Create(112, 110, 142), Tuple.Create(110, 103, 143), Tuple.Create(103, 105, 144),
		Tuple.Create(105, 107, 145), Tuple.Create(112, 103, 146), Tuple.Create(103, 113, 147), Tuple.Create(113, 106, 148), Tuple.Create(106, 113, 149), //150
		Tuple.Create(113, 103, 150), Tuple.Create(103, 112, 151), Tuple.Create(107, 108, 152), Tuple.Create(108, 107, 153), Tuple.Create(107, 105, 154),
		Tuple.Create(105, 103, 155), Tuple.Create(103, 109, 156), Tuple.Create(109, 103, 157), Tuple.Create(103, 105, 158), Tuple.Create(105, 107, 159), //160
		Tuple.Create(112, 103, 160), Tuple.Create(103, 102, 161), Tuple.Create(107, 105, 162), Tuple.Create(105, 103, 163), Tuple.Create(103, 104, 164),
		Tuple.Create(104, 102, 165), Tuple.Create(102, 104, 166), Tuple.Create(104, 102, 167), Tuple.Create(102, 104, 168), Tuple.Create(104, 102, 169), //170
		Tuple.Create(102, 111, 170), Tuple.Create(111, 132, 171), 
		
		//Treatment Plant - 49 doors
		                                                          Tuple.Create(132, 134, 172), Tuple.Create(134, 135, 173), Tuple.Create(135, 134, 174),
		Tuple.Create(134, 136, 175), Tuple.Create(136, 134, 176), Tuple.Create(134, 166, 177), Tuple.Create(166, 141, 178), Tuple.Create(141, 142, 179), //180
		Tuple.Create(142, 145, 180), Tuple.Create(145, 146, 181), Tuple.Create(146, 153, 182), Tuple.Create(153, 154, 183), Tuple.Create(154, 155, 184),
		Tuple.Create(155, 156, 185), Tuple.Create(156, 155, 186), Tuple.Create(154, 153, 187), Tuple.Create(153, 146, 188), Tuple.Create(146, 145, 189), //190
		Tuple.Create(145, 144, 190), Tuple.Create(144, 147, 191), Tuple.Create(147, 148, 192), Tuple.Create(148, 150, 193), Tuple.Create(150, 151, 194),
		Tuple.Create(151, 152, 195), Tuple.Create(152, 160, 196), Tuple.Create(160, 159, 197), Tuple.Create(159, 160, 198), Tuple.Create(160, 152, 199), //200
		Tuple.Create(152, 158, 200), Tuple.Create(158, 157, 201), Tuple.Create(157, 161, 202), Tuple.Create(160, 163, 203), Tuple.Create(163, 162, 204),
		Tuple.Create(162, 161, 205), Tuple.Create(161, 157, 206), Tuple.Create(157, 156, 207), Tuple.Create(156, 155, 208), Tuple.Create(155, 154, 209), //210
		Tuple.Create(154, 153, 210), Tuple.Create(153, 154, 211), Tuple.Create(154, 155, 212), Tuple.Create(155, 156, 213), Tuple.Create(156, 157, 214),
		Tuple.Create(157, 161, 215), Tuple.Create(161, 162, 216), Tuple.Create(162, 174, 217), Tuple.Create(174, 164, 218), Tuple.Create(164, 173, 219), //220
		Tuple.Create(173, 165, 220)
    };

	//NG+ & WM Door Splits
    vars.NGPDoors = new List<Tuple<int, int, int>>
    {
		//Train - 44 doors
		Tuple.Create( 7,  6,  0), Tuple.Create( 6,  2,  1), Tuple.Create( 2,  5,  2), Tuple.Create( 5,  2,  3), Tuple.Create( 2,  6,  4), 
		Tuple.Create( 6,  7,  5), Tuple.Create( 7,  8,  6), Tuple.Create( 8, 15,  7), Tuple.Create(15, 17,  8), Tuple.Create(15,  8,  9), //10
		Tuple.Create( 8,  7, 10), Tuple.Create( 7,  6, 11), Tuple.Create( 6,  2, 12), Tuple.Create( 2,  3, 13), Tuple.Create( 3, 11, 14), 
		Tuple.Create(11, 12, 15), Tuple.Create(12, 11, 16), Tuple.Create(11,  3, 17), Tuple.Create( 3,  2, 18), Tuple.Create( 2,  6, 19), //20
		Tuple.Create( 6,  7, 20), Tuple.Create( 7,  8, 21), Tuple.Create(17, 15, 22), Tuple.Create(15,  8, 23), Tuple.Create( 8,  9, 24), 
		Tuple.Create( 9, 10, 25), Tuple.Create(10,  9, 26), Tuple.Create( 9,  8, 27), Tuple.Create( 8,  7, 28), Tuple.Create( 7,  6, 29), //30
		Tuple.Create( 6, 14, 30), Tuple.Create(14, 12, 31), Tuple.Create(12,  6, 32), Tuple.Create( 6,  2, 33), Tuple.Create( 2,  1, 34), 
		Tuple.Create( 1,  0, 35), Tuple.Create( 0,  1, 36), Tuple.Create( 1,  2, 37), Tuple.Create( 2,  6, 38), Tuple.Create( 6,  7, 39), //40
		Tuple.Create( 7,  8, 40), Tuple.Create( 8,  9, 41), Tuple.Create( 9, 10, 42), Tuple.Create( 0, 66, 43), 
		
		//Training Center 1 - 52 doors
		                                                                                                        Tuple.Create(66, 67, 44), 
		Tuple.Create(67, 36, 45), Tuple.Create(36, 55, 46), Tuple.Create(55, 36, 47), Tuple.Create(36, 37, 48), Tuple.Create(37, 42, 49), //50
		Tuple.Create(42, 44, 50), Tuple.Create(44, 64, 51), Tuple.Create(64, 47, 52), Tuple.Create(47, 48, 53), Tuple.Create(48, 50, 54), 
		Tuple.Create(50, 45, 55), Tuple.Create(45, 65, 56), Tuple.Create(50, 48, 57), Tuple.Create(48, 47, 58), Tuple.Create(47, 36, 59), //60
		Tuple.Create(36, 65, 60), Tuple.Create(65, 57, 61), Tuple.Create(57, 65, 62), Tuple.Create(65, 36, 63), Tuple.Create(36, 37, 64), 
		Tuple.Create(37, 38, 65), Tuple.Create(38, 37, 66), Tuple.Create(37, 36, 67), Tuple.Create(36, 47, 68), Tuple.Create(47, 48, 69), //70
		Tuple.Create(48, 50, 70), Tuple.Create(50, 52, 71), Tuple.Create(52, 50, 72), Tuple.Create(50, 48, 73), Tuple.Create(48, 51, 74), 
		Tuple.Create(51, 48, 75), Tuple.Create(48, 47, 76), Tuple.Create(47, 36, 77), Tuple.Create(36, 65, 78), Tuple.Create(65, 45, 79), //80
		Tuple.Create(45, 50, 80), Tuple.Create(50, 45, 81), Tuple.Create(45, 65, 82), Tuple.Create(65, 36, 83), Tuple.Create(36, 56, 84), 
		Tuple.Create(56, 36, 85), Tuple.Create(36, 40, 86), Tuple.Create(40, 39, 87), Tuple.Create(39, 40, 88), Tuple.Create(40, 36, 89), //90
		Tuple.Create(36, 47, 90), Tuple.Create(47, 53, 91), Tuple.Create(53, 54, 92), Tuple.Create(54, 53, 93), Tuple.Create(53, 47, 94), 
		Tuple.Create(47, 36, 95), 
		
		//Underground - 19 doors
		                           Tuple.Create(36, 86,  96), Tuple.Create(86, 89,  97), Tuple.Create(89, 97,  98), Tuple.Create(97, 88,  99), //100
		Tuple.Create(97, 89, 100), Tuple.Create(89, 86, 101), Tuple.Create(86, 36, 102), Tuple.Create(36, 37, 103), Tuple.Create(37, 42, 104), 
		Tuple.Create(42, 90, 105), Tuple.Create(90, 91, 106), Tuple.Create(91, 90, 107), Tuple.Create(90, 95, 108), Tuple.Create(95, 96, 109), //110
		Tuple.Create(96, 95, 110), Tuple.Create(95, 90, 111), Tuple.Create(90, 93, 112), Tuple.Create(93, 90, 113), Tuple.Create(90, 42, 114), 
		
		//Training Center 2 - 21 doors
		Tuple.Create(42, 37, 115), Tuple.Create(37, 36, 116), Tuple.Create(36, 65, 117), Tuple.Create(65, 57, 118), Tuple.Create(57, 58, 119), //120
		Tuple.Create(58, 63, 120), Tuple.Create(63, 58, 121), Tuple.Create(58, 59, 122), Tuple.Create(59, 61, 123), Tuple.Create(61, 59, 124), 
		Tuple.Create(59, 58, 125), Tuple.Create(58, 62, 126), Tuple.Create(62, 58, 127), Tuple.Create(58, 57, 128), Tuple.Create(57, 65, 129), //130
		Tuple.Create(65, 36, 130), Tuple.Create(36, 45, 131), Tuple.Create(45, 36, 132), Tuple.Create(36, 65, 133), Tuple.Create(65, 43, 134), 
		Tuple.Create(43, 99, 135), 
		
		//Laboratory - 38 doors
		                             Tuple.Create( 99, 100, 136), Tuple.Create(100, 114, 137), Tuple.Create(114, 100, 138), Tuple.Create(100, 101, 139), //140
		Tuple.Create(101,  99, 140), Tuple.Create( 99, 131, 141), Tuple.Create(131, 103, 142), Tuple.Create(103, 112, 143), Tuple.Create(112, 110, 144), 
		Tuple.Create(110, 103, 145), Tuple.Create(103, 105, 146), Tuple.Create(105, 107, 147), Tuple.Create(112, 103, 148), Tuple.Create(103, 113, 149), //150
		Tuple.Create(113, 106, 150), Tuple.Create(106, 113, 151), Tuple.Create(113, 103, 152), Tuple.Create(103, 112, 153), Tuple.Create(107, 108, 154), 
		Tuple.Create(108, 107, 155), Tuple.Create(107, 105, 156), Tuple.Create(105, 103, 157), Tuple.Create(103, 109, 158), Tuple.Create(109, 103, 159), //160
		Tuple.Create(103, 105, 160), Tuple.Create(105, 107, 161), Tuple.Create(112, 103, 162), Tuple.Create(103, 102, 163), Tuple.Create(107, 105, 164), 
		Tuple.Create(105, 103, 165), Tuple.Create(103, 104, 166), Tuple.Create(104, 102, 167), Tuple.Create(102, 104, 168), Tuple.Create(104, 102, 169), //170
		Tuple.Create(102, 104, 170), Tuple.Create(104, 102, 171), Tuple.Create(102, 111, 172), Tuple.Create(111, 132, 173), 
		
		//Treatment Plant - 49 doors
		                                                                                                                    Tuple.Create(132, 134, 174), 
		Tuple.Create(134, 135, 175), Tuple.Create(135, 134, 176), Tuple.Create(134, 136, 177), Tuple.Create(136, 134, 178), Tuple.Create(134, 166, 179), //180
		Tuple.Create(166, 141, 180), Tuple.Create(141, 142, 181), Tuple.Create(142, 145, 182), Tuple.Create(145, 146, 183), Tuple.Create(146, 153, 184), 
		Tuple.Create(153, 154, 185), Tuple.Create(154, 155, 186), Tuple.Create(155, 156, 187), Tuple.Create(156, 155, 188), Tuple.Create(154, 153, 189), //190
		Tuple.Create(153, 146, 190), Tuple.Create(146, 145, 191), Tuple.Create(145, 144, 192), Tuple.Create(144, 147, 193), Tuple.Create(147, 148, 194), 
		Tuple.Create(148, 150, 195), Tuple.Create(150, 151, 196), Tuple.Create(151, 152, 197), Tuple.Create(152, 160, 198), Tuple.Create(160, 159, 199), //200
		Tuple.Create(159, 160, 200), Tuple.Create(160, 152, 201), Tuple.Create(152, 158, 202), Tuple.Create(158, 157, 203), Tuple.Create(157, 161, 204), 
		Tuple.Create(160, 163, 205), Tuple.Create(163, 162, 206), Tuple.Create(162, 161, 207), Tuple.Create(161, 157, 208), Tuple.Create(157, 156, 209), //210
		Tuple.Create(156, 155, 210), Tuple.Create(155, 154, 211), Tuple.Create(154, 153, 212), Tuple.Create(153, 154, 213), Tuple.Create(154, 155, 214), 
		Tuple.Create(155, 156, 215), Tuple.Create(156, 157, 216), Tuple.Create(157, 161, 217), Tuple.Create(161, 162, 218), Tuple.Create(162, 174, 219), //220
		Tuple.Create(174, 164, 220), Tuple.Create(164, 173, 221), Tuple.Create(173, 165, 222)
    };
}

update
{
	//Reset variables when the timer is reset.
	if(timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.completedSplits.Clear();
		vars.completedSplitsInt.Clear();
		vars.doorIterator = 0;
		vars.scorpionReload = 0;
		vars.boxReload = 0;
	}

	//Iterate through the inventory slots to return their values
	for(int i = 0; i < 6; i++)
	{
        current.InventoryBilly[i] = new DeepPointer(0x9CDF44, 0x64 + (i * 0x8)).Deref<byte>(game);
        current.InventoryRebecca[i] = new DeepPointer(0x9CDF44, 0x24 + (i * 0x8)).Deref<byte>(game);
    }

	//Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
}

start
{
    return(current.time > old.time && old.time == 0);
}

split
{
    //Final Split -- Not Optional
	if(current.menuId == 21 && current.roomIdCur == 165 && current.roomIdNext == 165)
    {
		return true;
    }
    
	//Create variables to check for the variables in each item slot
    byte[] currentInventoryBilly = (current.InventoryBilly as byte[]);
    byte[] currentInventoryRebecca = (current.InventoryRebecca as byte[]);

	//Item + Weapon Splits
	//Double loop through the amount of settings and the amount of slots in our inventory
	if(settings["item"] || settings["weapon"])
    {
		for(int i = 0; i < 6; i++)
        {
			//Check if any of our inventory slots (both Billy and Rebecca) include the variables in our KeyItems list, check if the split was already completed and if the setting for the given item is activated
			if((vars.KeyItems.Contains(currentInventoryBilly[i]) || vars.KeyWeapons.Contains(currentInventoryBilly[i])) && !vars.completedSplitsInt.Contains(currentInventoryBilly[i]) && settings[currentInventoryBilly[i].ToString()])
            {
            	vars.completedSplitsInt.Add(currentInventoryBilly[i]);
            	return true;
        	}

        	if((vars.KeyItems.Contains(currentInventoryRebecca[i]) || vars.KeyWeapons.Contains(currentInventoryRebecca[i])) && !vars.completedSplitsInt.Contains(currentInventoryRebecca[i]) && settings[currentInventoryRebecca[i].ToString()])
            {
           		vars.completedSplitsInt.Add(currentInventoryRebecca[i]);
            	return true;
        	}
    	}
	}
	
	//Event Splits
    /*
        1. Checks if event splits are active, door splits are inactive, and if we're in a door transition
        2. Checks if we're in an event split room, if that event split is active, and whether we've completed that split
        3. Checks if we're going to the correct next room and possibly if we have required items
        Splits if all three checks are passed and adds the event to the list of completed splits
    */
	if(settings["event"] && !settings["doors"] && (current.roomIdCur != current.roomIdNext))
	{
        if(vars.eventsCur.Contains(current.roomIdCur) && settings["Event" + current.roomIdCur.ToString()] && !vars.completedSplitsInt.Contains(current.roomIdCur)){
            if(vars.eventsNext.Contains(current.roomIdNext)){
                vars.completedSplitsInt.Add(current.roomIdCur);
                return true;
            }
        }

		if(current.roomIdCur == 11 && settings["Scorp"] && !vars.completedSplits.Contains("Scorp"))
        {
            for(int i = 0; i < 6; i++)
            {
			    //Check for Panel Opener upon leaving room
			    if((currentInventoryBilly[i] == 82 || currentInventoryRebecca[i] == 82) && current.roomIdNext == 3)
			    {
        	    	vars.completedSplits.Add("Scorp");
			    	return true;
			    }
		    }
        }
        else if(current.roomIdCur == 50 && settings["Clock"] && !vars.completedSplits.Contains("Clock"))
        {
            for(int i = 0; i < 6; i++)
            {
			    //Check for Book of Good, Angel Wings, or Statue of Good in inventory upon leaving room
			    if((currentInventoryBilly[i] == 121 || currentInventoryBilly[i] == 130 || currentInventoryBilly[i] == 88 || currentInventoryRebecca[i] == 121 || currentInventoryRebecca[i] == 130 || currentInventoryRebecca[i] == 88) && current.roomIdNext == 45)
			    {
        	    	vars.completedSplits.Add("Clock");
			    	return true;
			    }
		    }
        }
		else if(current.roomIdCur == 100 && settings["Bat"] && !vars.completedSplits.Contains("Bat"))
        {
            if(current.roomIdNext == 101)
			{
				vars.completedSplits.Add("Bat");
				return true;
			}
        }
        else if(current.roomIdCur == 109 && settings["Hntrs"] && !vars.completedSplits.Contains("Hntrs"))
        {
            for(int i = 0; i < 6; i++)
            {
			    //Check for Dial upon leaving room
			    if((currentInventoryBilly[i] == 118 || currentInventoryRebecca[i] == 118) && current.roomIdNext == 103)
			    {
        	    	vars.completedSplits.Add("Hntrs");
			    	return true;
			    }
		    }
        }
        else if(current.roomIdCur == 154 && settings["Crate"] && !vars.completedSplits.Contains("Crate"))
        {
            for(int i = 0; i < 6; i++)
            {
			    //Check for Handle upon leaving room
			    if((currentInventoryBilly[i] == 87 || currentInventoryRebecca[i] == 87) && current.roomIdNext == 153)
			    {
        	    	vars.completedSplits.Add("Crate");
			    	return true;
			    }
		    }
        }
	}
	
    //Event Cutscene Splits
    if(settings["cutscene"] && (current.cutsceneId != old.cutsceneId))
	{
		if(settings["Train"] && !vars.completedSplits.Contains("Train") && !settings["doors"] && (current.cutsceneId == 491515 || current.cutsceneId == 524283))
		{
			vars.completedSplits.Add("Train");
			return true;
		} else if(settings["Centi"] && !vars.completedSplits.Contains("Centi") && current.cutsceneId == 27230203)
		{
			vars.completedSplits.Add("Centi");
			return true;
		}
	}

    //Door Splits
	if(settings["doors"])
	{
		//New Game
        if((settings["NG"] || settings["NGDS"]) && vars.NGDoors.Contains(Tuple.Create(Convert.ToInt32(current.roomIdCur), Convert.ToInt32(current.roomIdNext), vars.doorIterator)))
        {
            vars.doorIterator++;
            return true;
        }

		//New Game Plus
        if((settings["NGP"] || settings["NGPDS"]) && vars.NGPDoors.Contains(Tuple.Create(Convert.ToInt32(current.roomIdCur), Convert.ToInt32(current.roomIdNext), vars.doorIterator)))
        {
            vars.doorIterator++;
            return true;
        }

		//Door Skip Room Reload Exceptions
		//Scorpion Reload
		if(settings["NGPDS"] && vars.doorIterator == 17)
		{
			if(old.roomIdNext != current.roomIdNext && vars.scorpionReload < 2)
	    	{
	    		vars.scorpionReload++;
				return true;
	    	}
		}
		//Box Reload
		if((settings["NGDS"] && vars.doorIterator == 131) || (settings["NGPDS"] && vars.doorIterator == 133))
		{
			if(old.roomIdNext != current.roomIdNext && vars.boxReload < 2)
	    	{
	    		vars.boxReload++;
				return true;
	    	}
		}

        //Basic Door Splits
        if(settings["Basic"])
	    {
	    	if(old.roomIdNext != current.roomIdNext)
	    	{
	    		return true;
	    	}
	    }
	}
}

gameTime
{
    return TimeSpan.FromSeconds(current.time / 30);
}

isLoading
{
    return true;
}

reset
{
	return(current.time <= old.time && current.cutsceneId != 8187 && current.menuId == 24 && current.roomIdNext == 0 && current.roomIdCur != 0);
	//return(current.time < old.time && current.time == 0);
}