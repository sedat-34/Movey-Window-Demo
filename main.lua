local WindowMover = require "windowmover"
flux = require "lib.flux"
tick = require "lib.tick"

function love.load()
    love.graphics.setNewFont(30)
    WindowMover = require "windowmover"
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
    love.graphics.print("This is a test string! Don't mind me.")
end