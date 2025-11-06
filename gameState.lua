gameState = {}

function gameState:load()
    self.font = love.graphics.setNewFont("assets/Minecraft.ttf", 50)
    self.smallFont = love.graphics.setNewFont("assets/Minecraft.ttf", 25)
    self.lose = false
    -- Score Ribbon --
    self.score = {}
    self.score.x = 352
    self.score.y = 64

    -- Wave Ribbon --
    self.wave = {}
    self.wave.x = 352
    self.wave.y = 0

    -- Game Over Ribbon --
    self.gameOver = {}
    self.gameOver.x = 576
    self.gameOver.y = 192
    self.gameOver.scale = 4

    -- Game Over Text --
    self.gameOver.text = {}
    self.gameOver.string = "GAME OVER"
    self.gameOver.text.x = 816
    self.gameOver.text.y = 272
end

function gameState:update()

end

function gameState:draw()
    -- Two ribbons for wave and score --
    love.graphics.draw(counters.ribbon, self.score.x, self.score.y)
    love.graphics.draw(counters.ribbon, self.wave.x, self.wave.y)

    -- When the players health drops to 0 draw game over ribbon --
    if self.lose == true then
        love.graphics.setFont(self.font)
        love.graphics.draw(counters.ribbon, self.gameOver.x, self.gameOver.y, nil, self.gameOver.scale)
        love.graphics.print( self.gameOver.string, self.gameOver.text.x, self.gameOver.text.y)

        love.graphics.setFont(self.smallFont)
        love.graphics.draw(counters.ribbon, self.gameOver.x + 192, self.gameOver.text.y + 192, nil, 2)
        love.graphics.print("Wave " ..counters.wave.value, self.gameOver.text.x + 104, self.gameOver.text.y + 208)
        love.graphics.print("Score " ..counters.score.value, self.gameOver.text.x + 96, self.gameOver.text.y + 256)
        love.graphics.print("Restart", buttons.restart.x + 48, buttons.restart.y + 16)
    end
end