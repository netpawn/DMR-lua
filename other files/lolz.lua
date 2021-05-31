--button test
--[[
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

---groups 
local buttonGroup = display.newGroup()

--]]
