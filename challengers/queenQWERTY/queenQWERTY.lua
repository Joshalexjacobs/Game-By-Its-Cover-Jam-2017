-- typingChimp.lua
-- #AGBIC #indiegames #gamedev #love2d
local enemy = {
  name = "QWERTY",
  aka = "Queen Qwerty",
  sentenceTime = 25,
  healthMAX = 80,
  health = 80,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 0.7,
  timers = {},
  color = {255, 255, 255, 255},
  image = "img/qwerty.png", -- 164 x 128
  portrait = "img/qwertyP.png", -- 72 x 72
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
  attackRate = 1.15,
  attackLength = 5,
  attackSpeed = 40,
  attackDamage = 5,
  isDead = false,
  reward = 3, -- skill points awarded to the player after winning
  -- words
  easy = 130,
  med = 120,
  hard = 100,
  expert = 50
}

local expert = {
  sentenceTime = 15,
  healthMAX = 115,
  health = 115,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 1.1,
  attackRate = 0.95,
  attackLength = 7,
  attackSpeed = 55,
  attackDamage = 6
}

local hard = {
  sentenceTime = 20,
  healthMAX = 95,
  health = 95,
  staminaMAX = 25,
  stamina = 0,
  staminaRate = 0.9,
  attackRate = 1.0,
  attackLength = 5,
  attackSpeed = 50,
  attackDamage = 6
}

enemy.setWords = function()
  shuffleWords()

  local wordBank = {}
  local easy = getEasy()
  local med = getMed()
  local hard = getHard()
  local expert = getExpert()

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

  -- expert
  for i = 1, enemy.expert do
    table.insert(wordBank, expert[i])
  end

  setWordBank(wordBank)
  enemy.attackWords = getWordBank()
end

enemy.setDifficulty = function()
  if difficulty == 2 then
    enemy.sentenceTime = hard.sentenceTime
    enemy.healthMAX = hard.healthMAX
    enemy.health = hard.health
    enemy.staminaMAX = hard.staminaMAX
    enemy.staminaRate = hard.staminaRate
    enemy.attackRate = hard.attackRate
    enemy.attackLength = hard.attackLength
    enemy.attackSpeed = hard.attackSpeed
    enemy.attackDamage = hard.attackDamage
  elseif difficulty == 3 then
    enemy.sentenceTime = expert.sentenceTime
    enemy.healthMAX = expert.healthMAX
    enemy.health = expert.health
    enemy.staminaMAX = expert.staminaMAX
    enemy.staminaRate = expert.staminaRate
    enemy.attackRate = expert.attackRate
    enemy.attackLength = expert.attackLength
    enemy.attackSpeed = expert.attackSpeed
    enemy.attackDamage = expert.attackDamage
  end
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
