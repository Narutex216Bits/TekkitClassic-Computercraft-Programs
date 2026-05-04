print("========================================================")
print("|           Refinery control v0.1 alpha                |")
print("========================================================")
print(" 1.Oil tanks Control Program                           |")
print(" 2.Water tanks Control Program                         |")
print(" 3.Fuel Tanks Control Program                          |")
print(" 4.Generator Control Program                           |")
print(" 5.Refinery Control Program                            |")
print(" 6.Exit Refinery Control                               |")
print("========================================================")
write("> ")
input = read()

if input == "1" then
    shell.run("clear")
    shell.run("oiltanks")
end

if input == "2" then
    shell.run("clear")
    shell.run("watertanks")
end

if input == "3" then
    shell.run("clear")
    shell.run("fueltanks")
end

if input == "4" then
    shell.run("clear")
    shell.run("generator")
end

if input == "5" then
    shell.run("clear")
    shell.run("refinery")
end

if input == "6" then
    s