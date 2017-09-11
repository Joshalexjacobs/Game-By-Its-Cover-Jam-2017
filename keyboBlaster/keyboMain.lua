-- keyboMain.lua

background = require "keyboBlaster/scrollingBG"
-- require "keyboBlaster/bullets"
require "keyboBlaster/words"

local keybo = {
  x = 175,
  y = 190,
  image = "img/keyboard.png",
  timers = {},
}

local count = 0

function loadKeybo()
  dodgebox = maid64.newImage("img/dodge.png")
  keybo.image = maid64.newImage(keybo.image)

  background.load()

  addTimer(0.0, "spawn", keybo.timers)
  loadWords(getCurrentEnemy())
end

function dodgeParser(string)
  local words = getWords()
  for i = 1, #words do
    if stripSpaces(words[i].text) == stripSpaces(string) then
      table.remove(words, i)
      count = count + 1
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

  if count == curEnemy.attackLength then
    resetTimer(0.0, "spawn", keybo.timers)
    clearWords()
    curEnemy.isAttacking = false
    curEnemy.stamina = 0
    count = 0
    dodge = false
  end
end

local function details()
  -- draws helpful tips
end

function drawKeybo()
  background.draw()

  love.graphics.draw(keybo.image, keybo.x, keybo.y, 0, 1, 1, 0, 0)
  drawWords()
  love.graphics.printf(string, 0, 230, 102*4, "center")

  love.graphics.draw(dodgebox, 0, 0, 0, 1, 1, 0, 0)
end
