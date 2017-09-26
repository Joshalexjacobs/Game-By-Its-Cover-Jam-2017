-- keyboMain.lua

background = require "keyboBlaster/scrollingBG"
require "keyboBlaster/words"

local keybo = {
  x = 175,
  y = 190,
  image = "img/keyboard.png",
  timers = {},
}

local count = 0
local kbDamage = 0

function loadKeybo()
  dodgebox = maid64.newImage("img/dodge.png")
  enemyBar = maid64.newImage("img/enemyBar.png")
  keybo.image = maid64.newImage(keybo.image)

  background.load()

  addTimer(0.0, "spawn", keybo.timers)
  loadWords(getCurrentEnemy())
end

function dodgeParser(string)
  local words = getWords()
  for i = 1, #words do -- for the future, this should be it's own function (eg. checkWord(string))
    if stripSpaces(words[i].text) == stripSpaces(string) and words[i].isDangerous then
      -- table.remove(words, i)
      words[i].isDangerous = false
      words[i].color = {0, 255, 0, 255}
      count = count + 1
      correctWord:play()

      if getPlayer().curSpecial == getSpecials().gains then
        getPlayer().curSpecial(getPlayer())
      end

      return ''
    end
  end

  return ''
end

function updateKeybo(dt)
  local curEnemy = getCurrentEnemy()
  if updateTimer(dt, "spawn", keybo.timers) then
    addWord(curEnemy.attackWords[love.math.random(1, #curEnemy.attackWords)])
    resetTimer(curEnemy.attackRate, "spawn", keybo.timers)
  end

  updateWords(dt)
  background.update(dt)

  if count == curEnemy.attackLength or getPlayerHealth() <= 0 then
    setLog(curEnemy.name .. " dealt " .. kbDamage .. " damage!")
    resetTimer(0.0, "spawn", keybo.timers)
    clearWords()
    curEnemy.isAttacking = false
    curEnemy.stamina = 0
    count = 0
    kbDamage = 0
    dodge = false
  end
end

function damageKeybo()
  count = count + 1
  local curEnemy = getCurrentEnemy()

  local dmIndex = love.math.random(1, #damage)
  damage[dmIndex]:setPitch(1 - love.math.random(-1, 1) * 0.1)
  damage[dmIndex]:play()

  setShake(0.2, 1.0)
  local actualDamage = damagePlayer(curEnemy.attackDamage)
  kbDamage = kbDamage + actualDamage
  addPoints(love.math.random(25, 300), 200, actualDamage, {255, 0, 0, 255})
end

function drawKeybo()
  local curEnemy = getCurrentEnemy()
  background.draw()

  love.graphics.draw(keybo.image, keybo.x, keybo.y, 0, 1, 1, 0, 0)
  drawWords()
  love.graphics.printf(string, 0, 230, 102*4, "center")

  local displayCount = count / curEnemy.attackLength
  displayCount = displayCount * 196
  love.graphics.rectangle("fill", 106, 218, displayCount, 2)

  love.graphics.draw(dodgebox, 0, 0, 0, 1, 1, 0, 0)
end
