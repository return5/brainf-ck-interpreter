local setmetatable <const> = setmetatable
local write <const> = io.write

local Token <const> = {}
Token.__index = Token

_ENV = Token

function Token:print()
	write(self.type, " : ",self.count, " : ",self.jmpPos or "none", "\n")
	return self
end

function Token:new(type,count,jumpPos)
	return setmetatable({type = type, count = count, jumpPos = jumpPos},self)
end

return Token
