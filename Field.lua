local Field = {}
Field.__index = Field

local easing = require("easing/lib/easing")

function Field:create(color)
	local result = {}
	result.color = color
	result.isRemoved = false
	result.matched = false
	setmetatable(result, Field)
	result.dropping = false
	result.deltaY = 0
	result.dropDuration = .2
	result.t = 0
	result.oy = 0
	return result
end

function Field:update(dt)
	--print("updating field", dt)
	if self.dropping and self.t < self.dropDuration then 
		self.oy = easing.inQuart(self.t, -self.deltaY, self.deltaY, self.dropDuration)
		self.t = self.t + dt
		--print("field dropping ", self.oy)
	else
		--print("drop done ", self.oy)
		self.dropping = false
		self.oy = 0
	end
end

function Field:getOffsetY()
	return self.oy
end

-- specify deltaY in positive units
function Field:drop(deltaY)
	self.dropping = true
	self.deltaY = deltaY
	self.t = 0
end

return Field

