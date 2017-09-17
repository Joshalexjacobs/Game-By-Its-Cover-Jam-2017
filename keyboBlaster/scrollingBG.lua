--scrollingBG.lua

local background = {
  sprite = "img/bg1.png",
  x1 = 0,
  y1 = 0,
  x2 = 0,
  y2 = -256, -- -256
  w = 0,
  h = 0,
  -- functions
  load = nil,
  update = nil,
  draw = nil,
  -- other
  speed = 225 -- 200
}

background.load = function ()
  background.sprite = maid64.newImage(background.sprite)
  background.h = background.sprite:getHeight() - 5
end

background.update = function (dt)
  local move = background.speed * dt
  background.y1 = background.y1 + move
  background.y2 = background.y2 + move

  if background.y1 >= background.h then
    background.y1 = -background.h
  end

  if background.y2 >= background.h then
    background.y2 = -background.h
  end
end

background.draw = function ()
  love.graphics.setColor({0, 0, 0, 255})
  love.graphics.rectangle("fill", 102, 32, 204, 192)
  love.graphics.setColor(NONE)

  -- bottom
  love.graphics.draw(background.sprite, background.x1, background.y1)

  -- top
  love.graphics.draw(background.sprite, background.x2, background.y2)
end

return background
