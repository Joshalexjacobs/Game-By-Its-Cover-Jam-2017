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
end

function parser(word)
  local match = challengerFile[cfIndex][curWord].word

  if word == match then
    challengerFile[cfIndex][curWord].color = PASS
  else
    challengerFile[cfIndex][curWord].color = FAIL
  end

  curWord = curWord + 1

  if curWord > #challengerFile[cfIndex] then
    cfIndex = cfIndex + 1
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

  love.graphics.printf(coloredText, 4, 150, 404, "center")
  love.graphics.setColor(NONE)
end
