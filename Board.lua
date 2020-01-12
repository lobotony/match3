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

return Board

