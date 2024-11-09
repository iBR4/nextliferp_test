
local screenW, screenH = guiGetScreenSize()
local sx, sy = screenW/1920, screenH/1080

TConfig = {
	{0,"Rendimiento",true},
	{1,"Activar/Desactivar Nubes - [Recomendable en pc de bajos recursos]",false},
	{2,"Activar/Desactivar Oclusiones - [Recomendable en pc de bajos recursos]",false},
	{3,"Hud Configuraciones",true},
	{4,"Hud Base (Opcion 1)",false},
	{5,"Hud Avanzado (Opcion 2)",false},
}

ConfigGUI = guiCreateWindow(622*sx, 248*sy, 672*sx, 582*sy, "Configuracion", false)
guiWindowSetSizable(ConfigGUI, false)
guiSetAlpha(ConfigGUI, 1.00)

TabConfig = guiCreateTabPanel(8*sx, 24*sy, 654*sx, 498*sy, false, ConfigGUI)

tGeneral = guiCreateTab("General", TabConfig)

ResetConfig = guiCreateButton(10*sx, 12*sy, 142*sx, 36*sy, "Configuración\nPredeterminada", false, tGeneral)
guiSetFont(ResetConfig, "default-bold-small")
guiSetProperty(ResetConfig, "NormalTextColour", "FFF69F08")
Label_Config1 = guiCreateLabel(12*sx, 58*sy, 142*sx, 202*sy, "El botón\n\"Configuración\npredeterminada\" te\ndevolverá la\nconfiguración\npredeterminada por el\nservidor.\n\nSi deseas personalizar\ntu experiencia en el\nservidor haz doble\nclick sobre alguna\nopcion para\nmodificarla.", false, tGeneral)
guiLabelSetVerticalAlign(Label_Config1, "center")
Grid_Config = guiCreateGridList(162*sx, 8*sy, 482*sx, 454*sy, false, tGeneral)
guiGridListAddColumn(Grid_Config, "Configuración", 0.769)
guiGridListAddColumn(Grid_Config, "Valor", 0.190)

tTag = guiCreateTab("Nametag", TabConfig)

CerrarConfig = guiCreateButton(482*sx, 528*sy, 180*sx, 38*sy, "Cerrar", false, ConfigGUI)
guiSetFont(CerrarConfig, "default-bold-small")
prox = guiCreateButton(10*sx, 528*sy, 468*sx, 38*sy, "<< Obtener más soporte aqui >>", false, ConfigGUI)
guiSetFont(prox, "default-bold-small")

guiSetVisible(ConfigGUI, false)

function update()
	TConfig = {
		{0,"Rendimiento",true},
		{1,"Activar/Desactivar Nubes - [Recomendable en pc de bajos recursos]",false,Save.Nubes},
		{2,"Activar/Desactivar Oclusiones - [Recomendable en pc de bajos recursos]",false,Save.Oclusiones},
		{3,"Activar/Desactivar UltraFPS - [Recomendable en pc de bajos recursos]",false,Save.UltraFPS},
		{4,"Hud Configuraciones",true},
		{5,"Hud Base (Opcion 1)",false,Save.HudBase},
		{6,"Hud Avanzado (Opcion 2)",false,Save.HudPro},
		{7,"Otras Configuraciones",true},
		{8,"Recordar de Datos (Login)",false,Save.AutoRecordar},
	}
	guiGridListClear(Grid_Config)
	for i,v in ipairs(TConfig) do
		
		local row = guiGridListAddRow(Grid_Config)
		guiGridListSetItemText(Grid_Config,row,1,v[2],v[3],false)
		if v[4] then
			guiGridListSetItemText(Grid_Config,row,2,v[4],v[3],false)
		end
		guiGridListSetItemData(Grid_Config,row,1,v[1])

		if v[3] == true then
			guiGridListSetItemColor(Grid_Config,row,1,255,165,0)
			guiGridListSetItemColor(Grid_Config,row,2,255,165,0)
		else
			guiGridListSetItemColor(Grid_Config,row,1,210,210,210)
			guiGridListSetItemColor(Grid_Config,row,2,210,210,210)
		end
		


	end
end


function showConfigPanel(player)
	if source == player then
		if guiGetVisible(ConfigGUI) == false then
			update()
			showCursor(true)
			guiSetVisible(ConfigGUI, true)
		else
			showCursor(false)
			guiSetVisible(ConfigGUI, false)
		end
	end
end
addEvent("NextLife:ShowConfig",true)
addEventHandler("NextLife:ShowConfig",root,showConfigPanel)

function ApplyConfigPanel(player)
	if source == player then
		if fileExists('save.json') then
			if Save.Nubes == "Si" then
				setCloudsEnabled(true)
			else
				setCloudsEnabled(false)
			end
			if Save.Oclusiones == "Si" then
				setOcclusionsEnabled(true)
			else
				setOcclusionsEnabled(false)
			end
			if Save.UltraFPS == "Si" then
				setFarClipDistance(100)
				setFogDistance(100)
				setSkyGradient( 0, 0, 0, 0, 0, 0 )
			else
				resetSkyGradient()
				resetFarClipDistance()
				resetFogDistance()
			end
		end
	end
end
addEvent("NextLife:ApplyConfig",true)
addEventHandler("NextLife:ApplyConfig",root,ApplyConfigPanel)

addEventHandler( "onClientGUIClick", ConfigGUI, function(button,state,x,y)
	if (button == "left" and state == "up") then
		if source == CerrarConfig then
			showCursor(false)
			guiSetVisible(ConfigGUI, false)
		elseif source == ResetConfig then
			Save.Nubes = "Si"
			Save.Oclusiones = "Si"
			Save.HudBase = "Si"
			Save.HudPro = "No"
			Save.AutoRecordar = "No"
			Save.UltraFPS = "No"
			update()
			ApplyConfigPanel(localPlayer)
		end
	end
end)

addEventHandler( "onClientGUIDoubleClick", Grid_Config, function(button,state,x,y)
	if (button == "left" and state == "up") then
		local id = guiGridListGetItemText(Grid_Config, guiGridListGetSelectedItem(Grid_Config), 1)
		if tostring(id) ~= "" then

			if tostring(id) == "Activar/Desactivar Nubes - [Recomendable en pc de bajos recursos]" then
				if Save.Nubes == "No" then
					Save.Nubes = "Si"
					setCloudsEnabled(true)
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Nubes Activado' #ffffff!",255,255,255)
				else
					Save.Nubes = "No"
					setCloudsEnabled(false)
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Nubes Desactivado' #ffffff!",255,255,255)
				end
			elseif tostring(id) == "Activar/Desactivar Oclusiones - [Recomendable en pc de bajos recursos]" then
				if Save.Oclusiones == "No" then
					Save.Oclusiones = "Si"
					setOcclusionsEnabled(true)
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Oclusiones Activado' #ffffff!",255,255,255)
				else
					Save.Oclusiones = "No"
					setOcclusionsEnabled(false)
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Oclusiones Desactivado' #ffffff!",255,255,255)
				end
			elseif tostring(id) == "Activar/Desactivar UltraFPS - [Recomendable en pc de bajos recursos]" then
				if Save.UltraFPS == "No" then
					Save.UltraFPS = "Si"
					setFarClipDistance(100)
					setFogDistance(100)
					setSkyGradient( 0, 0, 0, 0, 0, 0 )
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'UltraFPS Activado' #ffffff!",255,255,255)
				else
					Save.UltraFPS = "No"
					resetSkyGradient()
					resetFarClipDistance()
					resetFogDistance()
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'UltraFPS Desactivado' #ffffff!",255,255,255)
				end
			elseif tostring(id) == "Hud Base (Opcion 1)" then
				if Save.HudBase == "No" then
					Save.HudBase = "Si"
					Save.HudPro = "No"
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Hud Base Activado' #ffffff!",255,255,255)
				else
					--Save.HudBase = "No"
					--triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Hud Base Desactivado' #ffffff!",255,255,255)
				end
			elseif tostring(id) == "Hud Avanzado (Opcion 2)" then
				if Save.HudPro == "No" then
					Save.HudPro = "Si"
					Save.HudBase = "No"
					triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Hud Avanzado Activado' #ffffff!",255,255,255)
				else
					--Save.HudPro = "No"
					--triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Hud Avanzado Desactivado' #ffffff!",255,255,255)
				end
			elseif tostring(id) == "Recordar de Datos (Login)" then
				if Save.AutoRecordar == "No" then
					Save.AutoRecordar = "Si"
				else
					Save.AutoRecordar = "No"
				end
				triggerEvent("addTextMessage3D",localPlayer,"Cambios #F58A02Aplicados #ffffff'Recordar de Datos' #ffffff!",255,255,255)
			end
			update()
		end
	end
end)


Save = {}
Save.Nubes = "Si"
Save.Oclusiones = "Si"
Save.HudBase = "Si"
Save.HudPro = "No"
Save.AutoRecordar = "No"
Save.UltraFPS = "No"

if fileExists('save.json') then
    local file = fileOpen('save.json')
    Save = fromJSON(file:read(file:getSize()))
    file:close()
end


function saveDatos()
    if fileExists('save.json') then
        fileDelete( 'save.json' )
    end

    local file = fileCreate( 'save.json' )
    fileWrite(file, toJSON(Save))
    file:close()
end
addEventHandler( "onClientResourceStop", resourceRoot, saveDatos)
addEventHandler( "onClientPlayerQuit", localPlayer, saveDatos)

-- Hud

function recoverData(player)
	if Save then
        return Save.AutoRecordar
    end
    return false
end


