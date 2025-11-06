-- This file loads the players health and gold counter and their animations --
counters = {}

function counters:load()
    self.ribbon = love.graphics.newImage("assets/gameover/ribbon.png")
    self.ribbon:setFilter('nearest', 'nearest')
    self.font = love.graphics.setNewFont("assets/Minecraft.ttf", 50)
    self.halfFont = love.graphics.setNewFont("assets/Minecraft.ttf", 20)
    self.gold = {}
    self.health = {}
    self.wave = {}
    self.score = {}

    -- Wave Properties --
    self.wave.value = 0
    self.wave.x = 408
    self.wave.y =  16

    -- Score Properties
    self.score.value = 0
    self.score.x = 395
    self.score.y = 80

    -- Health Properties --
    self.health.value = 100
    self.health.x = 1536
    self.health.y = 48

    -- Gold Properties --
    self.gold.value = 100
    self.gold.x = 1280
    self.gold.y = 48


    -- Gold Animation Setup -- 
    self.gold.spriteSheet = love.graphics.newImage('assets/gold/goldSpawn.png')
    self.gold.grid = anim8.newGrid( 128, 128, self.gold.spriteSheet:getWidth(), self.gold.spriteSheet:getHeight() )
    
    self.gold.animations = {}
    self.gold.animations.idle = anim8.newAnimation( self.gold.grid('7-7', 1), 0.1 )
    self.gold.animations.active = anim8.newAnimation( self.gold.grid('2-7', 1), 0.1 )
    self.gold.anim = self.gold.animations.idle

    -- Health Animation Setup -- 
    self.health.spriteSheet = love.graphics.newImage('assets/meat/meatFlip.png')
    self.health.grid = anim8.newGrid( 128, 128, self.health.spriteSheet:getWidth(), self.health.spriteSheet:getHeight() )

    self.health.animations = {}
    self.health.animations.idle = anim8.newAnimation( self.health.grid('7-7', 1), 0.1 )
    self.health.animations.active = anim8.newAnimation( self.health.grid('2-7', 1), 0.1 )
    self.health.anim = self.health.animations.idle

end

function counters:update(dt)
    self.gold.anim:update(dt)
    self.health.anim:update(dt)

    if self.health.value <= 0 then
        gameState.lose = true
    end

    if roundOver() then
        self.gold.anim = self.gold.animations.idle
        self.health.anim = self.health.animations.idle
    else
        self.gold.anim = self.gold.animations.active
        self.health.anim = self.health.animations.active
    end
end

function counters:draw()
    love.graphics.setFont(self.font)
    -- Gold --
    love.graphics.print(self.gold.value, self.gold.x, self.gold.y)

    -- Health
    love.graphics.print(self.health.value, self.health.x, self.health.y)
    love.graphics.setFont(self.halfFont)

    -- Wave --
    love.graphics.print("WAVE " ..self.wave.value, self.wave.x, self.wave.y)

     -- Score --
    love.graphics.print("SCORE: "..self.score.value, self.score.x, self.score.y)

    -- Draw animations --
    self.gold.anim:draw(self.gold.spriteSheet, self.gold.x - 110, self.gold.y - 55)
    self.health.anim:draw(self.health.spriteSheet, self.health.x - 110, self.health.y - 55)
end