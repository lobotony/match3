local Field = require("Field")

local Board = {}
Board.__index = Board

function Board:create() 
	local result = {}
	setmetatable(result, Board)

	result.bw = 8
	result.bh = 8
	result.numGemKinds = 7
	result.fields = {}

	return result
end

function Board:randomize()
	self.fields = {}
	print("-- randomizing board")
	for i=0,(self.bw * self.bh)-1 do
		local randomColor = math.random(0,self.numGemKinds-1)
		self.fields[i] = Field:create(randomColor)
		--print(randomColor)
	end	
	print("-- done")
end

function Board:gemColorAt(x,y)
	return self.fields[y*self.bw+x].color
end

function Board:setColorAt(x,y,col) 
	self.fields[y*self.bw+x].color = col
end

-- checks to see if beginning at (x,y) there are three or more gems that can be matched and removed
-- returns the number of gems that match, or -1
function Board:testHorizontalMatch(x,y)
	local result = -1 
	local startCol = self:gemColorAt(x,y)
	local matchLength = 0

	for i=x,(self.bw-1) do
		local curCol = self:gemColorAt(i, y)
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

function Board:testVerticalMatch(x,y)
	local result = -1 
	local startCol = self:gemColorAt(x,y)
	local matchLength = 0

	for i=y,(self.bh-1) do
		local curCol = self:gemColorAt(x, i)
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

return Board

