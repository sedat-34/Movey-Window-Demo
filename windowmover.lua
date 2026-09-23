local WindowMover = {}
local EVENTS = require "windowevents" --Arbitrary. Can be any script so long as it matches the functionality.

--When WindowMover.isLocked, a new keypress is ignored.
--When unlocked, they are registered.
WindowMover.isLocked = false

WindowMover.eventindex = 0

--The local mirror for the window.
--Since the actual window can't be modified directly by setting a variable (necessary for flux to work),
--The "window" table acts as a dummy to use flux on. The valued are cross-checked on update to see if new
--values must be sent to the window.
local window = {}
window.x, window.y = love.window.getPosition()
window.w, window.h = love.graphics.getDimensions()

--Choose a random list of events from the EVENTS table.
--Runs on initialisation and every time an EVENTLIST is completed.
local function GetEventList()
    math.randomseed(os.time())
    local random_index = math.random(#EVENTS.EVENTLIST)
    WindowMover.EVENTLIST = EVENTS.EVENTLIST[random_index]
    WindowMover.eventindex = 1
end

function WindowMover:update(dt)

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
        love.resize(window.w, window.h)
    end

end

function WindowMover:keypressed()

    if self.isLocked then return end

    self.eventindex = self.eventindex + 1

    local EventTable = self.EVENTLIST[self.eventindex]
    if not EventTable then GetEventList() end
    EventTable = self.EVENTLIST[self.eventindex]

    local WindowEventFunction =  EventTable.func
    local WindowEventTime = EventTable.time
    local WindowEventMiscArgs = EventTable.misc

    if WindowEventFunction then
        self.isLocked = true
        WindowEventFunction(WindowEventTime, WindowEventMiscArgs, window)
        tick.delay(function() self.isLocked = false end, WindowEventTime)
    end

end

GetEventList()

return WindowMover