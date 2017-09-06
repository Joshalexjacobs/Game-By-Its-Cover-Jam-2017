-- player.lua

local player = {
  health = 100,
  staminaMAX = 25,
  stamina = 0,
  shieldMAX = 10,
  shield = 0,
}

function playerLoad()
  heart = maid64.newImage("img/heart.png")
  stamina = maid64.newImage("img/stamina.png")
end

function drawPlayerBars()
  -- health:
  love.graphics.draw(heart, 5, 5, 0, 1, 1, 0, 0)
  love.graphics.rectangle("fill", 24, 7.5, 36, 10) -- 36 is the max width

  -- stamina:
  love.graphics.draw(stamina, 65, 5, 0, 1, 1, 0, 0)
  love.graphics.rectangle("fill", 84, 7.5, 36, 10) -- 36 is the max width
end
