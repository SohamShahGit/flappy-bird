push = require 'push'
Class = require "class"
require 'Bird'
require "Pipe"
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
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


local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local scrolling = true
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514




function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallfont = love.graphics.newFont('flappy.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf',28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    love.window.setTitle('fifty Bird')


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
      ['title'] = function() return TitleScreenState() end,
      ['play'] = function() return PlayState() end,
      ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

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
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end



function love.draw()
 push:start()
  love.graphics.draw(background, -backgroundScroll, 0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT -16)

 push:finish()
end


function love.update(dt)

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

        gStateMachine:update(dt)

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % GROUND_LOOPING_POINT

      love.keyboard.keysPressed = {}
end
