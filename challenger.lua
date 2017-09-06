-- challengerLoader

--[[
Challengers:
- Typing Chimp
- Data Entry Darrel
- Batty Bookkeeper
- The Squinting Stenographer
- Queen QWERTY
]]

local challengersFiles = {
  "challengers/typingChimp/typingChimp.txt", -- typing chimp
}
local challengersIndex = 1

local challengerFile = {}
local cfIndex = 1
local curWord = 1

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

local challenger = {}

-- colors:
local NONE = {255, 255, 255, 255}
local CURRENT = {255, 255, 0, 255}
local PASS = {0, 255, 0, 255}
local FAIL = {255, 0, 0, 255}

local function shuffle(x)
  local n = #x -- gets the length of the table
  while n >= 2 do -- only run if the table has more than 1 element
    local k = love.math.random(n) -- get a random number
    x[n], x[k] = x[k], x[n]
    n = n - 1
  end
  return x
end

function loadChallengerFile()
  -- load the current challenger's text file
  for line in io.lines(challengersFiles[challengersIndex]) do
    local newLine = {}

    while(#line > 0) do
      local newWord = {word = "", color = nil}
      newWord.word = string.sub(line, 1, string.find(line, ' '))
      newWord.color = NONE

      line = string.gsub(line, newWord.word, '')
      table.insert(newLine, newWord)
    end

    table.insert(challengerFile, newLine)
  end

  challengerFile = shuffle(challengerFile)
end

function reloadChallengerFile()
  cfIndex = 1

  for i, file in ipairs(challengerFile) do
    for j = 1, #challengerFile[i] do
      challengerFile[i][j].color = NONE
    end
  end

  challengerFile = shuffle(challengerFile)
end

local function stripSpaces(word)
  return string.gsub(word, ' ', '')
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

    addPoints(count)
    if cfIndex == #challengerFile then
      reloadChallengerFile()
    else
      cfIndex = cfIndex + 1
    end
    curWord = 1
  end

  return ''
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
end
