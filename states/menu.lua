--menu.lua

require "states/game"

menu = {}

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
    Gamestate.switch(game) -- swtich to game screen
  end
end

function menu:update(dt)

end

function menu:draw()
  maid64.start()

  love.graphics.printf("Press Space!", 0, 180, 102*4, "center")
  love.graphics.draw(titleImg, 32, 32, 0, 1, 1, 32, 32)

  maid64.finish()
end
