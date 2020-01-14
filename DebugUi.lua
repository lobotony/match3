local DebugUi = {}
DebugUi.__index = DebugUi

function DebugUi:create(board) 
	local result = {}
	result.board = board
	result.enabled = true
	setmetatable(result, DebugUi)
	result.showMatches = {checked = false, text = "Matches"}
	result.showMoves = {checked = false, text = "Moves"}	
	return result
end

function DebugUi:update()
	if not self.enabled then 
		return 
	end

	love.graphics.setNewFont(14)

	suit.layout:reset(10,10)
	suit.layout:padding(10)

	suit.Checkbox(self.showMatches, suit.layout:row(100,30))
	suit.Checkbox(self.showMoves, suit.layout:row(100,30))

	if suit.Button("Randomize", suit.layout:row(100,30)).hit then 
		self.board:randomize()
		self.board:markMatches()
	end	
end

return DebugUi