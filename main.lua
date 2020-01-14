local Board = require("Board")
local Renderer = require("Renderer")
local Ui = require("Ui")

local board = Board:create()
local renderer = Renderer:create(board)
local ui = Ui:create()

suit = require "suit"

function love.load() 	
	math.randomseed(os.time())

	love.window.setMode(800,600,{highdpi=true})
	print("--- starting")

	renderer:init()
	ui:init()
	
	board:randomize()
	board:markMatches()

--	love.window.setFullscreen(true)
--	love.mouse.setVisible(false)
end

--[[
function love.mousepressed(x,y,button, istouch)
	--print("mouse down",x,y, button, istouch)
	board:randomize()
	board:markMatches()
	local bx, by = renderer:mousePosToGemCoords(x,y)
	--print(bx, by)

	if bx == -1 or by == -1 then 
		--nothing
	else
		board:setColorAt(bx, by, 0)
		print("horizontal: "..board:testHorizontalMatch(bx,by))
		print("vertical: "..board:testVerticalMatch(bx,by))
	end
end]]

local showMatches = {checked = false, text = "Matches"}
local showMoves = {checked = false, text = "Moves"}

function love.update(dt)
	love.graphics.setNewFont(14)

	suit.layout:reset(10,10)
	suit.layout:padding(10)

	suit.Checkbox(showMatches, suit.layout:row(100,30))
	suit.Checkbox(showMoves, suit.layout:row(100,30))

	if suit.Button("Randomize", suit.layout:row(100,30)).hit then 
		board:randomize()
		board:markMatches()
	end


end

function love.draw()
	renderer:updateBoardMeasurements()
	renderer.highlightMatches = showMatches.checked
	renderer:render()
	--ui:render()
	suit.draw()
end
