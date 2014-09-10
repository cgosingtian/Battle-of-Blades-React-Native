Battle-of-Blades
================

Battle of Blades Project: Battle enemies within a time limit by tapping randomly appearing buttons.

There are two types of buttons that appear:
1. ATTACK button - these yellow buttons appear at specific places but have random respawn times. The number that appears on them is the damage that they deal when they are tapped. This number counts down, however, and when it reaches 0, it heals the enemy by 1 health.
2. ENEMY SHIELD button - these buttons appear like evil ghost faces and move around randomly. They also randomly appear in various locations. Tapping them causes you to lose 5 seconds from the time limit.

Game Design:
The damage countdown on the attack buttons is a risk-reward feature where players are rewarded for tapping on an attack button early in its lifetime, but with the risk of an enemy shield appearing or moving over the button just as they do so.

The spawning of enemy shields is balanced in such a way that only one ghost is spawned per second (and even then, by chance), giving the player some breathing room and allowing the player to find "safe tapping areas".

To prevent abuse of "safe tapping areas", the respawn of buttons once they are tapped is also randomized.

To prevent turtling or excessive waiting on the side of the player, attack buttons that count down to zero heal the enemy by 1. This also provides an incentive for the player to tap attack buttons that have low values.
