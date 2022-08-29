--[[ Variables ]]--
local Bird = {
    X = 30,
    Y = 0,
    Width = 30,
    Height = 30,
    Speed = 0,
    Color = { R = 255/255, G = 128/255, B = 0, A = 255/255 }
}

local Pipe = {
    { X = 140, Y = 100, Width = 30, Height = 200, Color = { R = 255/255, G = 0, B = 0, A = 255/255 } },
    { X = 280, Y = 100, Width = 30, Height = 100, Color = { R = 255/255, G = 0, B = 0, A = 255/255 } },
}

local Score = 0
local ScoreFlag = false


--[[ Functions ]]--
local CheckAABBCollision = function (A, B)
    return (A.X < B.X+B.Width) and (A.X+A.Width > B.X) 
    and ((A.Y < B.Height) or (A.Y+A.Height > B.Height+B.Y)) -- 위 또는 아래 파이프 닿았을 때
end

local GameReset = function ()
    Bird.X = 30
    Bird.Y = 0
    Bird.Speed = 0

    Pipe = {
        { X = 140, Y = 100, Width = 30, Height = 200, Color = { R = 255/255, G = 0, B = 0, A = 255/255 } },
        { X = 280, Y = 100, Width = 30, Height = 100, Color = { R = 255/255, G = 0, B = 0, A = 255/255 } },
    }

    Score = 0
end



--[[ Callbacks ]]--
function love.load()

end

function love.update(dt)
    -- 낙하
    Bird.Speed = Bird.Speed + (200 * dt)
    Bird.Y = Bird.Y + (Bird.Speed * dt)

    -- 파이프 이동
    for i=1, #Pipe do
        -- 좌로 이동
        Pipe[i].X = Pipe[i].X - (50 * dt)

        -- 맵 끝에 닿았다면~
        if ((Pipe[i].X + Pipe[i].Width) <= 0) then
            -- 제거하지 말고 우측으로 이동
            Pipe[i].X = ConfigMgr.window.width
            Pipe[i].Y = love.math.random(50, ConfigMgr.window.height - Pipe[i].Height - 50)
            ScoreFlag = false
        end
    end

    -- 파이프 충돌 처리
    for i=1, #Pipe do
        if (CheckAABBCollision(Bird, Pipe[i])) then
            GameReset()
        end
    end

    -- 점수 증가
    for i=1, #Pipe do
        if (Bird.X > (Pipe[i].X + Pipe[i].Width)) then
            if (ScoreFlag == false) then
                Score = Score + 1
                ScoreFlag = true
            end
        end
    end
end

function love.draw()
    -- 주인공
    love.graphics.setColor(Bird.Color.R, Bird.Color.G, Bird.Color.B, Bird.Color.A)
    love.graphics.rectangle("fill", Bird.X, Bird.Y, Bird.Width, Bird.Height)

    -- 파이프
    for i=1, #Pipe do
        love.graphics.setColor(Pipe[i].Color.R, Pipe[i].Color.G, Pipe[i].Color.B, Pipe[i].Color.A)
        love.graphics.rectangle("fill", Pipe[i].X, 0, Pipe[i].Width, Pipe[i].Height)

        love.graphics.setColor(Pipe[i].Color.R, Pipe[i].Color.G, Pipe[i].Color.B, Pipe[i].Color.A)
        love.graphics.rectangle("fill", Pipe[i].X, Pipe[i].Y + Pipe[i].Height, Pipe[i].Width, ConfigMgr.window.height - Pipe[i].Y - Pipe[i].Height)
    end

    -- 점수
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(tostring(Score), 0, 30, ConfigMgr.window.width, "center")
end

function love.keypressed(key)
    -- 점프
    if (key == "space") then
        Bird.Speed = -100
    end
end