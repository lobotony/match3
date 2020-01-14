local Board = require("Board")
local Renderer = require("Renderer")

local board = Board:create()
local renderer = Renderer:create(board)

function love.load() 	
	math.randomseed(os.time())

	love.window.setMode(800,600,{highdpi=true})
	print("--- starting")

	renderer:init()

	board:randomize()

--	love.window.setFullscreen(true)
--	love.mouse.setVisible(false)
end

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
end

function love.update(dt)
end

function love.draw()
	renderer:render()
end

