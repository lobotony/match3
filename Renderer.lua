
local easing = require("easing/lib/easing")

local Renderer = {}
Renderer.__index = Renderer

function Renderer:create(board) 
	local result = {}
	setmetatable(result, Renderer)
	result.board = board
	result.highlightMatches = false
	result.highlightMoves = false
	result.r = 0
	result.rspeed = 0.8
	return result
end

-- call once on startup
function Renderer:init()
	self.gemBitmaps = {}
	self.gemBitmaps[0] = love.graphics.newImage("assets/images/green.png")
	self.gemBitmaps[1] = love.graphics.newImage("assets/images/purple.png")
	self.gemBitmaps[2] = love.graphics.newImage("assets/images/blue.png")
	self.gemBitmaps[3] = love.graphics.newImage("assets/images/grey.png")
	self.gemBitmaps[4] = love.graphics.newImage("assets/images/orange.png")
	self.gemBitmaps[5] = love.graphics.newImage("assets/images/red.png")
	self.gemBitmaps[6] = love.graphics.newImage("assets/images/yellow.png")
	self.bitmapSize = 512
	self.sz = 64
	self:updateBoardMeasurements()
end

-- dedicated function in order to refresh screen centering once window size updates
function Renderer:updateBoardMeasurements()
	-- center in window 
	self.screenWidthPixels,self.screenHeightPixels = love.graphics.getDimensions( )
	self.bpw = self.sz * self.board.bw
	self.bph = self.sz * self.board.bh
	self.box = (self.screenWidthPixels - self.bpw)/2
	self.boy = (self.screenHeightPixels - self.bph)/2
end

function Renderer:drawGem(gemIndex, x,y)
	local image = self.gemBitmaps[gemIndex]
	local scaling = self.sz / self.bitmapSize
	local o = self.sz/2
	love.graphics.setColor(1,1,1,1)	
	love.graphics.draw(image, 
		x+o, 
		y+o, 
		self.r, 
		scaling, scaling, 
		self.bitmapSize/2, self.bitmapSize/2, 0, 0)
end

function Renderer:update(dt)
	self.r = self.r + self.rspeed * dt
end

function Renderer:drawBoard(x, y)
	for i=0,(self.board.bw * self.board.bh)-1 do
		local index = y * self.board.bw + x
		local field = self.board.fields[i]
		local c = field.color

		local tx = x+(i%self.board.bw)*self.sz
		local ty = y+math.floor(i/self.board.bw)*self.sz

		if field.matched and self.highlightMatches then 
			love.graphics.setColor(1,0,0, 0.5)
			love.graphics.rectangle("fill", tx, ty, self.sz, self.sz)
		end

		if not field.isRemoved then 
			self:drawGem(c, tx, ty)
		end
	end
end

function Renderer:mousePosToGemCoords(x,y)
	local lx = x - self.box
	local ly = y - self.boy

	local rx = -1
	local ry = -1

	if lx > 0 and lx < self.bpw then
		rx = math.floor(lx / self.sz)
	end

	if ly > 0 and ly < self.bph then 
		ry = math.floor(ly / self.sz)
	end

	return rx, ry
end


function Renderer:render()
	self:updateBoardMeasurements()
	self:drawBoard(self.box, self.boy)
end

return Renderer
