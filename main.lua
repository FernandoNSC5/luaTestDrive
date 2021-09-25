pillarGap = 200

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

width = 600
height = 800

function getWidth() return width end

function getHeight() return height end

lostGame = false
flappyBird = {x = getWidth() / 2 - 50, y = 300, speed = 150, img = nil}
pillar = {x = getWidth(), y = getHeight() / 2}
score = 0

-- Draw the collision pillars
function drawPillar()
    love.graphics.rectangle('fill', pillar.x, 0, 50, pillar.y)
    love.graphics.rectangle('fill', pillar.x, pillar.y + pillarGap, 50,
                            getHeight())
end

-- This is called at the very beginning of the love engine when it launches
function love.load(arg)
    flappyBird.img = love.graphics.newImage('assets/flappy_bird.png')
    love.graphics.setBackgroundColor(0, 0, 200)
end

-- Called every time (delta t)
function love.update(dt)

    -- exit the game if scape is pressed
    if love.keyboard.isDown('escape') then love.event.push('quit') end

    -- in the end (lostGame is true) space restart things
    if love.keyboard.isDown('space') and lostGame then
        love.graphics.setBackgroundColor(0, 0, 200)
        lostGame = false
        flappyBird.x = getWidth() / 2 - 50
        flappyBird.y = 300
        flappyBird.speed = 150
        pillar = {x = getWidth(), y = getHeight() / 2}
        score = 0
    end

    -- During the game, the up key is used to control the bird
    if love.keyboard.isDown('up', 'w') and not lostGame then
        flappyBird.speed = flappyBird.speed + 50 + score
    end

    -- If the bird exits the frame, the game ends
    if flappyBird.y > getHeight() - 50 or flappyBird.y < 0 then
        lostGame = true
    end

    if CheckCollision(pillar.x, 0, 50, pillar.y, flappyBird.x, flappyBird.y,
                      flappyBird.img:getWidth() * .2,
                      flappyBird.img:getHeight() * .2) then lostGame = true end
    if CheckCollision(pillar.x, pillar.y + pillarGap, 50, getHeight(),
                      flappyBird.x, flappyBird.y,
                      flappyBird.img:getWidth() * .2,
                      flappyBird.img:getHeight() * .2) then lostGame = true end

    if not lostGame then
        pillar.x = pillar.x - 5;
        flappyBird.y = flappyBird.y - (flappyBird.speed * dt)

        flappyBird.speed = flappyBird.speed - 20 - score
    end

    -- Reset the pillar if it has passed across the screen
    if pillar.x <= 0 then
        pillar.x = getWidth()
        pillar.y = pillarGap + love.math.random(getHeight() - 2 * pillarGap)
    end

    -- When the bird crosses the pillar, the score increases
    if pillar.x == getWidth() / 2 - 50 then score = score + 1 end

end

-- This function is called after each frame update in the game. Updates the game canvas
function love.draw(dt)
    -- If the game hasnt ended, then draw the bird, the pillar and the score
    if not lostGame then
        love.graphics.draw(flappyBird.img, flappyBird.x, flappyBird.y,
                           math.rad(0), .2, .2)
        drawPillar()
        love.graphics.print("Score: " .. tostring(score), 0, 0, 0, 2, 2)
    end

    -- If the game has ended, then display the score 
    if lostGame then
        love.graphics.setBackgroundColor(200, 0, 0)
        love.graphics.print("Dead - Score: " .. tostring(score), 175, 300, 0, 3,
                            3)
        love.graphics.print("\nPress spacebar to retry", 175, 350, 0, 2, 2)
    end

end
