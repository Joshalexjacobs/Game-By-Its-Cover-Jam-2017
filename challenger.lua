-- challengerLoader

local chimp = require "challengers/typingChimp/typingChimp"
local darrel = require "challengers/dataDarrel/dataDarrel"
local betty = require "challengers/bettyBookKeeper/bettyBookKeeper"
local stan = require "challengers/stanStenographer/stanStenographer"
local qwerty = require "challengers/queenQWERTY/queenQWERTY"
local challengers = {
  chimp,
  darrel,
  betty,
  stan,
  qwerty
}

local challengersIndex = 1

local wordBank = {}

-- [[ testing new word files ]]
local easy = {}
local med = {}
local hard = {}
local expert = {}

local challengerFile = {}
local cfIndex = 1
local curWord = 1

local curEnemy = nil

local challengerTimers = {}
local sentenceTimerMax = 15.0

--[[ challengerFile diagram:
{
  { -- line 1 -- cfIndex = 1
    {word = "place ", color = PASS}, -- word 1
    {"give ", color = FAIL},
    "country ",
  },
  { -- line 2

  }
}
]] --

local attackWord = ""
local aWordIndex = 1
local maxAttackBonus = 0
local attackBonus = 0

local returnKey = {
  x = 305,
  y = 110,
  spriteSheet = "img/returnKey.png",
  spriteGrid = nil,
  animations = {},
  curAnim = 1,
  isShowing = false,
}

function loadReturnKey()
  returnKey.spriteGrid = anim8.newGrid(100, 57, 200, 57, 0, 0, 0)
  returnKey.spriteSheet = maid64.newImage(returnKey.spriteSheet)
  returnKey.animations = {
    anim8.newAnimation(returnKey.spriteGrid("1-2", 1), 0.2), -- 1 idle
  }  
end

local function updateReturnKey(dt)
  returnKey.animations[returnKey.curAnim]:update(dt)
end

function drawReturnKey()
  if returnKey.isShowing then
    returnKey.animations[returnKey.curAnim]:draw(returnKey.spriteSheet, returnKey.x, returnKey.y)
  end
end

local function shuffle(x)
  local n = #x -- gets the length of the table
  while n >= 2 do -- only run if the table has more than 1 element
    local k = love.math.random(n) -- get a random number
    x[n], x[k] = x[k], x[n]
    n = n - 1
  end
  return x
end

local function generateLines()
  challengerFile = {}
  local lineLength = love.math.random(10, 14)
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

--[[ testing new word files ]]
function shuffleWords()
  shuffle(easy)
  shuffle(med)
  shuffle(hard)
  shuffle(expert)
end

function getEasy()
  return easy
end

function getMed()
  return med
end

function getHard()
  return hard
end

function getExpert()
  return expert
end

function loadWordFiles()
  for line in io.lines("challengers/easy.txt") do
    table.insert(easy, line)
  end

  for line in io.lines("challengers/med.txt") do
    table.insert(med, line)
  end

  for line in io.lines("challengers/hard.txt") do
    table.insert(hard, line)
  end

  for line in io.lines("challengers/expert.txt") do
    table.insert(expert, line)
  end

  shuffleWords()
end

function setWordBank(list)
  wordBank = {}

  for i = 1, #list do
    table.insert(wordBank, list[i])
  end
end

function loadChallengerFile()
  for i = 1, #challengers do
    challengers[i].load()
  end

  curEnemy = challengers[challengersIndex]
  curEnemy.setWords()

  generateLines()

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
    count = count + 1
    perfectLine:play()

    if getPlayer().curSpecial == getSpecials().perfect then
      getPlayer().curSpecial(getPlayer())
    end

  else
    endOfLine:play()
  end

  if getPlayer().curSpecial == getSpecials().stamina then
    count = getPlayer().curSpecial(getPlayer(), count)
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
    string = "" -- testing
  end

  resetTimer(curEnemy.sentenceTime, "sentenceTimer", challengerTimers)
end

function parser(word, eol)
  if curWord <= #challengerFile[cfIndex] then
  local match = stripSpaces(challengerFile[cfIndex][curWord].word)

  if stripSpaces(word) == match then
    challengerFile[cfIndex][curWord].color = PASS
    -- correctWord:setPitch(1 - love.math.random(-1, 1) * 0.2)
    correctWord:play()
  else
    challengerFile[cfIndex][curWord].color = FAIL
  end

  curWord = curWord + 1

  end
  -- if curWord > #challengerFile[cfIndex] then
    -- nextLine()
  -- end


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

  -- testing... not sure if im a fan of this or not
  if curWord > #challengerFile[cfIndex] then
    returnKey.isShowing = true
    
    if eol then
      returnKey.isShowing = false
      nextLine()
    end
  end

  return ''
end

function setAttackWord()
  shuffle(expert)
  attackWord = expert[1] -- !!! this actually needs to be seperated out into a list like coloredText, green/red/white/yellow
  -- this will also make it easer to compare which letters you entered correctly 
  -- then ill just need to make them move (sin) and add a timer
  maxAttackBonus = #attackWord
  aWordIndex = 1
end

function battleParser(word)
  if stripSpaces(word) == "attack" then
    -- curEnemy.damage(attack(curEnemy.name))
    -- battle = false

    -- new code
    setAttackWord()
    bAttack = true
  elseif stripSpaces(word) == "defend" then -- swap this out for abilities
    defend()
    battle = false
  elseif stripSpaces(word) == "special" then
    special()
  end

  return ''
end

function attackParser(word)
  if string.sub(word, aWordIndex, aWordIndex+1) == string.sub(attackWord, aWordIndex, aWordIndex+1) then
    attackBonus = attackBonus + 1
  end

  if #word == #attackWord then
    curEnemy.damage(attack(curEnemy.name, attackBonus, maxAttackBonus))

    bAttack = false
    battle = false
    return ' '
  end

  return word
end

function drawAttackWord()
  love.graphics.setColor({0, 0, 0, 200})
  love.graphics.rectangle("fill", 0, 45, 408, 50)
  love.graphics.setColor(NONE)
  love.graphics.setFont(bigFont)
  love.graphics.printf(attackWord, 0, 60, 408, "center")
  love.graphics.setFont(medFont)
end

function winParser(word)
  if stripSpaces(word) == "continue" then
    -- chimpMusic:stop()
    resetGame()

    if challengersIndex ~= 5 then
      challengersIndex = challengersIndex + 1
      curEnemy = challengers[challengersIndex]
      curEnemy.setWords()
      Gamestate.switch(inbetween)
    else
      Gamestate.switch(welcome)
    end
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
  updateReturnKey(dt)

  if battle == false and dodge == false and updateTimer(dt, "sentenceTimer", challengerTimers) then
    nextLine()
    returnKey.isShowing = false
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