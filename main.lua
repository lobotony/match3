local Board = require("Board")

board = Board:create()
board:randomize()

gemBitmaps = {}
scoreFont = nil
bw = 8
bh = 8
bd = {}
bpw = nil
bph = nil
box = nil
boy = nil

numGemKinds = 7

sz = 64

bitmapSize = 512

screenWidthPixels = nil
screenHeightPixels = nil

function updateBoardMeasurements()
	-- center in window 
	screenWidthPixels,screenHeightPixels = love.graphics.getDimensions( )
	bpw = sz*bw
	bph = sz*bh
	box = (screenWidthPixels - bpw)/2
	boy = (screenHeightPixels - bph)/2
end

function drawGem(gemIndex, x,y)
	local image = gemBitmaps[gemIndex]
	local scaling = sz / bitmapSize
	love.graphics.draw(image, 
		x, 
		y, 
		0, 
		scaling, scaling, 
		0, 0, 0, 0)
end

function drawBoard(x, y)
	for i=0,(bw*bh)-1 do
		local index = y*board.bw+x
		local field = board.fields[i]
		local c = field.color
		drawGem(c, x+(i%bw)*sz, y+math.floor(i/bw)*sz)
	end
end

-- returns -1 for a coord that is out of range
function mousePosToGemCoords(x,y)
	local lx = x - box
	local ly = y - boy

	local rx = -1
	local ry = -1

	if lx > 0 and lx < bpw then
		rx = math.floor(lx / sz)
	end

	if ly > 0 and ly < bph then 
		ry = math.floor(ly / sz)
	end

	return rx, ry
end

function love.load() 	
	math.randomseed(os.time())

	love.window.setMode(800,600,{highdpi=true})
	print("--- starting")

	scoreFont = love.graphics.newFont("assets/fonts/PrincessSofia-Regular.ttf", 32)
	print(scoreFont)

	gemBitmaps[0] = love.graphics.newImage("assets/images/green.png")
	gemBitmaps[1] = love.graphics.newImage("assets/images/purple.png")
	gemBitmaps[2] = love.graphics.newImage("assets/images/blue.png")
	gemBitmaps[3] = love.graphics.newImage("assets/images/grey.png")
	gemBitmaps[4] = love.graphics.newImage("assets/images/orange.png")
	gemBitmaps[5] = love.graphics.newImage("assets/images/red.png")
	gemBitmaps[6] = love.graphics.newImage("assets/images/yellow.png")

	board:randomize()

--	love.window.setFullscreen(true)
--	love.mouse.setVisible(false)
	updateBoardMeasurements()
end

function love.mousepressed(x,y,button, istouch)
	--print("mouse down",x,y, button, istouch)
	local bx, by = mousePosToGemCoords(x,y)
	print(bx, by)

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
	drawBoard(box,boy)
	love.graphics.setFont(scoreFont)
	love.graphics.print("12345")
end

