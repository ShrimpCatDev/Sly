# Sly
Slick support for Tiled in LÖVE

# Demo
This is the main.lua file
```lua
slick=require("slick") --be sure to require slick before sly! for some reason it gives you an error if you don't have it in the main folder...
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
```

# Usage
Sly is very easy to use, simply create a layer in your tiled project, add a bool property called collidable and set it to true (you can also do it with objects if you don't want to do it to all the objects in a layer),
go into your game project and require sly (use `sly=require("path_to_sly/sly")` and make sure to load Slick first!) and enter `sly:loadMap(path,world)`. path is the path to your map file (dont bother including .lua at the end), and world is your slick world.

If you want to draw the collision objects, simply use `sly:draw(hex1,hex2)`, defining hex1 and hex2 is completely optional, all they do is set the color of collision objects,
but if you do want to, be sure not to include a `#`.

and thats it!
now if you need to access the collision objects at all you can using the table `sly.cols` (replace sly with whatever you called the sly variable)
