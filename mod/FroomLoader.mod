/***************************************************************************
* FROOM LOADER by Noname
* Based on the specific froom message chosen, loads
* the appropriate gamemode. E.g. If someone were to select the message,
* "Let's play Bob-omb Blast!" Then a value at a specified address will be
* set, letting the game know to load bob-omb blast, which is handled in a
* different file. Obviously, this is to be paired with edited BMG-text files.
****************************************************************************/


MOD_REL(
	mod_options,
	FroomMsgAddr,
	
	bl		froomMethod;

)

MOD_DOL(
	mod_optionsFroom,
	0x80002500,
	
	
	.globl froomMethod;
	froomMethod:
	stwx	r0,r3,r4; /*Original instruction */
	lbz	  r4, 0x2(r3); /*r4 will now contain selected froom msg id */
	cmpwi r4, FIRST_OPTION_ID; /* If not any of the "option loader" msgs, do nothing else. */
	blt   endOptionLoad;

	/*A bunch of comparisons to determine which msgs contain different options of the same "type"
	 *So options can be overriden by the last message to appear (e.g. someone chooses bob-omb blast,
	 *then selects fibbed mode. Fib mode is now active, NOT bob-omb blast. However, any other options
	 *that have been selected & have nothing to do with items are still active.) */
	lis   r12, ItemAddr@ha;
	li    r11, ItemAddr@l;
	cmpwi r4, 0x5c;
	bgt   setGameMode;
	cmpwi r4, 0x58;
	subi  r11, r11, 0x04;
	bgt   setGameMode;
	cmpwi r4, 0x56;
	subi  r11, r11, 0x04;
	bgt   setGameMode;
	subi  r11, r11, 0x04;

	/* Stores froom message id selected at a specific address, from 0x80002300 and below. */
	setGameMode:
	stwx   r4, r11, r12;

	endOptionLoad:
	blr;
)