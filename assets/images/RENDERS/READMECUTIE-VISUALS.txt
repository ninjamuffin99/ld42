Layer Order- Top > Bottom
-------------------------

I rendered all the images to scale with the size of the game so that you won't have to figure out image placement.

1. Pause Menu- DED-DRIVE_PAUSE_Overlay
2. Dead Drive- DED-DRIVE_DEDDRIVE_HD1-3
3. Any and all TEXT and DED-DRIVE_DRIVEFULL_TEXT_HD1-3
4. Grid Texture- DED-DRIVE_GRIDTEXTURE_Overlay
5. Active hard drive bay crosses- DED-DRIVE_DriveBayCross_ON_HD1-3
6. Hard drive bay FULL background- DED-DRIVE_DRIVEFULL_BG_HD1-3
7. Files, corrupted files and bombs
8. Background- DED-DRIVE_Background

File Color Index and Parameters
-------------------------------

File Sizes- Minimum Height- 17PX

1. Photos - Pink - #fffa9b
2. Music - Green - #b0ff9b
3. Movies - Purple - #c59bff
4. Documents - Light Blue - #9bf6ff
5. OS- Color - Blue - #636aff
6. Corrupted File - Color - #75001e

Font Parameters
---------------

Command Line section - Consolas - 15PX - Color - White
Command Line section ERROR MESSAGE - Consolas [ALLCAPS]- 15PX - Color - Red - #ff0048
Pause screen buttons - Consolas [ALLCAPS]- 15PX - Color - White

Command Line section should only have one line of text. I'm not sure what that section above would be called but I just labeled it as "Command Bank". I think based on the visuals I made there should be 3 lines of text at a time in the Command Bank.

Bomb Description
----------------

I made 5 bombs "DED-DRIVE_Bomb_1-5". The bomb's number relates to it's value and will decide how bad it's corruption of files will be.

When a bomb comes into contact with a file switch the bomb to "DED-DRIVE_BombContact" and change the color of to red [#75001e]. After a small bit of time get rid of the bomb "DED-DRIVE_BombContact" and replace the the red file [#75001e] with "DED-DRIVE_CorruptedFiles".
REFER TO "EXAMPLE4-6" FOR VISUAL REFERENCE

Something I just realized is that what happens when a bomb hits corrupted data? Technically at the moment the bombs could only hit the top file in the hard drive bay. This could lead to a complication for the game. I guess for now the way it should work is as follows.

When a bomb hits corrupted data the following rows beneath are corrupted according to the value of the bomb.

Active hard drive bay crosses Description
-----------------------------------------

I made "DED-DRIVE_DriveBayCross_ON_HD1-3" to let players know which hard drive bay they are currently accessing. REFER TO "EXAMPLE4-2" FOR VISUAL REFERENCE