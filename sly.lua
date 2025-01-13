local sly={}
sly.cols={}
sly.draws={}

function sly:loadMap(path,world)
    local map=require(path)
    for _, layer in ipairs(map.layers) do
        if layer.type=="objectgroup" then
            for _,obj in ipairs(layer.objects) do
                if layer.properties.collidable==true or obj.properties.collidable==true then
                    local t={
                        name=obj.name,
                        type=obj.type,
                        x=obj.x,
                        y=obj.y,
                        width=obj.width,
                        height=obj.height,
                        layer=layer,
                        properties=obj.properties
                    }
                    table.insert(sly.cols,t)
                    if obj.shape=="rectangle" and obj.rotation==0 then
                        
                        world:add(sly.cols[#sly.cols],t.x,t.y,slick.newBoxShape(0,0,t.width,t.height))
                        table.insert(sly.draws,{x=t.x,y=t.y,width=t.width,height=t.height,kind="rectangle"})

                    elseif obj.shape=="ellipse" and obj.rotation==0 then

                        world:add(sly.cols[#sly.cols],t.x+t.width/2,t.y+t.height/2,slick.newCircleShape(0,0,t.width/2))
                        table.insert(sly.draws,{x=t.x,y=t.y,width=t.width,height=t.height,kind="circle"})

                    elseif obj.shape=="polygon" and obj.rotation==0 then

                        local polygon={}
                        for i=1,#obj.polygon do
                            table.insert(polygon,obj.polygon[i].x)
                            table.insert(polygon,obj.polygon[i].y)
                        end
                        world:add(sly.cols[#sly.cols],t.x,t.y,slick.newPolygonMeshShape(polygon))
                        table.insert(sly.draws,{x=t.x,y=t.y,width=t.width,height=t.height,kind="polygon",poly=polygon})

                    end
                end
            end
        end
    end
end

local function Color(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, value or 1}
end

function sly:draw(hex1,hex2)
    local r1,g1,b1=0.329,0.863,576
    local r2,g2,b2=.255,.588,.522
    if hex1 then
        r1,g1,b1=Color("#"..hex1)
    end
    if hex2 then
        r2,g2,b2=Color("#"..hex2)
    end
    for i,v in pairs(sly.draws) do
        if v.kind=="rectangle" then
            love.graphics.setColor(r1,g1,b1)
            love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
            love.graphics.setColor(r2,g2,b2)
            love.graphics.rectangle("line",v.x,v.y,v.width,v.height)
            love.graphics.setColor(1,1,1)
        elseif v.kind=="circle" then
            love.graphics.setColor(r1,g1,b1)
            love.graphics.circle("fill",v.x+v.width/2,v.y+v.height/2,v.width/2)
            love.graphics.setColor(r2,g2,b2)
            love.graphics.circle("line",v.x+v.width/2,v.y+v.height/2,v.width/2)
            love.graphics.setColor(1,1,1)
        elseif v.kind=="polygon" then
            love.graphics.push()
            love.graphics.translate(v.x,v.y)
            love.graphics.setColor(r1,g1,b1)
            love.graphics.polygon("fill",v.poly)
            love.graphics.setColor(r2,g2,b2)
            love.graphics.polygon("line",v.poly)
            love.graphics.setColor(1,1,1)
            love.graphics.pop()
        end
    end
end

return sly
