push = require 'push'
require 'Bird'
require "Pipe"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- learn how to use git testddd
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- adding some more comment
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local pipes = {}
local spawntimer = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413


local bird = Bird()

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('fifty Bird')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
     love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)

  love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end


function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end



function love.update(dt)
    bird:update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH
  spawntimer = spawntimer + dt
   if spawntimer > 2 then
        table.insert(pipes,Pipe())
        spawntimer = 0
   end

-- retreive pipe object from list of pipes update each object and if
    for k, pipe in pairs(pipes) do
        pipe:update(dt)
        if pipe.x < -pipe.width then
           table.remove(pipes,k)
        end
    end
        -- Reset all enters keys from the list
    love.keyboard.keysPressed = {}
     -- update spawntime by adding frame to it

end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pipe in pairs(pipes) do
      pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT -16)
    bird:render()
    push:finish()
end
