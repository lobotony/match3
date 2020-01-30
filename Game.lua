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
	self.debugUi = DebugUi:create()


	self.debugUi.randomize = function() self:randomizeBoard() end
	self.debugUi.remove = function() self:removeMatches() end
	self.debugUi.dropOld = function() self:dropOldGems() end

	return result
end

function Game:init()
	math.randomseed(os.time())
	self:randomizeBoard()
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
	self.board:update(dt)
end

function Game:render()
	self.renderer.highlightMatches = self.debugUi.showMatches.checked
	self.renderer:render()
	--ui:render()
	self.debugUi:render()
end

function Game:randomizeBoard()
	self.board:randomize()
	self.board:markMatches()
end

function Game:removeMatches()
	self.board:removeMatches()
end

function Game:dropOldGems()
	self.board:dropOldGems()
	self.board:clearAllMatchFlags()
	self.board:markMatches()
end

return Game
