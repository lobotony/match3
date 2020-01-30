local Board = require("Board")
local Renderer = require("Renderer")
local Ui = require("Ui")
local DebugUi = require("DebugUi")

local Game = {}
Game.__index = Game

function Game:create()
	local result = {}
	setmetatable(result, Game)
	self.board = Board:create()
	self.renderer = Renderer:create(self.board)
	self.ui = Ui:create()
	self.debugUi = DebugUi:create(board)
	return result
end

function Game:init()
	math.randomseed(os.time())
	self.board:randomize()
	self.board:markMatches()
	self.renderer:init()

end

function Game:keypressed(key)
	if key == "escape" then 
		self.debugUi.enabled = not self.debugUi.enabled
	end
end

function Game:update(dt)
	self.debugUi:update()
	self.renderer:update(dt)
end

function Game:render()
	self.renderer.highlightMatches = self.debugUi.showMatches.checked
	self.renderer:render()
	--ui:render()
	self.debugUi:render()
end

return Game
