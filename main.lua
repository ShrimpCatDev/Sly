slick=require("slick") --be sure to require slick before sly! for some reason it freaks out if you don't have it in the main folder...
local sly = require("sly")
local sti=require("lib/sti") --meh do this whenever you want if you need it

pl={x=64,y=64,w=36,h=36,vx=0,vy=0}
local key=love.keyboard.isDown

function love.load()
    map=sti("demo.lua") --e
    world=slick.newWorld(800,600) --create a new world
    sly:loadMap("demo",world) --load the map for slick
    world:add(pl,pl.x,pl.y,slick.newCircleShape(pl.w/2,pl.h/2,pl.w/2))
end

function love.update(dt)
    map:update(dt) --update the map

    --move the player
    pl.vx, pl.vy = 0, 0
    if key("down") then
        pl.vy = 2
    elseif key("up") then
        pl.vy = -2
    end
    if key("right") then
        pl.vx = 2
    elseif key("left") then
        pl.vx = -2
    end
    pl.x, pl.y, collisions, count = world:move(pl, pl.x+pl.vx, pl.y+pl.vy)
end

function love.draw()

    --draw the map
    map:draw()

    --draw the map collisions
    sly:draw("5c70ff","22123b") --draw the map, hex colors are optional

    --draw the player
    love.graphics.setColor(0.329,0.863,576)
    love.graphics.circle("fill",pl.x+pl.w/2,pl.y+pl.w/2,pl.w/2)
    love.graphics.setColor(1,1,1)
end