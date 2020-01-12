
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

function createField(params)
	local result = {}
	for k,v in pairs(params) do 
		result[k] = v
	end
	return result
end

function gemColorAt(x,y)
	return bd[y*bw+x].color
end

function randomizeBoard()
	math.randomseed(os.time())
	for i=0,(bw*bh)-1 do
		local randomColor = math.random(0,numGemKinds-1)
		bd[i] = createField({color = randomColor})
		--print(bd[i])
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
		drawGem(bd[i].color, x+(i%bw)*sz, y+math.floor(i/bw)*sz)
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

-- checks to see if beginning at (x,y) there are three or more gems that can be matched and removed
-- returns the number of gems that match, or -1
function testHorizontalMatch(x,y)
	local result = -1 
	local startCol = gemColorAt(x,y)
	local matchLength = 0

	for i=x,(bw-1) do
		local curCol = gemColorAt(i, y)
		if startCol == curCol then 
			matchLength = matchLength + 1
		else
			break
		end
	end

	if matchLength >= 3 then 
		return matchLength
	else
		return -1
	end
end

function testVerticalMatch(x,y)
	local result = -1 
	local startCol = gemColorAt(x,y)
	local matchLength = 0

	for i=y,(bh-1) do
		local curCol = gemColorAt(x, i)
		if startCol == curCol then 
			matchLength = matchLength + 1
		else
			break
		end
	end

	if matchLength >= 3 then 
		return matchLength
	else
		return -1
	end
end


function love.load() 	
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

	randomizeBoard()

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
		bd[by*bw+bx].color = 0
	end

	print("horizontal: "..testHorizontalMatch(bx,by))
	print("vertical: "..testVerticalMatch(bx,by))
end

function love.update(dt)
end

function love.draw()
	drawBoard(box,boy)
	love.graphics.setFont(scoreFont)
	love.graphics.print("12345")
end

