-----------------------------------------------------------------------------------------
--
-- main.lua
--
--
--
--
-- 1. create a start screen 
--			used composer to take care of start screen
--			used previous material to create fun looking start screen.
-- 2. create a scoring system 
--			used a background style scoring system,
--			otherwise, we would have too much "stuff"
-- 			inside the title bar. This was a preference.
--			check hw1 from me I used a title score system
--
--3. function to generate and return a box with an event listener attached.
--			exactly as stated.
--			add the current time to the box on creation.
--
--4. from step "3" generate a box, assign a random color red or blue
--
--5. max of ten rounds.... since the idea of a "round" was left arbitrary. 
--			each level will be 10 seconds, levels 1-10 10 sec each.
--			each level should progressively get faster, 
--			until multiple blue will appear at the same time.
--			
--6. when a box is tapped check color and update the score.
--			red 	- update failed
-- 			blue 	- update correct
--			get the time between the time created and tapped.
--			average that time into the average time it takes to tap a box.
--
--7. since the background scoring system was implemented, there was no need for a score screen.
-- 			simply restart the game to play again. 
--    					There was no required restart.
--
--
--
--
-----------------------------------------------------------------------------------------

-- hide the status bar
-- display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu", "fade", 1000)