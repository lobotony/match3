local Game = {}
Game.__index = Game

function Game:create()
	result = {}
	setmetatable(result, Game)
	return result
end

return Game