-- words.lua

local word ={
  x = 0,
  y = 0,
  speed = 100,
  text = "",
  length = 0,
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

  table.insert(words, newWord)
end

function updateWords(dt)
  for i, word in ipairs(words) do
    word.y = word.y + (word.speed * dt)

    if word.y >= 185 then
      table.remove(words, i)
      damageKeybo()
    end
  end
end

function clearWords()
  words = {}
end

function drawWords()
  for _, word in ipairs(words) do
    love.graphics.printf(word.text, word.x, word.y, 300)
  end
end
