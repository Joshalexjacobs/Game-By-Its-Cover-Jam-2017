-- [[ T Y P I N G  C H A M P *click clack click* ]]

--[[ Typer Todd must rise through the ranks to become the TYPING CHAMP ]]
--[[ Typer Tabby must rise through the ranks to become the TYPING CHAMP ]]

Gamestate = require "lib/gamestate"
anim8 = require "lib/anim8"
require "lib/maid64"

require "states/menu"

require "challengerLoader"

DEBUG = false

function love.load(arg)
  love.window.setMode(160*4, 144*2.97, {resizable=true, vsync=true, minwidth=200, minheight=200}) -- 640 x 427
  maid64.setup(102*4, 64*4)

  -- general sound effects
  menuSelect = love.audio.newSource("sfx/menuSelect.wav", "static")
  menuSelect:setRolloff(0.01)

  -- load fonts
  smallestFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 6)
  smallFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 7)
  medFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 8)
  bigFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 16)
  love.graphics.setFont(bigFont)

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function love:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  -- elseif key == 'f' then
  --   local fullscreen, ftype = love.window.getFullscreen()
  --   love.window.setFullscreen(not fullscreen)
  elseif key == 'b' then
    DEBUG = not DEBUG
  end
end

function love.update(dt)

end

function love.draw()

end

function love.resize(w, h)
  -- this is used to resize the screen correctly
  maid64.resize(w, h)
end
