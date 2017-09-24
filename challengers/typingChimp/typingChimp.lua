-- typingChimp.lua
-- #AGBIC #indiegames #gamedev #love2d
local chimp = {
  name = "Howard",
  aka = "The Typing Chimp",
  sentenceTime = 15,
  healthMAX = 30,
  health = 30,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 0.75,
  timers = {},
  color = {255, 255, 255, 255},
  image = "img/newmonkey.png",
  portrait = "img/monkeyPortrait.png",
  ui = "img/enemyHP.png",
  -- functions
  load = nil,
  damage = nil,
  update = nil,
  draw = nil,
  drawUI = nil,
  -- booleans
  isAttacking = false,
  attackWords = {},
  attackRate = 1.0,
  attackLength = 5,
  attackSpeed = 50, --45
  attackDamage = 2,
  isDead = false,
  reward = 1, -- skill points awarded to the player after winning
}

chimp.load = function()
  chimp.image = maid64.newImage(chimp.image)
  chimp.portrait = maid64.newImage(chimp.portrait)
  chimp.ui = maid64.newImage(chimp.ui)

  chimp.attackWords = getWordBank()

  addTimer(0.0, "isHit", chimp.timers)
  addTimer(0.0, "hitTime", chimp.timers)
end

chimp.damage = function(x)
  chimp.health = chimp.health - x
  resetTimer(1.0, "isHit", chimp.timers)
  addPoints(love.math.random(190, 210), 80, x, {255, 255, 0, 255})

  local dmIndex = love.math.random(1, #damage)
  damage[dmIndex]:setPitch(1 - love.math.random(-1, 1) * 0.1)
  damage[dmIndex]:play()
end

chimp.update = function(dt)
  if updateTimer(dt, "isHit", chimp.timers) == false then
    if updateTimer(dt, "hitTime", chimp.timers) then
      if chimp.color == NONE then
        chimp.color = {255, 255, 255, 0}
      else
        chimp.color = NONE
      end

      resetTimer(0.05, "hitTime", chimp.timers)
    end
  else
    chimp.color = NONE
  end

  if chimp.isDead == false then
    if chimp.stamina >= chimp.staminaMAX and chimp.isAttacking == false then
      chimp.isAttacking = true
      setLog(chimp.name .. " is getting ready to attack!")
    elseif chimp.isAttacking == false then
      chimp.stamina = chimp.stamina + chimp.staminaRate * dt
    end
  end
end

chimp.draw = function()
  -- draw chimp
  love.graphics.setColor(chimp.color)
  love.graphics.draw(chimp.image, 140, 0, 0, 1, 1, 0, 0)
  love.graphics.setColor(NONE)
end

chimp.drawUI = function()
  -- draw chimp health
  love.graphics.setColor({113, 15, 7, 255})

  local displayHealth = chimp.health / chimp.healthMAX
  if displayHealth > 1 then displayHealth = 1 end
  if displayHealth < 0 then displayHealth = 0 end
  displayHealth = displayHealth * 74

  love.graphics.rectangle("fill", 325, 7.5, displayHealth, 10)
  love.graphics.setColor(NONE)
  love.graphics.printf(chimp.name, 325, 10, 74, "center")
  love.graphics.draw(chimp.ui, 324, 5, 0, 1, 1, 0, 0)
end

return chimp
