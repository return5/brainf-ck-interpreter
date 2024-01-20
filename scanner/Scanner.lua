local Token <const> = require('scanner.Token')
local stdErr <const> = io.stderr
local exit <const> = os.exit
local gmatch <const> = string.gmatch
local open <const> = io.open

local Scanner <const> = {type = "scanner"}
Scanner.__index = Scanner

_ENV = Scanner

local listTokens <const> = {
	['['] = true,
	[']'] = true,
	['>'] = true,
	['<'] = true,
	['.'] = true,
	['+'] = true,
	['-'] = true,
	[','] = true
}

local function errorOut()
	stdErr:write("failed to find matching brace.\n")
	exit()
end

local function checkBrackets(char,countClosingBracket,openingBrackets,i,token)
	if char == "[" then
		openingBrackets[#openingBrackets + 1] = token
		return countClosingBracket - 1
	end
	if char == "]" then
		if #openingBrackets <= 0 then errorOut() end
		local prevOpenBracket <const> = openingBrackets[#openingBrackets]
		openingBrackets[#openingBrackets] = nil
		token.jmpPos = prevOpenBracket.i + 1
		prevOpenBracket.jmpPos = i
		return countClosingBracket + 1
	end

	return countClosingBracket
end

local function getText(filePath)
	local file <const> = open(filePath,"r")
	if not file then
		stdErr:write("not a valid file path.\n")
		exit()
	end
	local text <const> = file:read("*a")
	file:close()
	return text
end

function Scanner.scanText(filePath)
	local text <const> = getText(filePath)
	local tokens <const> = {}
	local openingBrackets <const> = {}
	local countClosingBracket = 0
	local i = 1
	for char in gmatch(text,".") do
		if listTokens[char] then
			tokens[#tokens + 1] = Token:new(char,i)
			i = i + 1
			countClosingBracket = checkBrackets(char,countClosingBracket,openingBrackets,i,tokens[#tokens])
		end
	end
	if countClosingBracket ~= 0 then
		errorOut()
	end
	return tokens
	end

return Scanner
