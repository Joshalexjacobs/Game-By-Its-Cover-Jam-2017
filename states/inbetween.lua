--inbetween.lua

inbetween = {}

require "states/game"

local states = {
  {"battle ", "level ", "help "},
  {"vitality ", "endurance ", "strength ", "agility ", {255, 255, 0, 255}, "done "},
  {"health ", "move ", "s-points ", "vitality ", "endurance ", "strength ", "agility ", {255, 255, 0, 255}, "done "},
}

local state = 1

local stats = {}

local string = ""

function inbetween:enter()
  inbetweenBG = maid64.newImage("img/inbetween.png")
  textBox = maid64.newImage("img/textbox.png")

  stats = getPlayerStats()
end

local function inbetweenParser(text)
  if state == 1 then
    if stripSpaces(text) == 'battle' then
      state = 1
      correctWord:play()
      Gamestate.switch(game)
    elseif stripSpaces(text) == 'level' then
      state = 2
      correctWord:play()
      setHelpLog("select a stat to improve!", {255, 255, 255, 255})
    elseif stripSpaces(text) == 'help' then
      setHelpLog("type any stat for a description!", {255, 255, 255, 255})
      state = 3
      correctWord:play()
    end
  elseif state == 2 then
    if stripSpaces(text) == 'vitality' then
      stats.vitality = stats.vitality + 1
      if updatePlayerStats(stats) then setLog("vitality upgraded!") else setLog("you're out of skill points!") end
      correctWord:play()
    elseif stripSpaces(text) == 'endurance' then
      stats.endurance = stats.endurance + 1
      if updatePlayerStats(stats) then setLog("endurance upgraded!") else setLog("you're out of skill points!") end
      correctWord:play()
    elseif stripSpaces(text) == 'strength' then
      stats.strength = stats.strength + 1
      if updatePlayerStats(stats) then setLog("strength upgraded!") else setLog("you're out of skill points!") end
      correctWord:play()
    elseif stripSpaces(text) == 'agility' then
      stats.agility = stats.agility + 1
      if updatePlayerStats(stats) then setLog("agility upgraded!") else setLog("you're out of skill points!") end
      correctWord:play()
    elseif stripSpaces(text) == 'done' then
      state = 1
      clearHelpLog()
      correctWord:play()
    end
  elseif state == 3 then
    if stripSpaces(text) == 'health' then
      setHelpLog("health - your lifeforce, let it drop to 0 and you're out of the tournament!", {255, 255, 255, 255})
      correctWord:play()
    elseif stripSpaces(text) == 'move' then
      setHelpLog("move - the amount of stamina needed for you to attack. stamina is gained by completing sentences.", {255, 255, 255, 255})
      correctWord:play()
    elseif stripSpaces(text) == 's-points' then
      setHelpLog({"s-points - points used to level up your stats between battles. you can do this now by selecting the ", {255, 255, 0, 255}, "level ",  {255, 255, 255, 255}, "command on the previous menu. you currently have:", {255, 255, 0, 255}, " " .. stats.skillPoints}, {255, 255, 255, 255})
        correctWord:play()
    elseif stripSpaces(text) == 'vitality' then
      setHelpLog("vitality - directly impacts your max health. more vitality means more health!", {255, 255, 255, 255})
      correctWord:play()
    elseif stripSpaces(text) == 'endurance' then
      setHelpLog("endurance - affects how much damage you can negate during an enemy attack. essentially your defense!", {255, 255, 255, 255})
      correctWord:play()
    elseif stripSpaces(text) == 'strength' then
      setHelpLog("strength - the amount of damage you can dish out when attacking!", {255, 255, 255, 255})
      correctWord:play()
    elseif stripSpaces(text) == 'agility' then
      setHelpLog("agility - determines how much stamina you need for your next move. the more agility the less stamina you need!", {255, 255, 255, 255})
      correctWord:play()
    elseif stripSpaces(text) == 'done' then
      state = 1
      correctWord:play()
      clearHelpLog()
    end
  end

  return ''
end

function inbetween:textinput(t)
  if t == ' ' then
    string = inbetweenParser(string .. t)
  else
    string = string .. t
  end

  clickClack()
end

function inbetween:keypressed(key, code)
  -- pressed backspace
  if key == "backspace" then
    string = string.sub(string, 1, #string - 1)
    clickClack()
  end
end

function inbetween:update(dt)
  updatePoints(dt)
  stats = getPlayerStats()

  if fast:isPlaying() then
    fast:setVolume(fast:getVolume() - dt * 0.1)
    if fast:getVolume() <= 0 then
      fast:stop()
      fast:setVolume(0.25)
    end
  end

  if menuMusic:isPlaying() then
    menuMusic:setVolume(menuMusic:getVolume() - dt * 0.1)
    if menuMusic:getVolume() <= 0 then
      menuMusic:stop()
      menuMusic:setVolume(1)
    end
  end
end

function inbetween:draw()
  maid64.start()
  love.graphics.draw(inbetweenBG, 0, 0, 0, 1, 1, 0, 0)
  love.graphics.draw(textBox, 32, 189, 0, 1, 1, 32, 32)

  love.graphics.setFont(medFont)
  -- love.graphics.printf("next battle", 0, 10, 408, "center")
  love.graphics.printf("you", 32, 27, 80, "center")
  love.graphics.printf("howard", 297, 27, 80, "center")

  -- draw player stats
  love.graphics.printf("health:   " .. stats.healthMAX, 22, 120, 300, "left")
  love.graphics.printf("to move:  " .. stats.staminaMAX, 22, 130, 300, "left")
  love.graphics.printf("s-points: " .. stats.skillPoints, 22, 140, 300, "left")

  love.graphics.printf("vitality:  " .. stats.vitality, 155, 120, 300, "left")
  love.graphics.printf("endurance: " .. stats.endurance, 155, 130, 300, "left")
  love.graphics.printf("strength:  " .. stats.strength, 155, 140, 300, "left")
  love.graphics.printf("agility:   " .. stats.agility, 155, 150, 300, "left")

  love.graphics.printf(string, 0, 230, 102*4, "center")
  love.graphics.printf(states[state], 12, 190, 390, "center")

  drawHelpLog()
  drawLog()

  maid64.finish()
end
