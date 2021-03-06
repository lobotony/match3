local DebugUi = {}
DebugUi.__index = DebugUi

suit = require "suit"

function DebugUi:create() 
	local result = {}
	result.enabled = true
	setmetatable(result, DebugUi)
	result.showMatches = {checked = false, text = "Matches"}
	result.showMoves = {checked = false, text = "Moves"}	
	result.fullscreen = {checked = false, text = "Fullscreen"}	
	result.numMoves = -1
	return result
end

function DebugUi:update()
	if not self.enabled then 
		return 
	end

	love.graphics.setNewFont(14)

	suit.layout:reset(10,10)
	suit.layout:padding(10)

	local w = 120
	local h = 30

	suit.Checkbox(self.showMatches, suit.layout:row(w,h))
	suit.Checkbox(self.showMoves, suit.layout:row(w,h))
	if suit.Checkbox(self.fullscreen, suit.layout:row(w,h)).hit then 
		love.window.setFullscreen(self.fullscreen.checked)
	end

	if suit.Button("Randomize", suit.layout:row(w,h)).hit then 
		self.randomize()
	end	

	if suit.Button("Remove", suit.layout:row(w,h)).hit then
		self.remove()
	end

	if suit.Button("Drop Old", suit.layout:row(w,h)).hit then
		self.dropOld()
	end

	if suit.Button("Drop New", suit.layout:row(w,h)).hit then
		self.dropNew()
	end

	if suit.Button("Find moves", suit.layout:row(w,h)).hit then
		self.findMoves()
	end

	suit.Label("Moves: "..self.numMoves, suit.layout:row(w,h))

end

function DebugUi:render()
	suit.draw()
end


return DebugUi