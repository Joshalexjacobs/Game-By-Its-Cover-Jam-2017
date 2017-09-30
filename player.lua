-- player.lua

local player = {
  health = 50,
  healthMAX = 50, -- (vitality * 2.5)
  staminaMAX = 25, -- (25 - agility/4)
  stamina = 0,
  specialMAX = 35,
  shield = 30, -- repurposed for special ability
  vitality = 6, -- health
  endurance = 3, -- defense (enemy.damage - endurance / 4)
  strength = 5, -- attack
  agility = 3, -- stamina to reach
  attackDie = 6,
  attackMultiplier = 1,
  skillPoints = 1,
  curSpecial = nil
}

local battleOptions = {}

function calculateStats()
  player.staminaMAX = 25 - player.agility
  player.stamina = 0
  player.healthMAX = player.vitality * 2.5
  player.health = player.healthMAX
end

function playerLoad()
  -- set special
  player.curSpecial = getSpecials().heal


  heart = maid64.newImage("img/heart.png")
  stamina = maid64.newImage("img/stamina.png")
  shield = maid64.newImage("img/shield.png")

  -- set up basic stats
  calculateStats()
  -- player.staminaMAX = 25 - player.agility / 4
  -- player.healthMAX = player.vitality * 2.5
  -- player.health = player.healthMAX

  table.insert(battleOptions, NONE) -- 1
  table.insert(battleOptions, "attack ") -- 2

  table.insert(battleOptions, NONE) -- 3
  table.insert(battleOptions, "defend ") -- 4

  table.insert(battleOptions, FAIL) -- 5
  table.insert(battleOptions, "special ") -- 6
end

-- function calculateStats()
--   player.staminaMAX = 25 - player.agility / 4
--   player.stamina = 0
--   player.healthMAX = player.vitality * 2.5
--   player.health = player.healthMAX
-- end

function setPlayerSpecial(special)
  player.curSpecial = special
end

function damagePlayer(x)
  local actualDamage = x - player.endurance / 4
  player.health = player.health - actualDamage

  return actualDamage
end

function getPlayerHealth()
  return player.health
end

function getPlayerStats()
  local stats = {
    vitality = player.vitality,
    endurance = player.endurance,
    strength = player.strength,
    agility = player.agility,
    skillPoints = player.skillPoints,
    staminaMAX = player.staminaMAX,
    healthMAX = player.healthMAX
  }

  return stats
end

function updatePlayerStats(stats)
  if player.skillPoints > 0 then
    player.vitality = stats.vitality
    player.endurance = stats.endurance
    player.strength = stats.strength
    player.agility = stats.agility
    player.skillPoints = player.skillPoints - 1
    calculateStats()
    return true
  end

  return false
end

function attack(name, bonus, maxBonus)
  -- calculate and return damage
  local damage = 0

  -- bonus calculation should look something like:
  bonus = math.floor((bonus / maxBonus) * player.strength)
  -- print("bonus would be " .. bonus .. " player strength is " .. player.strength)

  damage = damage + love.math.random(5, player.attackDie) + player.strength + bonus

  player.stamina = 0
  setShake(0.2, 1.0)

  setLog(name .. " took "..damage.." damage!")
  return damage
end

function defend()
  player.shield = player.shield + player.endurance
  if player.shield > player.specialMAX then
    player.shield = player.specialMAX
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
  elseif player.curSpecial == getSpecials().perfect or player.curSpecial == getSpecials().gains or player.curSpecial == getSpecials().stamina then
    setLog("Your current special is a passive ability!")
  else
    player.shield = 0
    -- curSpecial()
    player.curSpecial(player)

    battleOptions[5] = FAIL
  end
end

function addStamina(x)
  local newStam = player.stamina + x
  if newStam > player.staminaMAX then
    newStam = newStam - player.staminaMAX
    player.shield = player.shield + newStam
    -- setLogY(newStam .. " points added to special meter!", 85)
    setLog(newStam .. " points added to special meter!")

    if player.shield >= player.specialMAX then
      battleOptions[5] = PASS
    end
  end
  player.stamina = player.stamina + x
end

function getPlayer()
  return player
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
  if displayHealth > 1 then displayHealth = 1
  elseif displayHealth < 0 then displayHealth = 0 end
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
  local displayShield = player.shield / player.specialMAX
  if displayShield > 1 then displayShield = 1 end
  displayShield = displayShield * 112
  love.graphics.rectangle("fill", 7, 24, displayShield, 3)
  love.graphics.draw(shield, 7, 12, 0, 1, 1, 0, 0)
end
