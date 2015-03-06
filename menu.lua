-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

local widget = require( "widget" )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- forward references should go here

-- screen size
local dX = display.contentWidth
local dY = display.contentHeight

-- number of colors for bakcground
local nColors = 4

-- create background size
local sX = dX/nColors
local sY = dY/nColors

-- array of tiles
local tiles = {}

-- array of timers for the tiles
local tileTimers = {}

-- Name for the logo
local logo = "Color Tap"

math.randomseed( os.time() )

display.setDefault( "background", 200, 150, 255, .5 )

-- -------------------------------------------------------------------------------

local function onReadyButtonRelease( )

    --go to the game.lua scene
    composer.gotoScene( "game", "fade", 500 )

    return true --indicate successful touch
end

--set the tile to have a blue color
local function changeTileColorBlue( tile )
    tile:setFillColor( math.random(0, .01), math.random(), 1 )
end

--set the tile to have a red color
local function changeTileColorRed( tile )
    tile:setFillColor( 1, math.random(), math.random(0, .01) )
end

-- toggle the tile color.
local function flipTileFinish( tile )
    if tile.color == 'blue' then
        tile.color = 'red'
        transition.to(tile, {time = 300, xScale=1, onStart=changeTileColorRed})
    else
        tile.color = 'blue'
        transition.to(tile, {time = 300, xScale=1, onStart=changeTileColorBlue})
    end
    
end

-- make the tile look like it is flipping
local function flipTileStart( event )
    local params = event.source.params
    local tile = params.tile
    transition.to(tile, {time = 300, xScale=.001, onComplete=flipTileFinish})
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    for i=1, nColors do
        tiles[i] = {}
        tileTimers[i] = {}
        for j=1, nColors do
            tiles[i][j] = display.newRect( sX*i-sX/2, sY*j-sY/2, sX, sY )
            tiles[i][j].color = 'blue' 
            changeTileColorBlue( tiles[i][j] )

            -- add a timer for the delayed event.
            tileTimers[i][j] = timer.performWithDelay( math.random(500, 3000), flipTileStart, 1)
            tileTimers[i][j].params = { tile = tiles[i][j] }
            timer.pause(tileTimers[i][j])


            -- add tile to display object
            sceneGroup:insert( tiles[i][j] )
        end
    end

    --TODO:: create Logo Title.
    local logoText = display.newText( "SPEED TAP", dX/2 + 20, 200, dX, 200, arial, 120 )
    changeTileColorBlue( logoText )

    --display.newText( [parentGroup,], text, x, y, [width, height,], font, fontSize )


    local playButton = widget.newButton
    {
        label = "START",
        labelColor = { default={  math.random(0, .01), math.random(), 1, 1 }, over={ 1, math.random(), math.random(0, .01), 1 } },
        onRelease = onReadyButtonRelease,
        emboss = false,
        shape="roundedRect",
        font=arial,
        fontSize=100,
        x = dX/2,
        y = dY-100,
        width = 375,
        height = 150,
        cornerRadius = 0,
        fillColor = { default={ 0, 0, 0, 0}, over={ 0, 0, 0, 0 } },
        strokeColor = { default={ math.random(0, .01), math.random(), 1, 1 }, over={ 1, math.random(), math.random(0, .01) } },
        strokeWidth = 4
    }

    --insert display objects.
    sceneGroup:insert( playButton )
    sceneGroup:insert( logoText )


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

        --start timers for the tiles
        for i=1, nColors do
            for j=1, nColors do
                timer.resume(tileTimers[i][j])
            end
        end

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

    if playButton then
        playButton:removeSelf()    -- widgets must be manually removed
        playButton = nil
    end
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene