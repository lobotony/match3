
testImage = nil
panthi = nil

function love.load() 
	print("hello once")
	testImage = love.graphics.newImage("test.png")
	panthi = love.graphics.newImage("panthi.png")
	print(testImage)

	love.window.setFullscreen(true)
	love.mouse.setVisible(false)
end


t = 0
function love.draw()

	love.graphics.draw(panthi, 0, 0, 0, .2, .2, 0, 0, 0, 0)

	mx, my = love.mouse.getPosition()

	st = math.sin(t)

	love.graphics.draw(testImage, 
		mx, 
		my+st*10, 
		0, 
		0.1, 0.1, 
		0, 0, 0, 0)
	t = t + .2
end