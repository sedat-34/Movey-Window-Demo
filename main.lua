local WindowMover = require "windowmover"
flux = require "lib.flux"
tick = require "lib.tick"

function love.load()
    love.graphics.setNewFont(30)
    WindowMover:setImage("assets/images/back.png")
    WindowMover:loadScript("windowevents")
end

function love.update(dt)
    WindowMover:update()
    flux.update(dt)
    tick.update(dt)
end

function love.keypressed(key)
    if key == "1" then
        WindowMover:loadScript("movingevents")
    else
        WindowMover:initiateEvent()
    end
end

function love.draw()
    WindowMover:draw()
    love.graphics.print(WindowMover.debugMessage)
end