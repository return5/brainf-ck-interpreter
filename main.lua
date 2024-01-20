local Scanner <const> = require('scanner.Scanner')
local Interpreter <const> = require('interpreter.Interpreter')

local function main()
	local tokens <const> = Scanner.scanText(arg[1])
	Interpreter.interpretBF(tokens)
end

main()

