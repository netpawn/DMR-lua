
local composer = require("composer")
local appodeal = require( "plugin.appodeal" )

local scene = composer.newScene()
local menumusic

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene("game", {time=800, effect="crossFade"})
end 

local function gotoHighScores()
	composer.gotoScene("highscores", {time=800, effect="crossFade"})
end

local function gotoInfo()
	composer.gotoScene("Info", {time=800, effect="crossFade"})
end

local function gotoCredits()
	composer.gotoScene("credits", {time=800, effect="crossFade"})
end





-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	
	
	local background = display.newImageRect(sceneGroup, "images/background.png", 800, 1400)
	background.x = display.contentCenterX
	background.y = display.contentCenterY 

	local title = display.newImageRect(sceneGroup, "images/Title.png", 500, 200)
	title.x = display.contentCenterX
	title.y = 330

	local playButton = display.newImageRect(sceneGroup, "images/PLAY.png", 500, 200)
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY+50

	local highScoresButton = display.newImageRect(sceneGroup, "images/HighScores.png", 70, 70)
	highScoresButton.x = display.contentCenterX +150
	highScoresButton.y = display.contentCenterY+250

	local volumeButton = display.newImageRect(sceneGroup, "images/Volume.png", 70, 70)
	volumeButton.x = display.contentCenterX
	volumeButton.y = display.contentCenterY+250

	local developButton = display.newImageRect(sceneGroup, "images/DeveloperPage.png", 70, 70)
	developButton.x = display.contentCenterX -150
	developButton.y = display.contentCenterY+250

	local infoButton = display.newImageRect(sceneGroup, "images/Info.png", 70, 70)
	infoButton.x = display.contentCenterX-200
	infoButton.y = display.contentCenterY-390

	local creditsButton = display.newImageRect(sceneGroup, "images/credits.png", 70, 70)
	creditsButton.x = display.contentCenterX+200
	creditsButton.y = display.contentCenterY-390

	local sexbar = display.newImageRect(sceneGroup, "images/sexbar.png", 70, 70)
	sexbar.x = display.contentCenterX
	sexbar.y = display.contentCenterY+250


	local function developer()
		system.openURL( "https://mamugian.github.io" )
	end
	--volume function 
	local volumeIsActive = true
	sexbar.isVisible = false

	local function volume() 
		if volumeIsActive == true then 
			audio.setVolume(0.0)
			volumeIsActive = false
			sexbar.isVisible = true 

	
		elseif volumeIsActive == false then 
			audio.setVolume(1.0)
			volumeIsActive = true
			sexbar.isVisible = false
	
		end
	end  
-- 



	volumeButton:addEventListener("tap", volume)
	playButton:addEventListener("tap", gotoGame)
	highScoresButton:addEventListener("tap", gotoHighScores)	
	creditsButton:addEventListener("tap", gotoCredits)
	infoButton:addEventListener("tap", gotoInfo)
	developButton:addEventListener("tap", developer)	
	local menumusic
	menumusic = audio.loadStream("audio/menumusic.mp3")


local alien
local sheetOptions =
    {
    width = 120,
    height = 215,
    numFrames = 92,
    }
    local sheet_alien = graphics.newImageSheet("images/alieno.png", sheetOptions)

local sequences_alien = {
    {
        name = "normalDance",
        start = 1,
        count = 92,
        time = 10000,
        loopCount = 0
    }
}
alien = display.newSprite(sceneGroup, sheet_alien, sequences_alien)
	alien.x = display.contentCenterX
	alien.y = display.contentHeight - 100
    alien.myName = "alien"
	alien:play()
	

end

-- show()
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		local menumusic
		menumusic = audio.loadStream("audio/menumusic.mp3")
		audio.play(menumusic, {loops=-1})
		appodeal.show( "banner", { yAlign="top" } ) 
	
	end
end 


-- hide()
function scene:hide(event)

	local sceneGroup = self.view
	local phase = event.phase
	audio.stop()
	

	if ( phase == "will" ) then
	
	elseif ( phase == "did" ) then
 
		-- Sometime later, hide the ad
		appodeal.hide("banner")
		composer.removeScene("menu")
	
		
	end
end


-- destroy()
function scene:destroy(event)
	local sceneGroup = self.view
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
