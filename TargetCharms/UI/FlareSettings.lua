-- Flare charms settings registration

local function CreateEnableGate(setting)
	return Settings.CreateControlInitializer("SettingsCheckboxControlTemplate", setting)
end

function TargetCharms_RegisterFlareSettings(category, layout, RIGHT, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern)
	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_FLARE_TITLE))

	local flEnabledSetting = Settings.RegisterProxySetting(category, "FL_ENABLED", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_ENABLE, true,
		function() return TargetCharms_Options["FlareCharms"]["enabled"] end,
		function(v) TargetCharms_Options["FlareCharms"]["enabled"] = v; CheckFlareFrameViewState() end)
	local flEnabled = Settings.CreateCheckbox(category, flEnabledSetting)
	local flParent = CreateEnableGate(flEnabledSetting)

	do
		local s = Settings.RegisterProxySetting(category, "FL_DRAG", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_DRAG, false,
			function() return TargetCharms_Options["FlareCharms"]["draggable"] end,
			function(v) TargetCharms_Options["FlareCharms"]["draggable"] = v; SetupButtons("FlareCharms", "FlareCharms") end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_PARTY", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_PARTYONLY, false,
			function() return TargetCharms_Options["FlareCharms"]["partyOnly"] end,
			function(v) TargetCharms_Options["FlareCharms"]["partyOnly"] = v; CheckFlareFrameViewState() end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_ICONS", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_SHOWICONS, true,
			function() return TargetCharms_Options["FlareCharms"]["showicons"] end,
			function(v) TargetCharms_Options["FlareCharms"]["showicons"] = v; SetupButtons("FlareCharms", "FlareCharms") end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_SCALE", Settings.VarType.Number, TARGETCHARMS_OPTIONS_SCALE, 1.0,
			function() return TargetCharms_Options["FlareCharms"]["barscale"] end,
			function(v) v = SnapSliderValue(v, 0.5, 3.0, 0.1); TargetCharms_Options["FlareCharms"]["barscale"] = v; SetFrameScale(v, 5) end)
		local o = Settings.CreateSliderOptions(0.5, 3.0, 0.1)
		o.steps = 25
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_OPACITY", Settings.VarType.Number, TARGETCHARMS_OPTIONS_OPACITY, 0.5,
			function() return TargetCharms_Options["FlareCharms"]["alphaVal"] end,
			function(v) v = SnapSliderValue(v, 0.1, 1.0, 0.1); TargetCharms_Options["FlareCharms"]["alphaVal"] = v; TopFlare:SetAlpha(v) end)
		local o = Settings.CreateSliderOptions(0.1, 1.0, 0.1)
		o.steps = 9
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_XSPACING", Settings.VarType.Number, TARGETCHARMS_OPTIONS_XSPACING, 0,
			function() return TargetCharms_Options["FlareCharms"]["Xspacing"] end,
			function(v) v = SnapSliderValue(v, -20, 20, 1); TargetCharms_Options["FlareCharms"]["Xspacing"] = v; SetupButtons("FlareCharms", "FlareCharms") end)
		local o = Settings.CreateSliderOptions(-20, 20, 1)
		o.steps = 40
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_YSPACING", Settings.VarType.Number, TARGETCHARMS_OPTIONS_YSPACING, 0,
			function() return TargetCharms_Options["FlareCharms"]["Yspacing"] end,
			function(v) v = SnapSliderValue(v, -20, 20, 1); TargetCharms_Options["FlareCharms"]["Yspacing"] = v; SetupButtons("FlareCharms", "FlareCharms") end)
		local o = Settings.CreateSliderOptions(-20, 20, 1)
		o.steps = 40
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_PRESET", Settings.VarType.String, TARGETCHARMS_OPTIONS_PRESETS_TITLE, Defaults["FlareCharms"]["buttonTemplate"],
			function() return customLayoutMode["FlareCharms"] and CUSTOM_LAYOUT or FindPresetPattern(TC_DEFAULT_LAYOUTS_FLARE, TargetCharms_Options["FlareCharms"]["buttonTemplate"]) or CUSTOM_LAYOUT end,
			function(v)
				if v == CUSTOM_LAYOUT then
					customLayoutMode["FlareCharms"] = true
				else
					customLayoutMode["FlareCharms"] = false
					TargetCharms_Options["FlareCharms"]["buttonTemplate"] = v
					SetupButtons("FlareCharms", "FlareCharms")
				end
			end)
		local function GetPresetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, v in ipairs(TC_DEFAULT_LAYOUTS_FLARE) do
				container:Add(v[2], v[1])
			end
			container:Add(CUSTOM_LAYOUT, TARGETCHARMS_OPTIONS_CUSTOM_LAYOUT)
			return container:GetData()
		end
		local init = Settings.CreateDropdown(category, s, GetPresetOptions)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_TEMPLATE", Settings.VarType.String, TARGETCHARMS_OPTIONS_LAYOUT_TEXT, Defaults["FlareCharms"]["buttonTemplate"],
			function() return TargetCharms_Options["FlareCharms"]["buttonTemplate"] end,
			function(v)
				TargetCharms_Options["FlareCharms"]["buttonTemplate"] = v
				SetupButtons("FlareCharms", "FlareCharms")
			end)
		local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
		init:AddShownPredicate(function() return customLayoutMode["FlareCharms"] or not FindPresetPattern(TC_DEFAULT_LAYOUTS_FLARE, TargetCharms_Options["FlareCharms"]["buttonTemplate"]) end)
		layout:AddInitializer(init)
	end
end
