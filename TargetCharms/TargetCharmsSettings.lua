local addonName = ...

TargetCharmsEditBoxControlMixin = CreateFromMixins(SettingsControlMixin);

function TargetCharmsEditBoxControlMixin:OnLoad()
	SettingsControlMixin.OnLoad(self);

	self.SettingEditBox = CreateFrame("EditBox", nil, self, "InputBoxTemplate");
	self.SettingEditBox:SetHeight(24);
	self.SettingEditBox:SetWidth(230);
	self.SettingEditBox:SetPoint("LEFT", self, "CENTER", -80, 0);
	self.SettingEditBox:SetAutoFocus(false);
	self.SettingEditBox:SetMaxLetters(512);
end

function TargetCharmsEditBoxControlMixin:Init(initializer)
	SettingsControlMixin.Init(self, initializer);

	self.suspendWriteback = true;
	self.SettingEditBox:SetText(self:GetSetting():GetValue() or "");
	self.suspendWriteback = false;

	self.SettingEditBox:SetScript("OnTextChanged", function(editBox, userInput)
		self:OnEditBoxTextChanged(userInput);
	end);

	self:EvaluateState();
end

function TargetCharmsEditBoxControlMixin:OnEditBoxTextChanged(userInput)
	if self.suspendWriteback then
		return;
	end

	local text = self.SettingEditBox:GetText();
	local setting = self:GetSetting();
	if text ~= setting:GetValue() then
		setting:SetValue(text);
	end
end

function TargetCharmsEditBoxControlMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value);

	local text = self.SettingEditBox:GetText();
	if value ~= text then
		self.suspendWriteback = true;
		self.SettingEditBox:SetText(value or "");
		self.suspendWriteback = false;
	end
end

function TargetCharmsEditBoxControlMixin:EvaluateState()
	SettingsListElementMixin.EvaluateState(self);

	local enabled = self:IsEnabled();
	self.SettingEditBox:SetEnabled(enabled);
	self:DisplayEnabled(enabled);
end

function TargetCharmsEditBoxControlMixin:Release()
	self.SettingEditBox:SetScript("OnTextChanged", nil);
	SettingsControlMixin.Release(self);
end

local function StepDecimals(step)
	local d = 0
	local s = step
	while s - math.floor(s) > 1e-6 do
		d = d + 1
		s = s * 10
	end
	return d
end

local function SnapSliderValue(v, minValue, maxValue, step)
	v = math.max(minValue, math.min(maxValue, v))
	local steps = math.floor((v - minValue) / step + 0.5)
	local value = minValue + steps * step
	return tonumber(string.format("%." .. StepDecimals(step) .. "f", value))
end

local function CreateSliderLabelFormatter(step)
	local decimals = StepDecimals(step)
	local fmt = "%." .. decimals .. "f"
	return function(value)
		return string.format(fmt, value)
	end
end

local function CreateEnableGate(setting)
	return Settings.CreateControlInitializer("SettingsCheckboxControlTemplate", setting)
end

local CUSTOM_LAYOUT = "CUSTOM"

local customLayoutMode = {}

local settingsRefreshVariables = {
	"TC_ENABLED", "TC_DRAG", "TC_PARTY", "TC_SHOWTARGET", "TC_TOGGLE", "TC_SCALE", "TC_OPACITY", "TC_XSPACING", "TC_YSPACING", "TC_TEMPLATE", "TC_PRESET",
	"RC_ENABLED", "RC_DRAG", "RC_PARTY", "RC_SCALE", "RC_OPACITY", "RC_TEXT",
	"FL_ENABLED", "FL_DRAG", "FL_PARTY", "FL_ICONS", "FL_SCALE", "FL_OPACITY", "FL_XSPACING", "FL_YSPACING", "FL_TEMPLATE", "FL_PRESET",
	"PROFILE_MAIN",
};

function TargetCharms_SettingsRefresh()
	if type(Settings.GetSetting) ~= "function" or not TargetCharms_SettingsCategoryID then
		return;
	end
	for index = 1, #settingsRefreshVariables do
		Settings.NotifyUpdate(settingsRefreshVariables[index]);
	end
end

function TargetCharms_InitSettings()
	local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)
	local RIGHT = MinimalSliderWithSteppersMixin.Label.Right

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
		local s = Settings.RegisterProxySetting(category, "TC_SHOWTARGET", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_SHOWONTARGET, false,
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
			function(v) v = SnapSliderValue(v, 0.2, 2.0, 0.1); TargetCharms_Options["TargetCharms"]["barscale"] = v; SetFrameScale(v, 1) end)
		local o = Settings.CreateSliderOptions(0.2, 2.0, 0.1)
		o.steps = 18
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(tcParent, function() return tcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "TC_OPACITY", Settings.VarType.Number, TARGETCHARMS_OPTIONS_OPACITY, 1.0,
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
			function() return customLayoutMode["TargetCharms"] and CUSTOM_LAYOUT or TargetCharms_Options["TargetCharms"]["buttonTemplate"] end,
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
			for _, v in ipairs(TargetCharms_LayoutDefaults) do
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
		init:AddShownPredicate(function() return customLayoutMode["TargetCharms"] end)
		layout:AddInitializer(init)
	end

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
			function(v) v = SnapSliderValue(v, 0.2, 2.0, 0.1); TargetCharms_Options["FlareCharms"]["barscale"] = v; SetFrameScale(v, 5) end)
		local o = Settings.CreateSliderOptions(0.2, 2.0, 0.1)
		o.steps = 18
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(flParent, function() return flEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "FL_OPACITY", Settings.VarType.Number, TARGETCHARMS_OPTIONS_OPACITY, 1.0,
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
			function() return customLayoutMode["FlareCharms"] and CUSTOM_LAYOUT or TargetCharms_Options["FlareCharms"]["buttonTemplate"] end,
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
			for _, v in ipairs(Flare_LayoutDefaults) do
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
		init:AddShownPredicate(function() return customLayoutMode["FlareCharms"] end)
		layout:AddInitializer(init)
	end

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_READYCHECK_TITLE))

	local rcEnabledSetting = Settings.RegisterProxySetting(category, "RC_ENABLED", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_ENABLE, true,
		function() return TargetCharms_Options["ReadyCharm"]["enabled"] end,
		function(v) TargetCharms_Options["ReadyCharm"]["enabled"] = v; CheckReadyButtonViewState() end)
	local rcEnabled = Settings.CreateCheckbox(category, rcEnabledSetting)
	local rcParent = CreateEnableGate(rcEnabledSetting)

	do
		local s = Settings.RegisterProxySetting(category, "RC_DRAG", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_DRAG, false,
			function() return TargetCharms_Options["ReadyCharm"]["draggable"] end,
			function(v) TargetCharms_Options["ReadyCharm"]["draggable"] = v end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "RC_PARTY", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_PARTYONLY, false,
			function() return TargetCharms_Options["ReadyCharm"]["partyOnly"] end,
			function(v) TargetCharms_Options["ReadyCharm"]["partyOnly"] = v; CheckReadyButtonViewState() end)
		local init = Settings.CreateCheckbox(category, s)
		init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "RC_SCALE", Settings.VarType.Number, TARGETCHARMS_OPTIONS_SCALE, 1.0,
			function() return TargetCharms_Options["ReadyCharm"]["barscale"] end,
			function(v) v = SnapSliderValue(v, 0.2, 2.0, 0.1); TargetCharms_Options["ReadyCharm"]["barscale"] = v; _G["ReadyCharm"]:SetScale(v) end)
		local o = Settings.CreateSliderOptions(0.2, 2.0, 0.1)
		o.steps = 18
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "RC_OPACITY", Settings.VarType.Number, TARGETCHARMS_OPTIONS_OPACITY, 1.0,
			function() return TargetCharms_Options["ReadyCharm"]["alphaVal"] end,
			function(v) v = SnapSliderValue(v, 0.1, 1.0, 0.1); TargetCharms_Options["ReadyCharm"]["alphaVal"] = v; TopReady:SetAlpha(v) end)
		local o = Settings.CreateSliderOptions(0.1, 1.0, 0.1)
		o.steps = 9
		o:SetLabelFormatter(RIGHT)
		o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
		local init = Settings.CreateSlider(category, s, o)
		init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
	end

	do
		local s = Settings.RegisterProxySetting(category, "RC_TEXT", Settings.VarType.String, TARGETCHARMS_OPTIONS_READYCHECK_TEXT, Defaults["ReadyCharm"]["text"],
			function() return TargetCharms_Options["ReadyCharm"]["text"] end,
			function(v)
				TargetCharms_Options["ReadyCharm"]["text"] = v
				local readyButton = _G["ReadyCharm"]
				if readyButton then
					readyButton:SetText(v)
				end
				AutoSizeReadyButton()
			end)
		local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
		init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
		layout:AddInitializer(init)
	end

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_PROFILE))

	Settings.CreateCheckbox(category, Settings.RegisterProxySetting(category, "PROFILE_MAIN", Settings.VarType.Boolean, TARGETCHARMS_OPTIONS_MAIN_PROFILE, false,
		function() return TargetCharms_OptionsGlobal["Name"] == UnitName("player") end,
		function(v)
			if v then
				TargetCharms_OptionsGlobal["Name"] = UnitName("player")
			else
				TargetCharms_OptionsGlobal["Name"] = nil
			end
		end))

	local sourceProfileName = TargetCharms_OptionsGlobal["Name"]
	local copyInitializer = CreateSettingsButtonInitializer(
		sourceProfileName and (TARGETCHARMS_OPTIONS_SOURCE .. " " .. sourceProfileName) or TARGETCHARMS_OPTIONS_SOURCE,
		TARGETCHARMS_OPTIONS_COPY_SETTINGS,
		function() CopySetup() end, nil, true)
	copyInitializer:AddShownPredicate(function()
		local source = TargetCharms_OptionsGlobal["Name"]
		return source ~= nil and source ~= UnitName("player")
	end)
	layout:AddInitializer(copyInitializer)

	Settings.RegisterAddOnCategory(category)
	TargetCharms_SettingsCategoryID = category:GetID()
end
