--menu.lua

require "states/game"

menu = {}

local state = 0

local timers = {}

local flash = 0
local flashSpeed = 400
local flashDir = 1

local fade = 0

local showMenu = false
local menuText = {{255, 255, 0, 255, 255}, "normal\n", {255, 255, 255, 255}, "expert"}
local selection = 1 -- 1 for normal 2 for expert

function menu:enter()
  menuMusic:setLooping(true)
  menuMusic:play()

  addTimer(30.0, "introFade", timers)
end

function menu:keypressed(key, code)
  -- pressed enter/space
  if key ~= nil and showMenu == false then
    showMenu = true
    correctWord:play()
    return
  end

  if showMenu and checkTimer("fadeOut", timers) == false then
    if key == "up" or key == "down"  then
      correctWord:play()
      if selection == 1 then selection = 2 else selection = 1 end
    elseif (key == "return" or key == "space") and checkTimer("fadeOut", timers) == false then -- quit on escape
      menuSelect:play()
      difficulty = selection
      -- Gamestate.switch(game) -- swtich to game screen
      -- Gamestate.switch(inbetween) -- swtich to game screen
      resetTimer(0.0, "introFade", timers)
      addTimer(5.0, "fadeOut", timers)
      flashSpeed = 1000
    end
  end
end

function menu:update(dt)
  if updateTimer(dt, "introFade", timers) then
    menuMusic:setVolume(menuMusic:getVolume() - dt * 0.1)
  end

  flash = flash + (dt * flashDir) * flashSpeed
  if flash > 255 then flash = 255 elseif flash < 0 then flash = 0 end
  if flash <= 0 or flash >= 255 then
    flashDir = - flashDir
  end

  if checkTimer("fadeOut", timers) and updateTimer(dt, "fadeOut", timers) == false then
    fade = fade + dt * 75
  elseif checkTimer("fadeOut", timers) and getTimerStatus("fadeOut", timers) then
    Gamestate.switch(inbetween) -- swtich to game screen
    -- Gamestate.switch(welcome) -- swtich to game screen
  end

  if selection == 1 then
    menuText = {{255, 255, 0, 255, 255}, "normal\n", {255, 255, 255, 255}, "expert"}
  else
    menuText = {{255, 255, 255, 255}, "normal\n", {255, 255, 0, 255, 255}, "expert"}
  end
end

function menu:draw()
  maid64.start()

  love.graphics.setFont(bigFont)

  if showMenu then
    love.graphics.setColor(NONE)
    love.graphics.printf(menuText, 0, 180, 102*4, "center")
  else
    love.graphics.setColor({255, 255, 255, flash})
    love.graphics.printf("Press Space!", 0, 180, 102*4, "center")
  end

  love.graphics.setColor(NONE)
  love.graphics.draw(titleImg, 32, 32, 0, 1, 1, 32, 32)
  love.graphics.setFont(medFont)
  love.graphics.printf("Stumphead Games", 0, 239, 102*4, "center")
  love.graphics.draw(copyright, 125, 231.5, 0, 1, 1, 0, 0)

  if fade > 255 then fade = 255 end
  love.graphics.setColor({0, 0, 0, fade})
  love.graphics.rectangle("fill", 0, 0, 408, 256)

  maid64.finish()
end
