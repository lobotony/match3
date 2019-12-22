
testImage = nil
green = nil
purple = nil

gemBitmaps = {}

bw = 8
bh = 8
bd = {}

sz = 64

bitmapSize = 512

function initBoard() 
	for i=0,(bw*bh)-1	do
		bd[i] = i % 3
	end
end

function drawGem(gemIndex, x,y)
	print("gemIndex = "..gemIndex)
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

function love.load() 	
	print("--- starting")

	initBoard()

	gemBitmaps[0] = love.graphics.newImage("green.png")
	gemBitmaps[1] = love.graphics.newImage("purple.png")
	gemBitmaps[2] = love.graphics.newImage("blue.png")
--	love.window.setFullscreen(true)
--	love.mouse.setVisible(false)
end

function love.update(dt)
	if(love.mouse.isDown(1)) then
		print("down")
	end
end

function love.draw()

	-- center in window 
	w,h = love.graphics.getDimensions( )
	bpw = sz*bw
	bph = sz*bh
	ox = (w - bpw)/2
	oy = (h - bph)/2

	drawBoard(ox,oy)
end