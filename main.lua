-- [[ T Y P I N G  C H A M P *click clack click* ]]

--[[ Typer Todd must rise through the ranks to become the TYPING CHAMP ]]
--[[ Typer Tabby must rise through the ranks to become the TYPING CHAMP ]]

--[[
TODO:
- more enemies (at least 2-4 more)
- timer on each sentence (set via enemy)
]]

Gamestate = require "lib/gamestate"
anim8 = require "lib/anim8"
require "lib/maid64"
require "lib/timer"
require "cameraControls"

require "states/menu"
require "player"
require "challenger"
require "score"

require "keyboBlaster/keyboMain"

DEBUG = false
CRT = true

-- global colors:
NONE = {255, 255, 255, 255}
CURRENT = {255, 255, 0, 255}
PASS = {0, 255, 0, 255}
FAIL = {255, 0, 0, 255}

world = love.physics.newWorld(0, 9.81 * 64, true)

function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function clickClack()
  local kbIndex = love.math.random(1, #keyboard)
  keyboard[kbIndex]:setPitch(1 - love.math.random(-1, 1) * 0.1)
  keyboard[kbIndex]:play()
end

--[[ experimental: ]]
local function loadShader()
  local crtShaderFile = love.filesystem.read('shaders/CRT-Simple.frag')
  crtShader = love.graphics.newShader(crtShaderFile)
  crtShader:send('inputSize', {love.graphics.getWidth(), love.graphics.getHeight()})
  crtShader:send('outputSize', {love.graphics.getWidth(), love.graphics.getHeight()})
  crtShader:send('textureSize', {love.graphics.getWidth(), love.graphics.getHeight()})
end

function love.load(arg)
  love.window.setMode(102*12, 64*12, {resizable=true, vsync=true, minwidth=200, minheight=200}) -- 640 x 427
  maid64.setup(102*4, 64*4)

  -- seed love.math.rand() using os time
  math.randomseed(os.time())

  -- load camera
  loadCamera()

  -- load shader
  loadShader()

  -- general sound effects
  menuSelect = love.audio.newSource("sfx/menuSelect.wav", "static")
  menuSelect:setRolloff(0.01)

  correctWord = love.audio.newSource("sfx/correctWord.wav", "static")
  correctWord:setRolloff(0.01)

  endOfLine = love.audio.newSource("sfx/endOfLine.wav", "static")
  endOfLine:setRolloff(0.01)

  perfectLine = love.audio.newSource("sfx/perfectLine.wav", "static")
  perfectLine:setRolloff(0.01)

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

  -- damage sfx
  damage = {
    love.audio.newSource("sfx/damage/damage1.wav", "static"),
    love.audio.newSource("sfx/damage/damage2.wav", "static"),
    love.audio.newSource("sfx/damage/damage3.wav", "static"),
    love.audio.newSource("sfx/damage/damage4.wav", "static"),
    love.audio.newSource("sfx/damage/damage5.wav", "static"),
    love.audio.newSource("sfx/damage/damage6.wav", "static"),
    love.audio.newSource("sfx/damage/damage7.wav", "static"),
  }

  -- defend sfx
  defendSFX = love.audio.newSource("sfx/defend.wav", "static")

  -- music
  fast = love.audio.newSource("music/fast.wav")
  fast:setLooping(true)
  fast:setVolume(0.25)

  -- load fonts
  smallestFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 6)
  smallFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 7)
  medFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 8)
  bigFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 16)
  biggestFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 24)
  love.graphics.setFont(bigFont)

  -- game images
  textBox = maid64.newImage("img/textbox.png")
  stage = maid64.newImage("img/stage2.png")
  overlay = maid64.newImage("img/overlay3.png")
  theTyper = maid64.newImage("img/theTyper.png")

  -- load player
  playerLoad()
  calculateStats()

  -- load challenger
  loadChallengerFile()

  -- load keybo
  loadKeybo()

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
  loadCamera()
end
