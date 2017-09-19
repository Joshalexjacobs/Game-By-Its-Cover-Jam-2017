--game.lua

-- pre-fight/post-fight screen options:
-- 1. Next Battle
-- 2. Level
-- 3. Quit

game = {}

string = ""

battle = false
dodge = false
win = false
loss = false

function resetGame()
  -- reset globals
  battle = false
  dodge = false
  win = false
  loss = false
  calculateStats()
end

function game:enter()
  menuMusic:stop()

  fast:setVolume(0.25)
  fast:rewind()
  fast:play()

  setLog("Type!")

  -- loadKeybo()
  -- loadWordBank()
  -- loadWords(getCurrentEnemy())
end

function game:textinput(t) -- add user keystrokes to existing input
  if t ~= ' ' then
    string = string .. t
  elseif t == ' ' and #string > 0 and win then
    string = winParser(string .. t)
  elseif t == ' ' and #string > 0 and win == false and loss then
    string = lossParser(string .. t)
  elseif t == ' ' and #string > 0 and win == false and loss == false and battle == false and dodge == false then
    string = parser(string .. t)
  elseif t == ' ' and #string > 0 and win == false and loss == false and battle and dodge == false then
    string = battleParser(string .. t)
  elseif t == ' ' and #string > 0 and win == false and loss == false and battle == false and dodge then
    string = dodgeParser(string .. t)
  end

  if #string > 20 then
    if battle == false then
      string = parser(string .. t)
    elseif battle then
      string = battleParser(string .. t)
    elseif dodge then
      string = dodgeParser(string .. t)
    elseif win then
      string = winParser(string .. t)
    -- elseif loss then
      -- string = lossParser(string .. t)
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
  local player = updatePlayer(dt)

  if player.health <= 0 then
    loss = true
    battle = false
    dodge = false
  end

  if getCurrentEnemy().health <= 0 then
    if win == false then
      player.skillPoints = player.skillPoints + getCurrentEnemy().reward
      win = true
    end
    battle = false
    dodge = false
  end

  updatePoints(dt)
  challengerUpdate(dt)
  updateCamera(dt)

  if win == false and loss == false then
    -- challengerUpdate(dt)

    if player.stamina >= player.staminaMAX and dodge == false and battle == false then
      battle = true
      setLog("Combat phase!")
    end

    if dodge and battle == false then
      updateKeybo(dt)
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
end

function game:draw()
  maid64.start()

  -- attach camera
  cam:attach()

  -- draw background images
  love.graphics.draw(stage, 32, 32, 0, 1, 1, 32, 32)
  love.graphics.draw(overlay, 32, 32, 0, 1, 1, 32, 32)
  love.graphics.draw(textBox, 32, 189, 0, 1, 1, 32, 32)

  drawEnemy()

  -- draw words to type
  love.graphics.setFont(medFont)
  if battle == false and win == false and loss == false then
    drawCurrentWord()
  elseif battle and win == false and loss == false then
    drawBattleOptions()
  elseif win then
    drawWinOptions()
  elseif loss then
    drawLossOptions()
  end

  if dodge then
    drawKeybo()
  end

  -- detach camera
  cam:detach()

  drawLog()

  -- draw UI stuff
  love.graphics.printf(string, 0, 230, 102*4, "center")
  drawScore()
  drawPlayerBars()
  drawPoints()

  if win then
    love.graphics.setFont(biggestFont)
    love.graphics.setColor(PASS)
    love.graphics.printf("--VICTORY!--", 0, 100, 102*4, "center")
    love.graphics.setFont(medFont)
  elseif loss then
    love.graphics.setFont(biggestFont)
    love.graphics.setColor(FAIL)
    love.graphics.printf("--DEFEAT!--", 0, 100, 102*4, "center")
    love.graphics.setFont(medFont)
  end

  love.graphics.setColor(NONE)

  maid64.finish()
end
