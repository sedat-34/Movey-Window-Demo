local WindowMover = require "windowmover"
flux = require "lib.flux"
tick = require "lib.tick"

function love.load()
    love.graphics.setNewFont(30)
    WindowMover:setImage("assets/images/back.png")
end

function love.update(dt)
    WindowMover:update(dt)
    flux.update(dt)
    tick.update(dt)
end

function love.keypressed()
    WindowMover:keypressed()
end

function love.draw()
    WindowMover:draw()
    love.graphics.print("This is a test string! Don't mind me.")
end