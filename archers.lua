archers = {}

-- Load archer controller and table holding archers--
function archers:load()
    self.table = {}
    self.arrows = {}
end

-- Update archers in the archers table --
function archers:update(dt)
    for i,archer in ipairs(self.table) do
        
        archer.anim:update(dt)
        
        if archer.cooldown >= 2.5 and archer.cooldown <= 2.7 then
            archer.anim = archer.animations.attack
        end

        if archer.cooldown >= 2.9 then
            archer.cooldown = archer.cooldown - 2.9
            archers:shootArrow( archer.x, archer.y )
            archer.anim = archer.animations.idle
        end

        -- Check if can target first iterator in range, make target X and Y reference to that enemy's X and Y then do math --
        if roundOver() then
            archer.inRange = false
            archer.anim = archer.animations.idle
            self.arrows = {}
            archer.cooldown = 2.3

            goto doNotAttack end
            if getDistance( archer.x, archer.y, enemies.table[1].x, enemies.table[1].y) < archer.range then
                archer.inRange = true
            elseif math.floor(enemies.table[#enemies.table].x - archer.x) / fCell < -archer.range and
             math.floor(enemies.table[#enemies.table].y - archer.y) / fCell > -archer.range and
             math.floor(enemies.table[#enemies.table].y - archer.y) / fCell < archer.range then
                archer.inRange = false
            end

            if archer.inRange == true then
                archer.cooldown = archer.cooldown + dt
            elseif archer.inRange == false then
                archer.anim = archer.animations.idle
            end
        ::doNotAttack::
    end

    for v, arrow in ipairs(self.arrows) do
        if roundOver() then 
            table.remove( self.arrows, v)
            goto continue end
        arrowDistanceX = enemies.table[1].x + hCell - arrow.x + hCell
        arrowDistanceY = enemies.table[1].y + hCell - arrow.y + hCell
        arrowDistance = (math.sqrt(arrowDistanceX^2 + arrowDistanceY^2))

        if arrowDistance >= hCell then
            arrowAngle = math.atan2(arrowDistanceY, arrowDistanceX)
            arrowVelocityX = arrow.speed * math.cos(arrowAngle)
            arrowVelocityY = arrow.speed * math.sin(arrowAngle)
            arrow.x = arrow.x + arrowVelocityX * dt
            arrow.y = arrow.y + arrowVelocityY * dt
        else
            counters.gold.value = counters.gold.value + 10
            counters.score.value = counters.score.value + 1
            table.remove( self.arrows, v)
            table.remove( enemies.table, 1)
        end
        ::continue::
    end


end

-- Draw each archer in the archer table --
function archers:draw()
    for i,archer in ipairs(self.table) do
        archer.anim:draw(archer.spriteSheet, archer.x, archer.y)
    end

    for i,arrow in ipairs(self.arrows) do
        love.graphics.draw(arrow.img, arrow.x, arrow.y, arrowAngle)
    end
end

-- Function to call to place archers in table onto grid
function archers:spawn( x , y )
    collum = (math.floor(x / fCell))
    row = (math.floor(y / fCell))
    print("COLLUM "..collum.." ROW "..row)
    if grid[row + 1][collum + 1] == 1 then
        
        grid[row + 1][collum + 1] = 2
        x = collum * fCell
        y = row * fCell

        archer = {}
            archer.x = x - fCell
            archer.y = y - fCell
            archer.row = row + 1
            archer.collum = collum + 1
            archer.range = 5
            archer.inRange = false
            archer.damage = 25
            archer.cooldown = 2.3
            archer.selected = false
        -- Archer Animation --
        archer.spriteSheet = love.graphics.newImage('assets/archer/Archer.png')
        archer.grid = anim8.newGrid( 192, 192, archer.spriteSheet:getWidth(), archer.spriteSheet:getHeight() )
        archer.animations = {}
        archer.animations.idle = anim8.newAnimation( archer.grid('1-6', 1), 0.1 )
        archer.animations.attack = anim8.newAnimation( archer.grid('1-8', 5), 0.08 )
        archer.anim = archer.animations.idle

        
        counters.gold.value = counters.gold.value - 100
        table.insert(self.table, archer)
    end
end

function archers:onClick( x , y )
    if buttons.archer.selected == true and buttons:hovering( x , y ) == false and counters.gold.value >= 100 then
        archers:spawn( x , y )
    end
end

function archers:shootArrow( archerX, archerY, targetX, targetY )
    arrow = {}
        arrow.x = archerX + 96
        arrow.y = archerY + 96
        arrow.speed = 1250

        arrow.img = love.graphics.newImage('assets/archer/Arrow.png')

    table.insert( self.arrows, arrow )
end

function archers:sell()
    for i, archer in ipairs(archers.table) do
        if archer.collum - 1 == grid.x / fCell and archer.row - 1 == grid.y / fCell then
            grid[archer.row][archer.collum] = 1
            table.remove(archers.table, i)
            counters.gold.value = counters.gold.value + 100
        end
    end

end