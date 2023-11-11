function love.load()
    function createRectangle(width, height, angle, centerX, centerY)
        local imgdata = love.image.newImageData(1, 1, 'rgba8', '\xff\xff\xff\xff')
        local img = love.graphics.newImage(imgdata)
        return {
            x = centerX,
            y = centerY,
            width = width,
            height = height,
            angle = angle,
            draw = function(self)
                love.graphics.draw(img, self.x, self.y, self.angle, self.width, self.height, 0.5, 0.5)
            end
        }
    end

    Player = {
        x = 0,
        y = 0,
        moveSpeed = 5,
        angle = 0,
        turnSpeed = 0.1,
        size = 50,
    }

    Keys = {
        left = "a",
        right = "d",
        up = "w",
        down = "s",
        rotateL = "left",
        rotateR = "right",
        forward = "up",
        backward = "down",
    }

    -- Create the player rectangle
    Player.body = createRectangle(Player.size, Player.size, Player.angle, Player.x, Player.y)

    Wheels = {
        FR = {
            x = Player.x,
            y = Player.y,
            angle = Player.angle,
        },
        FL = {
            x = Player.x,
            y = Player.y,
            angle = Player.angle,
        },
        BR = {
            x = Player.x,
            y = Player.y,
            angle = Player.angle,
        },
        BL = {
            x = Player.x,
            y = Player.y,
            angle = Player.angle,
        },
    }
    for k, v in pairs(Wheels) do
        v.body = createRectangle(100, 20, v.angle, v.x, v.y)
    end
end

function love.update(dt)
    -- Move based on arrow keys
    Player.x = Player.x + (
        (love.keyboard.isDown(Keys.left) and -1 or 0) +
        (love.keyboard.isDown(Keys.right) and 1 or 0)
    ) * Player.moveSpeed

    Player.y = Player.y + (
        (love.keyboard.isDown(Keys.up) and -1 or 0) +
        (love.keyboard.isDown(Keys.down) and 1 or 0)
    ) * Player.moveSpeed

    -- Change angle
    Player.angle = Player.angle + ((love.keyboard.isDown(Keys.rotateL) and -1 or 0) + (love.keyboard.isDown(Keys.rotateR) and 1 or 0)) * Player.turnSpeed

    -- Keep angle within [0, 2*pi)
    Player.angle = Player.angle % (2 * math.pi)

    -- Update the player rectangle's properties
    Player.body.x = Player.x
    Player.body.y = Player.y
    Player.body.angle = Player.angle

    --wheel
    for k, v in pairs(Wheels) do
        v.body.x, v.body.y = Player.x, Player.y
        v.body.angle = Player.angle
    end
end

function love.draw()
    -- Draw the player rectangle
    Player.body:draw()
    for k, v in pairs(Wheels) do
        v.body:draw()
    end
end
