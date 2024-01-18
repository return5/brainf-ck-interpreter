local Scanner <const> = require('scanner.Scanner')

local function main()
	local text = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
	local tokens <const> = Scanner.scanText(text)
	for i = 1, #tokens,1 do
		tokens[i]:print()
	end
end

main()

