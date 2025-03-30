--!strict
local vec3 = {}

type vec3_raw = {
	x: number,
	y: number,
	z: number
}

local mt = {}

mt.__index = vec3

mt.__add = function(a: vec3, b: vec3): vec3
	return vec3.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

mt.__sub = function(a: vec3, b: vec3): vec3
	return vec3.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

mt.__mul = function(a: vec3, b: number): vec3
	return vec3.new(a.x * b, a.y * b, a.z * b)
end

mt.__div = function(a: vec3, b: number): vec3
	return vec3.new(a.x / b, a.y / b, a.z / b)
end

mt.__tostring = function(a: vec3): string
	return "(" .. a.x .. ", " .. a.y .. ", " .. a.z .. ")"
end

function vec3.new(x: number, y: number, z: number) : vec3
	local b: vec3_raw = { x = x, y = y, z = z}
	return setmetatable(b, mt) :: vec3
end

export type vec3 = typeof(setmetatable({} :: vec3_raw, mt))

return vec3