-- score.lua

local playerScore = 0
local enemyScore = 0

local points = {}

local log = {
  x = 0,
  y = 50,
  originalY = 50,
  text = "",
  color = {85, 199, 83, 255}
}

local logs = {}

function addScore(x)
  playerScore = playerScore + x
end

function addPoints(x, y, p, color)
  -- addScore(p)

  local point = {
    x = x,
    y = y,
    p = p,
    color = color
  }

  table.insert(points, point)
end

function setLog(text)
  newLog = copy(log, newLog)
  newLog.text = text
  newLog.color[4] = 255
  newLog.y = love.math.random(50, 75)
  table.insert(logs, newLog)
end

function updatePoints(dt)
  for i, point in ipairs(points) do
    point.y = point.y - (dt * 150)
    point.color[4] = point.color[4] - 2.5
    if point.color[4] <= 0 then
      table.remove(points, i)
    end
  end

  for i, log in ipairs(logs) do
    log.y = log.y - (dt * 15)
    log.color[4] = log.color[4] -0.5
    if log.color[4] <= 0 then
      table.remove(logs, i)
    end
  end
end

function drawPoints()
  for _, point in ipairs(points) do
    love.graphics.setColor(point.color)
    love.graphics.setFont(bigFont)
    love.graphics.printf(point.p .. "!", point.x, point.y, 100)
    love.graphics.setFont(medFont)
    love.graphics.setColor({255, 255, 255, 255})
  end
end

function drawScore()
  --love.graphics.printf(playerScore, 10, 10, 100)
end

function drawLog()
  for _, log in ipairs(logs) do
    love.graphics.setFont(medFont)
    love.graphics.setColor(log.color)
    love.graphics.printf(log.text, log.x, log.y, 408, "center")
    love.graphics.setColor(NONE)
  end
end
