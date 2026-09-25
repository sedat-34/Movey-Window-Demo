--This file is a set of example functions for the format "windowmover" expects.
--The events can be any arbitrary code, save for the format of arguments.

local EVENTS = {}

local SCREENMETA = {}
SCREENMETA.WIDTH, SCREENMETA.HEIGHT  = love.window.getDesktopDimensions()

local function SineTheWindowAcross(time, misc, window)
    local truey = SCREENMETA.HEIGHT/2 - window.h/2 --Keep the initial y level recorded for the sinewaves!
    local timesToSineAcross = misc.turns
    local time = time/(4+3*(timesToSineAcross-1)) --splits steps evenly

    --A queue of preprogrammed flux statements
    local initialFlux
    local loopindex = 1
    local loopedatindex = {}

    for i = 1, timesToSineAcross do loopedatindex[i] = false end

    local function realfunction()
        if loopindex == 1 then
            initialFlux = flux.to(window, time, {x = -(window.w+1), y = truey})
        else
            if not loopedatindex[loopindex] then
                initialFlux = flux.to(window, 0, {x = -(window.w+1), y = truey})
            end
        end
        if initialFlux and (not loopedatindex[loopindex]) then
            loopedatindex[loopindex] = true
            initialFlux

            :after(window, time, {x = SCREENMETA.WIDTH/4 - window.w/2}):ease("sinein")
            :onstart(function () flux.to(window, time, {y = truey + window.h/2}):ease("sineout") end)

            :after(window, time, {x = SCREENMETA.WIDTH/2 - window.w/2}):ease("sineout")
            :onstart(function () flux.to (window, time, {y = truey - window.h/2}):ease("sinein") end)

            :after(window, time, {x = 3*SCREENMETA.WIDTH/4 - window.w/2, y = truey + window.h/2}):ease("circin")
            :after(window, time, {x = SCREENMETA.WIDTH+1, y = truey - window.h/2}):ease("circout")
            :oncomplete(function () loopindex = loopindex + 1 if loopindex <= timesToSineAcross then realfunction() end end):delay(time)
        end
    end

    realfunction()

end

local function CenterTheWindow(time, misc, window)
    flux.to(window, time, {x = SCREENMETA.WIDTH/2 - window.w/2, y = SCREENMETA.HEIGHT/2 - window.h/2}):ease("linear")
end

local function LoopingTheScreen(time, misc, window)
    local turn = 0
    local totalturns = misc.turns
    local time = (time - 1)/totalturns

    flux.to(window, 1, {x = -(window.w + 1), y = SCREENMETA.HEIGHT/2 - window.h/2})

    local function realfunction()
        if turn <= totalturns then
            flux.to(window, time, {x = SCREENMETA.WIDTH+1})
            :oncomplete(function ()
                turn = turn + 1
                if turn <= totalturns then
                    realfunction()
                    window.x = -(window.w + 1)
                end
            end)
        end
    end

    realfunction()
end

function LastSizeTest(time, misc, window)
    local truew, trueh = love.graphics.getPixelDimensions()
    print(truew, trueh)
    local steptime = time/2
    flux.to(window, steptime, {w = truew/2, h = trueh/2}):
    after(window, steptime, {w = truew, h = trueh})
end

--Other than func and time, please place all arguments in "misc".

local SINE_ACROSS = {
    {func = SineTheWindowAcross, time = 10, misc = {turns = 3} },
    {func = CenterTheWindow, time = 5, misc = {} },
}

local LOOP_TEST = {
    {func = LoopingTheScreen, time = 13, misc = {turns = 6}},
    {func = CenterTheWindow, time = 5, misc = {} },
}

local LAST_SIZE_TEST = {
    {func = LastSizeTest, time = 6, misc = {}}
}

EVENTS.EVENTLIST = {
    SINE_ACROSS,
    LOOP_TEST,
    LAST_SIZE_TEST
}

return EVENTS