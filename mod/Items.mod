/**********************************************************
* Items.mod by Noname
* 
* This file deals with many "item modes" within the project.
* This is done by hijacking itemslot.bin while it is being read
* and stored by the game, and editing the item probabilities before
* they are stored to memory. 
*
* CURRENT ITEM MODES:
* (1) Bob-omb blast [Bombs only!]
* (2) Snipemode [Fibs, triple bananas] soon to be updated to include more.
* 
*
* Code contributors: 
* - Davidevgen [Item Limiters code] used to increase item limits in game.
* - Zakmkw / Vega [Equal Item probability code] I used an address from his code to modify the
* probabilities of items. This so happens to be the address that reads from ItemSlot.bin!!!
***********************************************************/


/* Increases bomb limit from 3 to [CustomItemLimit]
 * and fib- item limits from 6 to [CustomItemLimit]
 * if bob-omb blast or fibbed modes are active. */

/* increase the item limits and replace Triple red shells
 * with the desired item. */
MOD_REL(
	mod_itemLim,
	ItemLimitAddr,

	b  itemLimAndReplace;
)


/* Depending on the item mode, changes the probabilities of the items.
 * E.g. If bob-omb blast is chosen, then bombs are always gaurenteed.
 *
 * CREDITS: Zakmkw / Vega for finding the address that deals with
 * ItemSlot.bin, allowing for item probability edits.
 *
 * REGISTERS: r17 holds current item id. r10 contains the following: 
 * [0x00 = when player is in first;]
 * [0x01 = player is 3-5 pts behind,]
 * [0x02 = player is more than 5 behind]
 * r5 contains item probability (out of 200)

 * So here is how the code works: 
 * compare to r17, if not bob-omb (0x06) / fib (0x03) then set r5 = 0.
 * if bomb/fib, while r10 = 0, then set bomb chance 100% (r5 = 0xC8)
 * while r10 = 1, then set bomb chance 90% (0xB4), triple red 10%(0x14) 
 * while r10 = 2; then set bomb 80% (0xA0) triple red 20% (0x28) */
MOD_REL(
	mod_Itemprobabilities,
	ItemSlotAddr,
	
	bl setProbabilities;

)

MOD_DOL(
	mod_setItems,
	0x80002600,
	
	.globl itemLimAndReplace;
	itemLimAndReplace:
	
	/* Check what item mode is active */
	lis	r12, ItemAddr@ha;
	lwz	r11, ItemAddr@l(r12);
	cmpwi	r11, 0x5e;
	li	r11, CUSTOM_ITEM_LIMIT;
	li	r3, 0x02;
	beq	setLimitsAndReplace;
	li	r3, 0x09;
	bgt	setLimitsAndReplace;
	li	r11, DEFAULT_ITEM_LIMIT;
	li	r3, 0x01;

	/*Sets the max amount of fibs / bombs allowed at once, and also
	 *replaces triple reds with either fibs / bombs depending on which item mode is active. */
	setLimitsAndReplace:
	lis	r12, BombLimitAddr@ha;
	stw	r11, FibLimitAddr@l(r12); /*Fib Lim*/
	stw	r11, BombLimitAddr@l(r12); /*Bomb Lim*/
	stw	r11, NanaLimitAddr@l(r12); /*Nana Lim*/
	stw	r3, RedReplacementLow(r16); /*Triple Red replacement & Original Instruction.*/ 
	b   ItemLimitAddr + 0x04;
	
	
	
	.globl setProbabilities;
	setProbabilities:
	
	.set	MAX_CHANCE, 0xC8; /*200/200 = 100%. */
	.set	CHANCE_FACTOR, 0x14; /* -10% chance for bomb for each time r10 increments */
	
	lis	r12, ItemAddr@ha;
	lwz	r11, ItemAddr@l(r12);
	cmpwi	r11, 0x5e;
	blt	default_probabilities;
	li	r11, 0x03; /*r11 contains fib id*/
	beq	determineProbabilities;
	li	r11, 0x06; /*r11 contains bomb id*/

	/*The method below determines the probabilities for each item.
	 *This also takes the player's current standing into account as well.
	 *So for example, if the player is in first place, then they can only
	 *obtain single bombs/fibs. However, lets say they are behind other
	 *players by a lot of pts and in last place. Then they would have a 
	 *20% chance of obtaining "triple bombs/fibs", etc. */

	/*r11 = item id; r12 = Max Chance; r5 = calculated chance of current item. */

	/*NOTE: consider using negative numbers for less code lines!*/
	determineProbabilities:
	li	r12, MAX_CHANCE;
	cmpw	r17, r11; /*Compare to Bomb or Fib*/
	beq	setBombChance;
	cmpwi	r17, 0x11; /*Compare to Triple Red shell*/
	beq	setTripleRedChance;
	li	r5, 0;
	b	endProbabilityMethod;

		setBombChance:
		/*Bomb probability =  [Max Chance (0xC8) - (r10 * CHANCE_FACTOR)]*/
		mulli	r11, r10, CHANCE_FACTOR;
		sub	r5, r12, r11 ;	/*r5 = Bomb Probability*/
		b	endProbabilityMethod;

		/*NOTE: consider using negative numbers for less code lines!*/
		setTripleRedChance:
		/*Triple Red Probability = [Max Chance - Bomb Probability]*/
		/*Yay for the Probability Law of Compliments.*/
		mulli	r11, r10, CHANCE_FACTOR;
		sub	r12, r12, r11; 	/*r12 = Bomb Probability*/
		li	r11, MAX_CHANCE;
		sub	r5, r11, r12;
		b	endProbabilityMethod;



	default_probabilities:
	lwz	r5, 0x0054(r1); /*Original Instruction*/

	endProbabilityMethod:
	blr;
	

)
