module 'aux'

local gui = require 'aux.gui'

function handle.LOAD()
	for _, v in ipairs(tab_info) do
		tabs:create_tab(v.name)
	end
end

function handle.INIT_UI()
    do
        local frame = CreateFrame('Frame', 'aux_frame', UIParent)
        tinsert(UISpecialFrames, 'aux_frame')
        if not gui.is_blizzard() then
            gui.set_window_style(frame)
        end
        gui.set_size(frame, 768, 447)
        if gui.is_blizzard() then
            local frameBorder = CreateFrame('Frame', '$parentBorder', frame)
            frameBorder:SetWidth(frame:GetWidth() + 24)
            frameBorder:SetHeight(frame:GetHeight() + 24)
            frameBorder:SetPoint('CENTER', frame, 'CENTER')
            frameBorder:SetBackdrop({edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 24, 
                tile = true, tileSize = 24, bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], 
                insets = { 
                    left = 6, right = 6, top = 6, bottom = 6 }})
        end
        frame:SetPoint('LEFT', 100, 0)
        frame:SetToplevel(true)
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:SetClampedToScreen(true)
        frame:CreateTitleRegion():SetAllPoints()
        frame:SetScript('OnShow', function() PlaySound('AuctionWindowOpen') end)
        frame:SetScript('OnHide', function() PlaySound('AuctionWindowClose'); CloseAuctionHouse() end)
        frame.content = CreateFrame('Frame', nil, frame)
        frame.content:SetPoint('TOPLEFT', 4, -80)
        frame.content:SetPoint('BOTTOMRIGHT', -4, 35)
        frame:Hide()
        M.frame = frame
    end
    do
        tabs = gui.tabs(frame, 'DOWN')
        tabs._on_select = on_tab_click
        function M.set_tab(id) tabs:select(id) end
    end
    do
        local btn = gui.button(frame)
        btn:SetPoint('BOTTOMRIGHT', -5, 5)
        gui.set_size(btn, 60, 24)
        btn:SetText('Close')
        btn:SetScript('OnClick', function() frame:Hide() end)
        btn:SetFrameLevel(btn:GetFrameLevel() + 2)
        close_button = btn
    end
    do
        local btn = gui.button(frame, gui.font_size.small)
        btn:SetPoint('RIGHT', close_button, 'LEFT' , -5, 0)
        gui.set_size(btn, gui.is_blizzard() and 80 or 60, 24)
        btn:SetText(color.blizzard'Blizzard UI')
        btn:SetFrameLevel(btn:GetFrameLevel() + 2)
        btn:SetScript('OnClick',function()
            if AuctionFrame:IsVisible() then HideUIPanel(AuctionFrame) else ShowUIPanel(AuctionFrame) end
        end)
        local money_frame = CreateFrame('Frame', '$parentMoneyFrame', aux_frame.content, 'SmallMoneyFrameTemplate')
        money_frame:SetPoint('RIGHT', btn, 'LEFT', 5, 0)
        money_frame:SetToplevel()
        if gui.is_blizzard() then
            local texture = aux_frame.content:CreateTexture(nil, 'ARTWORK')
            gui.set_size(texture, 145, 34)
            texture:SetTexture('Interface\\MoneyFrame\\UI-MONEYFRAME-BORDER')
            texture:SetPoint('TOPRIGHT', money_frame, -6, 4)
        end
    end
end