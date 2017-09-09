-- score.lua

local playerScore = 0
local enemyScore = 0

local points = {}

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

function updatePoints(dt)
  for _, point in ipairs(points) do
    point.y = point.y - (dt * 150)
    point.color[4] = point.color[4] - 2.5
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
