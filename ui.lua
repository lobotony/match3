local Ui = {}
Ui.__index = Ui

function Ui:create() 
	local result = {}
	setmetatable(result, Ui)
	return result
end

function Ui:init()
	self.scoreFont = love.graphics.newFont("assets/fonts/PrincessSofia-Regular.ttf", 32)	
end

function Ui:render()
	love.graphics.setFont(self.scoreFont)
	love.graphics.print("12345")
end

return Ui
