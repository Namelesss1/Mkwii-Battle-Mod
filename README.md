# Mkwii-Battle-Mod
Adds new features and fixes to Mario Kart Wii's Battle Mode

This project drew a lot of inspiration from CTGP, and I hope to create something very similar to battle mode, which is not paid much attention to. Simply put – it felt like battles were lacking a lot and has been “dead” compared to its earlier days recently. This project was meant to bring a bit more interest into the battling scene and to fix many problems that I, and many other battle veterans, felt battle had in MKW. 

**NOTE: This repository contains an outdated, older version of the mod which will no longer be updated. The new version is located here: https://github.com/Namelesss1/ProjectBT **



## Current Features and Changes to Battle Mode

* **Custom Tracks for battles!:** 
  * Custom menu system like CTGP to select Regular Battle Tracks, And Custom Tracks!
  * 48 Battle Tracks total: 10 Original stages + 10 "shine thief" stages + 28 Custom Tracks!

* **FFA Battle mode:** Battles, without the teams! You can hit whoever you like. Its a free-for-all and the scores are based on your
  individual points, not your team!
  * You can select any vehicle you want in this mode including those that are otherwise unavaliable in battles.
    (Yes, you can use Funky + Flame Runner; Daisy + Mach; Yoshi + Dolphin Dasher, etc.)
  
* **"No Mercy" mode**: A unique gamemode that is meant to be *evil.* There are different versions for Balloon Battle And
  Coin Runners. 
  * Coin Runners: When hit, you will lose ALL of your coins. It doesn not matter what item you're hit by or how - you will lose
    everything! Stars and shrooms steal ALL coins from other players!
  * Balloon Battle: It's as if you always only have 1 balloon. This means that you will die after each time you are hit 
    (Lose a point and need to respawn back - same thing that happens when you lose all 3 of your balloons normally)
    
* **Custom Item modes**: Options that change the type of items used in battles!
  * Bob-omb Blast: Exactly what it sounds like - Bombs only. Includes custom triple bombs if you're behind on points!
  * Snipemode: Strategic Items only (Nanas, fibs, etc.) Includes custom triple fibs as an item.
  
* **Custom WWs**: Changes to "Worldwide" battles
  * Uses a custom region - Region 769.
  * The BR range allowed in the region is 7000BR to 9999BR. The lowest BR attainable is 7000. If a player enters a WorldWide
    with below 7000, they will have 7000 the next battle. 
  * The amount of points you score in a battle is factored into your BR gain. For example, if you're supposed to gain +20 BR for a
    battle and you scored 8 points that battle, you will gain an extra 8 points. (So +28 BR total)
    BR gain / loss = Raw BR gain/loss + Your points scored that battle.
  * Battles with an even amount of players (2, 4, 6, etc.) are in teams. Battles with an odd amount of players
    (3, 5, 7, etc.) are in FFA mode to avoid the uneven team issue regular battle WWs face.
    
 * **General Changes:** 
 
   * You gain +2 Points for popping another player's last balloon, but you lose -2 when you lose all of your's. 
   
   * Froom teams are not random anymore. They are decided based on the order of players in a froom in an alternating pattern:
     Red team: HOST, 2, 4, 6, 8, 10
     Blue team: 1, 3, 5, 7, 9, 11
     Guests are on the same team as their partner.
   
   * Chances of Megas are reduced by about ~1.5%.
   
   * You can change characters in-between battles! This is done by selecting a certain cup meant for this
     during voting online. 
     
   * In normal battles, you lose -3 coins when hit by a ground item (Nana, FIB, dropped shell, etc.) But in this project, you lose
     slightly more. Now, you lose -4 coins. 
     
   * Under normal circumstances, you lose 50% of your coins in battle. In this project, you only lose 40% of your coins. (So you lose
     slightly less for being hit in most cases.)


## List of planned Features
*	“Fair-Play” System (optional) – This system will involve settings that will enable you to turn anti-wallthrow, anti-respawn, etc. on/off. The system will be flexible in frooms meaning that you will able to turn each of the “fair-play” features on or off, it will be up to the host. These are optional because some people do enjoy things like wall-throwing, while others don’t. The system itself includes:
  1.	Anti-wallthrow: A small area above walls In battle tracks are made solid for shells so that you cannot throw them over walls
  1.	Respawn timer will be increased: The time of invincibility after you lose your balloons will be increased to give players a better       chance to obtain items before they are hit. 
  1.	Suicide penalty – If somebody is about to hit you, and you drive off the track to avoid getting hit, you will lose one point in     balloon battle as well as a balloon. There is no need to change anything about this in coin runners, since losing half your coins is     enough anyway.
*	Re-balance of items – Make the game consider the points of the two teams, not just the individual players.
*	Gaining points like Countdown – If you hit somebody in countdown mode on your screen, you always get the point. I hope to implement this to battles.
*	(Possibly) Anti-hacking system
* A custom "cycle" in online Battle-Revolution Worldwides. Worldwides will randomly cycle between various gamemodes. (E.g.: "The next battle will be Bob-omb Blast, No Mercy, Balloon Battle!" or "The next Battle Will Be Coin runners, Fibbed Mode!")
* + Many more as I continue to gain ideas, or as people suggest them.


## How the project works

This project is currently built using Chadderz and Bean's CT-CODE Engine. (https://github.com/Chadderz121/wii-ct-code) So it follows
a similar format - except with new / edited mod files and .id files (which contain memory addresses).
There are many .mod files which contains the assembly code for this project under the /mod/ directory. These files are placed 
inside the /mod/ directory of the ct-code engine, where the code is compiled using Devkitpro. The generated files which contain
the code are then inserted into English.szs. A modified main.dol with support for CT-CODE is also used (this can be done with
Wiimm's wctct tool). For more information, refer to Bean and Chadderz's Ct-code engine. 

## Note
Take note: This project is meant to make battles more interesting. However, this project is my very first experience working with Assembly code. As a result, the code found in here will be very messy. As I gain experience, it'll become better. It is also my first experience with using Git, therefore I probably won't be using these resources in the most efficient manner. Although I have a goal in
mind with this project, its still just a casual part-time thing i'm working on.
