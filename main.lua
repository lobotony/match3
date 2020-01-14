local Board = require("Board")
local Renderer = require("Renderer")
local Ui = require("Ui")
local DebugUi = require("DebugUi")

local board = Board:create()
local renderer = Renderer:create(board)
local ui = Ui:create()
local debugUi = DebugUi:create(board)

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

function love.keypressed(key)
	if key == "escape" then 
		debugUi.enabled = not debugUi.enabled
	end
end

function love.update(dt)
	debugUi:update()
end

function love.draw()
	renderer.highlightMatches = debugUi.showMatches.checked
	renderer:render()
	--ui:render()
	suit.draw()
end
