--game.lua

game = {}

string = ""

battle = false

function game:enter()
  textBox = maid64.newImage("img/textbox.png")
  stage = maid64.newImage("img/stage.png")

  menuMusic:stop()

  -- level music
  chimpMusic = love.audio.newSource("music/Venus.wav")
  -- chimpMusic:setVolume(0)
  chimpMusic:setLooping(true)
  chimpMusic:play()

  -- keyboard sfx
  keyboard = {
    love.audio.newSource("sfx/keyboard/keyboard1.wav", "static"),
    love.audio.newSource("sfx/keyboard/keyboard2.wav", "static"),
    love.audio.newSource("sfx/keyboard/keyboard4.wav", "static"),
    love.audio.newSource("sfx/keyboard/keyboard5.wav", "static"),
    love.audio.newSource("sfx/keyboard/keyboard6.wav", "static")
  }

  for i = 1, #keyboard do
    keyboard[i]:setVolume(0.35)
  end

  playerLoad()
  loadChallengerFile()
end

function clickClack()
  local kbIndex = love.math.random(1, #keyboard)
  keyboard[kbIndex]:setPitch(1 - love.math.random(-1, 1) * 0.1)
  keyboard[kbIndex]:play()
end

function game:textinput(t) -- add user keystrokes to existing input
  if t ~= ' ' then
    string = string .. t
  elseif t == ' ' and #string > 0 and battle == false then
    string = parser(string .. t)
  elseif t == ' ' and #string > 0 and battle then
    string = battleParser(string .. t)
  end

  if #string > 20 then
    if battle == false then
      string = parser(string .. t)
    elseif battle then
      string = battleParser(string .. t)
    end
  end

  clickClack()
end

function game:keypressed(key, code)
  -- pressed backspace
  if key == "backspace" then
    string = string.sub(string, 1, #string - 1)
    clickClack()
  -- elseif key == "return" then
  --   string = parser(string .. ' ')
  end
end

function game:update(dt)
  updatePoints(dt)
  local player = updatePlayer(dt)

  if player.stamina >= player.staminaMAX then
    battle = true
  end
  -- if menuMusic:getVolume() ~= 0 then
  --   menuMusic:setVolume(menuMusic:getVolume() - dt * 0.25)
  -- elseif menuMusic:getVolume() == 0 then
  --   menuMusic:stop()
  -- end

  -- if chimpMusic:getVolume() ~= 1 then
  --   chimpMusic:setVolume(chimpMusic:getVolume() + dt * 0.1)
  -- end
end

function game:draw()
  maid64.start()

  -- draw background images
  --love.graphics.draw(stage, 32, 32, 0, 1, 1, 32, 32)
  love.graphics.draw(textBox, 32, 189, 0, 1, 1, 32, 32)

  drawEnemy()

  -- draw words to type
  love.graphics.setFont(medFont)
  if battle == false then
    drawCurrentWord()
  else
    drawBattleOptions()
  end

  -- draw UI stuff
  love.graphics.printf(string, 0, 230, 102*4, "center")
  drawScore()
  drawPlayerBars()
  drawPoints()


  maid64.finish()
end
