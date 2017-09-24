-- specials.lua

local specials = {
  heal = nil,
  attack = nil,
  perfect = nil,
  gains = nil,
  stamina = nil
}

function getSpecials()
  return specials
end

specials.heal = function(player)
  player.health = player.health + 5
  perfectLine:play()
  setLog("Player healed for 5 health!")
end

specials.attack = function(player)
  -- calculate and return damage
  local curEnemy = getCurrentEnemy()
  local damage = 0

  for i = 1, player.attackMultiplier do
    damage = damage + love.math.random(1, player.attackDie) + player.strength
  end

  setShake(0.2, 1.0)

  setLog(curEnemy.name .. " took "..damage.." damage!")

  curEnemy.damage(damage)
end

specials.perfect = function(player)
  -- calculate and return damage
  local curEnemy = getCurrentEnemy()
  local damage = 1
  local health = 1

  setShake(0.2, 1.0)

  setLog(curEnemy.name .. " took "..damage.." damage and player was healed for " .. health .. " health!")

  player.health = player.health + health
  curEnemy.damage(damage)
end

specials.gains = function(player)
  local special = 0.25
  local stamina = 0.5
  if player.stamina >= player.staminaMAX then
    player.shield = player.shield + special
    setLog("player gains " .. special .. " special!")
  else
    player.stamina = player.stamina + stamina
    setLog("player gains " .. stamina .. " stamina!")
  end
end

specials.stamina = function(player, points)
  local percentage = 1.05

  return points * percentage
end
