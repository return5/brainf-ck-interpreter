local Token <const> = require('scanner.Token')
local gmatch <const> = string.gmatch
local exit <const> = os.exit
local stdError <const> = io.stderr

local Scanner <const> = {type = "scanner"}
Scanner.__index = Scanner

_ENV = Scanner


local function addToTokens(tokens,char,count,jumpPos)
	tokens[#tokens + 1] = Token:new(char,count,jumpPos)
end

local function countChar(tokens,i,char,textArr)
	local count = 0
	repeat
		count = count + 1
		i = i + 1
	until i > #textArr or textArr[i] ~= char
	addToTokens(tokens,char,count)
	return i
end


local function continueConditionForward(i,textArr,targetChar)
	if i > #textArr then
		stdError:write("didnt find a matching ]\n")
		exit()
	end
	return textArr[i] ~= targetChar
end

local function continueConditionBackwards(i,textArr,targetChar)
	if i <= 0 then
		stdError:write("didnt find a matching [\n")
		exit()
	end
	return textArr[i] ~= targetChar
end

local function loopUntil(targetChar,i,textArr,incr,continueCondition)
	while continueCondition(i,textArr,targetChar) do
		i = i + incr
	end
	return i
end

local function openBracket(tokens,i,char,textArr)
	local jumpPos <const> = loopUntil(']',i + 1,textArr,1,continueConditionForward)
	addToTokens(tokens,char,1,jumpPos)
	return i + 1
end

local function closeBracket(tokens,i,char,textArr)
	local jumpPos <const> = loopUntil('[',i - 1,textArr,-1,continueConditionBackwards)
	addToTokens(tokens,char,1,jumpPos)
	return i + 1
end

local function addChar(tokens,i,char)
	addToTokens(tokens,char,1)
	return i + 1
end


local listTokens <const> = {
	['['] = openBracket,
	[']'] = closeBracket,
	['>'] = countChar,
	['<'] = countChar,
	['.'] = addChar,
	['+'] = countChar,
	['-'] = countChar,
	[','] = addChar
}

function Scanner.convertTextToArr(text)
	local textArr <const> = {}
	for char  in gmatch(text,".") do
		textArr[#textArr + 1] = char
	end
	return textArr
end

function Scanner.scanText(text)
	local tokens <const> = {}
	local textArr <const> = Scanner.convertTextToArr(text)
	local i = 1
	while i <= #textArr do
		local char <const> = textArr[i]
		if listTokens[char] then
			i =  listTokens[char](tokens,i,char,textArr)
		else
			i = i + 1
		end
	end
	return tokens
end

return Scanner
