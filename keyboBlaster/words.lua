-- words.lua

local word ={
  x = 0,
  y = 0,
  speed = 100, -- 100
  text = "",
  letters = {},
  length = 0,
  color = {255, 255, 255, 255},
  isDangerous = true
}

local words = {}

function loadWords(enemy)
  word.speed = enemy.attackSpeed
end

function getWords()
  return words
end

function addWord(attackWord)
  newWord = copy(word, newWord)
  newWord.text = attackWord
  newWord.length = #attackWord
  newWord.x = love.math.random(115, 225)

  local text = newWord.text
  for i = 1, #newWord.text do
    local newLetter = {letter = string.sub(text, i, i), y = i, dir = 1}
    text = string.sub(text, 1, #text)
    table.insert(newWord.letters, newLetter)
  end

  table.insert(words, newWord)
end

function updateWords(dt)
  for i, word in ipairs(words) do
    word.y = word.y + (word.speed * dt)

    for _, letter in ipairs(word.letters) do
      if letter.y >= 0.75 and letter.dir == 1 then
        letter.dir = - letter.dir
      elseif letter.y <= -0.75 and letter.dir == -1 then
        letter.dir = - letter.dir
      end

      letter.y = letter.y + ((math.sin(5 * dt)) * letter.dir)
    end

    if word.y >= 185 and word.isDangerous then
      word.isDangerous = false
      word.color = {255, 0, 0, 255}
      damageKeybo()
    elseif word.y >= 300 then
      table.remove(words, i)
    end

  end
end

function clearWords()
  words = {}
end

function drawWords()
  for _, word in ipairs(words) do
    for i = 1, #word.text do
      local modifier = 0
      if i ~= 1 then
        modifier = (i-1)  * 7.5
      end

      love.graphics.setColor(word.color)
      -- love.graphics.printf(word.letters[i], word.x + modifier, word.y, 300)
      love.graphics.printf(word.letters[i].letter, word.x + modifier, word.y + word.letters[i].y, 300)
    end
    -- love.graphics.setColor(word.color)
    -- love.graphics.printf(word.text, word.x, word.y, 300)
  end
end
