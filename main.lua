require("gameState")
require("grid")
require("counters")
require("buttons")
require("enemies")
require("archers")
require("knights")
require("pawns")


function love.load()
    -- Grid size --
    fCell = 64
    hCell = 32
    qCell = 16
    sti = require 'libraries/sti'
    gameMap = sti('assets/map.lua')
    anim8 = require 'libraries/anim8'
    gameState:load()
    grid:load()
    counters:load()
    buttons:load()
    enemies:load()
    archers:load()
    knights:load()
    pawns:load()
    cursor = love.mouse.newCursor( 'assets/pointer/pointer.png', 16, 16)
    love.mouse.setCursor(cursor)
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    gameState:update(dt)
    counters:update(dt)
    enemies:update(dt)
    buttons:update(dt)
    archers:update(dt)
    knights:update(dt)
    pawns:update(dt)
end

function love.draw()
    gameMap:draw()
    grid:draw()
    buttons:draw()
    enemies:draw()
    archers:draw()
    knights:draw()
    pawns:draw()
    gameState:draw()
    counters:draw()
end

-- When the mouse is pressed --
function love.mousepressed(x, y)
    x = math.floor( x )
    y = math.floor( y )
    
    -- Stop all tower function on game loss --
    if gameState.lose == false then
        archers:onClick( x , y )
        knights:onClick( x , y )
        pawns:onClick( x , y )
    end

    grid:onClick( x , y )
    buttons:onClick( x , y )
end

-- After the mouse is clicked --
function love.mousereleased()
    buttons:onRelease()
end

-- Returns the distance between two points --
function getDistance(x1, y1, x2, y2)
    dx = x2 - x1
    dy = y2 - y1
    return math.floor(math.sqrt( dx * dx + dy * dy ) / 64)
end

-- When there are no enemies in the enemies table -- 
function roundOver()
    if next(enemies.table) == nil then
        return true
    end
end
