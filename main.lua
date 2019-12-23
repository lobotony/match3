
gemBitmaps = {}
scoreFont = nil
bw = 8
bh = 8
bd = {}
bpw = nil
bph = nil
box = nil
boy = nil

sz = 64

bitmapSize = 512

screenWidthPixels = nil
screenHeightPixels = nil

function initBoard() 
	for i=0,(bw*bh)-1 do
		bd[i] = i % 7
	end
end

function updateBoardMeasurements()
	-- center in window 
	screenWidthPixels,screenHeightPixels = love.graphics.getDimensions( )
	bpw = sz*bw
	bph = sz*bh
	box = (screenWidthPixels - bpw)/2
	boy = (screenHeightPixels - bph)/2
end

function drawGem(gemIndex, x,y)
	image = gemBitmaps[gemIndex]
	scaling = sz / bitmapSize
	love.graphics.draw(image, 
		x, 
		y, 
		0, 
		scaling, scaling, 
		0, 0, 0, 0)
end

function drawBoard(x, y)
	for i=0,(bw*bh)-1 do
		drawGem(bd[i], x+(i%bw)*sz, y+math.floor(i/bw)*sz)
	end
end

-- returns -1 for a coord that is out of range
function mousePosToGemCoords(x,y)
	lx = x - box
	ly = y - boy

	rx = -1
	ry = -1

	if lx > 0 and lx < bpw then
		rx = math.floor(lx / sz)
	end

	if ly > 0 and ly < bph then 
		ry = math.floor(ly / sz)
	end

	return rx, ry
end


function love.load() 	
	initBoard()

	love.window.setMode(800,600,{highdpi=true})
	print("--- starting")

	scoreFont = love.graphics.newFont("PrincessSofia-Regular.ttf", 32)
	print(scoreFont)

	gemBitmaps[0] = love.graphics.newImage("green.png")
	gemBitmaps[1] = love.graphics.newImage("purple.png")
	gemBitmaps[2] = love.graphics.newImage("blue.png")
	gemBitmaps[3] = love.graphics.newImage("grey.png")
	gemBitmaps[4] = love.graphics.newImage("orange.png")
	gemBitmaps[5] = love.graphics.newImage("red.png")
	gemBitmaps[6] = love.graphics.newImage("yellow.png")

--	love.window.setFullscreen(true)
--	love.mouse.setVisible(false)
	updateBoardMeasurements()
end

function love.mousepressed(x,y,button, istouch)
	--print("mouse down",x,y, button, istouch)
	bx, by = mousePosToGemCoords(x,y)
	print(bx, by)

	if bx == -1 or by == -1 then 
		--nothing
	else
		bd[by*bw+bx] = 0
	end
end

function love.update(dt)
end

function love.draw()
	drawBoard(box,boy)
	love.graphics.setFont(scoreFont)
	love.graphics.print("12345")
end

