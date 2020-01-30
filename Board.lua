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

function Board:setMatchedAt(x,y,flag) 
	self.fields[y*self.bw+x].matched = flag
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

function Board:clearAllMatchFlags()
	local n = self.bw*self.bh
	for i=0,n-1 do
		self.fields.matched = false
	end
end

function Board:markHorizontalMatch(x,y,n)
	print("H marking ",x,y,n)
	for i=0,n-1 do
		self:setMatchedAt(x+i,y, true)
	end
end

function Board:markVerticalMatch(x,y, n)
	print("V marking ",x,y,n)
	for i=0,n-1 do
		self:setMatchedAt(x,y+i, true)
	end
end

function Board:markMatches()
	print("-- marking")
	self:clearAllMatchFlags()

	for y=0,self.bh-1 do
		for x=0,self.bw-1 do
			local hm = self:testHorizontalMatch(x,y)
			local vm = self:testVerticalMatch(x,y)

			if hm >= 3 then 
				self:markHorizontalMatch(x,y,hm)
			end
			if vm >= 3 then 
				self:markVerticalMatch(x,y,vm)
			end
		end
	end
end

function Board:removeMatches()
	print("removing matches ... ")
	for i,f in ipairs(self.fields) do
		if f.matched then 
			f.isRemoved = true
		end
	end
end

return Board

