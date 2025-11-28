--https://www.hammerspoon.org/go/

hs.notify.new({title="ZWVi", informativeText="Config Reloaded"}):send()
debuglog = hs.logger.new("ZWVi", "debug")


currentMode = "normal"

-- Utility function to get the length of a table
function lenTable(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Mode change function
function changeMode(newMode, execute)
    currentMode = newMode
    hs.notify.new({title="ZWVi", informativeText="Current Mode: " .. currentMode}):send()
    if execute then
        execute()
    end
end

-- Key event handler
function keyHandler(event)
    local keycode = event:getKeyCode()
    local modifiers = event:getFlags()

    --hs.alert.show("Key pressed: " .. keycode)

    -- normal mode keybindings
    if currentMode == "normal" then
        -- Handle 'i' key for insert mode
        if keycode == hs.keycodes.map["i"] then
            -- i
            if lenTable(modifiers) == 0 then
                changeMode("insert")
                return true
            -- Shift + i
            elseif lenTable(modifiers) == 1 and modifiers["shift"] then
                changeMode("insert")
                hs.alert.show("Shift I WIP")
                return true
            end
        -- Handle 'a' key for insert mode
        elseif keycode == hs.keycodes.map["a"] then
            -- a
            if lenTable(modifiers) == 0 then
                changeMode("insert", function()
                    hs.eventtap.keyStroke({}, "right")
                end)
                return true
            -- Shift + a
            elseif lenTable(modifiers) == 1 and modifiers["shift"] then
                changeMode("insert", function()
                    hs.eventtap.keyStroke({}, "end")
                end)
                return true
            end
        end
    end

    if currentMode == "insert" then
        if keycode == hs.keycodes.map["escape"] then
            changeMode("normal")
            return true
        else
            return false
        end
    end
end

keyListener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, keyHandler)
keyListener:start()


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.notify.new({title="ZWVi", informativeText="Hello World"}):send()
end)


-- Resize focused window to left half of the screen
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)
--- End of window resizing hotkeys

