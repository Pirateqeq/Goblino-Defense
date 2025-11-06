buttons = {}

function buttons:load()
    self.selected = false
    
    -- Archer Button --
    buttons:archerInfo(self)

    -- Knight Button --
    buttons:knightInfo(self)
    
    -- Pawn Button --
    buttons:pawnInfo(self)

    -- Play button --
    buttons:playInfo(self)

    -- Restart Button --
    buttons:restartInfo(self)

    -- Sell Button --
    buttons:sellInfo(self)
end

function buttons:update(dt)
    self.archer.animation:update(dt)
    self.knight.animation:update(dt)
    self.pawn.animation:update(dt)
    self.play.currentAnimation:update(dt)

    if roundOver() then
        self.play.currentAnimation = self.play.animations.jumping
    else
        self.play.currentAnimation = self.play.animations.idle
    end
end

function buttons:draw()
    -- Draw buttons --
    buttons:drawButtons(self)

    -- Draw animations --
    buttons:drawAnimation(self)

    -- Select Towers on mouse --
    buttons:selectTowers(self)
end

function buttons:hovering( x, y)
    -- Return what button is pressed when called based on x and y of mouse --
    if x > 544 and x < 600 and y > 32 and y < 90 then
        return "play"
    elseif x > 656 and x < 784 and y > 16 and y < 110 then
        return "archer"
    elseif x > 848 and x < 941 and y > 16 and y < 110 then
        return "knight"
    elseif x > 1040 and x < 1136 and y > 16 and y < 110 then
        return "pawn"
    elseif x > 864 and x < 1056 and y > 608 and y < 752 and gameState.lose == true then
        return "restart"
    elseif x > 1664 and x < 1760 and y > 16 and y < 110 and grid.towerSelected == true then
        return "sell"
    else
        return false
    end
end


function buttons:onClick( x, y )
    -- If hovering button and clicked --
    if self:hovering( x, y ) == "archer" and self.selected == false then
        self.archer.img = love.graphics.newImage('assets/button/Button_Large_Pressed.png')
        self.archer.selected = true
        self.selected = true
    elseif self:hovering( x, y ) == "knight" and self.selected == false then
        self.knight.img = love.graphics.newImage('assets/button/Button_Large_Pressed.png')
        self.knight.selected = true
        self.selected = true
    elseif self:hovering( x , y) == "pawn" and self.selected == false then
        self.pawn.img = love.graphics.newImage('assets/button/Button_Large_Pressed.png')
        self.pawn.selected = true
        self.selected = true
    elseif buttons:hovering( x , y ) == "play" and roundOver() then
        self.play.img = love.graphics.newImage('assets/button/Button_Large_Pressed.png')
        counters.wave.value = counters.wave.value + 1
        enemies:spawnWaves()
    elseif buttons:hovering( x , y ) == "restart" then
        love.event.quit("restart")
    elseif buttons:hovering( x , y ) == "sell" then
        archers:sell()
        knights:sell()
        pawns:sell()
    else 
        self.archer.selected = false
        self.knight.selected = false
        self.pawn.selected = false
        self.selected = false
    end
end

function buttons:onRelease()
    -- On mouse release --
    self.archer.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.knight.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.pawn.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.play.img = love.graphics.newImage('assets/button/Button_Large.png')
end

function buttons:drawButtons(self)
    -- Draw buttons --
    love.graphics.draw(self.archer.img, self.archer.x, self.archer.y, nil, 0.5, 0.5)
    love.graphics.draw(self.knight.img, self.knight.x, self.knight.y, nil, 0.5, 0.5)
    love.graphics.draw(self.pawn.img, self.pawn.x, self.pawn.y, nil, 0.5, 0.5)
    love.graphics.draw(self.play.img, self.play.x, self.play.y, nil, 0.35, 0.35)
    love.graphics.draw(self.play.img2, self.play.x + 16, self.play.y + 12, nil, 0.5, 0.5)
    
    if grid.towerSelected == true then
        love.graphics.draw(self.sell.img, self.sell.x, self.sell.y, nil, 0.5, 0.5)
        love.graphics.draw(self.sell.img2, self.sell.x, self.sell.y + 8, nil, 1.5, 1.5)
    end

    if gameState.lose == true then
        love.graphics.draw(self.restart.img, self.restart.x, self.restart.y)
    end
end

function buttons:drawAnimation(self)
    -- Draw tower animations --
    self.archer.animation:draw(self.archer.spriteSheet, self.archer.x - 48, self.archer.y - 48)
    self.knight.animation:draw(self.knight.spriteSheet, self.knight.x - 48, self.knight.y - 48)
    self.pawn.animation:draw(self.pawn.spriteSheet, self.pawn.x - 48, self.pawn.y - 48)
    self.play.currentAnimation:draw(self.play.spriteSheet, self.play.x - 32, self.play.y - 32)
end

function buttons:selectTowers(self)
    -- When tower is selected --
    if self.archer.selected == true then
        love.graphics.draw(self.archer.imgSelected, mouseX - 96, mouseY - 96)
        love.graphics.circle("line", mouseX, mouseY, 5 * fCell, 10)
    end

    if self.knight.selected == true then
        love.graphics.draw(self.knight.imgSelected, mouseX - 96, mouseY - 96)
        love.graphics.circle("line", mouseX, mouseY, 3 * fCell, 10)
    end

    if self.pawn.selected == true then
        love.graphics.draw(self.pawn.imgSelected, mouseX - 96, mouseY - 96)
        love.graphics.circle("line", mouseX, mouseY, 3 * fCell, 10)
    end
end

function buttons:archerInfo(self)
    -- Archer Button --
    self.archer = {}
    self.archer.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.archer.imgSelected = love.graphics.newImage("assets/archer/Archer_Still.png")
    self.archer.x = 656
    self.archer.y = 16
    self.archer.selected = false

    -- Archer Animation --
    self.archer.spriteSheet = love.graphics.newImage('assets/archer/Archer.png')
    self.archer.grid = anim8.newGrid( 192, 192, self.archer.spriteSheet:getWidth(), self.archer.spriteSheet:getHeight() )
    self.archer.animation = anim8.newAnimation( self.archer.grid('1-6', 1), 0.1 )
end

function buttons:knightInfo(self)
    -- Knight Button --
    self.knight = {}
    self.knight.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.knight.imgSelected = love.graphics.newImage("assets/knight/Knight_Still.png")
    self.knight.x = 848
    self.knight.y = 16
    self.knight.selected = false

    -- Knight Animation --
    self.knight.spriteSheet = love.graphics.newImage('assets/knight/Knight.png')
    self.knight.grid = anim8.newGrid( 192, 192, self.knight.spriteSheet:getWidth(), self.knight.spriteSheet:getHeight() )
    self.knight.animation = anim8.newAnimation( self.knight.grid('1-6', 1), 0.1 )
end

function buttons:pawnInfo(self)
    -- Pawn Button --
    self.pawn = {}
    self.pawn.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.pawn.imgSelected = love.graphics.newImage("assets/pawn/Pawn_Still.png")
    self.pawn.x = 1040
    self.pawn.y = 16
    self.pawn.selected = false

    -- Pawn Animation --
    self.pawn.spriteSheet = love.graphics.newImage('assets/pawn/Pawn.png')
    self.pawn.grid = anim8.newGrid( 192, 192, self.pawn.spriteSheet:getWidth(), self.pawn.spriteSheet:getHeight() )
    self.pawn.animation = anim8.newAnimation( self.pawn.grid('1-6', 1), 0.1 )
end

function buttons:playInfo(self)
    self.play = {}
    self.play.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.play.img2 = love.graphics.newImage('assets/button/play.png')
    self.play.x = 544
    self.play.y = 32

    -- Play Animation --
    self.play.spriteSheet = love.graphics.newImage('assets/sheep/Sheep.png')
    self.play.grid = anim8.newGrid( 128, 128, self.play.spriteSheet:getWidth(), self.play.spriteSheet:getHeight() )
    self.play.animations = {}
    self.play.animations.idle = anim8.newAnimation( self.play.grid('1-8', 1), 0.1 )
    self.play.animations.jumping = anim8.newAnimation( self.play.grid('1-6', 2), 0.1 )
    self.play.currentAnimation = self.play.animations.jumping
end

function buttons:restartInfo(self)
    -- Restart Button --
    self.restart = {}
    self.restart.img = love.graphics.newImage('assets/button/Restart_Button.png')
    self.restart.imgSelected = love.graphics.newImage('assets/button/Restart_Button_Pressed.png')
    self.restart.x = 864
    self.restart.y = 608
end

function buttons:sellInfo(self)
    -- Sell information --
    self.sell = {}
    self.sell.img = love.graphics.newImage('assets/button/Button_Large.png')
    self.sell.img2 = love.graphics.newImage('assets/button/sell.png')
    self.sell.img2:setFilter('nearest', 'nearest')
    self.sell.x = 1664
    self.sell.y = 16
end
