# Mkwii-Battle-Mod
Adds new features and fixes to Mario Kart Wii's Battle Mode

This project drew a lot of inspiration from CTGP, and I hope to create something very similar to battle mode, which is not paid much attention to. Simply put – it felt like battles were lacking a lot and has been “dead” compared to its earlier days recently. This project was meant to bring a bit more interest into the battling scene and to fix many problems that I, and many other battle veterans, felt battle had in MKW. A few of the problems include: 
-	It is too easy to play cheap / “dirty” in battles – of course, this is battle mode so everyone is supposed to try to destroy each other to win. However, in regular battle mode there are so many different ways to play dirty to the point where it becomes unfun to many other players, a lot of the veteran battlers know this well. A few of these “dirty tricks” involve wall-throwing, respawn hitting, suicide, hacking, and running.
-	Lag can become an issue in battles – It is very common to hit someone with an item in battles, but not have the point count, because on the other person’s screen, they were not hit. This becomes a pain at times because there are battles where you have, for example, put in effort to squish 5 players with a mega – but none or few of the points have counted. (This mainly applies to items where you need to make contact with another player like Megas, Stars, and Mushrooms.)
-	Lack of flexibility – Teams are the only option in battle mode. There is no FFA game mode where anybody can go after anyone. Although there is no competitive scene in battles anymore, this would often cause problems for battle clan wars in the past and within the new battle lounge – Players that  are supposed to be within the same team get put on separate teams, which can cause game play to become complicated because it limits the amount of people you can go after since you cannot hit your own teammate, who was placed on the other team.
-	Only two game modes, and Coin runners is abysmal – This one, of course, is an opinion. However, it appears to be a very popular opinion among those that have played a lot of battle before in the past. Coin runners is not very well-liked. [More blah blah]
-	Items are not as balanced as they can be – Let’s say red team only has 6 pts, while blue team has 15 pts in balloon battle. Despite blue team winning by a lot already, its possible for everyone on blue to obtain power items like stars and triple red-shells, which will make it nearly impossible for the red team who is way behind to even catch up. This happens at times when the red team is being carried by one person (who in this case, we can say they have all of red’s 6 pts while the rest of the team has 0) and most people on the blue team only have 2-4 pts. In this case, everyone on blue is getting power items even though they are winning by a lot. 
This project was begun in hopes that it will be able to improve battle mode to a much more enjoyable standard. 



List of current added features/ fixes (Which may or may not be fully-completed:)
- FFA Mode (Incomplete): Free-for-all, every person for themselves (no teams!) However, this is not complete yet. You can hit your teammates, but "teams" still exist. This still works out decently in coin runners, but in balloon battle you don't get points for hitting your teammates.
-Mirror mode: Self-explanitory. Not a necessary feature since most maps are symetrical but eh it can be nice I guess.
- Bob-omb Blast: The only items are bombs! Drive around the track bombing everything. (Think: Mario Kart 8 Deluxe Bob-omb blast)
- Snipemode: Similar to Bob-omb blast, but with Fake Item Boxes (and possibly other "strategic" items.
- "Shine Thief" (incomplete): Only one coin spawns on the battle map. This coin is the "shine" and everyone fights for it. For now, whoever has the shine by the end of the battle is the winner. This is meant to be played with "FFA mode" active, but cam have the usual team version played as well. This mode is incomplete, as I need to improve it further.
- Play more than 10 battle tracks at once with a custom battle menu! (In progress): You can play the original 10 battle tracks, 4 shine thief tracks, and a handful of battle Custom Tracks (CTs!)
- Change characters in between battles! 
- "No Mercy" Mode: A new way to shake up battles and tear out your soul. In coin runners, you lose ALL of your coins when you are hit. Even when you slip on a banana peel. In balloon battle, you will instantly lose a point when hit and respawn back on the map (As if you always only have 1 balloon)
- Changes to balloon battle points: You get +2 points for popping someone's last balloon, and -2 for losing your last balloon.
- Battle Teams in frooms are now based on froom join order, this would help in battle wars and tournaments.
- Custom Region, to play WWs with this project!




List of planned Features
-	“Fair-Play” System (optional) – This system will involve settings that will enable you to turn anti-wallthrow, anti-respawn, etc. on/off. The system will be flexible in frooms meaning that you will able to turn each of the “fair-play” features on or off, it will be up to the host. These are optional because some people do enjoy things like wall-throwing, while others don’t. The system itself includes:
1.	Anti-wallthrow: A small area above walls In battle tracks are made solid for shells so that you cannot throw them over walls
2.	Respawn timer will be increased: The time of invincibility after you lose your balloons will be increased to give players a better chance to obtain items before they are hit. 
3.	Suicide penalty – If somebody is about to hit you, and you drive off the track to avoid getting hit, you will lose one point in balloon battle as well as a balloon. There is no need to change anything about this in coin runners, since losing half your coins is enough anyway.
-	Re-balance of items – Make the game consider the points of the two teams, not just the individual players.
-	Gaining points like Countdown – If you hit somebody in countdown mode on your screen, you always get the point. I hope to implement this to battles.
-	(Possibly) Anti-hacking system
-A custom "cycle" in online Battle-Revolution Worldwides. Worldwides will randomly cycle between various gamemodes. (E.g.: "The next battle will be Bob-omb Blast, No Mercy, Balloon Battle!" or "The next Battle Will Be Coin runners, Fibbed Mode!")
- + Many more as I continue to gain ideas, or as people suggest them.


Take note: This project is meant to make battles more interesting. However, this project is my very first experience working with Assembly code. As a result, the code found in here will be very messy. As I gain experience, it'll become better. It is also my first experience with using Git, therefore I probably won't be using these resources in the most efficient manner. Although I have a goal in
mind with this project, its still just a casual part-time thing i'm working on.

Currently, there is no fancy or formal build system to generate these codes. The assembly code here is converted to hex code using ASMWiird, and the hex codes are then inserted into the game using a code handler. Certain files in the game are also modified to
pair along with this code to make the visuals neater.
