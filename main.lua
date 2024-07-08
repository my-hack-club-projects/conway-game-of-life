local gridWidth = 50
local gridHeight = 50
local cellSize = 10
local grid = {}
local updateTime = 0.1
local timer = 0

function love.load()
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = math.random(2) - 1  -- Randomly initialize cells
        end
    end
end

function love.draw()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] == 1 then
                love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize, cellSize)
            else
                love.graphics.rectangle("line", (x - 1) * cellSize, (y - 1) * cellSize, cellSize, cellSize)
            end
        end
    end
end