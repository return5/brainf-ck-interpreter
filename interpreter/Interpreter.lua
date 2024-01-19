local write <const> = io.write
local read <const> = io.read
local toChar = string.char

local Interpreter <const> = {type = "Interpreter"}
Interpreter.__index = Interpreter

_ENV = Interpreter

local function printByte(i,dataPointer,cells)
	write(toChar(cells[dataPointer + 1]))
	return dataPointer, i + 1
end

local function takeByte(i,dataPointer,cells)
	cells[dataPointer + 1] = read(1)
	return dataPointer,i + 1
end

local function movePointerRight(i,dataPointer,cells)
	local newDataPointer <const> = dataPointer + 1
	if not cells[newDataPointer] then cells[newDataPointer] = 0 end
	return newDataPointer,i + 1
end

local function movePointerLeft(i,dataPointer,cells)
	local newDataPointer <const> = dataPointer - 2
	if not cells[newDataPointer] then cells[newDataPointer] = 0 end
	return newDataPointer,i + 1
end

local function incrementCell(i,dataPointer,cells)
	cells[dataPointer + 1] = cells[dataPointer + 1] + 1
	return dataPointer, i + 1
end

local function decrementCell(i,dataPointer,cells)
	cells[dataPointer + 1] = cells[dataPointer + 1] - 1
	return dataPointer,i + 1
end

local function jumpToClosingBracket(i,dataPointer,cells,token)
	if cells[dataPointer + 1] == 0 then
		return dataPointer,token.jumpPos
	end
	return dataPointer, i + 1
end

local function jumpToOpeningBracket(i,dataPointer,cells,token)
	if cells[dataPointer + 1] ~= 0 then
		return dataPointer,token.jumpPos
	end
	return dataPointer, i + 1
end

local listTokens <const> = {
	['['] = jumpToClosingBracket,
	[']'] = jumpToOpeningBracket,
	['>'] = movePointerRight,
	['<'] = movePointerLeft,
	['.'] = printByte,
	['+'] = incrementCell,
	['-'] = decrementCell,
	[','] = takeByte
}

function Interpreter.interpretBF(tokens)
	local dataPointer = 0
	local cells <const> = {0}
	local i = 1
	while i <= #tokens do
		dataPointer,i = listTokens[tokens[i].type](i,dataPointer,cells,tokens[i])
	end

end

return Interpreter
