--game.lua

game = {}

string = ""

function game:enter()
  titleImg = maid64.newImage("img/title.png")

  menuMusic:stop()

  loadChallengerFile()
end

function game:textinput(t) -- add user keystrokes to existing input
  if t ~= ' ' then
    string = string .. t
  elseif t == ' ' then
    string = parser(string .. t)
  end
end

function game:keypressed(key, code)
  -- pressed enter/space
  if key == "backspace" then
    string = string.sub(string, 1, #string - 1)
  end
end

function game:update(dt)

end

function game:draw()
  maid64.start()
  love.graphics.setFont(bigFont)
  love.graphics.printf("TYPING CHIMP", 0, 20, 102*4, "center")

  love.graphics.setFont(medFont)
  drawCurrentWord()
  love.graphics.printf(string, 0, 180, 102*4, "center")

  maid64.finish()
end
