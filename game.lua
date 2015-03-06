-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here


local dX=display.contentWidth
local dY=display.contentHeight

local MAX_LEVEL = 10           -- max level 
local level     = 1             --  starting level
local average   = 0             -- average time to tap each correct tile
local correct   = 0             -- count the correct tiles
local failed    = 0             -- count the failed tiles
local lTimer    = 10            -- each level is 10 seconds long

-- forward for the timer referecnces.
local timerEventListenerRef
local timerNewBoxListenerRef


--how often a new tile is created.
local newBoxTimer = math.random(500, 5000)



-------------------------------------------------------------------------------------
--
--  these are the background score keeping system.
--
local levelText = display.newText( "level "..level, dX/2, dY/4, arial, 100 )
levelText:setFillColor( .01, .01, .1, .5 )

--local lTimerText = display.newText( lTimer, dX/2, dY/2 - dY/12, arial, 50 )
--lTimerText:setFillColor( .01, .05, .1, .5 )

local failedText = display.newText( "failed "..failed, dX/2, dY/2 + dY/12, arial, 50 )
failedText:setFillColor( .01, .01, .1, .5 )

local correctText = display.newText( "correct "..correct, dX/2, dY/2 + dY/4, arial, 75 )
correctText:setFillColor( .01, .01, .1, .5 )

local averageText = display.newText( "average "..average.." ms", dX/2, dY/2 + dY/2 - 100, arial, 50 )
averageText:setFillColor( .01, .01, .1, .5 )


---------------------------------------------------------------------------------
--
--  update the background score keeping system
--
local function updateAverage( newTime )
    average = average + newTime
    local foo = average/correct
    averageText.text = string.format( "average %d ms", foo )
end

local function updateLevel( )
    lTimer = 10
    level = level + 1
    levelText.text = string.format( "level %d", level )
end

local function updateFailed( )
    failed = failed + 1
    failedText.text = string.format( "failed %d", failed )
end

local function updateCorrect( )
    correct = correct + 1
    correctText.text = string.format( "correct %d", correct )
end

local function lTimerCount( )
    lTimer = lTimer - 1

    if level == 10 and lTimer == 1 then 
        timer.pause( timerNewBoxListenerRef )
    elseif lTimer == 0 then 
        updateLevel()
    end

    --lTimerText.text = string.format( "%d", lTimer)
end

----------------------------------------------------------------------------------------
--
--
--  add some pizzaz to make the boxes look a little nicer!
--  
--

local function rotateBox( box )
    transition.to(box, {time=box.time, rotation=180})
end

local function boxFadeOut( box )
    transition.fadeOut(box, {time=200, onComplete=function(obj) display.remove( box ); obj=nil end})
end

local function moveBox( box )
    transition.moveTo( box, {time=box.time, onComplete=boxFadeOut, onStart=rotateBox} ) 
end

local function boxFadeIn( box )
    transition.fadeIn( box, {time=200, onStart=moveBox} )
end

--------------------------------------------------------------------------------------
-- remove a box after it has been tapped correctly
--
--
local function removeBoxListener( event )
    if event.target.color == "blue" then 
        local newTime = system.getTimer() - event.target.createTime
        updateCorrect()
        updateAverage( newTime )
    else
        updateFailed()
    end
    boxFadeOut( event.target )
end

-----------------------------------------------------------------------------------
--
--  generate a new box
--          returns: a new box with a random size and specs.
--
local function genNewBox()

    local nW = math.random( 120, 200 ) 
    local nH = math.random( 120, 200 )
    local nR = 20

    local nX = math.random( nW/.9, dX ) - nW/1.9
    local nY = math.random( nH/.9, dY ) - nH/1.9 

    local box = display.newRoundedRect( nX, nY, nW, nH, nR )
    local changeColor = math.random( 0, 100 )
    box.rotation = math.random( -180, 0 )

    if changeColor >= 50 then
        box.color = "red"
        box.time = 3000
        box:setFillColor( math.random(.8, 1), 0, 0, .5 )
        box:setStrokeColor( 1, 0, 0, 1 )
        box.strokeWidth = 6
    else
        box.color = "blue"
        box.time = 1800
        box:setFillColor( 0, 0, math.random(.8, 1), .5 )
        box:setStrokeColor( 0, 0, math.random(.8, 1), 1 )
        box.strokeWidth = 6
    end

    box.createTime = system.getTimer()
    box:addEventListener( "tap", removeBoxListener )
    return box

end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        local function gameLoop( )
            newBoxTimer = math.random(500, 5000)
            boxFadeIn( genNewBox() )
        end

        timerNewBoxListenerRef = timer.performWithDelay( newBoxTimer, gameLoop, 0 )
        timerEventListenerRef = timer.performWithDelay( 1000, lTimerCount, (MAX_LEVEL*lTimer) - 1 )
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene