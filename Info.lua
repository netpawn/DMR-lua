local composer = require( "composer" )
local scene = composer.newScene()
local menumusic

local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "images/background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
     
	local infos = display.newText(sceneGroup, 
	"How to play:", display.contentCenterX, 100, native.systemFont, 44)
	
	local text = display.newImageRect(sceneGroup, "images/cazzoculo.png", 500, 1000)
	text.x, text.y = display.contentCenterX, display.contentCenterY
    
	local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 1000, native.systemFont, 44)
    menuButton:setFillColor( 0.75, 0.78, 1 )
    menuButton:addEventListener( "tap", gotoMenu )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase


	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--menumusic = audio.loadStream("audio/menumusic.mp3")
		--audio.play(menumusic, {loops=-1})
	end
end


-- hide()
function scene:hide( event )
    audio.stop()

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("highscores")
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
