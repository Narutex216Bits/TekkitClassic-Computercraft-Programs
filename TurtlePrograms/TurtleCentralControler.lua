-- centralTurtle.lua (version with rednet cause of tekkit classic version please before using this, change the modem range on config file!)
local side = "left" -- modem on the left side, change it to what you want

if not peripheral.isPresent(side) then
    error(" Modem not found on the side: " .. side)
end

rednet.open(side) -- open the communication channel

print(" Minning Turtles Central Control Initializing...")

while true do
    write("command (ex: tunnel 30, exit): ")
    local comando = read()

    if command == "exit" then
        print("Exiting...")
        break
    end

    rednet.broadcast(command) -- Send to all turtles listening
    print(" Command send: " .. command)
end
