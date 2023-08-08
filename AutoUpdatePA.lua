script_name("AutoUpdatePA") 
script_author("Corban")
script_description("Command")

local tag = '[AutoUpdatePA]: '
local main_color = 0xDC143C

require "lib.moonloader"
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local SE = require 'samp.events'
local keys = require "vkeys"
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "cp1251"
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

update_state = false

local script_vers = 6
local script_vers_text = "1.06"

local update_path = getWorkingDirectory() .. "/update.ini"
local update_url = "https://raw.githubusercontent.com/CorbanYT/PatrolAssistant/main/update.ini"

local script_path = thisScript().path
local script_url = "https://github.com/CorbanYT/PatrolAssistant/raw/main/AutoUpdatePA.lua"


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
 
    sampAddChatMessage(tag .. u8"{FFFFFF}Скрипт по обновлению - {5A90CE}работает.", main_color)

    sampRegisterChatCommand("update", cmd_update)
    
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status) 
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then 
                sampAddChatMessage(tag .. u8"{FFFFFF}Появилось новое обновление! Версия: {5A90CE}".. updateIni.info.vers_text, main_color)
		update_state = true
            end
            os.remove(update_path)
        end
    end)

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status) 
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tag .. u8"{FFFFFF}Скрипт успешно {5A90CE}обновлен!", main_color)
                    thisScript():reload()
                end
            end)
            break
        end

    end
end

function cmd_update(arg)
    sampShowDialog(1000, u8"Автообновление новое!!!!", u8"Это автообновление детка", u8"Закрыть", "", 0)
end
