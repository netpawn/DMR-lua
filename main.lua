local composer = require( "composer" )
local globalData = require( "globalData" )
local json = require( "json" )
local appodeal = require( "plugin.appodeal" )


-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Go to the menu screen
composer.gotoScene("splash")
--composer.gotoScene("menu")

audio.setVolume(0.5)

local appKey
if ( system.getInfo("platformName") == "Android" ) then  -- Android
	appKey = "ccef5f7e8204c61e85d78433f8df09b275f811c91073dadc"
elseif ( system.getInfo("platformName") == "iPhone OS" ) then  --iOS
	appKey = "462df4d656428178a60f7cf753f1aa05fc38a60f54b55c95"
end
 
local function adListener( event )
 
    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.isError )
    end
end

appodeal.init(adListener, {appKey=appKey})
 
-- Initialize the Appodeal plugin
--appodeal.init( adListener, { appKey="462df4d656428178a60f7cf753f1aa05fc38a60f54b55c95" } )
--appodeal.init( adListener, { appkey="ccef5f7e8204c61e85d78433f8df09b275f811c91073dadc" } )

--[[

local function screenshot()	

	--I set the filename to be "widthxheight_time.png"
	--e.g. "1920x1080_20140923151732.png"
	local date = os.date( "*t" )
	local timeStamp = table.concat({date.year .. date.month .. date.day .. date.hour .. date.min .. date.sec})
	local fname = display.pixelWidth.."x"..display.pixelHeight.."_"..timeStamp..".png"
	
	--capture screen
	local capture = display.captureScreen(false)

	--make sure image is right in the center of the screen
	capture.x, capture.y = display.contentWidth * 0.5, display.contentHeight * 0.5

	--save the image and then remove
	local function save()
		display.save( capture, { filename=fname, baseDir=system.DocumentsDirectory, isFullResolution=true } )    
		capture:removeSelf()
		capture = nil
	end
	timer.performWithDelay( 100, save, 1)
	       	
	return true               
end


--works in simulator too
local function onKeyEvent(event)
	if event.phase == "up" then
		--press s key to take screenshot which matches resolution of the device
    	    if event.keyName == "s" then
    		screenshot()
    	    end
        end
end

Runtime:addEventListener("key", onKeyEvent)
--]]