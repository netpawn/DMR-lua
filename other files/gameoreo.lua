system.activate( "multitouch" )
local composer = require("composer" )

local scene = composer.newScene()

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

-- Configure image sheet
local sheetOptions =
    {
    width = 100,
    height = 179.2,
    numFrames = 92,
    }
    local sheet_alien = graphics.newImageSheet("images/last one copia.png", sheetOptions)

local sequences_alien = {
    {
        name = "normalDance",
        start = 1,
        count = 91,
        time = 10000,
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

---sond and music 
local deathsound 
local firesound 
local backgroundmusic  
local gamemusic

---groups 
local buttonGroup = display.newGroup()

--meme sheet
local memeoptions =
{	
    width = 170.8,
    height = 155.5,
    numFrames = 20
}
local memeSheet = graphics.newImageSheet("images/codio.png", memeoptions)


--creo un meme 
local function createMemes()
	local newMemes = display.newImage(mainGroup, memeSheet, math.random(20))
	table.insert(memesTable, newMemes)
	physics.addBody( newMemes, "dynamic", {radius=43, bounce=1.5})
	newMemes.myName = "memes"

	local whereFrom = math.random(3)

	if (whereFrom == 1) then
		-- From the left
		newMemes.x = -60
		newMemes.y = math.random(100)
		newMemes:setLinearVelocity(180, 100)
	elseif (whereFrom == 2) then
		-- From the top
		newMemes.x = math.random(display.contentWidth - 15)
		newMemes.y = -10
		newMemes:setLinearVelocity(0, 400)
	elseif (whereFrom == 3) then
		-- From the right
		newMemes.x = display.contentWidth + 40
		newMemes.y = math.random(100)
		newMemes:setLinearVelocity(-300, 200)
	end

	newMemes:applyTorque(math.random(-12,12))
end

local function createMemes2()
	if score >= 1200 then 
		local newMemes = display.newImage(mainGroup, memeSheet, math.random(14))
		table.insert(memesTable, newMemes)
		physics.addBody( newMemes, "dynamic", {radius=43, bounce=2.5})
		newMemes.myName = "memes"
	
		local whereFrom = math.random(3)
	
		if (whereFrom == 1) then
			-- From the left
			newMemes.x = -60
			newMemes.y = math.random(100)
			newMemes:setLinearVelocity(180, 100)
		elseif (whereFrom == 2) then
			-- From the top
			newMemes.x = math.random(display.contentWidth - 15)
			newMemes.y = -10
			newMemes:setLinearVelocity(0, 400)
		elseif (whereFrom == 3) then
			-- From the right
			newMemes.x = display.contentWidth + 40
			newMemes.y = math.random(100)
			newMemes:setLinearVelocity(-300, 200)
		end
	
		newMemes:applyTorque(math.random(-24,24))
	end
end

local function createMemes3()
	if score >= 3000 then 
		local newMemes = display.newImage(mainGroup, memeSheet, math.random(14))
		table.insert(memesTable, newMemes)
		physics.addBody( newMemes, "dynamic", {radius=43, bounce=3.5})
		newMemes.myName = "memes"
	
		local whereFrom = math.random(3)
	
		if (whereFrom == 1) then
			-- From the left
			newMemes.x = -60
			newMemes.y = math.random(100)
			newMemes:setLinearVelocity(180, 100)
		elseif (whereFrom == 2) then
			-- From the top
			newMemes.x = math.random(display.contentWidth - 15)
			newMemes.y = -10
			newMemes:setLinearVelocity(0, 400)
		elseif (whereFrom == 3) then
			-- From the right
			newMemes.x = display.contentWidth + 40
			newMemes.y = math.random(100)
			newMemes:setLinearVelocity(-300, 200)
		end
	
		newMemes:applyTorque(math.random(-12,12))
	end
end

local function createMemes4()
	if score >= 4200 then 
		local newMemes = display.newImage(mainGroup, memeSheet, math.random(14))
		table.insert(memesTable, newMemes)
		physics.addBody( newMemes, "dynamic", {radius=43, bounce=4.5})
		newMemes.myName = "memes"
	
		local whereFrom = math.random(3)
	
		if (whereFrom == 1) then
			-- From the left
			newMemes.x = -60
			newMemes.y = math.random(100)
			newMemes:setLinearVelocity(180, 100)
		elseif (whereFrom == 2) then
			-- From the top
			newMemes.x = math.random(display.contentWidth - 15)
			newMemes.y = -10
			newMemes:setLinearVelocity(0, 400)
		elseif (whereFrom == 3) then
			-- From the right
			newMemes.x = display.contentWidth + 40
			newMemes.y = math.random(100)
			newMemes:setLinearVelocity(-300, 200)
		end
	
		newMemes:applyTorque(math.random(-12,12))
	end
end 


--Alieno che spara 
local function fireAlien()

	local newBullet = display.newImageRect(mainGroup, "images/rasengan2.png", 80, 80)
	physics.addBody(newBullet, "dynamic", {isSensor=true})
	newBullet.isBullet = true
	newBullet.myName = "bullet"
	newBullet:applyTorque(math.random(100))
	newBullet.x = alien.x
	newBullet.y = alien.y-25
	newBullet:toBack()
	audio.play(firesound)

	transition.to( newBullet, { y=-40, time=1000,
		onComplete = function() display.remove(newBullet) end
	} )
end


--Trascinare il personaggio
local function dragalien(event)

	local alien = event.target
	local phase = event.phase

	if ("began" == phase) then
		-- Set touch focus on the alien
		display.currentStage:setFocus(alien)
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


--Game loop 
local function gameLoop()

	-- Create new memes
	createMemes()
	createMemes2()
	createMemes3()
	createMemes4()

	-- Remove memess which have drifted off screen
	for i = #memesTable, 1, -1 do
		local thismemes = memesTable[i]

		if ( thismemes.x < -100 or
			 thismemes.x > display.contentWidth + 100 or
			 thismemes.y < -100 or
			 thismemes.y > display.contentHeight + 100 )
		then
			display.remove(thismemes)
			table.remove(memesTable, i)
		end
	end
end


--Ritorna l'alieno dopo la morte 
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


-- FINE DEL GIOCO 
local function endGame()
	composer.setVariable("finalScore", score)
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end



--COLLISIONI 
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
			audio.play(deathsound)

			for i = #memesTable, 1, -1 do
				if ( memesTable[i] == obj1 or memesTable[i] == obj2 ) then
					table.remove( memesTable, i )
					break
				end
			end

			-- Increase score
			score = score + 100
			scoreText.text = "Score: " .. score

		elseif ((obj1.myName == "alien" and obj2.myName == "memes") or
				 (obj1.myName == "memes" and obj2.myName == "alien"))
		then
			if (died == false) then
				died = true

				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if (lives == 0) then
					display.remove(alien)
					audio.play(deathsound)
					timer.performWithDelay(2000, endGame)
				else
					alien.alpha = 0
					audio.play(deathsound)
					timer.performWithDelay(1000, restorealien)
				end
			end
		end
	end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert(backGroup)  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the alien, memess, bullets, etc.
	sceneGroup:insert(mainGroup)  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert(uiGroup)    -- Insert into the scene's view group
	
	-- Load the background
	local background = display.newImageRect(backGroup, "images/background.png", 800, 1400)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	-- Load the alien 
	alien = display.newSprite(sheet_alien, sequences_alien)
	alien.x = display.contentCenterX
	alien.y = display.contentHeight - 100
	physics.addBody(alien, {radius=35, isSensor=true})
    alien.myName = "alien"
    alien:play()

	-- Display lives and score
	livesText = display.newText(uiGroup, "Lives: " .. lives, 1400, 80, native.systemFont, 36)
    scoreText = display.newText(uiGroup, "Score: " .. score, 1100, 80, native.systemFont, 36)
    
	alien:addEventListener("tap", fireAlien)
	alien:addEventListener("touch", dragalien)

	deathsound = audio.loadSound("audio/deathsound.wav")
	firesound = audio.loadSound("audio/firesound.wav")




--button test

local fireTimer
 
local function fireLaser( event )
	fireAlien()
	print( "FIRE A LASER!" )
	
end

local fireButton = display.newImageRect(buttonGroup, "images/Info.png", 100, 100)
fireButton.x = display.contentCenterX
fireButton.y = display.contentCenterY
local groupBounds = buttonGroup.contentBounds
local groupRegion = display.newRect( 0, 0, groupBounds.xMax-groupBounds.xMin+200, groupBounds.yMax-groupBounds.yMin+200 )
groupRegion.x = groupBounds.xMin + ( buttonGroup.contentWidth/2 )
groupRegion.y = groupBounds.yMin + ( buttonGroup.height/2 )
groupRegion.isVisible = false
groupRegion.isHitTestable = true
local function detectButton( event )
 
    for i = 1,buttonGroup.numChildren do
        local bounds = buttonGroup[i].contentBounds
        if (
            event.x > bounds.xMin and
            event.x < bounds.xMax and
            event.y > bounds.yMin and
            event.y < bounds.yMax
        ) then
            return buttonGroup[i]
        end
    end
end
local function handleController( event )
 
    local touchOverButton = detectButton( event )
 
    if ( event.phase == "began" ) then
 
        if ( touchOverButton ~= nil ) then
            if not ( buttonGroup.touchID ) then
                -- Set/isolate this touch ID
                buttonGroup.touchID = event.id
                -- Set the active button
                buttonGroup.activeButton = touchOverButton
                -- Fire the weapon
				print( "BEGIN FIRING" )
				fireTimer = timer.performWithDelay( 100, fireLaser, 0 )
            end
            return true
		end

	elseif ( event.phase == "moved" ) then
 
        -- Handle slide off
        if ( touchOverButton == nil and buttonGroup.activeButton ~= nil ) then
            event.target:dispatchEvent( { name="touch", phase="ended", target=event.target, x=event.x, y=event.y } )
            return true
        end
 
    elseif ( event.phase == "ended" and buttonGroup.activeButton ~= nil ) then
 
        -- Release this touch ID
        buttonGroup.touchID = nil
        -- Set that no button is active
        buttonGroup.activeButton = nil
        -- Stop firing the weapon
		print( "STOP FIRING" )
		timer.cancel( fireTimer )
        return true
    end
end
groupRegion:addEventListener( "touch", handleController )

--
	
end

local function updateText()
	livesText.text = "Lives: " .. lives
	scoreText.text = "Score: " .. score
end
--

-- show()
function scene:show(event)

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif (phase == "did") then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
		local gamemusic
		gamemusic = audio.loadStream("audio/gamemusic.mp3")
		audio.play(gamemusic, {loops=-1})
	end
end
--

-- hide()
function scene:hide(event)
	audio.stop()

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(gameLoopTimer)

	elseif (phase == "did") then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("collision", onCollision)
		physics.pause()
		--stop music
		audio.stop()
		composer.removeScene("game")
	end
end
--

-- destroy()
function scene:destroy(event)
	local sceneGroup = self.view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners                                                   
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
--------------------------------------------------------------------------------------

return scene