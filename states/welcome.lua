--welcome.lua

welcome = {}

require "states/inbetween"

local fade = 0
local isFading = false
local welcomeText = "Congratulations, you're the new typing champion!"

function welcome:enter()

end

function welcome:keypressed(key, code)
 if key then
   isFading = true
 end
end

function welcome:update(dt)
  if menuMusic:isPlaying() then
    menuMusic:setVolume(menuMusic:getVolume() - dt * 0.1)
    if menuMusic:getVolume() <= 0 then
      menuMusic:stop()
      menuMusic:setVolume(1)
    end
  end

  if isFading == false then
   if fade > 255 then
     fade = 255
   elseif fade < 255 then
     fade = fade + dt * 75
   end
 else
   if fade > 0 then
     fade = fade - dt * 75
   elseif fade <= 0 then
     love.event.quit()
   end
 end
end

function welcome:draw()
  maid64.start()
  love.graphics.setColor({113, 15, 7, fade})
  love.graphics.rectangle("fill", 0, 90, 408, 50)
  love.graphics.setColor({255, 255, 255, fade})
  -- love.graphics.setColor(NONE)
  love.graphics.setFont(bigFont)
  love.graphics.printf(welcomeText, 0, 100, 408, "center")
  love.graphics.draw(theTyper, 36, 12, 0, 1, 1, 0, 0)
  love.graphics.setFont(medFont)
  love.graphics.setColor(NONE)
  maid64.finish()
end
