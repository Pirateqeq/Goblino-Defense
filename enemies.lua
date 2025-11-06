enemies = {}

function enemies:load()
    self.table = {}
end

function enemies:update(dt)
    
    for i, enemy in ipairs(self.table) do
        -- Enemy path system --
        nextX, nextY = unpack(enemy.waypoints[enemy.currentWaypoint])
        distanceX = nextX - enemy.x
        distanceY = nextY - enemy.y
        distance = math.sqrt(distanceX^2 + distanceY^2)
        
        if distance > 1 then
            angle = math.atan2(distanceY, distanceX)
            velocityX = enemy.speed * math.cos(angle)
            velocityY = enemy.speed * math.sin(angle)
            enemy.x = enemy.x + velocityX * dt
            enemy.y = enemy.y + velocityY * dt
        else
            enemy.currentWaypoint = enemy.currentWaypoint % #enemy.waypoints + 1
        end

        enemy.animation:update(dt)

        if enemy.x <= -150  then
            table.remove( self.table, i)
            counters.health.value = counters.health.value - 10
        end
    end
end

function enemies:draw()
    for i, enemy in ipairs(self.table) do
        enemy.animation:draw(enemy.spriteSheet, enemy.x , enemy.y)
    end
end

function enemies:spawn(tempX, tempSpeed)
    
    enemy = {}
        enemy.x = tempX or 1920
        enemy.y = 416
        enemy.currentWaypoint = 1
        enemy.speed = tempSpeed or 250
        

        -- Enemy Path --
        enemy.waypoints = {
            {1536, 416},
            {1536, 160},
            {1344, 160},
            {1344, 672},
            {1152, 672},
            {1152, 160},
            {960, 160},
            {960, 672},
            {768, 672},
            {768, 160},
            {576, 160},
            {576, 672},
            {384, 672},
            {384, 160},
            {192, 160},
            {192, 416},
            {-192, 416}
        }

        -- Enemy Animation --
        enemy.spriteSheet = love.graphics.newImage('assets/goblin/goblin.png')
        enemy.grid = anim8.newGrid( 192, 192, enemy.spriteSheet:getWidth(), enemy.spriteSheet:getHeight() )
        enemy.animation = anim8.newAnimation( enemy.grid('2-6', 2), 0.1 )

    table.insert(self.table, enemy)
end

function enemies:spawnWaves()
    for i = 1, counters.wave.value do
        if counters.wave.value <= 5 then
            enemies:spawn(1920 + 100 * i)
        elseif counters.wave.value > 5 then
            enemies:spawn(1920 + 100 * i, 250 + 50 * (counters.wave.value / 5))
        end
    end
end
