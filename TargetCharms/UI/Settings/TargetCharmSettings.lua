-- Target charms bar settings registration

local function CreateEnableGate(setting)
	return Settings.CreateControlInitializer("SettingsCheckboxControlTemplate", setting)
end

function TargetCharms_RegisterTargetSettings(category, layout, RIGHT, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern)
	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_TITLE))

	local tcEnabledSetting = Settings.RegisterProxySetting(category, "TC_ENABLED", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_ENABLE, true,
		function() return TargetCharms_Options["TargetCharms"]["enabled"] end,
		function(v) TargetCharms_Options["TargetCharms"]["enabled"] = v; CheckFrameViewState() end)
	local tcEnabled = Settings.CreateCheckbox(category, tcEnabledSetting)
	local tcParent = CreateEnableGate(tcEnabledSetting)

	do
		local s = Settings.RegisterProxySetting(category, "TC_DRAG", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_DRAG, false,
			function() return TargetCharms_Options["TargetCharms"]["draggable"] end,
			function(v) TargetCharms_Options["TargetCharms"]["draggable"] = v end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_PARTY", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_PARTYONLY, false,
			function() return TargetCharms_Options["TargetCharms"]["partyOnly"] end,
			function(v) TargetCharms_Options["TargetCharms"]["partyOnly"] = v; CheckFrameViewState() end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_SHOWTARGET", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_SHOWONTARGET, true,
			function() return TargetCharms_Options["TargetCharms"]["showontarget"] end,
			function(v) TargetCharms_Options["TargetCharms"]["showontarget"] = v; SetTargetHideShow() end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_TOGGLE", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_TOGGLEICON, false,
			function() return TargetCharms_Options["TargetCharms"]["toggleicon"] end,
			function(v) TargetCharms_Options["TargetCharms"]["toggleicon"] = v end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_SCALE", Settings.VarType.Number, TARGETCHARMS_OPTIONS_SCALE, 1.0,
			function() return TargetCharms_Options["TargetCharms"]["barscale"] end,
			function(v) v = SnapSliderValue(v, 0.5, 3.0, 0.1); TargetCharms_Options["TargetCharms"]["barscale"] = v; SetFrameScale(v, 1) end)
		local o = Settings.CreateSliderOptions(0.5, 3.0, 0.1)
		o.steps = 25
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_OPACITY", Settings.VarType.Number, TARGETCHARMS_OPTIONS_OPACITY, 0.5,
			function() return TargetCharms_Options["TargetCharms"]["alphaVal"] end,
			function(v) v = SnapSliderValue(v, 0.1, 1.0, 0.1); TargetCharms_Options["TargetCharms"]["alphaVal"] = v; TopCharm:SetAlpha(v) end)
		local o = Settings.CreateSliderOptions(0.1, 1.0, 0.1)
		o.steps = 9
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_XSPACING", Settings.VarType.Number, TARGETCHARMS_OPTIONS_XSPACING, 0,
			function() return TargetCharms_Options["TargetCharms"]["Xspacing"] end,
			function(v) v = SnapSliderValue(v, -20, 20, 1); TargetCharms_Options["TargetCharms"]["Xspacing"] = v; SetupButtons("TargetCharms", "TargetCharms") end)
		local o = Settings.CreateSliderOptions(-20, 20, 1)
		o.steps = 40
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_YSPACING", Settings.VarType.Number, TARGETCHARMS_OPTIONS_YSPACING, 0,
			function() return TargetCharms_Options["TargetCharms"]["Yspacing"] end,
			function(v) v = SnapSliderValue(v, -20, 20, 1); TargetCharms_Options["TargetCharms"]["Yspacing"] = v; SetupButtons("TargetCharms", "TargetCharms") end)
		local o = Settings.CreateSliderOptions(-20, 20, 1)
		o.steps = 40
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_PRESET", Settings.VarType.String, TARGETCHARMS_OPTIONS_PRESETS_TITLE, Defaults["TargetCharms"]["buttonTemplate"],
			function() return customLayoutMode["TargetCharms"] and CUSTOM_LAYOUT or FindPresetPattern(TC_DEFAULT_LAYOUTS_CHARMS, TargetCharms_Options["TargetCharms"]["buttonTemplate"]) or CUSTOM_LAYOUT end,
			function(v)
				if v == CUSTOM_LAYOUT then
					customLayoutMode["TargetCharms"] = true
				else
					customLayoutMode["TargetCharms"] = false
					TargetCharms_Options["TargetCharms"]["buttonTemplate"] = v
					SetupButtons("TargetCharms", "TargetCharms")
				end
			end)
		local function GetPresetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, v in ipairs(TC_DEFAULT_LAYOUTS_CHARMS) do
				container:Add(v[2], v[1])
			end
			container:Add(CUSTOM_LAYOUT, TARGETCHARMS_OPTIONS_CUSTOM_LAYOUT)
			return container:GetData()
		end
		local init = Settings.CreateDropdown(category, s, GetPresetOptions)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_TEMPLATE", Settings.VarType.String, TARGETCHARMS_OPTIONS_LAYOUT_TEXT, Defaults["TargetCharms"]["buttonTemplate"],
			function() return TargetCharms_Options["TargetCharms"]["buttonTemplate"] end,
			function(v)
				TargetCharms_Options["TargetCharms"]["buttonTemplate"] = v
				SetupButtons("TargetCharms", "TargetCharms")
			end)
		local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
		init:AddShownPredicate(function() return customLayoutMode["TargetCharms"] or not FindPresetPattern(TC_DEFAULT_LAYOUTS_CHARMS, TargetCharms_Options["TargetCharms"]["buttonTemplate"]) end)
		layout:AddInitializer(init)
	end
end
