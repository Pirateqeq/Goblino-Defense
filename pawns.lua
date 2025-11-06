pawns = {}

function pawns:load()
    self.table = {}
end

function pawns:update(dt)
    for i,pawn in ipairs(self.table) do


        pawn.anim:update(dt)
        if pawn.cooldown >= 3.5 and pawn.cooldown <= 3.8 then
            pawn.anim = pawn.animations.attack
        end

        if pawn.cooldown >= 3.9 then
            pawn.cooldown = pawn.cooldown - 3.9
            if #enemies.table < 2 then
                counters.score.value = counters.score.value + 1
                counters.gold.value = counters.gold.value + 10
                table.remove( enemies.table, 1)
            else
                counters.score.value = counters.score.value + 2
                counters.gold.value = counters.gold.value + 20
                table.remove( enemies.table, 1)
                table.remove( enemies.table, 1)
            end

            pawn.anim:gotoFrame(1)
            pawn.anim = pawn.animations.idle
        end

        if roundOver() then
            pawn.inRange = false
            pawn.anim = pawn.animations.idle
            pawn.cooldown = 3.3
            goto doNotAttack end

            if getDistance( pawn.x, pawn.y, enemies.table[1].x, enemies.table[1].y) < pawn.range then
                pawn.inRange = true
            elseif math.floor(enemies.table[#enemies.table].x - pawn.x) / fCell
             < -3 and
             math.floor(enemies.table[#enemies.table].y - pawn.y) / fCell
              > -4 and
             math.floor(enemies.table[#enemies.table].y - pawn.y) / fCell
              < 4 then
                pawn.inRange = false
            end

            if pawn.inRange == true then
                pawn.cooldown = pawn.cooldown + dt
            elseif pawn.inRange == false then
                pawn.anim = pawn.animations.idle
            end
        ::doNotAttack::
    end
end

function pawns:draw()
    for i,pawn in ipairs(self.table) do
        pawn.anim:draw(pawn.spriteSheet, pawn.x, pawn.y)

        if pawn.selected == true then
            love.graphics.circle("line", pawn.x + 96, pawn.y + 96, pawn.range * fCell
            , 10)
        end
    end
end

function pawns:spawn( x , y )
    collum = (math.floor(x / fCell))
    row = (math.floor(y / fCell))
    print("COLLUM "..collum.." ROW "..row)
    if grid[row + 1][collum + 1] == 1 then

        grid[row + 1][collum + 1] = 4
        x = collum * fCell

        y = row * fCell


        pawn = {}
            pawn.x = x - fCell
            pawn.y = y - fCell
            pawn.row = row + 1
            pawn.collum = collum + 1
            pawn.range = 3
            pawn.inRange = false
            pawn.cooldown = 3.3
            pawn.selected = false
        -- pawn Animation --
        pawn.spriteSheet = love.graphics.newImage('assets/pawn/Pawn.png')
        pawn.grid = anim8.newGrid( 192, 192, pawn.spriteSheet:getWidth(), pawn.spriteSheet:getHeight() )
        pawn.animations = {}
        pawn.animations.idle = anim8.newAnimation( pawn.grid('1-6', 1), 0.1 )
        pawn.animations.attack = anim8.newAnimation( pawn.grid('1-6', 4), 0.08 )
        pawn.anim = pawn.animations.idle

        
        counters.gold.value = counters.gold.value - 100
        table.insert(self.table, pawn)
    end
end

function pawns:onClick( x , y )
    if buttons.pawn.selected == true and buttons:hovering( x , y ) == false and counters.gold.value >= 100 then
        pawns:spawn( x , y )
    end
end

function pawns:sell()
    for i,pawn in ipairs(pawns.table) do
        if pawn.collum - 1 == grid.x / fCell and pawn.row - 1 == grid.y / fCell then
            grid[pawn.row][pawn.collum] = 1
            table.remove(pawns.table, i)
            counters.gold.value = counters.gold.value + 100
        end
    end
end