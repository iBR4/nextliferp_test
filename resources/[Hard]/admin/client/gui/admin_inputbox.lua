--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	gui\admin_inputbox.lua
*
*	Original File by lil_Toady
*
*   Traducido al español por Zelev
*
**************************************]]

aInputForm = nil
local varOne, varTwo = nil, nil

function aInputBox ( title, message, default, action, vOne, vTwo, defaultNick, defaultReason )
	if ( aInputForm == nil ) then
		local x, y = guiGetScreenSize()
		aInputForm		= guiCreateWindow ( x / 2 - 150, y / 2 - 64, 300, 170, "", false )
				  	   guiWindowSetSizable ( aInputForm, false )
		aInputLabel		= guiCreateLabel ( 20, 24, 270, 15, "", false, aInputForm )
					   guiLabelSetHorizontalAlign ( aInputLabel, "center" )
		aInputValue		= guiCreateEdit ( 35, 47, 230, 24, "", false, aInputForm )
		aInputOk		= guiCreateButton ( 90, 80, 55, 17, "OK", false, aInputForm )
		aInputCancel		= guiCreateButton ( 150, 80, 55, 17, "Cerrar", false, aInputForm )
		guiSetProperty ( aInputForm, "AlwaysOnTop", "true" )
		aInputAction = nil

		addEventHandler ( "onClientGUIClick", aInputForm, aInputBoxClick )
		addEventHandler ( "onClientGUIAccepted", aInputValue, aInputBoxAccepted )
		--Register With Admin Form
		aRegister ( "InputBox", aInputForm, aInputBox, aInputBoxClose )
	end
	if not action or action ~= "banSerial" and action ~= "banIP" then
		guiSetSize(aInputForm, 300, 170, false)
		guiSetPosition(aInputOk, 90, 80, false)
		guiSetPosition(aInputCancel, 150, 80, false)

		if isElement(banSerialLbl) then destroyElement(banSerialLbl) end
		if isElement(banNickEdit) then destroyElement(banNickEdit) end
		if isElement(banReasonEdit) then destroyElement(banReasonEdit) end
		if isElement(banSerialCombo) then destroyElement(banSerialCombo) end
		if isElement(banDurationLbl) then destroyElement(banDurationLbl) end
		if isElement(durationEdit) then destroyElement(durationEdit) end
	else
		guiSetSize(aInputForm, 300, 210, false)
		guiSetPosition(aInputOk, 90, 180, false)
		guiSetPosition(aInputCancel, 150, 180, false)


		-- time duration:

		if not isElement(banSerialCombo) then
			banSerialCombo = guiCreateComboBox ( 180, 80, 120, 100, "Perm", false, aInputForm )
				guiComboBoxAddItem(banSerialCombo, "Mints")
				guiComboBoxAddItem(banSerialCombo, "Horas")
				guiComboBoxAddItem(banSerialCombo, "Días")
				guiComboBoxAddItem(banSerialCombo, "Perm")
		end

		if not isElement(durationEdit) then
			durationEdit = guiCreateEdit ( 110, 80, 60, 24, "", false, aInputForm )
		end
		guiSetText(durationEdit, "")

		if not isElement(banDurationLbl) then
			banDurationLbl = guiCreateLabel ( 40, 83, 50, 15, "Duración:", false, aInputForm )
			guiLabelSetHorizontalAlign ( banDurationLbl, "center" )
		end

		if not isElement(banSerialLbl) then
			banSerialLbl = guiCreateLabel ( 20, 110, 270, 15, "Ingresar nombre del jugador y razón:", false, aInputForm )
			guiLabelSetHorizontalAlign ( banSerialLbl, "center" )
		end

		if not isElement(banNickEdit) then
			banNickEdit = guiCreateEdit ( 35, 130, 60, 24, "", false, aInputForm )
		end
		guiSetText(banNickEdit, defaultNick or "Nombre")

		if not isElement(banReasonEdit) then
			banReasonEdit = guiCreateEdit ( 100, 130, 165, 24, "", false, aInputForm )
		end
		guiSetText(banReasonEdit, defaultReason or "Razón")
	end


	guiSetText ( aInputForm, title )
	guiSetText ( aInputLabel, message )
	guiSetText ( aInputValue, default )
	aHideFloaters()
	guiSetVisible ( aInputForm, true )
	guiBringToFront ( aInputForm )
	aInputAction = action
	varOne = vOne
	varTwo = vTwo
end

addEventHandler("onClientGUIClick", guiRoot,
    function()
        if source == banNickEdit then
            if guiGetText(banNickEdit) == "Nombre" then
                guiSetText(banNickEdit, "")
            end
        elseif source == banReasonEdit then
            if guiGetText(banReasonEdit) == "Razón" then
                guiSetText(banReasonEdit, "")
            end
        end
    end
)

function aInputBoxClose ( destroy )
	if ( ( destroy ) or ( guiCheckBoxGetSelected ( aPerformanceInput ) ) ) then
		if ( aInputForm ) then
			removeEventHandler ( "onClientGUIClick", aInputForm, aInputBoxClick )
			removeEventHandler ( "onClientGUIAccepted", aInputValue, aInputBoxAccepted )
			aInputAction = nil
			destroyElement ( aInputForm )
			aInputForm = nil
		end
	else
		guiSetVisible ( aInputForm, false )
	end
end

-- Escape character '%' will be lost when using gsub, so turn % into %%
function keepEscapeCharacter ( text )
	return string.gsub( text, "%%", "%%%%" )
end

function aInputBoxAccepted ()
	--loadstring ( string.gsub ( aInputAction, "$value", "\""..keepEscapeCharacter( guiGetText ( aInputValue ) ).."\"" ) )()
end

function aInputBoxClick ( button )
	if ( button == "left" ) then
		if ( source == aInputOk ) then
			--loadstring ( string.gsub ( aInputAction, "$value", "\""..keepEscapeCharacter( guiGetText ( aInputValue ) ).."\"" ) )()

			if (aInputAction == "kickPlayer") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "kick", guiGetText(aInputValue))
			elseif (aInputAction == "setHealth") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "sethealth", guiGetText(aInputValue))
			elseif (aInputAction == "setArmor") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setarmour", guiGetText(aInputValue))
			elseif (aInputAction == "setNick") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setnick", guiGetText(aInputValue))
			elseif (aInputAction == "shout") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "shout", guiGetText(aInputValue))
			elseif (aInputAction == "setMoney") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setmoney", guiGetText(aInputValue))
			elseif (aInputAction == "setDimension") then
				triggerServerEvent("aPlayer", localPlayer, varOne, "setdimension", guiGetText(aInputValue))
			elseif (aInputAction == "setCurrentAmmo") then
				aSetCurrentAmmo(guiGetText(aInputValue))
			elseif (aInputAction == "setGameType") then
				triggerServerEvent("aServer", localPlayer, "setgame", guiGetText(aInputValue))
			elseif (aInputAction == "setMapName") then
				triggerServerEvent("aServer", localPlayer, "setmap", guiGetText(aInputValue))
			elseif (aInputAction == "setWelcome") then
				triggerServerEvent("aServer", localPlayer, "setwelcome", guiGetText(aInputValue))
			elseif (aInputAction == "setServerPassword") then
				triggerServerEvent("aServer", localPlayer, "setpassword", guiGetText(aInputValue))
			elseif (aInputAction == "serverShutdown") then
				triggerServerEvent("aServer", localPlayer, "shutdown", guiGetText(aInputValue))
			elseif (aInputAction == "unbanIP") then
				triggerServerEvent("aBans", localPlayer, "unbanip", guiGetText(aInputValue))
			elseif (aInputAction == "unbanSerial") then
				triggerServerEvent("aBans", localPlayer, "unbanserial", guiGetText(aInputValue))
			elseif (aInputAction == "banIP") or (aInputAction == "banSerial") then
				local theDuration = 0
				local durType = guiGetText(banSerialCombo)
				if durType and durType ~= "Perm" then
					-- First validate entry, must be a number
					local durEntry = tonumber(guiGetText(durationEdit))
					if not durEntry or type(durEntry) ~= "number" then
						return outputChatBox("* Error: Ingrese un valor de duración numérico válido", 255, 0, 0)
					else
						if durType == "Mints" then
							theDuration = math.floor(math.abs(durEntry)) * 60
						elseif durType == "Horas" then
							theDuration = math.floor(math.abs(durEntry)) * 60 * 60
						elseif durType == "Días" then
							theDuration = math.floor(math.abs(durEntry)) * 24 * 60 * 60
						end
					end
				end
				if aInputAction == "banIP" then
					triggerServerEvent("aBans", localPlayer, "banip", guiGetText(aInputValue), guiGetText(banNickEdit), guiGetText(banReasonEdit), theDuration)
				elseif aInputAction == "banSerial" then
					triggerServerEvent("aBans", localPlayer, "banserial", guiGetText(aInputValue), guiGetText(banNickEdit), guiGetText(banReasonEdit), theDuration)
				end
			elseif (aInputAction == "settingChange") then
				triggerServerEvent("aAdmin", localPlayer, "settings", "change", varOne, varTwo, guiGetText(aInputValue))
			elseif (aInputAction == "aclCreateGroup") then
				triggerServerEvent("aAdmin", localPlayer, "aclcreate", "group", guiGetText(aInputValue))
			elseif (aInputAction == "aclCreate") then
				triggerServerEvent("aAdmin", localPlayer, "aclcreate", "acl", guiGetText(aInputValue))
			elseif (aInputAction == "aclAddObject") then
				triggerServerEvent("aAdmin", localPlayer, "acladd", "object", varOne, guiGetText(aInputValue))
			elseif (aInputAction == "aclAddRight") then
				triggerServerEvent("aAdmin", localPlayer, "acladd", "right", varOne, guiGetText(aInputValue))
			end

			aInputAction = nil
			aInputBoxClose ( false )
		elseif ( source == aInputCancel ) then
			aInputAction = nil
			aInputBoxClose ( false )
		end
	end
end



--
-- Ban input box
--

aBanInputForm = nil
local aBanDurations = {}

function aBanInputBox ( player )
	-- parse 'bandurations' setting
	local durations = {}
	table.insert( durations, "Custom:" )
	for i,dur in ipairs( split( g_Prefs.bandurations, string.byte(',') ) ) do
		if tonumber( dur ) then
			table.insert( durations, tonumber( dur ) )
		end
	end

	-- destroy form if number of durations has changed
	if #aBanDurations ~= #durations then
		if aBanInputForm then
			_widgets["BanInputBox"] = nil
			destroyElement( aBanInputForm )
			aBanInputForm = nil
		end
	end
	aBanDurations = durations
	if ( aBanInputForm == nil ) then
		local height1 = 100
		local height2 = math.floor( #aBanDurations * 1.02 * 15 ) + 20
		local height = math.max(height1,height2)
		local x, y = guiGetScreenSize()
		aBanInputForm			= guiCreateWindow ( x / 2 - 150, y / 2 - 64, 400, height + 130, "", false )
							  guiWindowSetSizable ( aBanInputForm, false )
		guiSetAlpha(aBanInputForm, 1)
		y = 24

		aBanInputLabel			= guiCreateLabel ( 20, y, 270, 15, "", false, aBanInputForm )
		guiLabelSetHorizontalAlign ( aBanInputLabel, "center" )
		y = y + 23

		aBanInputValue			= guiCreateEdit ( 35, y, 230, 24, "", false, aBanInputForm )
		y = y + 33

		aBanInputRadioSet1bg	= guiCreateTabPanel( 10, y, 120, 100, false, aBanInputForm)
		aBanInputRadioSet1		= guiCreateStaticImage(0,0,1,1, 'client\\images\\empty.png', true, aBanInputRadioSet1bg)
		guiSetAlpha ( aBanInputRadioSet1bg, 0.3 )
		guiSetProperty ( aBanInputRadioSet1, 'InheritsAlpha', 'false' )

		aBanInputRadio1Label	= guiCreateLabel ( 10, 20, 270, 15, "Tipo:", false, aBanInputRadioSet1 )
		aBanInputRadio1A		= guiCreateRadioButton ( 50, 20, 50, 15, "IP", false, aBanInputRadioSet1 )
		aBanInputRadio1B		= guiCreateRadioButton ( 50, 35, 120, 15, "Serial", false, aBanInputRadioSet1 )

		aBanInputRadioSet2bg	= guiCreateTabPanel( 135, y, 260, height2, false, aBanInputForm)
		aBanInputRadioSet2		= guiCreateStaticImage(0,0,1,1, 'client\\images\\empty.png', true, aBanInputRadioSet2bg)
		guiSetAlpha ( aBanInputRadioSet2bg, 0.3 )
		guiSetProperty ( aBanInputRadioSet2, 'InheritsAlpha', 'false' )

		local yy = 5
		aBanInputRadio2Label	= guiCreateLabel ( 10, yy, 270, 15, "Duración:", false, aBanInputRadioSet2 )
		aBanInputRadio2s = {}
		for i,dur in ipairs(aBanDurations) do
			aBanInputRadio2s[i] = guiCreateRadioButton ( 70, yy, 90, 15, "-", false, aBanInputRadioSet2 )
			yy = yy + 15
		end
		customDuration      = guiCreateEdit ( 138, 3, 50, 24, "", false, aBanInputRadioSet2 )
		customType      = guiCreateComboBox ( 190, 4, 65, 80, "Mints", false, aBanInputRadioSet2 )
						  guiComboBoxAddItem(customType, "Mints")
						  guiComboBoxAddItem(customType, "Horas")
						  guiComboBoxAddItem(customType, "Días")
		y = y + height + 10

		aBanInputOk			= guiCreateButton ( 90, y, 55, 17, "OK", false, aBanInputForm )
		aBanInputCancel		= guiCreateButton ( 150, y, 55, 17, "Cerrar", false, aBanInputForm )
		y = y + 30



		guiSetSize ( aBanInputForm, guiGetSize ( aBanInputForm, false ), y, false )

		guiSetProperty ( aBanInputForm, "AlwaysOnTop", "true" )
		aBanInputPlayer = nil

		addEventHandler ( "onClientGUIClick", aBanInputForm, aBanInputBoxClick )
		addEventHandler ( "onClientGUIAccepted", aBanInputValue, aBanInputBoxAccepted )
		--Register With Admin Form
		aRegister ( "BanInputBox", aBanInputForm, aBanInputBox, aBanInputBoxClose )
	end

	-- update duration values in the form
	for i,dur in ipairs(aBanDurations) do
		if dur == "Custom:" then
		guiSetText ( aBanInputRadio2s[i], "Custom:" )
		else
		guiSetText ( aBanInputRadio2s[i], dur>0 and secondsToTimeDesc(dur) or "Permanente" )
		end
	end

	guiSetText ( aBanInputForm, "Banear a " .. string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "" ))
	guiSetText ( aBanInputLabel, "Ingresar la razón del ban:" )
	aHideFloaters()
	guiSetVisible ( aBanInputForm, true )
	guiBringToFront ( aBanInputForm )
	aBanInputPlayer = player
end

function aBanInputBoxClose ( destroy )
	if ( ( destroy ) or ( guiCheckBoxGetSelected ( aPerformanceInput ) ) ) then
		if ( aBanInputForm ) then
			removeEventHandler ( "onClientGUIClick", aBanInputForm, aBanInputBoxClick )
			removeEventHandler ( "onClientGUIAccepted", aBanInputValue, aBanInputBoxAccepted )
			aBanInputPlayer = nil
			destroyElement ( aBanInputForm )
			aBanInputForm = nil
		end
	else
		guiSetVisible ( aBanInputForm, false )
	end
end

function aBanInputBoxAccepted ()
	aBanInputBoxFinish()
end

function aBanInputBoxClick ( button )
	if ( button == "left" ) then
		if ( source == aBanInputOk ) then
			aBanInputBoxFinish()
			aBanInputPlayer = nil
			aBanInputBoxClose ( false )
		elseif ( source == aBanInputCancel ) then
			aBanInputPlayer = nil
			aBanInputBoxClose ( false )
		end
	end
end


function aBanInputBoxFinish ()
	-- Get options
	local bUseIP	 = guiRadioButtonGetSelected( aBanInputRadio1A )
	local bUseSerial = guiRadioButtonGetSelected( aBanInputRadio1B )

	-- Get duration
	local seconds = false
	for i,dur in ipairs(aBanDurations) do
		if guiRadioButtonGetSelected( aBanInputRadio2s[i] ) then
			if guiGetText(aBanInputRadio2s[i]) == "Custom:" then
				if guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Mints" then
				 seconds = guiGetText(customDuration) * 60
				elseif guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Horas" then
				 seconds = guiGetText(customDuration) * 3600
				elseif guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Días" then
				 seconds = guiGetText(customDuration) * 86400
				end
			else
			seconds = dur
			end
		end
	end

	-- Get reason
	local reason = guiGetText ( aBanInputValue )

	-- Validate settings
	if not bUseIP and not bUseSerial then
		aMessageBox ( "Error", "¡Tipo de ban no seleccionado!" )
		return
	end

	if seconds == false then
		aMessageBox ( "Error", "¡Duración no seleccionada!" )
		return
	end

	-- Send ban info to the server
	triggerServerEvent ( "aPlayer", localPlayer, aBanInputPlayer, "ban", reason, seconds, bUseSerial )



	-- Clear input
	guiSetText ( aBanInputValue, "" )
	for i,dur in ipairs(aBanDurations) do
		guiRadioButtonSetSelected( aBanInputRadio2s[i], false )
	end
end





--
-- Mute input box
--

aMuteInputForm = nil
local aMuteDurations = {}

function aMuteInputBox ( player )
	-- parse 'mutedurations' setting
	local durations = {}
	for i,dur in ipairs( split( g_Prefs.mutedurations, string.byte(',') ) ) do
		if tonumber( dur ) then
			table.insert( durations, tonumber( dur ) )
		end
	end
	-- destroy form if number of durations has changed
	if #aMuteDurations ~= #durations then
		if aMuteInputForm then
			_widgets["MuteInputBox"] = nil
			destroyElement( aMuteInputForm )
			aMuteInputForm = nil
		end
	end
	aMuteDurations = durations
	if ( aMuteInputForm == nil ) then
		local x, y = guiGetScreenSize()
		aMuteInputForm			= guiCreateWindow ( x / 2 - 150, y / 2 - 64, 300, 150 + #aMuteDurations * 15, "", false )
							  guiWindowSetSizable ( aMuteInputForm, false )
		guiSetAlpha(aMuteInputForm, 1)
		y = 24

		aMuteInputLabel			= guiCreateLabel ( 20, y, 270, 15, "", false, aMuteInputForm )
		guiLabelSetHorizontalAlign ( aMuteInputLabel, "center" )
		y = y + 23

		aMuteInputValue			= guiCreateEdit ( 35, y, 230, 24, "", false, aMuteInputForm )
		y = y + 33

		local height2 = math.floor( #aMuteDurations * 1.02 * 15 ) + 20
		aMuteInputRadioSet2bg			= guiCreateTabPanel( 55, y, 300-55*2, height2, false, aMuteInputForm)
		aMuteInputRadioSet2				= guiCreateStaticImage(0,0,1,1, 'client\\images\\empty.png', true, aMuteInputRadioSet2bg)
		guiSetAlpha ( aMuteInputRadioSet2bg, 0.3 )
		guiSetProperty ( aMuteInputRadioSet2, 'InheritsAlpha', 'false' )

		local yy = 5
		aMuteInputRadio2Label	= guiCreateLabel ( 10, yy, 270, 15, "Duración:", false, aMuteInputRadioSet2 )
		aMuteInputRadio2s = {}
		for i,dur in ipairs(aMuteDurations) do
			aMuteInputRadio2s[i] = guiCreateRadioButton ( 70, yy, 120, 15, "-", false, aMuteInputRadioSet2 )
			yy = yy + 15
		end
		y = y + height2 + 10

		aMuteInputOk			= guiCreateButton ( 90, y, 55, 17, "OK", false, aMuteInputForm )
		aMuteInputCancel		= guiCreateButton ( 150, y, 55, 17, "Cerrar", false, aMuteInputForm )
		y = y + 30

		guiSetSize ( aMuteInputForm, guiGetSize ( aMuteInputForm, false ), y, false )

		guiSetProperty ( aMuteInputForm, "AlwaysOnTop", "true" )
		aMuteInputPlayer = nil

		addEventHandler ( "onClientGUIClick", aMuteInputForm, aMuteInputBoxClick )
		addEventHandler ( "onClientGUIAccepted", aMuteInputValue, aMuteInputBoxAccepted )
		--Register With Admin Form
		aRegister ( "MuteInputBox", aMuteInputForm, aMuteInputBox, aMuteInputBoxClose )
	end

	-- update duration values in the form
	for i,dur in ipairs(aMuteDurations) do
		guiSetText ( aMuteInputRadio2s[i], dur>0 and secondsToTimeDesc(dur) or "Hasta reconectar" )
	end

	guiSetText ( aMuteInputForm, "Mutear jugador " .. getPlayerName(player) )
	guiSetText ( aMuteInputLabel, "Ingresar la razón de muteo:" )
	aHideFloaters()
	guiSetVisible ( aMuteInputForm, true )
	guiBringToFront ( aMuteInputForm )
	aMuteInputPlayer = player
end

function aMuteInputBoxClose ( destroy )
	if ( ( destroy ) or ( guiCheckBoxGetSelected ( aPerformanceInput ) ) ) then
		if ( aMuteInputForm ) then
			removeEventHandler ( "onClientGUIClick", aMuteInputForm, aMuteInputBoxClick )
			removeEventHandler ( "onClientGUIAccepted", aMuteInputValue, aMuteInputBoxAccepted )
			aMuteInputPlayer = nil
			destroyElement ( aMuteInputForm )
			aMuteInputForm = nil
		end
	else
		guiSetVisible ( aMuteInputForm, false )
	end
end

function aMuteInputBoxAccepted ()
	aMuteInputBoxFinish()
end

function aMuteInputBoxClick ( button )
	if ( button == "left" ) then
		if ( source == aMuteInputOk ) then
			aMuteInputBoxFinish()
			aMuteInputPlayer = nil
			aMuteInputBoxClose ( false )
		elseif ( source == aMuteInputCancel ) then
			aMuteInputPlayer = nil
			aMuteInputBoxClose ( false )
		end
	end
end


function aMuteInputBoxFinish ()
	-- Get duration
	local seconds = false
	for i,dur in ipairs(aMuteDurations) do
		if guiRadioButtonGetSelected( aMuteInputRadio2s[i] ) then
			seconds = dur
		end
	end

	-- Get reason
	local reason = guiGetText ( aMuteInputValue )

	-- Validate settings
	if seconds == false then
		aMessageBox ( "Error", "¡Duración no seleccionada!" )
		return
	end

	-- Send mute info to the server
	triggerServerEvent ( "aPlayer", localPlayer, aMuteInputPlayer, "mute", reason, seconds )

	-- Clear input
	guiSetText ( aMuteInputValue, "" )
	for i,dur in ipairs(aMuteDurations) do
		guiRadioButtonSetSelected( aMuteInputRadio2s[i], false )
	end
end
