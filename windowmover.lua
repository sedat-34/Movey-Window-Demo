local WindowMover = {}
local EVENTS

--When WindowMover.isLocked, a new keypress is ignored.
--When unlocked, they are registered.
WindowMover.isLocked = false
WindowMover.eventindex = 0
WindowMover.debugMessage = "No issues :)"

--The local mirror for the window.
--Since the actual window can't be modified directly by setting a variable (necessary for flux to work),
--The "window" table acts as a dummy to use flux on. The valued are cross-checked on update to see if new
--values must be sent to the window.
local window = {}
window.x, window.y = love.window.getPosition()
window.w, window.h = love.graphics.getDimensions()

--Choose a random list of events from the EVENTS table.
--Runs on initialisation and every time an EVENTLIST is completed.
local function SetEventList()
    if not EVENTS then return end
    math.randomseed(os.time())
    local random_index = math.random(#EVENTS.EVENTLIST)
    WindowMover.EVENTLIST = EVENTS.EVENTLIST[random_index]
    WindowMover.eventindex = 0
end

function WindowMover:update()

    --Check if the actual window matches the local "window" table.
    --Check size and position separately.
    local windowwidth, windowheight = love.graphics.getDimensions()
    local windowx, windowy = love.window.getPosition()
    local dimentionsdifferent = (windowwidth ~= window.w) or (windowheight ~= window.h)
    local posdifferent = (windowx ~= window.x) or (windowy ~= window.y)

    --Under appropiate conditions, apply window transformations
    if window.x and window.y and posdifferent then
        love.window.setPosition(window.x, window.y)
    end
    if window.w and window.h and dimentionsdifferent then
        window.w, window.h = love.graphics.getDimensions()
    end

end

function WindowMover:draw()
    if self.image then
        love.graphics.draw(self.image, -window.x, -window.y, 0, self.image_sx, self.image_sy)
    end
end

function WindowMover:setPositionAndScale(x, y, w, h) --When there is no access to the local "window" table, use this function to set the new position and scale.
    if x then window.x = x end
    if y then window.y = y end
    if w then window.w = w end
    if h then window.h = h end
end

function WindowMover:initiateEvent() --Continues execution of the current event list.

    if self.isLocked then return end

    self.eventindex = self.eventindex + 1

    local EventTable = self.EVENTLIST[self.eventindex]
    if not EventTable then SetEventList() self.eventindex = 1 end
    EventTable = self.EVENTLIST[self.eventindex]

    local WindowEventFunction =  EventTable.func
    local WindowEventTime = EventTable.time
    local WindowEventMiscArgs = EventTable.misc

    if WindowEventFunction and WindowEventTime and WindowEventMiscArgs then

        self.isLocked = true
        WindowEventFunction(WindowEventTime, WindowEventMiscArgs, window)
        tick.delay(function() self.isLocked = false end, WindowEventTime)

    end

end

function WindowMover:setImage(path) --Loads the image from the input path, scales it to the size of the desktop and hides all parts except what is shown behind the moving window.

    if self.image then self.image:release() end

    self.image = love.graphics.newImage(path)
    local sw, sh = love.window.getDesktopDimensions()
    self.image_sx = sw/self.image:getWidth()
    self.image_sy = sh/self.image:getHeight()
end

function WindowMover:loadScript(path) --Load any eventscript file. Works only when an event is not running!
    if self.isLocked then self.debugMessage = "Tried to load a script when the window was locked." return end

    self.debugMessage = "No issues :)"
    assert(io.open(path..".lua"), "Failure to load "..path..".lua. Check your loadScript() call!")
    if self.package then
        _G[self.package] = nil
        package.loaded[self.package] = nil
        collectgarbage("collect")
    end
    self.package = path
    EVENTS = require(path)
    SetEventList()

end

SetEventList()

return WindowMover