COLORS = {
	[' '] = {.87, .87, .87},
	i = {.47, .76, .94},
	j = {.93, .91, .42},
	l = {.49, .85, .76},
	o = {.92, .69, .47},
	s = {.83, .54, .93},
	t = {.97, .58, .77},
	z = {.66, .83, .46},
	preview = {.75, .75, .75}
}

PIECE_STRUCTURES = {
    {
        {
            {' ', ' ', ' ', ' '},
            {'i', 'i', 'i', 'i'},
            {' ', ' ', ' ', ' '},
      	    {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 'o', 'o', ' '},
            {' ', 'o', 'o', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', 'j', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {'j', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'j', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', 'j', ' '},
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
         {
            {' ', ' ', ' ', ' '},
            {'l', 'l', 'l', ' '},
            {'l', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', ' ', 'l', ' '},
            {'l', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'l', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {' ', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', ' ', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 's', 's', ' '},
            {'s', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'s', ' ', ' ', ' '},
            {'s', 's', ' ', ' '},
            {' ', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {' ', 'z', 'z', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'z', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {'z', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
}

TIMER_LIMIT = 0.5

PIECE_X_COUNT = 4
PIECE_Y_COUNT = 4

GRID_X_COUNT = 10
GRID_Y_COUNT = 18

OFFSET_X = 2
OFFSET_Y = 5

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	math.randomseed(os.time())

	love.window.setTitle('Blocks')

	love.graphics.setBackgroundColor(255, 255, 255)

	initGame()
end

function love.keypressed(key)
	if key == 'x' then
		local testRotation = pieceRotation + 1
		if testRotation > #PIECE_STRUCTURES[pieceType] then
			testRotation = 1
		end
		pieceRotation = canPieceMove(pieceX, pieceY, testRotation) and testRotation or pieceRotation

	elseif key == 'z' then
		local testRotation = pieceRotation - 1
		if testRotation < 1 then
			testRotation = #PIECE_STRUCTURES[pieceType]
		end
		pieceRotation = canPieceMove(pieceX, pieceY, testRotation) and testRotation or pieceRotation

	elseif key == 'left' then
        local testX = pieceX - 1
        pieceX = canPieceMove(testX, pieceY, pieceRotation) and testX or pieceX

    elseif key == 'right' then
        local testX = pieceX + 1
        pieceX = canPieceMove(testX, pieceY, pieceRotation) and testX or pieceX

    elseif key == 'c' then
    	while canPieceMove(pieceX, pieceY + 1, pieceRotation) do
    		pieceY = pieceY + 1
    		timer = TIMER_LIMIT
    	end
    elseif key == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	timer = timer + dt

	if timer > TIMER_LIMIT then
		timer = timer - TIMER_LIMIT

		local testY = pieceY + 1
		if canPieceMove(pieceX, testY, pieceRotation) then
			pieceY = testY
		else
			-- add piece to grid
			for y = 1, PIECE_Y_COUNT do
				for x = 1, PIECE_X_COUNT do
					local block = PIECE_STRUCTURES[pieceType][pieceRotation][y][x]
					if block ~= ' ' then
						Grid[pieceY + y][pieceX + x] = block
					end
				end
			end

			for y = 1, GRID_Y_COUNT do
				local complete = true
				for x = 1, GRID_X_COUNT do
					if Grid[y][x] == ' ' then
						complete = false
					end
				end

				if complete then
					for removeY = y, 2, -1 do
						for removeX = 1, GRID_X_COUNT do
							Grid[removeY][removeX] = Grid[removeY - 1][removeX]
						end
					end

					for removeX = 1, GRID_X_COUNT do
						Grid[1][removeX] = ' '
					end
				end
			end

			newPiece()

			if not canPieceMove(pieceX, pieceY, pieceRotation) then
				initGame()
			end
		end
	end
end

function love.draw()
	for y = 1, GRID_Y_COUNT do
		for x = 1, GRID_X_COUNT do
			drawBlock(Grid[y][x], x + OFFSET_X, y + OFFSET_Y)	
		end
	end

	for y = 1, PIECE_Y_COUNT do
		for x = 1, PIECE_X_COUNT do
			local block = PIECE_STRUCTURES[sequence[#sequence]][1][y][x]
			if block ~= ' ' then
				drawBlock('preview', x + 5, y + 1)
			end
		end
	end

	for y = 1, PIECE_Y_COUNT do
		for x = 1, PIECE_X_COUNT do
			local block = PIECE_STRUCTURES[pieceType][pieceRotation][y][x]
			if block ~= ' ' then
				drawBlock(block, x + pieceX + OFFSET_X, y + pieceY + OFFSET_Y)
			end
		end
	end
end

function drawBlock(block, x, y)
	love.graphics.setColor(COLORS[block])

	local blockSize = 20
	local blockDrawSize = blockSize - 1

	love.graphics.rectangle('fill', (x - 1) * blockSize, (y - 1) * blockSize, blockDrawSize, blockDrawSize)
end

function canPieceMove(testX, testY, testRotation)
	for x = 1, PIECE_X_COUNT do
		for y = 1, PIECE_Y_COUNT do
			local testBlockX = testX + x
			local testBlockY = testY + y

			if PIECE_STRUCTURES[pieceType][testRotation][y][x] ~= ' ' and (
				(testBlockX) < 1 
				or (testBlockX) > GRID_X_COUNT 
				or (testBlockY) > GRID_Y_COUNT
				or Grid[testBlockY][testBlockX] ~= ' '
			) then
				return false
			end
		end
	end

	return true
end

function newPiece()
	pieceX = 3
	pieceY = 0
	pieceType = table.remove(sequence)
	pieceRotation = 1

	if #sequence == 0 then
		sequence = newSequence()
	end
end

function newSequence()
	sequence = {}
	for pieceTypeIndex = 1, #PIECE_STRUCTURES do
		local position = math.random(#sequence + 1)
		table.insert(sequence, position, pieceTypeIndex)
	end

	return sequence
end

function initGame()
	-- create a grid in which game is played
	Grid = {}
	for y = 1, GRID_Y_COUNT do
		Grid[y] = {}
		for x = 1, GRID_X_COUNT do
			Grid[y][x] = ' '
		end
	end

	-- create a sequence of pieces
	sequence = newSequence()

	-- add a new piece to be spawn
	newPiece()

	-- initialize the timer to zero
    timer = 0
end