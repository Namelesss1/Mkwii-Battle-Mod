/********************************************************************************************
* MenuLoader.mod by Noname
* 
* The code in this file is responsible for loading more than 10 battle stages at once.
* This is done by loading the VS Cup selection menu (which is edited with Chadderz's CT-Code)
* While you're in battle mode. Then, the VS tracks are replaced with battle tracks.
*
* Another note: The code in here also allows for players to change characters in-between battles.
*
* Some redundant code in here, which I'll fix later on.
*
* Code contributors: MrBean35000vr, Volderbeek
**********************************************************************************************/




/* Using the CT-Code engine, sometimes certain instructions are replaced with others and I am unsure why. For example,
 * if I write " li r0, 0; " this will be replaced with something like "addi rtoc, rtoc, 27198" which is sure to cause a 
 * crash. Perhaps I'm doing something wrong while using this engine. 
 *
 * The two mods below "resolve" the issue, both are replaced with some other instruction, and as long as they are never
 * branched to, the game should run fine and the rest of my code should be used as is without replacement.*/
MOD_REL(
	mod_777,
	0x80002304,
	
	li r0, 0;
)

MOD_REL(
	mod_667,
	0x80002308,
	
	li r12, 1;
)

/* This code is responsible for loading the VS cup selection menu and character-select in battles. */
MOD_REL(
	mod_VScupLoader,
	screenLoaderAddr,
	
	bl loadVsOrChar;
)

/* Loads custom menus into memory in WWs. Also makes sure of two things in WWs:
 * 1) Players cannot have any of the custom settings from frooms in WWs
 * 2) To disable the "Teams based on room join order" code. 
 * Task 1) is subject to change, once I get the the Cycle between options in WW feature working. */
MOD_REL(
	mod_wwScreenloader,
	WwScreenMemoryAddr,
	
	b  loadwwscreens; 
)

/* The two mods below loads custom menus into memory in Frooms. Also makes sure the Teams in frooms are arranged by
 * Player Order in the room. Frooms have two seperate mem addresses for loading into memory for balloon,
 * and coins. */
MOD_REL(
	mod_bbScreenLoader,
	BalloonScreenMemoryAddr,
	
	b  balloonscreens;
)

MOD_REL(
	mod_coinScreenloader,
	CoinScreenMemoryAddr,
	
	b  coinscreens;

)

/* The two mods below change the starting battle time. (Its always 3:00.000.) This is
 * Necessary because Loading a VS track in battle mode causes a bug online
 * Where the battle timer is 0:00.000 (so the battle ends before you can even
 * play!) So I made this code to change the time back to normal, 3 minutes to
 * fix this problem. There are seperate address for BB, and CR time. */
MOD_REL(
	mod_timeFixBB,
	BalloonTimerAddr,
	
	li  r0, 0xB4; /* 0xB4 = 180s = 3 minutes. */

)

MOD_REL(
	mod_timeFixCR,
	CoinTimerAddr,
	
	li  r0, 0xB4; /* 0xB4 = 180s = 3 minutes. */

)

/* If you attempt to vote a vs track in battle mode, the game will become "stuck" and no tracks will
 * be selected. This is because of a check the game does, if a player does not choose a battle track
 *(ids: 0x20 through 0x29) Then it fails the check, and the game enters an infinite loop.
 * This is a problem, because the the battle CTs replace VS tracks. So if a CT is voted on, the game 
 * Will not start.

 * The code below "disables" the check, to make it possible to vote "VS tracks" in battle mode.
 * This is a different check (and different address) than that of VS mode. */
MOD_REL(
	mod_disableBattleCourseCheck,
	OnlineVoteCheckAddr,
	
	cmplwi	r0, 170;
	beq-	 0xC0; /* Branching to 0x80612FF8 */

)

/* It seems there are two slots that like to crash when replaced with a battle CT: 
 * Moonview Highway (0x0A) and GBA Shyguy Beach (0x1F) This mod below "tricks" the game
 * into thinking that it will load SNES MC3 (0x18) whenever Moonview Highway or GBA
 * Shyguy beach is chosen, which resolves the crash. The game does still load either
 * Moonview or Shyguy beach however. But no crash!*/
MOD_REL(
	mod_fixSlotCrash,
	StageDecidedOnlineAddr,
	
	b		fixSlotCrash;
)




MOD_DOL(
	mod_menuLoader,
	0x8000230C,
	
	
	
	.globl loadVsOrChar;
	loadVsOrChar:
	lis		r12, PrevScreenLoadedAddr@ha;
	lwz   r11, PrevScreenLoadedAddr@l(r12); /*Contains previous screen loaded*/
	cmpwi r11, 0xCA; /*If true, load Character select*/
	bne   0x0C;
	li    r30, 0x6b;
	b     store_screen;

	cmpwi r30, 0x79; /*Change made: 0x79 --> 0x78 in an attempt to skip bt cup screen. */
	bne   store_screen;
	li    r30, 0x6e;

	store_screen:
	stw		r30, PrevScreenLoadedAddr@l(r12); /*To keep track of what the previous screen loaded was.*/
	stw		r30, 0x03E8(r29); /*Original instruction, store the next screen id to be loaded.*/
	blr;
	
	
	
	.globl charTracker;
	charTracker:
	stw	  r0, 0x0644 (r3); /*Original Instruction, store cup thats highlighted.*/
	lis   r12, PrevScreenLoadedAddr@ha;
	cmpwi r0, 0x00; /*Wii Stage Cup*/
	bne   No_Char_Select;
	li    r11, 0xCA;
	b     store_charSelectStatus;

	No_Char_Select:
	li    r11, 0x00;

	store_charSelectStatus:
	stw   r11, PrevScreenLoadedAddr@l(r12);
	blr;
	
	
	
	.globl loadwwscreens;
	loadwwscreens:
	lis   r12, 0x805f;
	ori   r12, r12, WwScreenMemoryAddr@l + 0x04;
	lis   r11, LoadScreenToMemAddr@ha;
	stw   r12, CurrentOnlineStatusAddr@l(r11);

	/*Disabling Custom Froom Settings, and teams based on froom join order.*/
	li    r3, 0;
	stw   r3, ItemAddr@l(r11); /*Disable item modes*/
	stw   r3, FFAAddr@l(r11); /*Disable FFAs*/
	stw   r3, GametypeAddr@l(r11); /*Disable No Mercy*/
	stw   r3, BattleTeamAddr@l(r11); /*Disable custom team ordering*/

	/*Preparing to load the custom WW screens into memory*/
	ori   r11, r11, LoadScreenToMemAddr@l;
	mtlr  r11;
	blr; /*Branch to Bean's code, that loads the screens needed for custom menus into memory.*/
	b WwScreenMemoryAddr + 0x04;
	
	
	
	.globl balloonscreens;
	balloonscreens:
	lis   r12, 0x805f;
	ori   r12, r12, BalloonScreenMemoryAddr@l + 0x04;
	lis   r11, BattleTeamAddr@ha   ;
	stw   r12, CurrentOnlineStatusAddr@l(r11);

	/*Enabling Custom Teams*/
	li    r3, 1;
	stw   r3, BattleTeamAddr@l(r11);

	/*Preparing to load the custom Froom Balloon screens into memory*/
	ori   r11, r11, LoadScreenToMemAddr@l;
	mtlr  r11;
	blr; /*Branch to Bean's code, that loads the screens needed for custom menus into memory.*/
	b     BalloonScreenMemoryAddr + 0x04;
	
	
	
	
	
	.globl coinscreens;
	coinscreens:
	lis   r12, 0x805f;
	ori   r12, r12, CoinScreenMemoryAddr@l + 0x04;
	lis   r11, BattleTeamAddr@ha   ;
	stw   r12, CurrentOnlineStatusAddr@l(r11);

	/*Enabling Custom Teams*/
	li    r3, 1;
	stw   r3, BattleTeamAddr@l(r11);

	/*Preparing to load the custom Froom Balloon screens into memory*/
	ori   r11, r11, LoadScreenToMemAddr@l;
	mtlr  r11;
	blr ;/*Branch to Bean's code, that loads the screens needed for custom menus into memory.*/
	b     CoinScreenMemoryAddr + 0x04;
	
	
	.globl fixSlotCrash;
	fixSlotCrash:
	
	cmpwi	r22, 0x0A; /*Moonview*/
	beq		0x10;
	cmpwi	r22, 0x1F; /*Shy guy*/
	beq 	0x08;
	b		0x08;
	li		r22, 0x18; /*MC3*/
	
	stw		r22, 0x0B68 (r31); /* Original, storing track id chosen */
	b		StageDecidedOnlineAddr + 0x04;
	
)


/* CREDITS: Major credit to MrBean350000vr. His "Change characters Between Races" code allows you to load 
 * specific screens into memory that would typically not be loaded during online menus. 
 * His code is modified here to make it possible to change characters in-between battles, and also
 * to load the vs-cup selection screen and whatnot into memory (otherwise, the game would crash on an attempt.)
 * Also modified in other ways to fit this project. */
MOD_DOL(
	mod_screensToMem,
	LoadScreenToMemAddr,
	
	.globl loadScreensToMem;
	loadScreensToMem:
	
	mr r3, r31 ;/*(original instruction at the addresses) */
	li	r4, 111 ; /*To Load VS cup track screen into mem */
	bl	MemoryFunction ;
	mr r3, r31 ;
	li r4,107; /*107 = 0x6b in hex. load char select in mem*/
	bl MemoryFunction;
	mr	r3, r31;
	li	r4, 118; /*0x76, load Battle bike select in mem*/
	bl	MemoryFunction;
	mr	r3, r31;
	li	r4, 0x6c; /*load bike select in mem*/
	bl	MemoryFunction;
	mr	r3, r31;
	li	r4, 109 ;/*0x6D, drift menu into mem*/
	bl	MemoryFunction;
	mr	r3, r31;
	li	r4, 110 ; /*0x6e, VS Cup selection into mem*/
	bl	MemoryFunction;
	mr	r3, r31;
	lis r12, CurrentOnlineStatusAddr@ha;
	lwz r11, CurrentOnlineStatusAddr@l(r12);
	mtlr r11;
	blr;

)


/* This code here is responsible for keeping track of whether or not to load character select screen.
 * If lightning cup is chosen, store 0xCA into memory to let the screen loader know to load Char select.
 * Otherwise, store 0x00 into memory to let the game know to NOT load the char select next. */
MOD_REL(
	mod_charTrack,
	BtCupTrackerAddr,
	
	bl charTracker;
)


/* Disables online vote Check ( For VS) , code by Volderbeek. */
MOD_REL(
	mod_volderbeekCourseCheck,
	OnlineVoteCheckVSAddr,
	
	cmplwi 		r3,127;
)

/* Fixes menu timer (It would become 90 seconds at times + 30) */
MOD_REL(
	mod_TimerMenuFix,
	MenuTimerAddr,
	
	b		fixMenuTimer;
	
)


MOD_REL(
	mod_MenuFixes,
	0x80001398,
	
	.globl fixMenuTimer;
	fixMenuTimer:
	.set	TIMER_LIM, 0x41c8;
	
	stfs	f1, 0 (r3); /* Original Instruction */
	lwz		r11, 0(r3);
	lis		r12, 0x41c8; /* 25 seconds */
	cmpw	r11, r12; 
	ble		0x08;
	mr		r11, r12;
	stw		r11, 0(r3);
	b		MenuTimerAddr + 0x04;
	
)

