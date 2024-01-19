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

local function countChar(tokens,i,char,tokenCount,textArr)
	local count = 0
	repeat
		count = count + 1
		i = i + 1
	until i > #textArr or textArr[i] ~= char
	addToTokens(tokens,char,count)
	return i,tokenCount + count
end

local function addChar(tokens,i,char,tokenCount)
	addToTokens(tokens,char,1)
	return i + 1,tokenCount + 1
end

local function continueConditionForward(i,textArr,targetChar,count)
	if i > #textArr then
		stdError:write("didnt find a matching ]\n")
		exit()
	end
	return textArr[i] ~= targetChar or count > 0
end

local function continueConditionBackwards(i,textArr,targetChar,count)
	if i <= 0 then
		stdError:write("didnt find a matching [\n")
		exit()
	end
	return textArr[i] ~= targetChar or count > 0
end

local loopUntil

local function openBracket(tokens,i,char,tokenCount,textArr)
	local jumpPos <const> = loopUntil(tokenCount + 1,']',char,i + 1,textArr,1,continueConditionForward)
	addToTokens(tokens,char,1,jumpPos)
	return i + 1,tokenCount + 1
end

local function closeBracket(tokens,i,char,tokenCount,textArr)
	local jumpPos <const> = loopUntil(tokenCount + 1,'[',char,i - 1,textArr,-1,continueConditionBackwards)
	addToTokens(tokens,char,1,jumpPos)
	return i + 1,tokenCount + 1
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

local function checkCount(i,textArr,count,targetChar,sameChar)
	if textArr[i] == targetChar then return count - 1 end
	if textArr[i] == sameChar then return count + 1 end
	return count
end

loopUntil = function(startPos,targetChar,sameChar,i,textArr,incr,continueCondition)
	local tokenPos = startPos + incr
	local count = 0
	while continueCondition(i,textArr,targetChar,count) do
		count = checkCount(i,textArr,count,targetChar,sameChar)
		if listTokens[textArr[i]] then tokenPos = tokenPos + incr end
		i = i + incr
	end
	return tokenPos
end

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
	local tokenCount = 0
	while i <= #textArr do
		local char <const> = textArr[i]
		if listTokens[char] then
			i,tokenCount =  listTokens[char](tokens,i,char,tokenCount,textArr)
		else
			i = i + 1
		end
	end
	return tokens
end

return Scanner
