local Bullet = Object:extend()
local assets =  require "src.assets"
local vector = require "lib.hump.vector"
local lume = require "lib.lume"
-- local playstate = require "playstate"

function Bullet:new(x, y, angle, speed)
	-- entity
	self.name = "Bullet"
	self.isBullet = true
	self.isAlive = true

	self.pos = { x = x or 0, y = y or 0 }
	self.scale = {}
	self.angle = angle or 0
	self.offset = { x = 0, y = 0 }

	-- Bullet
	self.sprite = assets.bullet
	self.offset = { x = self.sprite:getWidth() / 2, y = self.sprite:getHeight() / 2 }

	-- MoveTowardsAngle component
	self.moveTowardsAngle = true

	-- movable component
	self.speed = speed or 400
	self.movable = {
		velocity = { x = 0, y = 0 },
		acceleration = { x = 0, y = 0 },
		drag = { x = 0, y = 0 },
		maxVelocity = { x = 0, y = 0 },
	}

	-- rotatable component
	self.rotatable = {
		speed = 10,
		velocity = 0,
		acceleration = 0,
		drag = 30,
		maxVelocity = 12
	}

	-- randomize a bit
	-- self.pos.x = self.pos.x + lume.random(5,10)
	-- self.pos.y = self.pos.y + lume.random(5,10)
	self.angle = self.angle + lume.random(-0.05,0.05)

	-- add small padding in front of player
	self.pos.x = self.pos.x + (self.pos.x * math.cos(self.angle - math.rad(90)) * 0.12)
	self.pos.y = self.pos.y + (self.pos.y * math.sin(self.angle - math.rad(90)) * 0.12)

	-- collider
	self.collider = HC:rectangle(self.pos.x - self.offset.x, self.pos.y - self.offset.y, self.sprite:getWidth(), self.sprite:getHeight())
	self.collider['parent'] = self

	-- destroy if out of screen
	self.destroyOffScreen = true

	return self
end

function Bullet:update(dt)
end

function Bullet:onCollision(other, delta)
	if other.isEnemy and other.isAlive then
		self.toRemove = true
		other:onCollision(self, delta)
		-- self.isAlive = false
	end
end

return Bullet