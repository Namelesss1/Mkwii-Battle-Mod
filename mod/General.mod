/*************************************************
* General.mod by Noname
* Just some general gameplay modifications.
*
* Note: This file should also contain a modified version of 
* Zakmkw / Vega's "Stacked Teams code." However, since it is not
* my work and I barely modified the code much, it is omitted from this
* file. It can be found at https://mkwii.com/archive/index.php?thread-1148.html
***************************************************/


/* Froom battle teams were always random. However, this code makes battle teams "un-random" by making teams based on 
 * The order in which people join the froom. HOST, 2, 4, etc. players will be on red team. 1, 3, 5, etc. players will be
 * be on blue team. I figure this could be convenient for battle wars or tournaments. 
 * So to make teams based on the order people join frooms, bits should be ordered
 * this way (Assuming we want guests on the same team as the player.): 

 * Player slot:  11/10 9/8  7/6  5/4   3/2 1/ho
 * BINARY(BITS): 0011 0011 00011 0011 0011 0011
 * HEX:           3    3    3     3    3     3
 *
 * ***************************************************************
 * As stated at the beginning of the file, this code was not created (or heavily modified)
 * by me, so the enableCustomTeams method is not shown.
 *****************************************************************/
MOD_REL (
	mod_teams,
	TeamManipulatorAddr,
	
	bl		enableCustomTeams;
)


/* Theres a "bug" in online track voting, the names of every battle CT appears as
 * "?". This is possibly due to the VS track courses not being loaded into memory during
 * battle voting? These mods fix the problem by briefly loading VS mode before track names are read,
 * then turning back to battles afterward. */
MOD_REL (
	mod_voteTrackNameFix1,
	VoteNameFixAddr1,
	
	b 	 	fixTrackNames;
)

/* Continue the previous mod. Once VS has been loaded, return to battle voting again. */
MOD_REL (
	mod_voteTrackNameFix2,
	VoteNameFixAddr2,
	
	b		fixTrackNamesBack;

)



MOD_DOL(
	mod_general,
	0x80002700,
	
	/* Player loses 2 points on death in balloon battle after losing all balloons. */
	.globl setPtLoss;
	setPtLoss:
	
	lis		r3, 0xFFFF;
	ori		r3, r3, 0xFFFE; /*Lose 2 points when dying.*/
	blr;
	
)
	
	
	
MOD_REL(
	mod_voteFixName,
	0x80001498,
	
	.globl	fixTrackNames;
	fixTrackNames:
	
	
	lis 	r12, 0x8000;
	lwz	r0, 0 (r4); /* Original */
	cmpwi	r0, 0x62; /* Battle Froom */
	beq	forBB;
	cmpwi   r0, 0x63; /*Coin Battle Froom */
	beq     forCR;
	b		compare_WW;
	
	forBB:
	li 		r11, 0;
	b 		store_60;
	
	forCR:
	li 		r11, 1;
	
	store_60:
	stw		r11, 0x22D4(r12);
	li		r0, 0x60; /* Load VS Froom */
	b 		store_VSvote;
	
	compare_WW:
	cmpwi	r0, 0x59; /* Battle WW Voting */
	bne     0x08;
	li		r0, 0x58; /* Load VS ww voting */
	
	store_VSvote:
	stw		r0, 0(r4);
	b		VoteNameFixAddr1 + 0x04;
	
	
	.globl fixTrackNamesBack;
	fixTrackNamesBack:
	
	mr	r12, r3;
	lwz	r3, 0 (r3);
	cmpwi	r3, 0x60; /* VS Froom */
	bne	determineWW;
	
	lis     r11, 0x8000;
	lwz	r11, 0x22D4(r11);
	cmpwi   r11, 1;
	bne	0x0c;
	li	r3, 0x63; /*CR BT Froom */
	b	store_BTvote;
	li	r3, 0x62; /* Load BT Froom */
	b	store_BTvote;
	
	determineWW:
	cmpwi	r3, 0x58; /* VS WW Voting */
	bne     0x08;
	li	r3, 0x59; /* Load BT ww voting */
	
	store_BTvote:
	stw	r3, 0(r12);
	b	VoteNameFixAddr2 + 0x04;
	
)
