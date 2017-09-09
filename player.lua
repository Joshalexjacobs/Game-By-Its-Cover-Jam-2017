-- player.lua

local player = {
  health = 100,
  healthMAX = 100,
  staminaMAX = 25,
  stamina = 20,
  shieldMAX = 7,
  shield = 0,
  endurance = 2,
  strength = 3,
  attackDie = 6,
  attackMultiplier = 1
}

local battleOptions = {}

function playerLoad()
  heart = maid64.newImage("img/heart.png")
  stamina = maid64.newImage("img/stamina.png")
  shield = maid64.newImage("img/shield.png")

  table.insert(battleOptions, NONE) -- 1
  table.insert(battleOptions, "attack ") -- 2

  table.insert(battleOptions, NONE) -- 3
  table.insert(battleOptions, "defend ") -- 4

  table.insert(battleOptions, FAIL) -- 5
  table.insert(battleOptions, "special ") -- 6
end

function attack()
  -- calculate and return damage
  local damage = 0

  for i = 1, player.attackMultiplier do
    damage = damage + love.math.random(1, player.attackDie) + player.strength
  end

  player.stamina = 0

  setLog("Howard took "..damage.." damage!")

  return damage
end

function defend()
  player.shield = player.shield + player.endurance
  if player.shield > player.shieldMAX then
    player.shield = player.shieldMAX
    -- change battleOptions so shield is red
  end
  addPoints(love.math.random(25, 100), 200, player.endurance, {0, 0, 255, 255})
  player.stamina = 0
  defendSFX:play()
  setLog("Shield increased by " .. player.endurance .."!")
end

function special()
  if battleOptions[5] == FAIL then
    setLog("Your special is not ready yet!")
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

  -- shield:
  local displayShield = player.shield / player.shieldMAX
  if displayShield > 1 then displayShield = 1 end
  displayShield = displayShield * 112
  love.graphics.rectangle("fill", 7, 24, displayShield, 3)
  love.graphics.draw(shield, 7, 12, 0, 1, 1, 0, 0)
end
