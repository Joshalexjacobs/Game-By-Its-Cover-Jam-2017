-- typingChimp.lua
-- #AGBIC #indiegames #gamedev #love2d
local enemy = {
  name = "Darrel",
  aka = "Data Entry Darrel",
  sentenceTime = 25,
  healthMAX = 50,
  health = 50,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 0.45,
  timers = {},
  color = {255, 255, 255, 255},
  image = "img/dataDarrel.png", -- 164 x 128
  portrait = "img/dataDarrelP.png", -- 72 x 72
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
  attackRate = 1.4,
  attackLength = 4,
  attackSpeed = 27.5, --45
  attackDamage = 3,
  isDead = false,
  reward = 2, -- skill points awarded to the player after winning
  -- words
  easy = 250,
  med = 125,
  hard = 25,
  expert = 0
}

local expert = {
  sentencetTime = 15,
  healthMAX = 75,
  health = 75,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 0.85,
  attackRate = 1.1,
  attackLength = 4,
  attackSpeed = 45,
  attackDamage = 3
}

local hard = {
  sentencetTime = 20,
  healthMAX = 60,
  health = 60,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 0.8,
  attackRate = 1.25,
  attackLength = 4,
  attackSpeed = 40,
  attackDamage = 3
}

enemy.setWords = function()
  shuffleWords()

  local wordBank = {}
  local easy = getEasy()
  local med = getMed()
  local hard = getHard()

  -- easy
  for i = 1, enemy.easy do
    table.insert(wordBank, easy[i])
  end

  -- med
  for i = 1, enemy.med do
    table.insert(wordBank, med[i])
  end

  -- hard
  for i = 1, enemy.hard do
    table.insert(wordBank, hard[i])
  end

  setWordBank(wordBank)
  enemy.attackWords = getWordBank()
end

enemy.load = function()
  enemy.image = maid64.newImage(enemy.image)
  enemy.portrait = maid64.newImage(enemy.portrait)
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

  if enemy.isDead == false then
    if enemy.stamina >= enemy.staminaMAX and enemy.isAttacking == false then
      enemy.isAttacking = true
      setLog(enemy.name .. " is getting ready to attack!")
    elseif enemy.isAttacking == false then
      enemy.stamina = enemy.stamina + enemy.staminaRate * dt
    end
  end
end

enemy.draw = function()
  -- draw enemy
  love.graphics.setColor(enemy.color)
  love.graphics.draw(enemy.image, 140, 0, 0, 1, 1, 0, 0) -- image is 164 x 128
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
