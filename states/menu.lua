--menu.lua

require "states/game"
require "states/inbetween"

menu = {}

local state = 0

local timers = {}

local flash = 0
local flashSpeed = 400
local flashDir = 1

local fade = 0

function menu:enter()
  titleImg = maid64.newImage("img/title.png")
  copyright = maid64.newImage("img/copyright.png")
  menuMusic = love.audio.newSource("music/Mercury.wav")
  menuMusic:setLooping(true)
  menuMusic:play()

  addTimer(30.0, "introFade", timers)

end

function menu:keypressed(key, code)
  -- pressed enter/space
  if key ~= nil and checkTimer("fadeOut", timers) == false then -- quit on escape
    menuSelect:play()
    -- Gamestate.switch(game) -- swtich to game screen
    -- Gamestate.switch(inbetween) -- swtich to game screen
    resetTimer(0.0, "introFade", timers)
    addTimer(5.0, "fadeOut", timers)
    flashSpeed = 1000
    -- menuMusic:stop()
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
  end
end

function menu:draw()
  maid64.start()

  love.graphics.setFont(bigFont)
  love.graphics.setColor({255, 255, 255, flash})
  love.graphics.printf("Press Space!", 0, 180, 102*4, "center")
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
