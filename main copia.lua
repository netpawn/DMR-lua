local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )



local lives = 3
local score = 0
local died = false 
local newMemes

local memesTable = {}

local gameLoopTimer
local livesText
local scoreText

--GROUPS 
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup =display.newGroup()

-- background and stuff 

local background = display.newImageRect(backGroup, "background.png", 800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterY



---------end shit 



math.randomseed( os.time())

local sheetOptions =
{
    width = 95,
    height = 174.82,
    numFrames = 23,
   
}

local sheet_alien = graphics.newImageSheet( "tom tom.png", sheetOptions )
-- sequences table
local sequences_alien = {
    {
        name = "normalDance",
        start = 1,
        count = 23,
        time = 2600,
        loopCount = 0
    }
}

display.newSprite(sheet_alien, sequences_alien )
-- my alien 
local alien = display.newSprite( sheet_alien, sequences_alien )
--

alien:play()
--alien:translate(160, 1000)
alien.x = display.contentCenterX
alien.y = display.contentCenterY +450
alien:scale(1, 1)

-- FISICA 

physics.addBody( alien, { radius=70, isSensor=true })
alien.myName = "alien"

-- Display lives and score
livesText = display.newText( uiGroup, "Lives: " .. lives, 1390, 80, native.systemFont, 40 )
display.setStatusBar( display.HiddenStatusBar )
scoreText = display.newText( uiGroup, "Score: " .. score, 1040, 80, native.systemFont, 40 )

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

--movement 
local function trascina(event)
 
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
        display.currentStage:setFocus( alien )

    end
    return true 
end

alien:addEventListener( "touch", trascina )

--creo gli "asteroidi memes"

local function createMemes()

    local newMemes = display.newImageRect( mainGroup, "circle.png", 200, 200 )
    table.insert( memesTable, newMemes )
    physics.addBody( newMemes, "dynamic", { radius=40, bounce=0.8 } )
    newMemes.myName = "memes"

    --da dove viene e cosa fa 

    local whereFrom = math.random(3)
    if ( whereFrom == 1 ) then
        -- From the left
        newMemes.x = -60
        newMemes.y = math.random( 600 )
        newMemes:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
        newMemes:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newMemes.x = math.random( display.contentWidth )
        newMemes.y = -60
        newMemes:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ))
    elseif ( whereFrom == 3 ) then
        -- From the right
        newMemes.x = display.contentWidth + 60
        newMemes.y = math.random( 500 )
        newMemes:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end
    --ruota 
    newMemes:applyTorque( math.random( -6,6 ) )
end

--funzione per sparare la lol face 
local function fireAlien()
    local newBullet = display.newImageRect(mainGroup, "lol.png", 100, 100)
    physics.addBody(newBullet, "dynamic", {isSensor=ture})
    newBullet.isBullet=true
    newBullet.myName="bullet"

    --dove spawnano 
    newBullet.x = alien.x
    newBullet.y = alien.y
    newBullet:toBack()
    transition.to( newBullet, { y=-40, time=1200, 
    onComplete = function() display.remove( newBullet ) 
    end
} )
end

alien:addEventListener( "tap", fireAlien )

--GAME LOOP 

local function gameLoop()
    --creo un meme
    createMemes()
    --removes memes off screen 
    for i = #memesTable, 1, -1 do
        local thisMemes = memesTable[i]
 
        if ( thisMemes.x < -100 or
             thisMemes.x > display.contentWidth + 100 or
             thisMemes.y < -100 or
             thisMemes.y > display.contentHeight + 100 )
        then
            display.remove( thisMemes )
            table.remove( memesTable, i )
        end
    end
end
--timer del giuoco
gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)

--restore alien when it gets eliminato 
local function restoreAlien()
    alien.isBodyActive = false
    alien.x = display.contentCenterX
    alien.y = display.contentHeight - 100

    --fade in the alien 
    transition.to(alien, {alpha=1, time=4000,
    onComplete = function()
        alien.isBodyActive = true
        died = false
    end
    })
end



--collision func 
--molto interessante
--molto complicata 

local function onCollision( event )

	if (event.phase == "began") then

		local obj1 = event.object1
		local obj2 = event.object2

		if ((obj1.myName == "bullet" and obj2.myName == "memes") or
			(obj1.myName == "memes" and obj2.myName == "bullet") )
		then
			-- remove the bullet and the meme hit 
			display.remove( obj1 )
			display.remove( obj2 )

			for i = #memesTable, 1, -1 do
				if (memesTable[i] == obj1 or memesTable[i] == obj2) then
					table.remove(memesTable, i)
					break
				end
			end

			-- Aumento score
			score = score + 100
			scoreText.text = "Score: " .. score

		elseif ((obj1.myName == "alien" and obj2.myName == "memes") or
				(obj1.myName == "memes" and obj2.myName == "alien"))
		then
			if ( died == false ) then
				died = true

				-- Update vite
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if (lives == 0) then
					display.remove(alien)
				else
					alien.alpha = 0
					timer.performWithDelay( 1000, restoreAlien )
				end
			end
		end
	end
end

Runtime:addEventListener( "collision", onCollision )