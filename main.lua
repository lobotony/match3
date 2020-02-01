local Game = require("Game")
local game = Game:create()

local inspect = require("inspect/inspect")

function love.load() 	
	love.window.setMode(800,600,{highdpi=true})
	print("--- starting")
	game:init()
	print(inspect(game, {depth=3}))
end

--[[
function love.mousepressed(x,y,button, istouch)
	--print("mouse down",x,y, button, istouch)
	board:randomize()
	board:markMatches()
	local bx, by = renderer:mousePosToGemCoords(x,y)
	--print(bx, by)

	if bx == -1 or by == -1 then 
		--nothing
	else
		board:setColorAt(bx, by, 0)
		print("horizontal: "..board:testHorizontalMatch(bx,by))
		print("vertical: "..board:testVerticalMatch(bx,by))
	end
end]]

function love.keypressed(key)
	game:keypressed(key)
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:render()
end
