function love.load()
    love.physics.setMeter(64) -- 1 meter = 64 pixels
    world = love.physics.newWorld(0, 0, true)

    screenHeight, screenWidth = love.graphics.getDimensions()
    screenCenterX, screenCenterY = screenHeight/2, screenWidth/2

    Robot = {
        x = 0,
        y = 0,
        moveSpeed = 50,
        angle = 0,
        turnSpeed = 10000,
        size = 50,
    }

    -- Create the robot body
    Robot.body = love.physics.newBody(world, Robot.x, Robot.y, "dynamic")
    Robot.shape = love.physics.newRectangleShape(Robot.size, Robot.size)
    Robot.fixture = love.physics.newFixture(Robot.body, Robot.shape)
    Robot.body:setLinearDamping(10)
    Robot.body:setAngularDamping(10)

    -- Create the wheels
    Wheels = {
        FR = createSwerveModule(world, Robot.body, -Robot.size/2, Robot.size/2),
        FL = createSwerveModule(world, Robot.body, Robot.size/2, Robot.size/2),
        BR = createSwerveModule(world, Robot.body, -Robot.size/2, -Robot.size/2),
        BL = createSwerveModule(world, Robot.body, Robot.size/2, -Robot.size/2),
    }

    -- Set up arrow keys
    Keys = {
        left = "a",
        right = "d",
        up = "w",
        down = "s",
        rotateL = "left",
        rotateR = "right",
        forward = "up",
        backward = "down",
        reset = "space"
    }
end

function createSwerveModule(world, body, offsetX, offsetY)
    local module = {}
    module.body = love.physics.newBody(world, Robot.x + offsetX, Robot.y + offsetY, "dynamic")
    module.shape = love.physics.newRectangleShape(20, 40)
    module.fixture = love.physics.newFixture(module.body, module.shape)
    module.joint = love.physics.newRevoluteJoint(body, module.body, Robot.x + offsetX, Robot.y + offsetY, false)

    return module
end

function updateSwerveModule(module, angle)
    module.joint:setLimits(angle, angle)
end

function love.update(dt)
    world:update(dt)
        
    -- Move based on arrow keys
    local forceX = (
        (love.keyboard.isDown(Keys.left) and -1 or 0) +
        (love.keyboard.isDown(Keys.right) and 1 or 0)
    ) * Robot.moveSpeed

    local forceY = (
        (love.keyboard.isDown(Keys.up) and -1 or 0) +
        (love.keyboard.isDown(Keys.down) and 1 or 0)
    ) * Robot.moveSpeed

    if love.keyboard.isDown(Keys.reset) then
        Robot.body:setPosition(screenCenterX, screenCenterY)
        Robot.body:setLinearVelocity(0,0)
        Robot.body:setAngularVelocity(0,0)
        Robot.body:setAngle(0)
    end



    Robot.body:applyForce(forceX * Robot.moveSpeed, forceY * Robot.moveSpeed)

    -- Change angle
    local torque = ((love.keyboard.isDown(Keys.rotateL) and -1 or 0) + (love.keyboard.isDown(Keys.rotateR) and 1 or 0)) * Robot.turnSpeed
    Robot.body:applyTorque(torque)

    -- Keep angle within [0, 2*pi)
    local angle = Robot.body:getAngle()
    Robot.body:setAngle(angle % (2 * math.pi))

    -- Update the swerve modules
    updateSwerveModule(Wheels.FR, Robot.body:getAngle())
    updateSwerveModule(Wheels.FL, Robot.body:getAngle())
    updateSwerveModule(Wheels.BR, Robot.body:getAngle())
    updateSwerveModule(Wheels.BL, Robot.body:getAngle())
end

function love.draw()
    -- Draw the wheels
    for k, v in pairs(Wheels) do
        love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
    end

    -- Draw the robot
    love.graphics.polygon("fill", Robot.body:getWorldPoints(Robot.shape:getPoints()))
end
