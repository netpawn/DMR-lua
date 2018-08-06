
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Configure image sheet
local sheetOptions =
    {
    width = 95,
    height = 174.82,
    numFrames = 23,
    }
    local sheet_alien = graphics.newImageSheet("tom tom.png", sheetOptions)

local sequences_alien = {
    {
        name = "normalDance",
        start = 1,
        count = 23,
        time = 2600,
        loopCount = 0
    }
}

-- Initialize variables
local lives = 3
local score = 0
local died = false
local newMemes 

local memesTable = {}

local alien
local gameLoopTimer
local livesText
local scoreText

local backGroup
local mainGroup
local uiGroup


local function createMemes()

	local newMemes = display.newImageRect( mainGroup, "circle.png", 200, 200 )
	table.insert( memesTable, newMemes )
	physics.addBody( newMemes, "dynamic", { radius=40, bounce=0.8 } )
	newMemes.myName = "memes"

	local whereFrom = math.random( 3 )

	if ( whereFrom == 1 ) then
		-- From the left
		newMemes.x = -60
		newMemes.y = math.random( 500 )
		newMemes:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	elseif ( whereFrom == 2 ) then
		-- From the top
		newMemes.x = math.random( display.contentWidth )
		newMemes.y = -60
		newMemes:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
	elseif ( whereFrom == 3 ) then
		-- From the right
		newMemes.x = display.contentWidth + 60
		newMemes.y = math.random( 500 )
		newMemes:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
	end

	newMemes:applyTorque( math.random( -6,6 ) )
end


local function fireAlien()

	local newBullet = display.newImageRect(mainGroup, "lol.png", 100, 100)
	physics.addBody( newBullet, "dynamic", { isSensor=true } )
	newBullet.isBullet = true
	newBullet.myName = "bullet"

	newBullet.x = alien.x
	newBullet.y = alien.y
	newBullet:toBack()

	transition.to( newBullet, { y=-40, time=500,
		onComplete = function() display.remove( newBullet ) end
	} )
end


local function dragalien( event )

	local alien = event.target
	local phase = event.phase

	if ( "began" == phase ) then
		-- Set touch focus on the alien
		display.currentStage:setFocus( alien )
		-- Store initial offset position
		alien.touchOffsetX = event.x - alien.x

	elseif ( "moved" == phase ) then
		-- Move the alien to the new touch position
		alien.x = event.x - alien.touchOffsetX

	elseif ( "ended" == phase or "cancelled" == phase ) then
		-- Release touch focus on the alien
		display.currentStage:setFocus( nil )
	end

	return true  -- Prevents touch propagation to underlying objects
end


local function gameLoop()

	-- Create new memes
	createMemes()

	-- Remove memess which have drifted off screen
	for i = #memesTable, 1, -1 do
		local thismemes = memesTable[i]

		if ( thismemes.x < -100 or
			 thismemes.x > display.contentWidth + 100 or
			 thismemes.y < -100 or
			 thismemes.y > display.contentHeight + 100 )
		then
			display.remove( thismemes )
			table.remove( memesTable, i )
		end
	end
end


local function restorealien()

	alien.isBodyActive = false
	alien.x = display.contentCenterX
	alien.y = display.contentHeight - 100

	-- Fade in the alien
	transition.to( alien, { alpha=1, time=4000,
		onComplete = function()
			alien.isBodyActive = true
			died = false
		end
	} )
end


local function endGame()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end


local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "bullet" and obj2.myName == "memes" ) or
			 ( obj1.myName == "memes" and obj2.myName == "bullet" ) )
		then
			-- Remove both the bullet and memes
			display.remove( obj1 )
			display.remove( obj2 )

			for i = #memesTable, 1, -1 do
				if ( memesTable[i] == obj1 or memesTable[i] == obj2 ) then
					table.remove( memesTable, i )
					break
				end
			end

			-- Increase score
			score = score + 100
			scoreText.text = "Score: " .. score

		elseif ( ( obj1.myName == "alien" and obj2.myName == "memes" ) or
				 ( obj1.myName == "memes" and obj2.myName == "alien" ) )
		then
			if ( died == false ) then
				died = true

				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if ( lives == 0 ) then
					display.remove( alien )
					timer.performWithDelay( 2000, endGame )
				else
					alien.alpha = 0
					timer.performWithDelay( 1000, restorealien )
				end
			end
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the alien, memess, bullets, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	-- Load the background
	local background = display.newImageRect(backGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	alien = display.newSprite( sheet_alien, sequences_alien )
	alien.x = display.contentCenterX
	alien.y = display.contentHeight - 100
	physics.addBody( alien, { radius=30, isSensor=true } )
    alien.myName = "alien"
    alien:play()

	-- Display lives and score
	livesText = display.newText("Lives: " .. lives, 1400, 80, native.systemFont, 36 )
    scoreText = display.newText("Score: " .. score, 1100, 80, native.systemFont, 36 )
    
	alien:addEventListener( "tap", fireAlien )
	alien:addEventListener( "touch", dragalien )
end

local function updateText()
	livesText.text = "Lives: " .. lives
	scoreText.text = "Score: " .. score
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
