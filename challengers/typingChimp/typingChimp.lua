-- typingChimp.lua

local enemy = {
  name = "Howard",
  health = 50,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 5,
  timers = {},
  image = "img/monkey2.png",
  -- functions
  load = nil,
  damage = nil,
  update = nil,
  draw = nil,
}

enemy.load = function()
  enemy.image = maid64.newImage(enemy.image)
end

enemy.damage = function(x)
  enemy.health = enemy.health - x
end

enemy.update = function(dt)

end

enemy.draw = function()
  love.graphics.draw(enemy.image, 175, 64, 0, 1, 1, 0, 0)
end

return enemy
