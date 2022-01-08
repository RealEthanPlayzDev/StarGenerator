--[[
File name: StarGenerator
Author: RadiatedExodus (ItzEthanPlayz_YT/RealEthanPlayzDev)
Created at: January 8 2022

Module for generating stars at a random specific location
--]]

type posv3 = {
    pos1: Vector3,
    pos2: Vector3?
}
type posnumber = {
    pos1: number,
    pos2: number?,
    minheight: number?,
    maxheight: number?
}

local StarGenerator = {}
local defcolors = {
    Color3.new(255, 0, 0); --// Red
    Color3.new(255, 255, 255); --// White
    Color3.new(0, 255, 255); --// Cyan
    Color3.new(0, 0, 255); --// Blue
}
local function GenPos(posdef: posv3 | posnumber, rand: Random): Vector3?
    if typeof(posdef["pos1"]) == "Vector3" then
        if typeof(posdef["pos2"]) == "Vector3" then
            return Vector3.new(rand:NextInteger(posdef["pos1"].X, posdef["pos2"].X), rand:NextInteger(posdef["pos1"].Y, posdef["pos2"].Y), rand:NextInteger(posdef["pos1"].Z, posdef["pos2"].Z))
        else
            return Vector3.new(rand:NextInteger(-posdef["pos1"].X, posdef["pos1"].X), posdef["pos1"].Y, rand:NextInteger(-posdef["pos1"].Z, posdef["pos1"].Z))
        end
    elseif tonumber(posdef["pos1"]) then
        if tonumber(posdef["pos2"]) then
            return Vector3.new(rand:NextInteger(posdef["pos1"], posdef["pos2"]), if tonumber(posdef["minheight"]) and tonumber(posdef["maxheight"]) then rand:NextInteger(posdef["minheight"], posdef["maxheight"]) else 500, rand:NextInteger(posdef["pos1"], posdef["pos2"]))
        else
            return Vector3.new(rand:NextInteger(-posdef["pos1"], posdef["pos1"]), if tonumber(posdef["minheight"]) and tonumber(posdef["maxheight"]) then rand:NextInteger(posdef["minheight"], posdef["maxheight"]) else 500, rand:NextInteger(-posdef["pos1"], posdef["pos1"]))
        end
    end
    error("posdef error, check the passed argument", 2)
end

function StarGenerator.Generate(count: number, posdef: posv3 | posnumber, acolors: {Color3}, folder: Instance, size: Vector3?)
    local rand = Random.new()
    local f do
        if folder then f = folder else f = Instance.new("Folder") f.Name = "StarGenerator_GeneratedStars" end
    end
    local colors: {Color3} do
        if acolors then colors = acolors else colors = defcolors end
    end

    print("[StarGenerator]: Generating stars.")
    local t = os.clock()
    for i = 1, count do
        local p = Instance.new("Part")
        p.Size = if typeof(size) == "Vector3" then size else Vector3.new(2, 2, 2)
        p.Position = (GenPos(posdef, rand) :: Vector3)
        p.Material = Enum.Material.Neon
        p.BrickColor = BrickColor.new(colors[rand:NextInteger(1, #colors)])
        p.Anchored = true
        p.Parent = f
    end
    
    warn("[StarGenerator]: Now parenting folder, expect lag.")
    if not folder then f.Parent = workspace end

    print("[StarGenerator]: Finished generating "..count.." stars, took "..os.clock() - t.." seconds.")
end

return StarGenerator