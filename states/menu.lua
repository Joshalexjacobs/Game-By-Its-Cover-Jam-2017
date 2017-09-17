--menu.lua

require "states/game"
require "states/inbetween"

menu = {}

local state = 0

function menu:enter()
  titleImg = maid64.newImage("img/title.png")
  menuMusic = love.audio.newSource("music/Mercury.wav")
  menuMusic:setLooping(true)
  menuMusic:play()

  print("loaded menu")
end

function menu:keypressed(key, code)
  -- pressed enter/space
  if key ~= nil then -- quit on escape
    menuSelect:play()
    -- Gamestate.switch(game) -- swtich to game screen
    Gamestate.switch(inbetween) -- swtich to game screen
    menuMusic:stop()
  end
end

function menu:update(dt)
  -- if state == 1 then
  --
  -- end
end

function menu:draw()
  maid64.start()

  love.graphics.setFont(bigFont)
  love.graphics.printf("Press Space!", 0, 180, 102*4, "center")
  love.graphics.draw(titleImg, 32, 32, 0, 1, 1, 32, 32)
  love.graphics.setFont(smallFont)
  love.graphics.printf("Stumphead Games", 0, 240, 102*4, "center")

  maid64.finish()
end
