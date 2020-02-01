local Game = require("Game")
local game = Game:create()

local inspect = require("inspect/inspect")

function love.load() 	
	love.window.setMode(800,600,{highdpi=true})
	print("--- starting")
	game:init()
end

function love.mousepressed(x,y,button, istouch)
	game:mousePressed(x,y)
end

function love.keypressed(key)
	game:keypressed(key)
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:render()
end
