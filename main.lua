-- [[ T Y P I N G  C H A M P *click clack click* ]]

--[[
Sites to post on once you finish the last build:
- r/learntyping
- r/typing
- r/typeracer
- r/itchio
- love2d forums (possible include source code?)
- r/IndieGaming/
- r/playmygame
- r/gamejams
- 10fastfingers.com/forum/
]]

--[[
TODO:
1. Normal and Expert difficulties
2. Digitized voice recording of someone saying "TYPINGGGGGG CHAAAMP!"
3. Figure out a way to make the combat more enjoyable. Maybe make the specials stronger or add
  abilities that cost a stamina turn, but do other things:
  - freeze: deals 3 damage and slows down the opponents stamina gain for 30 seconds
  - Poison: deals 0.25 - 0.5? damage per correct word for the next sentence
  - Potion: heals 0.25 - 0.5 health per correct word for the next sentence
  - Slow: slows down the enemies next attack significantly (X%)
  - Easy: the next 2 sentences are all easy words
  - Hard: deals 1 damage per correct word for the next sentence, but all words are hard
  - Double: your next attack deals double damage
4. make player not gain special when using passives (unless specified)
]]

--[[changelog:
- added new attack bonus
- added enter key
- normal, hard, and expert difficulties (normal 60 - 70 wpm, hard 70 - 90 wpm, expert 90+ wpm)
- added abilites (not yet)
]]

--[[BUGS
- bonus attack doesnt read caps locked letters
- if you fail bonus attack, it doesnt clear string
]]

Gamestate = require "lib/gamestate"
anim8 = require "lib/anim8"
require "lib/maid64"
require "lib/timer"
require "cameraControls"

require "states/menu"
require "states/welcome"
require "specials"
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

difficulty = "normal" 

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

  -- set master volume
  love.audio.setVolume(0.25)

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

  bossMusic = love.audio.newSource("music/boss.wav")
  bossMusic:setLooping(true)
  bossMusic:setVolume(0.25)

  -- load fonts
  smallestFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 6)
  smallFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 7)
  medFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 8)
  bigFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 16)
  bigBigFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 18)
  biggestFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 24)
  biggerestFont = love.graphics.newFont("lib/Punch-Out!! NES.ttf", 48)
  love.graphics.setFont(bigFont)

  -- game images
  textBox = maid64.newImage("img/textbox.png")
  stage = maid64.newImage("img/stage2.png")
  overlay = maid64.newImage("img/overlay3.png")
  theTyper = maid64.newImage("img/theTyper.png")

  -- load player
  playerLoad()
  calculateStats()

  -- logs and score load
  loadLogs()

  -- [[ test load files ]]
  loadWordFiles()
  loadReturnKey()

  -- load challenger
  loadChallengerFile()

  -- load keybo
  loadKeybo()

  -- load menu assets
  titleImg = maid64.newImage("img/title.png")
  copyright = maid64.newImage("img/copyright.png")
  menuMusic = love.audio.newSource("music/Mercury.wav")

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
