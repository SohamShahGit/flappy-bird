push = require 'push'
require 'Bird'
require "Pipe"
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- learn how to use git testddd
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- adding some more comment
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local pipesPairs = {}
local spawntimer = 0
local lastY = -PIPE_HEIGHT + math.random(80) + 20
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local scrolling = true
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

  if scrolling then
    bird:update(dt)

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH
  spawntimer = spawntimer + dt

   if spawntimer > 2 then
     local y = math.max(-PIPE_HEIGHT + 10,
     math.min(lastY + math.random(-20,20),VIRTUAL_HEIGHT- 90 - PIPE_HEIGHT ))
     lastY = y
     table.insert(pipesPairs,PipePair(y))
     spawntimer = 0
   end

-- retreive pipe object from list of pipes update each object and if
    for k, pair in pairs(pipesPairs) do
        pair:update(dt)
        --if pair.x < -pair.y then
        --   table.remove(pair,k)

        for l, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
              scrolling = false
           end
         end
        if pair.x < -PIPE_WIDTH then
          pair.remove = true
        end
    end
    --for l, pipe in pairs(pair.pipes) do
      --if bird:collides(pipe) then
    --    scrolling = false
    --  end
    --end
  end      -- Reset all enters keys from the list
    love.keyboard.keysPressed = {}
     -- update spawntime by adding frame to it

end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pipe in pairs(pipesPairs) do
      pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT -16)
    bird:render()
    push:finish()
  end
