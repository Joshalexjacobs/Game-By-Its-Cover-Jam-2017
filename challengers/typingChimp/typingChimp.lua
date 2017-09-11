-- typingChimp.lua

local enemy = {
  name = "Howard",
  healthMAX = 25,
  health = 2,
  staminaMAX = 25,
  stamina = 24.5,
  staminaRate = 1,
  timers = {},
  color = {255, 255, 255, 255},
  image = "img/monkey2.png",
  ui = "img/enemyHP.png",
  -- functions
  load = nil,
  damage = nil,
  update = nil,
  draw = nil,
  drawUI = nil,
  -- booleans
  isAttacking = false,
  attackWords = {
    "banana",
    "rascal",
    "scamp",
    "primate",
    "ape",
    "monkey",
  },
  attackRate = 1.5,
  attackLength = 5,
  attackSpeed = 40,
  attackDamage = 2
}

enemy.load = function()
  enemy.image = maid64.newImage(enemy.image)
  enemy.ui = maid64.newImage(enemy.ui)

  addTimer(0.0, "isHit", enemy.timers)
  addTimer(0.0, "hitTime", enemy.timers)
end

enemy.damage = function(x)
  enemy.health = enemy.health - x
  resetTimer(1.0, "isHit", enemy.timers)
  addPoints(love.math.random(190, 210), 80, x, {255, 255, 0, 255})

  local dmIndex = love.math.random(1, #damage)
  damage[dmIndex]:setPitch(1 - love.math.random(-1, 1) * 0.1)
  damage[dmIndex]:play()
end

enemy.update = function(dt)
  if updateTimer(dt, "isHit", enemy.timers) == false then
    if updateTimer(dt, "hitTime", enemy.timers) then
      if enemy.color == NONE then
        enemy.color = {255, 255, 255, 0}
      else
        enemy.color = NONE
      end

      resetTimer(0.05, "hitTime", enemy.timers)
    end
  else
    enemy.color = NONE
  end

  if enemy.stamina >= enemy.staminaMAX and enemy.isAttacking == false then
    enemy.isAttacking = true
    setLog(enemy.name .. " is getting ready to attack!")
  elseif enemy.isAttacking == false then
    enemy.stamina = enemy.stamina + enemy.staminaRate * dt
  end
end

enemy.draw = function()
  -- draw enemy
  love.graphics.setColor(enemy.color)
  love.graphics.draw(enemy.image, 175, 64, 0, 1, 1, 0, 0)
  love.graphics.setColor(NONE)
end

enemy.drawUI = function()
  -- draw enemy health
  love.graphics.setColor({113, 15, 7, 255})

  local displayHealth = enemy.health / enemy.healthMAX
  if displayHealth > 1 then displayHealth = 1 end
  if displayHealth < 0 then displayHealth = 0 end
  displayHealth = displayHealth * 74

  love.graphics.rectangle("fill", 325, 7.5, displayHealth, 10)
  love.graphics.setColor(NONE)
  love.graphics.printf(enemy.name, 325, 10, 74, "center")
  love.graphics.draw(enemy.ui, 324, 5, 0, 1, 1, 0, 0)
end

return enemy
