-- This Lua file loads in the grid data and size, and draws the grid onto the map--

grid = {}

-- Load grid keys and variables into table --
function grid:load()
    self.font = love.graphics.setNewFont("assets/Minecraft.ttf")
    self.cellSize = fCell
    self.rows = 17
    self.collums = 30
    self.gridCount = 0
    self.x = 0
    self.y = 0
    self.towerSelected = false

    self.selectImg = love.graphics.newImage("assets/select/select.png")
    -- Iterate through each grid fCell and assign them by count --
    for row = 1, self.rows do 
        grid[row] = {}
        for collum = 1, self.collums do
            if grid:checkCordinate( row , collum ) then
                grid[row][collum] = 1
            else
                grid[row][collum] = 0
            end
        end
    end
end

-- Draw the grid function --
function grid:draw()
    self:draw_grid()

    if grid.selected == true then
        love.graphics.draw(self.selectImg, self.x, self.y)
    end

    if grid.selected == true and grid[self.y / fCell + 1][self.x / fCell + 1] == 2 then
        love.graphics.circle("line", self.x + hCell, self.y + hCell, 5 * fCell, 10)
        self.towerSelected = true
    elseif grid.selected == true and grid[self.y / fCell + 1][self.x / fCell + 1] == 3 then
        love.graphics.circle("line", self.x + hCell, self.y + hCell, 3 * fCell, 10)
        self.towerSelected = true
    elseif grid.selected == true and grid[self.y / fCell + 1][self.x / fCell + 1] == 4 then
        love.graphics.circle("line", self.x + hCell, self.y + hCell, 3 * fCell, 10)
        self.towerSelected = true
    else
        self.towerSelected = false
    end

end

function grid:draw_grid()
    -- Iterate through rows and collums setting up grid parameters --
    love.graphics.setFont(self.font)
    for row = 1, self.rows do
        for collum = 1, self.collums do
            x = (collum - 1) * self.cellSize
            y = (row - 1) * self.cellSize

            if grid[row][collum] == 1 then 
                love.graphics.rectangle("line", x, y, self.cellSize, self.cellSize)
            end
        end
    end
end

-- Check function for grid, if cordinate is valid return true if not valid return false --
function grid:checkCordinate( row , collum )
    if row == 1 or row == 2 or row == 17 or collum == 1 or collum == 30 then
        return false
    elseif (row == 3 and (collum <= 3 or collum >= 28)) or (row <= 6 and (collum == 2 or collum == 29)) or (row >= 13 and collum >= 26) or (row >= 13 and collum <= 4) or (row >= 15 and collum <= 5)  then
        return false
    elseif ((row == 9 or row == 10) and (collum <= 5 or collum >= 26)) or ((row >= 5 and row <= 9) and (collum == 5 or collum == 26)) or ((row == 5 or row == 6) and (collum >= 6 and collum <= 25))then
        return false
    elseif ((row == 14 or row == 13) and (collum >= 8 and collum <= 23)) or ((row >= 7 and row <= 12) and (collum == 8 or collum == 11 or collum == 14 or collum == 17 or collum == 20 or collum == 23)) then 
        return false
    else
        return true
    end
end

-- Grid select function for selected towers / Grid squares --
function grid:onClick( x, y )
    if buttons:hovering(x , y) == false then
        grid.selected = true
        self.x = (math.floor(x / fCell)) * fCell
        self.y = (math.floor(y / fCell)) * fCell
    end
end
