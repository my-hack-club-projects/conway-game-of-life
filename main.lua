local gridWidth = 50
local gridHeight = 50
local cellSize = 10
local grid = {}
local updateTime = 0.1
local timer = 0
local running = false
local currentEditCell = {x = 0, y = 0}

math.randomseed(os.time()) -- Seed depending on the current time

function countNeighbors(x, y)
    local count = 0
    for j = -1, 1 do
        for i = -1, 1 do
            if not (i == 0 and j == 0) then
                local nx, ny = x + i, y + j
                if nx > 0 and ny > 0 and nx <= gridWidth and ny <= gridHeight then
                    count = count + grid[ny][nx]
                end
            end
        end
    end
    return count
end

function updateGrid()
    local newGrid = {}
    for y = 1, gridHeight do
        newGrid[y] = {}
        for x = 1, gridWidth do
            local alive = grid[y][x] == 1
            local neighbors = countNeighbors(x, y)

            if alive and (neighbors < 2 or neighbors > 3) then
                newGrid[y][x] = 0  -- Cell dies
            elseif alive and (neighbors == 2 or 3) then
                newGrid[y][x] = 1  -- Cell lives
            elseif not alive and neighbors == 3 then
                newGrid[y][x] = 1  -- Cell becomes alive
            else
                newGrid[y][x] = grid[y][x]
            end
        end
    end
    grid = newGrid
end

function love.load()
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = math.random(2) - 1  -- Randomly initialize cells
        end
    end
end

function love.update(dt)
    if running then
        timer = timer + dt
        if timer >= updateTime then
            updateGrid()
            timer = 0
        end
    else
        -- edit mode, click to toggle a cell
        if love.mouse.isDown(1) then
            local x, y = love.mouse.getPosition()

            x = math.floor(x / cellSize) + 1
            y = math.floor(y / cellSize) + 1

            if currentEditCell.x ~= x or currentEditCell.y ~= y then
                currentEditCell.x = x
                currentEditCell.y = y

                if x > 0 and y > 0 and x <= gridWidth and y <= gridHeight then
                    grid[y][x] = 1 - grid[y][x]
                end
            end
        else
            currentEditCell.x = 0
            currentEditCell.y = 0
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