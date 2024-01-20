local setmetatable <const> = setmetatable

local Token <const> = {type = "Token"}
Token.__index = Token

_ENV = Token

function Token:new(type,i,jmpPos)
	return setmetatable({type = type,i = i, jmpPos = jmpPos},self)
end

return Token