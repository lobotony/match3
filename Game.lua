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
	self.selection = {}


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


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Game:findMoves()
	local moves = self.board:findMoves()
	self.renderer.moves = moves
	self.debugUi.numMoves = tablelength(moves)
end

function Game:mousePressed(x,y)
	local fx, fy = self.renderer:mousePosToFieldCoords(x,y)

	if fx == -1 or fy == -1 then 
		return 
	end

	local tl = tablelength(self.selection)

	print("selections so far: ")
	for s in pairs(self.selection) do
		print("selection: ", inspect(s))
	end

	if tl == 0 then
		print("appending first")
		self.selection[tl] = {x=fx, y=fy}
	elseif tl == 1 then
		print("checking distance to first")
		local oldHit = self.selection[0]
		local dx = math.abs(oldHit.x - fx)
		local dy = math.abs(oldHit.y - fy)

		if (dx == 0 and dy ==1) or (dx == 1 and dy == 0) then
			print("ok, appending as second selection")
			self.selection[tl] = {x=fx, y=fy}
		else
			print("not adjacent, making it the new first")
			self.selection[0] = {x=fx, y=fy}
		end
	end

	-- check length after click processing
	tl = tablelength(self.selection)
	if tl == 2 then 
		print("checking move")

		local previousMatchCount = self.board:countMatches()
		local s0 = self.selection[0]
		local s1 = self.selection[1]
		self.board:performMove(s0.x, s0.y, s1.x, s1.y)
		local newMatchCount = self.board:countMatches()
		if newMatchCount > previousMatchCount then -- this is better. Act upon it. 
			self.board:markMatches()
			self.board:removeMatches()
			self.board:dropOldGems()
			self.board:dropNewGems()
			self.board:markMatches()
			self:findMoves()
		else -- nope, swap back to restore previous state
			self.board:performMove(s0.x, s0.y, s1.x, s1.y)
		end

		self.selection = {} -- reset selection 
	end

	self.renderer.selection = self.selection

end

return Game
