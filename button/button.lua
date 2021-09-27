-- A button working example

function love.load()
    printx = 0
    printy = 0
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

    text = "text"

function love.draw()
    love.graphics.print(text, printx, printy)
    love.graphics.rectangle('fill', 100, 100, 100, 50)
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
        if CheckCollision(100, 100, 100, 50, x, y, 1, 1) then
            text = "bla"
        else
            text = "text"
        end
    
    end
end
