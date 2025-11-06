knights = {}

function knights:load()
    self.table = {}
end

function knights:update(dt)
    for i,knight in ipairs(self.table) do


        knight.anim:update(dt)
        if knight.cooldown >= 1.5 and knight.cooldown <= 1.8 then
            knight.anim = knight.animations.attack
        end

        if knight.cooldown >= 1.9 then
            knight.cooldown = knight.cooldown - 1.9
            table.remove( enemies.table, 1)
            counters.score.value = counters.score.value + 1
            counters.gold.value = counters.gold.value + 10
            knight.anim:gotoFrame(1)
            knight.anim = knight.animations.idle
        end

        if roundOver() then
            knight.anim = knight.animations.idle
            knight.cooldown = 1.3
            knight.inRange = false
            goto doNotAttack 
        end

            if getDistance( knight.x, knight.y, enemies.table[1].x, enemies.table[1].y) < knight.range then
                knight.inRange = true
            elseif math.floor(enemies.table[#enemies.table].x - knight.x) / fCell < -knight.range and
             math.floor(enemies.table[#enemies.table].y - knight.y) / fCell > -knight.range and
             math.floor(enemies.table[#enemies.table].y - knight.y) / fCell < knight.range then
                knight.inRange = false
            end

            if knight.inRange == true then
                knight.cooldown = knight.cooldown + dt
            elseif knight.inRange == false then
                knight.anim = knight.animations.idle
            end
        ::doNotAttack::
    end
end

function knights:draw()
    for i,knight in ipairs(self.table) do
        knight.anim:draw(knight.spriteSheet, knight.x, knight.y)

        if knight.selected == true then
            love.graphics.circle("line", knight.x + 96, knight.y + 96, knight.range * fCell, 10)
        end
    end
end

function knights:spawn( x , y )
    collum = (math.floor(x / fCell))
    row = (math.floor(y / fCell))
    print("COLLUM "..collum.." ROW "..row)
    if grid[row + 1][collum + 1] == 1 then

        grid[row + 1][collum + 1] = 3
        x = collum * fCell
        y = row * fCell

        knight = {}
            knight.x = x - fCell
            knight.y = y - fCell
            knight.row = row + 1
            knight.collum = collum + 1
            knight.range = 3
            knight.inRange = false
            knight.cooldown = 1.3
            knight.selected = false
        -- knight Animation --
        knight.spriteSheet = love.graphics.newImage('assets/knight/Knight.png')
        knight.grid = anim8.newGrid( 192, 192, knight.spriteSheet:getWidth(), knight.spriteSheet:getHeight() )
        knight.animations = {}
        knight.animations.idle = anim8.newAnimation( knight.grid('1-6', 1), 0.1 )
        knight.animations.attack = anim8.newAnimation( knight.grid('1-6', 3), 0.07 )
        knight.anim = knight.animations.idle

        
        counters.gold.value = counters.gold.value - 100
        table.insert(self.table, knight)
        
    end
end

function knights:onClick( x , y )
    if buttons.knight.selected == true and buttons:hovering( x , y ) == false and counters.gold.value >= 100 then
        knights:spawn( x , y )
    end
end

function knights:sell()
    for i, knight in ipairs(knights.table) do
        if knight.collum - 1 == grid.x / fCell and knight.row - 1 == grid.y / fCell then
            grid[knight.row][knight.collum] = 1
            table.remove(knights.table, i)
            counters.gold.value = counters.gold.value + 100
        end
    end
end