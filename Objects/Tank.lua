local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.Tank = {}

function BattleGroundEnemies.Objects.Tank.New(playerButton)
				-- trinket
	local Tank = CreateFrame("Frame", nil, playerButton)

	
	Tank.Icon = Tank:CreateTexture()
	Tank.Icon:SetAllPoints()
	Tank:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)
	
	Tank.Cooldown = BattleGroundEnemies.MyCreateCooldown(Tank)
	
	Tank.ApplySettings = function(self)
		local conf = playerButton.bgSizeConfig
		-- trinket
		self:Enable()
		self:SetPosition()
		self.Cooldown:ApplyCooldownSettings(conf.Tank_ShowNumbers, false, true, {0, 0, 0, 0.75})
		self.Cooldown.Text:ApplyFontStringSettings(conf.Tank_Cooldown_Fontsize, conf.Tank_Cooldown_Outline, conf.Tank_Cooldown_EnableTextshadow, conf.Tank_Cooldown_TextShadowcolor)
	end
	
	Tank.Enable = function(self)
		if playerButton.bgSizeConfig.Tank_Enabled then
			self:Show()
			self:SetWidth(playerButton.bgSizeConfig.Tank_Width)
		else
			--dont SetWidth before Hide() otherwise it won't work as aimed
			self:Hide()
			self:SetWidth(0.01)
		end
	end
	
	Tank.TankUsed = function(self, spellID)
		local config = playerButton.bgSizeConfig
		
		if not config.Tank_Enabled then return end
		local insi = playerButton.Trinket
		
		if config.TankFiltering_Enabled and not config.TankFiltering_Filterlist[spellID] then return end
		
		self.Icon:SetTexture(Data.TriggerSpellIDToDisplayFileId[spellID])
		self.Cooldown:SetCooldown(GetTime(), Data.TankSpellIDtoCooldown[spellID])
	end
	
	Tank.Reset = function(self)
		self.Icon:SetTexture(nil)
		self.Cooldown:Clear()	--reset Tank Cooldown
	end

	Tank.SetPosition = function(self)
		BattleGroundEnemies.SetBasicPosition(self, playerButton.bgSizeConfig.Tank_BasicPoint, playerButton.bgSizeConfig.Tank_RelativeTo, playerButton.bgSizeConfig.Tank_RelativePoint, playerButton.bgSizeConfig.Tank_OffsetX)
	end
	return Tank
end
