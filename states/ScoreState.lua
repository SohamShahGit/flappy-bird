ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      gStateMachine:change('play')
 end
end

function ScoreState:render()
  love.graphics.setFont(flappyFont)
  love.graphics.printf('YOU LOST OK OK OK OK OK OK ', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.print('score:' ..tostring(self.score), 0,100,VIRTUAL_WIDTH)

love.graphics.printf('press enter to play again', 0, 160, VIRTUAL_WIDTH,  'center')
end
