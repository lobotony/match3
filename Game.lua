local Board = require("Board")
local Renderer = require("Renderer")
local Ui = require("Ui")
local DebugUi = require("DebugUi")

local inspect = require("inspect/inspect")

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
	self.debugUi.dropNew = function() self:dropNewGems() end
	self.debugUi.findMoves = function() self:findMoves() end

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
	self.renderer.highlightMoves = self.debugUi.showMoves.checked
	self.renderer:render()
	--ui:render()
	self.debugUi:render()
end

function Game:randomizeBoard()
	self.board:randomize()
	self.board:markMatches()
	local moves = self.board:findMoves()
	print(inspect(moves))
	self.renderer.moves = moves
end

function Game:removeMatches()
	self.board:removeMatches()
end

function Game:dropOldGems()
	self.board:dropOldGems()
	self.board:clearAllMatchFlags() -- FIXME: move out
	self.board:markMatches() -- FIXME: move out
end

function Game:dropNewGems()
	self.board:dropNewGems()
	self.board:clearAllMatchFlags() -- FIXME: move out
	self.board:markMatches() -- FIXME: move out
end

function Game:findMoves()
	local moves = self.board:findMoves()
	print(inspect(moves))
	self.renderer.moves = moves
end

return Game
