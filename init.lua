debuglogger = hs.logger.new('debuglogger','debug')


-- Reload Hammerspoon configuration
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
    hs.alert.show("Hammerspoon Config Reloaded")
    hs.notify.new({title="Hammerspoon", informativeText="RELOAD"}):send()
end)

-- Variables to track focused windows
previousFocusedWindowName = nil
currentFocusedWindowName = nil

-- Function to handle window focus changes
function windowFocusedCallback(window)
    local app = window:application()
    local appName = app:name()
    local windowTitle = window:title() or "Untitled"

    previousFocusedWindowName = currentFocusedWindowName
    currentFocusedWindowName = appName

    if previousFocusedWindow ~= nil then
        hs.alert.show(previousFocusedWindow:name())
    end
    
    if appName == "Finder" then
        output, status, typ, rc = hs.execute [[
        "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" --set-variables '{"current_mode": "normal"}' 2>&1
        ]] --2>&1 to capture stderr
        debuglogger.i(output)
        debuglogger.i(tostring(status))
        debuglogger.i(tostring(typ))
        debuglogger.i(tostring(rc))
        hs.alert.show("VI Mode")
    
    elseif previousFocusedWindowName == 'Finder' then
        output, status, typ, rc = hs.execute [[
        "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" --set-variables '{"current_mode": "insert"}' 2>&1
        ]] --2>&1 to capture stderr
        debuglogger.i(output)
        debuglogger.i(tostring(status))
        debuglogger.i(tostring(typ))
        debuglogger.i(tostring(rc))
        hs.alert.show("NON-VI Mode")
    end

end

allWindowsFilter = hs.window.filter.new()
allWindowsFilter:subscribe(hs.window.filter.windowFocused, windowFocusedCallback)


testing = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()
--[[
    if keyCode == hs.keycodes.map["f"] then
        hs.alert.show("F key pressed")
    end
    --]]
    return false  -- Allow the event to propagate
end)
testing:start()



local function findSearchField(axElement)
    local focusedWin = hs.window.get(618)
    if focusedWin then
        local axApp = hs.axuielement.applicationElement(focusedWin:application())
        if axApp then
            local searchField = axApp:attributeValue("AXFocusedUIElement")
            if searchField and searchField:attributeValue("AXRole") == "AXTextField" then
                return searchField
            end
        end
    end
end






local pid = 618 -- 찾고자 하는 애플리케이션의 프로세스 ID
local targetRole = "AXTextField" -- 찾고자 하는 역할 (예: 텍스트 입력 필드)

-- 1. 애플리케이션의 최상위 접근성 객체를 가져옵니다.
local appElement = hs.axuielement.applicationElementForPID(pid)
appElement = appElement:childrenWithRole("AXWindow")[1]
appElement = appElement:childrenWithRole("AXToolbar")[1]
appElement = appElement:childrenWithRole("AXGroup")[3]
if appElement then
    print("✅ 애플리케이션 객체를 찾았습니다.")
    
    -- 2. :childrenWithRole 메서드를 사용하여 직접적인 자식 중 텍스트 필드를 찾습니다.
    --    (대소문자 W와 R에 주의하세요!)
    local textFields = appElement:childrenWithRole(targetRole)
    
    -- 3. 찾은 요소의 개수를 출력하거나 경고 창으로 보여줍니다.
    local count = #textFields
    
    if count > 0 then
        hs.alert.show("애플리케이션 내 직접적인 " .. targetRole .. " 개수: " .. count)
        
        -- 첫 번째 텍스트 필드를 사용하고 싶다면:
        local firstTextField = textFields[1]
        -- ... 여기에 해당 요소에 대한 조작 코드를 추가합니다.
        hs.alert.show(appElement:childrenWithRole("AXTextField")[1].AXFocused)
        
    else
        hs.alert.show("직접적인 " .. targetRole .. " 요소를 찾지 못했습니다.")
        
    end
else
    hs.alert.show("❌ 오류: PID " .. pid .. "의 애플리케이션 객체에 접근할 수 없습니다.")
end





    


hs.alert.show("HAMMERSPOON ACTIVATED")