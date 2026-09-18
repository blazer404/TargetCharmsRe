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
