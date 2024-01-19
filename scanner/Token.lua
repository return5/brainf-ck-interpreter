local setmetatable <const> = setmetatable
local write <const> = io.write

local Token <const> = {}
Token.__index = Token

_ENV = Token

function Token:print()
	local jump <const> = self.jumpPos or "none"
	write(self.type, " : ",self.count, " : ",jump, "\n")
	return self
end

function Token:new(type,count,jumpPos)
	return setmetatable({type = type, count = count, jumpPos = jumpPos},self)
end

return Token
