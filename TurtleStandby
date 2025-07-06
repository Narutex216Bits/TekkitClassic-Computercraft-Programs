-- standby.lua (version 0.1 alpha)
local side = "right" -- The modem side on turtle is always the right side
if not peripheral.isPresent(side) then
    error("? Modem not found: " .. side)
end

rednet.open(side)
print("?? Turtle ready. waiting command...")

while true do
    local id, message = rednet.receive()

    if type(message) == "string" then
        print("?? Command received: " .. message)

        -- Divide the string into program name + arguments
        local args = {}
        for word in string.gmatch(message, "%S+") do
            table.insert(args, word)
        end

        if #args > 0 then
            shell.run(unpack(args)) -- split "tunnel" e "30"
        end
    end
end
