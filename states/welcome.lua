--welcome.lua

welcome = {}

require "states/inbetween"

local fade = 0
local isFading = false
local welcomeText = "Welcome to the 1987 National Typing Champ Tournament! You and 5 other competitors have answered the call to become the next TYPING CHAMP! But can you dethrone the almight Queen QWERTY and claim the title? Only if you truly do possess ten fingers of fury! Good luck, Typer! You're going to need it!"

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
     Gamestate.switch(inbetween)
   end
 end
end

function welcome:draw()
  maid64.start()
  love.graphics.setColor({255, 255, 255, fade})
  -- love.graphics.setColor(NONE)
  love.graphics.setFont(bigFont)
  love.graphics.printf(welcomeText, 0, 15, 408, "center")
  love.graphics.setFont(medFont)
  love.graphics.setColor(NONE)
  maid64.finish()
end
