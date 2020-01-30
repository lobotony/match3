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

function Board:isMatched(x,y)
	return self.fields[y*self.bw+x].matched
end

function Board:setRemoved(x,y,flag)
	self.fields[y*self.bw+x].isRemoved = flag
end

function Board:isRemoved(x,y)
	return self.fields[y*self.bw+x].isRemoved
end

-- checks to see if beginning at (x,y) there are three or more gems that can be matched and removed
-- returns the number of gems that match, or -1
function Board:testHorizontalMatch(x,y)
	local result = -1 
	local startCol = self:gemColorAt(x,y)
	local matchLength = 0

	for i=x,(self.bw-1) do
		if self:isRemoved(i,y) then 
			break
		end

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
		if self:isRemoved(x,i) then 
			break
		end


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
		self.fields[i].matched = false
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

-- start at the bottom, scan up
-- drop gems that have room to drop until they can't drop anymore
function Board:dropOldGems()
	print("!! searching for old drops")
	local startY = self.bh-2 -- start at the second lowest row, since lowest can't drop anymore

	for y=startY,0,-1 do 
		for x=0,self.bw-1 do 
			-- check if current gem is not removed and gem below current x/y is removed. drop it if necessary
			if not self:isRemoved(x,y) and self:isRemoved(x,y+1) then 
				print("dropping: ",x,y)
				self:dropGem(x,y)
			end
		end
	end
	print("!! done")
end

function Board:dropGem(x,y)
	local originalY = y
	while(y < (self.bh-1) and self:isRemoved(x,y+1))
	do
		y = y+1
	end
	self:setColorAt(x,y,self:gemColorAt(x,originalY))
	self:setRemoved(x,y,false)
	self:setRemoved(x,originalY, true)
end

return Board

