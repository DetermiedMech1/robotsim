function love.load()
    Player = {
        x = 0,
        y = 0,
        moveSpeed = 5,
        angle = 0,
        turnSpeed = 0.1,
    }
    Keys = {
        left = "a",
        right = "d",
        up = "w",
        down = "s",
        rotateL = "left",
        rotateR = "right",
    }
end

function love.update()
    Player.x = Player.x + (love.keyboard.isDown(Keys.left) and -Player.moveSpeed or 0) + (love.keyboard.isDown(Keys.right) and Player.moveSpeed or 0)
    Player.y = Player.y + (love.keyboard.isDown(Keys.up) and -Player.moveSpeed or 0) + (love.keyboard.isDown(Keys.down) and Player.moveSpeed or 0)
    Player.angle = Player.angle > 2*math.pi and 0 or Player.angle
    Player.angle = Player.angle < 0 and 2*math.pi or Player.angle
    Player.angle = Player.angle + ((love.keyboard.isDown(Keys.rotateL) and -1 or 0) + (love.keyboard.isDown(Keys.rotateR) and 1 or 0)) * Player.turnSpeed
end

function love.draw()
    love.graphics.push()
        love.graphics.translate(Player.x, Player.y)
        love.graphics.rotate(Player.angle)
        love.graphics.rectangle("line", -25, -25, 50, 50)
        love.graphics.line(0,0 , 0,-100)
    love.graphics.pop()
end