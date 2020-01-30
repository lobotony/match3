local Field = {}
Field.__index = Field

function Field:create(color)
	local result = {}
	result.color = color
	result.isRemoved = false
	result.matched = false
	setmetatable(result, Field)
	return result
end

function Field:update(dt)
	--print("updating field", dt)
end

return Field

