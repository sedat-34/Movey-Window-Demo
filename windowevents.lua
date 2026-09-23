local EVENTS = {}

local SCREENMETA = {}
SCREENMETA.WIDTH, SCREENMETA.HEIGHT  = love.window.getDesktopDimensions()

local function SineTheWindowAcross(time, misc, window)
    local truey = SCREENMETA.HEIGHT/2 - window.h/2 --Keep the initial y level recorded for the sinewaves!
    local time = time/10

    local timesToSineAcross = misc.turns

    --A queue of preprogrammed flux statements
    local initialFlux
    local loopindex = 1
    local loopedatindex = {}

    for i = 1, timesToSineAcross do loopedatindex[i] = false end

    local function realfunction()
        if loopindex == 1 then
            initialFlux = flux.to(window, time, {x = -window.x, y = SCREENMETA.WIDTH/2 - window.h/2})
        else
            if not loopedatindex[loopindex] then
                initialFlux = flux.to(window, 0, {x = -window.x, y = SCREENMETA.WIDTH/2 - window.h/2})
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
    flux.to(window, 1, {x = -(window.w + 1), y = SCREENMETA.HEIGHT/2 - window.h/2})

    time = (time - 1)/totalturns

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

--Other than func and time, please place all arguments in "misc".

local DEMO_EVENT_LIST = {
    {func = SineTheWindowAcross, time = 5, misc = {turns = 3} },
    {func = CenterTheWindow, time = 5, misc = {} },
}

local LOOP_TEST = {
    {func = LoopingTheScreen, time = 7, misc = {turns = 6}},
    {func = CenterTheWindow, time = 5, misc = {} },
}

EVENTS.EVENTLIST = {
    DEMO_EVENT_LIST,
    LOOP_TEST
}

return EVENTS