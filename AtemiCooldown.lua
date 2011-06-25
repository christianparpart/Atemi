--[[

@class         AtemiCooldown
@description   holds up a spell with a cooldown duration properties and the UI elements to show this cooldown

public function API:
	void bindToNameplate(nameplate);
	void hide();

public properties:
	int spellID;
	string spellName;
	double endTime;


example use:
	local cd = AtemiCooldown(spellID, spellCooldown + timeNow, self.db.profile)
	-- once you know the player's nameplate, bind the cooldown to show it atop
	cd.bindToNameplate(someNameplate)
]]

AtemiCooldown = {}
AtemiCooldown.__index = AtemiCooldown

-- {{{ some generic utility/helper functions
local function round(value)
	return ceil(value - 0.5)
end
-- }}}

function AtemiCooldown:new(spellID, endTime, db)
	local self = {}
	setmetatable(self, AtemiCooldown)

	local name, rank, texture = GetSpellInfo(spellID)

	self.db = db
	self.spellID = spellID
	self.spellName = name
	self.texture = texture
	self.endTime = endTime

	Atemi:Debug("New Spell cooldown (" .. tostring(spellID) .. ") " .. name .. "")

	return self
end

function AtemiCooldown:bindToNameplate(nameplate)
	Atemi:Debug("Bind Spell cooldown (" .. tostring(self.spellID) .. ") " .. self.spellName .. "")
	if self.nameplate then
		self.nameplate:SetScript("OnHide", nil)
	end

	self.nameplate = nameplate
	self.nameplate:SetScript("OnHide", function() self:hide() end)

	if not self.icon then
		self.icon = CreateFrame("Frame", nil, UIParent)
		self.icon:SetParent(self.nameplate)

		self.icon.texture = self.icon:CreateTexture(nil, "BORDER")
		self.icon.texture:SetAllPoints(self.icon)
		self.icon.texture:SetTexture(self.texture)

		self.iconText = self.icon:CreateFontString(nil, "OVERLAY")
		local color = self.db.textColor
		self.iconText:SetTextColor(color.red, color.green, color.blue)
		self.iconText:SetAllPoints(self.icon)
		self.iconText:SetFont(self.db.fontPath, self.db.fontSize, "OUTLINE")
		self.iconText:SetText("?")

		self.icon:Show()

		self.icon:SetScript("OnUpdate", function()
			self:onIconUpdate()
		end)
	end
end

function AtemiCooldown:setSize(value)
	self.icon:ClearAllPoints()
	self.icon:SetWidth(value)
	self.icon:SetHeight(value)
end

function AtemiCooldown:onIconUpdate()
	local itimer = round(self.endTime - GetTime())

	if itimer >= 60 then
		self.iconText:SetText(round(itimer / 60) .. "m")
	elseif itimer < 60 and itimer >= 1 then
		self.iconText:SetText(ceil(itimer))
	else
		self:hide()
	end
end

function AtemiCooldown:hide()
	Atemi:Debug("Hide Spell cooldown (" .. tostring(self.spellID) .. ") " .. self.spellName .. "")
	if self.icon then
		self.icon:Hide()
		self.icon:SetScript("OnUpdate", nil)
		self.icon:SetParent(nil)

		self.icon = nil
		self.iconText = nil
	end
end

function AtemiCooldown:isExpiredBy(time)
	return round(self.endTime - time) <= 0
end
