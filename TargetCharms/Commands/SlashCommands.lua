-- Chat slash commands
-- Use /tc or /targetcharms for more info

function TargetCharms_Command(msg)
    orig_msg = msg
    msg = string.lower(msg)
    a, b, cmd, arg = string.find(msg, "(%S+)%s*(%S*)")
    if cmd == TargetCharms_CMDS[1] then
        TargetCharms_Reset();
    elseif cmd == TargetCharms_CMDS[2] then
        ShowSetup();
    else
        TargetCharms_msg(TARGETCHARMS_CMD_HELP);
    end
    CheckReadyButtonViewState();
    CheckFrameViewState();
    CheckFlareFrameViewState();
end

function TargetCharms_RegisterSlashCommands()
    SLASH_TargetCharms1 = TARGETCHARMS_SLASH1;
    SLASH_TargetCharms2 = TARGETCHARMS_SLASH2;
    SlashCmdList["TargetCharms"] = TargetCharms_Command;
end
