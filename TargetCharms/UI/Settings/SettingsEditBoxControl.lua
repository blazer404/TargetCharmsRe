--- Настройка-поле ввода текста. Расширяет SettingsControlMixin - добавляет EditBox, в котором можно свободно вводить текст


--- @class TargetCharmsEditBoxControlMixin : SettingsControlMixin
--- @field SettingEditBox EditBox|nil Поле ввода
--- @field suspendWriteback boolean Признак подавления записи в настройку (при программной установке текста)
TargetCharmsEditBoxControlMixin = CreateFromMixins(SettingsControlMixin);

--- Создаёт `поле ввода` в строке настройки.
--- Вызывается фреймворком при создании контрола
function TargetCharmsEditBoxControlMixin:OnLoad()
    SettingsControlMixin.OnLoad(self);

    self.SettingEditBox = CreateFrame("EditBox", nil, self, "InputBoxTemplate");
    self.SettingEditBox:SetHeight(24);
    self.SettingEditBox:SetWidth(230);
    self.SettingEditBox:SetPoint("LEFT", self, "CENTER", -80, 0);
    self.SettingEditBox:SetAutoFocus(false);
    self.SettingEditBox:SetMaxLetters(512);
end

--- Инициализация контрола - `подставляет` текущее `значение` настройки в поле ввода
--- @param initializer table Обёртка настройки (инициализатор списка настроек)
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

--- Обработка `ввода игрока` - записывает текст в настройку, если он изменился
--- @param userInput boolean Признак ввода пользователем (а не программного изменения)
function TargetCharmsEditBoxControlMixin:OnEditBoxTextChanged(userInput)
    if self.suspendWriteback then
        return ;
    end

    local text = self.SettingEditBox:GetText();
    local setting = self:GetSetting();
    if text ~= setting:GetValue() then
        setting:SetValue(text);
    end
end

--- Синхронизирует поле ввода `при изменении` значения настройки `извне`
--- @param setting table Настройка, изменившая значение
--- @param value string|nil Новое значение настройки
function TargetCharmsEditBoxControlMixin:OnSettingValueChanged(setting, value)
    SettingsControlMixin.OnSettingValueChanged(self, setting, value);

    local text = self.SettingEditBox:GetText();
    if value ~= text then
        self.suspendWriteback = true;
        self.SettingEditBox:SetText(value or "");
        self.suspendWriteback = false;
    end
end

--- Включает/отключает поле ввода вместе с доступностью настройки
function TargetCharmsEditBoxControlMixin:EvaluateState()
    SettingsListElementMixin.EvaluateState(self);

    local enabled = self:IsEnabled();
    self.SettingEditBox:SetEnabled(enabled);
    self:DisplayEnabled(enabled);
end

--- Очистка при переиспользовании контрола списком настроек
function TargetCharmsEditBoxControlMixin:Release()
    self.SettingEditBox:SetScript("OnTextChanged", nil);
    SettingsControlMixin.Release(self);
end
