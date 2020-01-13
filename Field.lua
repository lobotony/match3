local Field = {}
Field.__index = Field

function Field:create(color)
	local result = {}
	result.color = color
	setmetatable(result, Field)
	return result
end

return Field

