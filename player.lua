-- player.lua

local player = {
  health = 100,
  healthMAX = 100,
  staminaMAX = 25,
  stamina = 0,
  shieldMAX = 10,
  shield = 0,
}

local battleOptions = {}

function playerLoad()
  heart = maid64.newImage("img/heart.png")
  stamina = maid64.newImage("img/stamina.png")

  table.insert(battleOptions, NONE) -- 1
  table.insert(battleOptions, "attack ") -- 2

  table.insert(battleOptions, NONE) -- 3
  table.insert(battleOptions, "defend ") -- 4

  table.insert(battleOptions, FAIL) -- 5
  table.insert(battleOptions, "special ") -- 6
end

function attack()
  print("attack")
end

function defend()
  print("defend")
end

function special()
  if battleOptions[5] == FAIL then
    print("CANNOT CAST SPECIAL")
  else
    -- do special stuff
  end
end

function addStamina(x)
  player.stamina = player.stamina + x
end

function getBattleOptions()
  return battleOptions
end

function updatePlayer(dt)
  return player
end

function drawPlayerBars()
  -- health:
  local displayHealth = player.health / player.healthMAX
  if displayHealth > 1 then displayHealth = 1 end
  displayHealth = displayHealth * 36
  love.graphics.draw(heart, 5, 5, 0, 1, 1, 0, 0)
  love.graphics.rectangle("fill", 24, 7.5, displayHealth, 10)

  -- stamina:
  local displayStamina = player.stamina / player.staminaMAX
  if displayStamina > 1 then displayStamina = 1 end
  displayStamina = displayStamina * 36
  love.graphics.draw(stamina, 65, 5, 0, 1, 1, 0, 0)
  love.graphics.rectangle("fill", 84, 7.5, displayStamina, 10)
end
