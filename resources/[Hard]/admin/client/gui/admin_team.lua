--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	gui\admin_team.lua
*
*	Original File by lil_Toady
*
*   Traducido al español por Zelev
*
**************************************]]

aTeamForm = nil
aTeamSelect = nil

function aPlayerTeam ( player )
	if ( aTeamForm == nil ) then
		local x, y = guiGetScreenSize()
		aTeamForm		= guiCreateWindow ( x / 2 - 150, y / 2 - 125, 300, 250, "Administrador de teams", false )
		aTeamLabel		= guiCreateLabel ( 0.03, 0.09, 0.94, 0.07, "Selecciona un team de la lista o crea uno nuevo", true, aTeamForm )
					  guiLabelSetHorizontalAlign ( aTeamLabel, "center" )
					  guiLabelSetColor ( aTeamLabel, 255, 0, 0 )
		aTeamList		= guiCreateGridList ( 0.03, 0.18, 0.50, 0.71, true, aTeamForm )
					  guiGridListAddColumn( aTeamList, "Teams", 0.85 )
		aTeamRefresh		= guiCreateButton ( 0.03, 0.90, 0.50, 0.08, "Actualizar", true, aTeamForm )
		aTeamNew		= guiCreateButton ( 0.55, 0.18, 0.42, 0.09, "Nuevo team", true, aTeamForm, "createteam" )
		aTeamDelete		= guiCreateButton ( 0.55, 0.28, 0.42, 0.09, "Eliminar team", true, aTeamForm, "destroyteam" )
		aTeamShowColor	= guiCreateCheckBox ( 0.55, 0.38, 0.42, 0.09, "Mostrar color", true, true, aTeamForm )
		aTeamNameLabel	= guiCreateLabel 	( 0.55, 0.19, 0.42, 0.07, "Nombre del team:", true, aTeamForm )
		aTeamColor		= guiCreateLabel 	( 0.55, 0.37, 0.42, 0.11, "Color:", true, aTeamForm )
		aTeamR		= guiCreateLabel 	( 0.70, 0.37, 0.42, 0.11, "R:", true, aTeamForm )
		aTeamG		= guiCreateLabel 	( 0.70, 0.48, 0.42, 0.11, "G:", true, aTeamForm )
		aTeanB			= guiCreateLabel 	( 0.70, 0.59, 0.42, 0.11, "B:", true, aTeamForm )
		aTeamName		= guiCreateEdit 	( 0.55, 0.26, 0.42, 0.10, "", true, aTeamForm )
		aTeamRed		= guiCreateEdit 	( 0.80, 0.36, 0.15, 0.10, "0", true, aTeamForm )
		aTeamGreen		= guiCreateEdit 	( 0.80, 0.47, 0.15, 0.10, "0", true, aTeamForm )
		aTeamBlue		= guiCreateEdit 	( 0.80, 0.58, 0.15, 0.10, "0", true, aTeamForm )
		aTeamCreate		= guiCreateButton ( 0.55, 0.73, 0.20, 0.09, "Crear", true, aTeamForm, "createteam" )
		aTeamCancel		= guiCreateButton ( 0.77, 0.73, 0.20, 0.09, "Cancelar", true, aTeamForm )
		aTeamAccept		= guiCreateButton ( 0.55, 0.88, 0.20, 0.09, "Elegir", true, aTeamForm )
		aTeamClose		= guiCreateButton ( 0.77, 0.88, 0.20, 0.09, "Cerrar", true, aTeamForm )
		aTeamRemove		= guiCreateButton ( 0.55, 0.78, 0.42, 0.09, "Echar del team", true, aTeamForm )
		addEventHandler ( "onClientGUIClick", aTeamForm, aClientTeamClick )
		addEventHandler ( "onClientGUIDoubleClick", aTeamForm, aClientTeamDoubleClick )
		--Register With Admin Form
		aRegister ( "PlayerTeam", aTeamForm, aPlayerTeam, aPlayerTeamClose )
	end
	aTeamSelect = player
	aTeamsRefresh ()
	guiSetVisible ( aTeamForm, true )
	guiBringToFront ( aTeamForm )
	aNewTeamShow ( false )
end

function aPlayerTeamClose ( destroy )
	if ( ( destroy ) or ( guiCheckBoxGetSelected ( aPerformanceTeam ) ) ) then
		if ( aTeamForm ) then
			removeEventHandler ( "onClientGUIClick", aTeamForm, aClientTeamClick )
			removeEventHandler ( "onClientGUIDoubleClick", aTeamForm, aClientTeamDoubleClick )
			destroyElement ( aTeamForm )
			aTeamForm = nil
		end
	else
		guiSetVisible ( aTeamForm, false )
	end
end

function aClientTeamDoubleClick ( button )
	if ( button == "left" ) then
		if ( source == aTeamList ) then
			if ( guiGridListGetSelectedItem ( aTeamList ) ~= -1 ) then
				local team = guiGridListGetItemText ( aTeamList, guiGridListGetSelectedItem ( aTeamList ), 1 )
				triggerServerEvent ( "aPlayer", getLocalPlayer(), aTeamSelect, "setteam", getTeamFromName ( team ) )
				aPlayerTeamClose ( false )
			end
		end
	end
end

function aClientTeamClick ( button )
	if ( button == "left" ) then
		if ( source == aTeamNew ) then
			aNewTeamShow ( true )
		elseif ( source == aTeamRefresh or source == aTeamShowColor ) then
			aTeamsRefresh()
		elseif ( source == aTeamDelete ) then
			if ( guiGridListGetSelectedItem ( aTeamList ) == -1 ) then
				aMessageBox ( "Advertencia", "¡Team no seleccionado!" )
			else
				local team = guiGridListGetItemText ( aTeamList, guiGridListGetSelectedItem ( aTeamList ), 1 )
				aMessageBox ( "Pregunta", "¿Eliminar el team \""..team.."\"?", "deleteTeam", team )
			end
			setTimer ( aTeamsRefresh, 2000, 1 )
		elseif ( source == aTeamCreate ) then
			local team = guiGetText ( aTeamName )
			if ( ( team == nil ) or ( team == false ) or ( team == "" ) ) then
				aMessageBox ( "Advertencia", "¡Ingresa el nombre del team!" )
			elseif ( getTeamFromName ( team ) ) then
				aMessageBox ( "Error", "Ya existe un team con este nombre" )
			else
				triggerServerEvent ( "aTeam", getLocalPlayer(), "createteam", team, guiGetText ( aTeamRed ), guiGetText ( aTeamGreen ), guiGetText ( aTeamBlue ) )
				aNewTeamShow ( false )
			end
			setTimer ( aTeamsRefresh, 2000, 1 )
		elseif ( source == aTeamName ) then

		elseif ( source == aTeamCancel ) then
			aNewTeamShow ( false )
		elseif ( source == aTeamAccept ) then
			if ( guiGridListGetSelectedItem ( aTeamList ) == -1 ) then
				aMessageBox ( "Advertencia", "¡Team no seleccionado!" )
			else
				local team = guiGridListGetItemText ( aTeamList, guiGridListGetSelectedItem ( aTeamList ), 1 )
				triggerServerEvent ( "aPlayer", getLocalPlayer(), aTeamSelect, "setteam", getTeamFromName ( team ) )
				guiSetVisible ( aTeamForm, false )
			end
		elseif ( source == aTeamClose ) then
			aPlayerTeamClose ( false )
		elseif ( source == aTeamRemove ) then
			if getPlayerTeam( aTeamSelect ) then
				triggerServerEvent ( "aPlayer", getLocalPlayer(), aTeamSelect, "removefromteam", nil )
			else
				aMessageBox( "Advertencia", "¡Este jugador no está en ningún team!")
			end
		end
	end
end

function aNewTeamShow ( bool )
	guiSetVisible ( aTeamNew, not bool )
	guiSetVisible ( aTeamDelete, not bool )
	guiSetVisible ( aTeamShowColor, not bool )
	guiSetVisible ( aTeamNameLabel, bool )
	guiSetVisible ( aTeamName, bool )
	guiSetVisible ( aTeamColor, bool )
	guiSetVisible ( aTeamR, bool )
	guiSetVisible ( aTeamG, bool )
	guiSetVisible ( aTeanB, bool )
	guiSetVisible ( aTeamRed, bool )
	guiSetVisible ( aTeamGreen, bool )
	guiSetVisible ( aTeamBlue, bool )
	guiSetVisible ( aTeamCreate, bool )
	guiSetVisible ( aTeamCancel, bool )
	guiSetVisible ( aTeamRemove, not bool )
end

function aTeamsRefresh ()
	if ( aTeamList ) then
		guiGridListClear ( aTeamList )
		local showColor = guiCheckBoxGetSelected ( aTeamShowColor )
		for id, team in ipairs ( getElementsByType ( "team" ) ) do
			local row = guiGridListAddRow ( aTeamList )
			guiGridListSetItemText ( aTeamList, row, 1, getTeamName ( team ), false, false )
			if showColor then
				guiGridListSetItemColor ( aTeamList, row, 1, getTeamColor ( team ) )
			end
		end
	end
end
