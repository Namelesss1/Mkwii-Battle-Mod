/********************************************************************
 * FFA & Mirror Mode By Noname
 * This code loads "FFA" battle mode (currently incomplete) or mirror
 * mode in battles as well if the correct froom message is set. 
 *******************************************************************/
 
 /* Makes it possible to hit your teammates and removes colors on player's names. and / or
  * causes mirror mode in battles, depending on the option chosen in frooms. */
 MOD_REL(
	mod_setFFAmodes,
	HitTeammateAddr,
	
	bl setFFAmode;
 )
 
 /* Disables team colors on vehicles. (E.g. Luigi's vehicle will be green, his normal color, instead of red or blue.) */
 MOD_REL(
	mod_teamColors,
	TeamColorAddr,
	
	b	disableTeamColors;
 )
 
 /* Makes it possible to play VS vehicles in battle! FFA mode must be active for this. 
  * Without certain features of FFA mode active ("disable team vehicle colors") the game crashes because there are 
  * no special blue/red variants avaliable for VS vehicles, that the standard Karts & Bikes have. */
 MOD_REL(
	mod_loadVSbikes,
	LoadVSbikeAddr,
 
	b	loadVSbikes;
 )
 
 
 

  /* This mod is pretty important to my FFA mode. During the battles themselves,
  * this mod causes teams to be "completely" removed! This is done by "tricking"
  * the game into thinking that it will load a regular VS race last second even though
  * most battle functionality has already been stored. This results in an interesting 
  * combination of both battles and VS races. The User Interface is that of VS; with the
  * lap counter, whether you are in first, second, etc. As well as the results screens you
  * would see in a standard VS GP - but with battle points! Everything else works like usual in
  * battle. Finding an address to accomplish this was extremely difficult for me, but then 
  * I stumbled upon one that keeps track of what "Menu" a player is currently in. Turns out,
  * This is THE address i've been looking for!*/
 MOD_REL(
	mod_ffaResultsScreen,
	MenuManipulatorAddr,
	
	bl ffaresults;
)


/* Stores balloon-battle points at 0x81400000 */
MOD_REL(
	mod_storeBB,
	BalloonPtsCountAddr,
	
	b		storeBBpts;

)

/* Stores Coin-Runners points at 0x81400000 */
MOD_REL(
	mod_storeCR,
	CoinCountAddr,
	
	b		storeCRpts;

)

MOD_REL(
	mod_lapToScoreCounter,
	VisualLapCountAddr,
	
	b		LapToScoreCounter;

)

 
 
 MOD_DOL(
	mod_setFFA,
	0x80002420,
	
	.macro _getFFAsetting;
		lis		r12, FFAAddr@ha;
		lwz		r11, FFAAddr@l(r12);
	.endm;
	
	
	.globl setFFAmode;
	setFFAmode:
	
	_getFFAsetting;
	cmpwi   r11, 0x59;
	blt     store_ffaOption;

	li      r12, 0x5c;
	li      r7, 0x03;

	ffa_loop:
	cmpw   r11, r12;
	beq    store_ffaOption;
	subi   r12, r12, 0x01;
	subic. r7, r7, 0x01;
	bne+   ffa_loop;

	store_ffaOption:
	stw 	r7,2960(r31); /* Original */
	blr;
	
	
	
	.globl disableTeamColors;
	disableTeamColors:
	_getFFAsetting;
	cmpwi	r11, 0x5A;
	bgt		0x10;
	cmpwi   r11, 0x59;
	blt		0x08;
	li		r4, 0x07;
	li		r20, 2;
	b		TeamColorAddr + 0x04;
	
	
	.globl loadVSbikes;
	loadVSbikes:
	_getFFAsetting;
	cmpwi	r11, 0x5A;
	bgt		0x10;
	cmpwi   r11, 0x59;
	blt		0x08;
	li		r0, 0; /* 0 = VS. But battles still load. */
	cmpwi	r0, 0; /* Original Instruction */
	b		LoadVSbikeAddr + 0x04;
	
	
 )
 
 /* Looks Sloppy as heck, confusing & undocumented. To be fixed. */
 MOD_REL(
	mod_results,
	0x80001798,
	
	.globl ffaresults;
	ffaresults:
	lis		r12, FFAAddr@ha;
	lwz		r11, FFAAddr@l(r12);
	cmpwi r11, 0x59;
	blt originalInstruction;
	cmpwi r11, 0x5A;
	bgt originalInstruction;
	
	lis r12, 0x8000;
	
	cmpwi r4, 0x72;
	beq setFFA_results;
	cmpwi r4, 0x73;
	beq setFFA_coins;
	
	cmpwi 	r4, 0x6C;
	beq 	setFFA_WW;
	
	cmpwi r4, 0x60;
	bne 0x20;
	lwz r11, 0x22D8(r12);
	cmpwi r11, 1;
	bne 0x0C;
	li r4, 0x63;
	b originalInstruction;
	li r4, 0x62;
	b  originalInstruction;
	
	cmpwi r4, 0x58;
	bne originalInstruction;
	li r4, 0x59;
	b	originalInstruction;

	setFFA_WW:
	li r4, 0x68;
	b  originalInstruction;
	
	setFFA_coins:
	li r11, 1;
	stw r11, 0x22D8(r12);
	b 	0x0C;
	
	setFFA_results:
	li r11, 0;
	stw r11, 0x22D8(r12);
	li r4, 0x70;
	
	originalInstruction:
	mr r31, r4; /* Original */
	blr;
 
 )
 
 MOD_REL(
	mod_storeBBpts,
	0x80000298,
	
	.globl storeBBpts;
	storeBBpts:
	lis		r12, 0x8140;
	stw		r0, 0(r12);
	stb		r0, 0x0124 (r30); /* original */
	b		BalloonPtsCountAddr + 0x04;
	
	
	.globl storeCRpts;
	storeCRpts:
	lis		r12, 0x8140;
	stw		r7, 0(r12);
	stb		r7, 0x00DC (r26); /* original */
	b		CoinCountAddr + 0x04;
	
 
 )
 
 
 MOD_REL(
	mod_lapToScore,
	0x80000198,
	
	.globl LapToScoreCounter;
	LapToScoreCounter:
	lis		r12, 0x8140;
	lwz		r0, 0(r12);
	stb		r0, 0x0026 (r3);
	b		VisualLapCountAddr + 0x04;
	
 
 )
 

/*
 *807e5548 - Reads from the laps!
 *807048e8 - same
* 807e5574 -same 
 *80709ba0
 *
 */
 
 

