-- challengerLoader

local chimp = require "challengers/typingChimp/typingChimp"
local darrel = require "challengers/dataDarrel/dataDarrel"
local batty = require "challengers/battyBookKeeper/battyBookKeeper"

local challengers = {
  chimp,
  darrel,
  batty
}

local challengersFiles = {
  "challengers/typingChimp/typingChimp.txt", -- typing chimp
  "challengers/dataDarrel/dataDarrel.txt", -- data darrel
  "challengers/battyBookKeeper/battyBookKeeper.txt", -- data darrel
  --[[
  Other Challengers:
  - Data Entry Darrel
  - Batty Bookkeeper
  - The Squinting Stenographer
  - Queen QWERTY
  ]]
}
local challengersIndex = 1

local wordBank = {}

local challengerFile = {}
local cfIndex = 1
local curWord = 1

local curEnemy = nil

local challengerTimers = {}
local sentenceTimerMax = 15.0

-- challengerFile diagram:
-- {
--   { -- line 1 -- cfIndex = 1
--     {word = "place ", color = PASS}, -- word 1
--     {"give ", color = FAIL},
--     "country ",
--   },
--   { -- line 2
--
--   }
-- }

-- local function shuffle(x)
--   local n = #x -- gets the length of the table
--   while n >= 2 do -- only run if the table has more than 1 element
--     local k = love.math.random(n) -- get a random number
--     x[n], x[k] = x[k], x[n]
--     n = n - 1
--   end
--   return x
-- end

local function generateLines()
  challengerFile = {}
  local lineLength = love.math.random(10, 15)
  local newLine = {}
  local tempWordBank = copy(wordBank, tempWordBank)

  for i = 1, 10 do
    for j = 1, lineLength do
      local rand = love.math.random(1, #tempWordBank)
      local newWord = {word = tempWordBank[rand]..' ', color = NONE}
      table.insert(newLine, newWord)
      -- table.remove(tempWordBank, rand) -- may be causing a concatenation bug in the line above
    end

    table.insert(challengerFile, newLine)
    newLine = {}
    local tempWordBank = copy(wordBank, tempWordBank)
  end
end

function loadWordBank()
  for line in io.lines(challengersFiles[challengersIndex]) do -- load the current wordBank to use
    table.insert(wordBank, line)
  end

  generateLines()
end

function loadChallengerFile()
  for i = 1, #challengers do
    challengers[i].load()
  end

  loadWordBank()
  curEnemy = challengers[challengersIndex]

  addTimer(0.0, "sentenceTimer", challengerTimers)
end

function getWordBank()
  return wordBank
end

function reloadChallengerFile()
  cfIndex = 1
  generateLines()
end

function stripSpaces(word)
  return string.lower(string.gsub(word, ' ', ''))
end

function nextLine()
  local count = 0

  for i, file in ipairs(challengerFile[cfIndex]) do
    if file.color == PASS then
      count = count + 1
    end
  end

  if #challengerFile[cfIndex] == count then
    count = count + 2
    perfectLine:play()
  else
    endOfLine:play()
  end

  -- increase player Stamina
  addPoints(love.math.random(25, 300), 200, count, {0, 255, 0, 255})
  addStamina(count)

  if cfIndex == #challengerFile then
    reloadChallengerFile()
  else
    cfIndex = cfIndex + 1
  end
  curWord = 1

  if curEnemy.isAttacking then
    dodge = true
    setLog("Type for your life!")
  end

  resetTimer(curEnemy.sentenceTime, "sentenceTimer", challengerTimers)
end

function parser(word)
  local match = stripSpaces(challengerFile[cfIndex][curWord].word)

  if stripSpaces(word) == match then
    challengerFile[cfIndex][curWord].color = PASS
    -- correctWord:setPitch(1 - love.math.random(-1, 1) * 0.2)
    correctWord:play()
  else
    challengerFile[cfIndex][curWord].color = FAIL
  end

  curWord = curWord + 1

  if curWord > #challengerFile[cfIndex] then
    nextLine()
    -- local count = 0
    --
    -- for i, file in ipairs(challengerFile[cfIndex]) do
    --   if file.color == PASS then
    --     count = count + 1
    --   end
    -- end
    --
    -- if #challengerFile[cfIndex] == count then
    --   count = count + 2
    --   perfectLine:play()
    -- else
    --   endOfLine:play()
    -- end
    --
    -- -- increase player Stamina
    -- addPoints(love.math.random(25, 300), 200, count, {0, 255, 0, 255})
    -- addStamina(count)
    --
    -- if cfIndex == #challengerFile then
    --   reloadChallengerFile()
    -- else
    --   cfIndex = cfIndex + 1
    -- end
    -- curWord = 1
    --
    -- if curEnemy.isAttacking then
    --   dodge = true
    --   setLog("Type for your life!")
    -- end
    --
    -- resetTimer(sentenceTimerMax, "sentenceTimer", challengerTimers)
  end

  return ''
end

function battleParser(word)
  if stripSpaces(word) == "attack" then
    curEnemy.damage(attack(curEnemy.name))
    battle = false
  elseif stripSpaces(word) == "defend" then
    defend()
    battle = false
  elseif stripSpaces(word) == "special" then
    special()
  end

  return ''
end

function winParser(word)
  if stripSpaces(word) == "continue" then
    -- chimpMusic:stop()
    resetGame()
    challengersIndex = challengersIndex + 1
    curEnemy = challengers[challengersIndex]
    Gamestate.switch(inbetween)
  end

  return ''
end

function lossParser(word)
  if stripSpaces(word) == "continue" then
    resetGame()
    Gamestate.switch(inbetween)
  end

  return ''
end

function getCurrentEnemy()
  return curEnemy
end

function challengerUpdate(dt)
  curEnemy.update(dt)

  if battle == false and dodge == false and updateTimer(dt, "sentenceTimer", challengerTimers) then
    nextLine()
  end
end

function drawCurrentWord()
  local coloredText = {}

  for i, file in ipairs(challengerFile[cfIndex]) do
    if i == curWord then
      table.insert(coloredText, CURRENT)
      table.insert(coloredText, file.word)
    else
      table.insert(coloredText, file.color)
      table.insert(coloredText, file.word)
    end
  end

  love.graphics.printf(coloredText, 12, 190, 390, "center")
  love.graphics.setColor(NONE)

  local time = math.floor(getTimerTime("sentenceTimer", challengerTimers) + 0.5)

  if time <= curEnemy.sentenceTime / 3 + 0.9 then
    love.graphics.setColor( {255, 255, 0, 255} )
  end

  love.graphics.printf(time, 0, 180, 390, "right")
  love.graphics.setColor(NONE)
end

function drawBattleOptions()
  love.graphics.printf(getBattleOptions(), 12, 190, 390, "center")
end

function drawWinOptions()
  love.graphics.printf("continue ", 12, 190, 390, "center")
end

function drawLossOptions()
  love.graphics.printf("continue", 12, 190, 390, "center")
end

function drawEnemy()
  curEnemy.draw()
  curEnemy.drawUI()
end
