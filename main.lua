--creo il background
local background = display.newImageRect("background.png", 2000, 2400)
background.x = display.contentCenterX
background.y = display.contentCenterY
--creo piattaforma
local platform = display.newImageRect("platform.png", 1700, 1200)
platform.x = display.contentCenterX
platform.y = display.contentCenterY+1000
--creo il player 
local ghost = display.newImageRect("ghost.png", 100, 100)
ghost.x = display.contentCenterX
-----------
--display.contentCenterX/Y centra in X e Y
--display.contentHeightX/Y/ -n/+n con n= numero per spostare
-----------
ghost.y = display.contentHeight-700

--aggiungo la fisica 
local physics = require( "physics" )
physics.start()
--aggiungo corpo fisico pavimento 
physics.addBody(platform, "static")
physics.addBody(ghost, "dynamic", { radius=40, bounce=0.3 } )

local function pushBalloon()
    ghost:applyLinearImpulse( 0, 1, ghost.x, ghost.y )
end
 
ghost:addEventListener( "tap", pushBalloon )