addEventHandler("onResourceStart", resourceRoot, function ( )

	database = Connection("sqlite", "Datos.db")

	if database then

		print("Conectado a la base de datos 'Datos.db'")

	else

		print("Error al conectar con la DB")

	end

end);



function query( ... )

	if database then

		local s = database:query(...)

		local result = s:poll(-1)

		return result

	else

		return false

	end

end



function update( ... )

	if database then

		return database:exec(...)

	else

		return false

	end

end



function insert( ... )

	if database then

		return database:exec(...)

	else

		return false

	end

end



function delete( ... )

	if database then

		return database:exec(...)

	else

		return false

	end

end



function AccountName( player )
	local s = player:getAccount()
	local cuenta = s:getName()
	return cuenta
end

function notIsGuest( player )
	local ac = player:getAccount()
	local is = ac:isGuest()
	return is
end
function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(Element.getAllByType("player")) do
            local name_ = player:getName():gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function removeColorCoding( name )
    return type(name)=='string' and string.gsub ( name, '#%x%x%x%x%x%x', '' ) or name
end

function getPlayerFromPartialNameID(id)
    for _, player in ipairs(Element.getAllByType("player")) do
        local id_ = player:getData("ID")
        if id_ and id_ == tonumber(id) then
            return player
        end
    end
    return false
end

function isPlayerInTeam(player, team)
    assert(isElement(player) and getElementType(player) == "player", "Bad argument 1 @ isPlayerInTeam [player expected, got " .. tostring(player) .. "]")
    assert((not team) or type(team) == "string" or (isElement(team) and getElementType(team) == "team"), "Bad argument 2 @ isPlayerInTeam [nil/string/team expected, got " .. tostring(team) .. "]")
    return getPlayerTeam(player) == (type(team) == "string" and getTeamFromName(team) or (type(team) == "userdata" and team or (getPlayerTeam(player) or true)))
end

function isPlayerInACL(player, acl)
	if isElement(player) and getElementType(player) == "player" and aclGetGroup(acl or "") and not isGuestAccount(getPlayerAccount(player)) then
		local account = getPlayerAccount(player)
		
		return isObjectInACLGroup( "user.".. getAccountName(account), aclGetGroup(acl) )
	end
	return false
end

local staffACLs =
{
    aclGetGroup("Desarrollador"),
    aclGetGroup("Administrador.General"),
    aclGetGroup("Admin"),
    aclGetGroup("Sup.Staff"),
    aclGetGroup("SuperModerador"),
    aclGetGroup("Moderador"),
	aclGetGroup("Moderador A Pruebas"),

}

function isPlayerStaff(p)

	if isElement(p) and getElementType(p) == "player" and not isGuestAccount(getPlayerAccount(p)) then
		local object = getAccountName(getPlayerAccount(p))
		
		for _,group in ipairs(staffACLs) do
			if isObjectInACLGroup( "user."..object, group ) then
				return true
			end
		end
	end
	return false
end

function getACLFromPlayer(player)
	if isElement(player) and getElementType(player) == "player" then
		local accName = getAccountName ( getPlayerAccount ( player ) )
		if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Desarrollador" ) ) then
			return "Desarrollador"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrador.General" ) ) then
			return "Administrador.General"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
			return "Admin"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Sup.Staff" ) ) then
			return "Sup.Staff"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "SuperModerador" ) ) then
			return "SuperModerador"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderador" ) ) then
			return "Moderador"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderador A Pruebas" ) ) then
			return "Moderador A Pruebas"
		end
	end
	return false
end

function getPlayerLeader( thePlayer, TheFaction )
	if isElement( thePlayer ) and ( thePlayer:getType() == "player" ) then
		if thePlayer:getData("Roleplay:faccion_lider") == "Si" then
			return true
		else
			return false
		end
	end
	return false
end


function getPlayerLeaderDivision( thePlayer, TheFaction )
	if isElement( thePlayer ) and ( thePlayer:getType() == "player" ) then
		if thePlayer:getData("Roleplay:faccion_division_lider") == "Si" then
			return true
		else
			return false
		end
	end
	return false
end



function getPlayerFaction( thePlayer, TheFaction )
	if isElement( thePlayer ) and ( thePlayer:getType() == "player" ) then
		return thePlayer:getData("Roleplay:faccion") == tostring(TheFaction)
	end
	return false
end

function getPlayerDivision( thePlayer, TheFaction )
	if isElement( thePlayer ) and ( thePlayer:getType() == "player" ) then
		return thePlayer:getData("Roleplay:faccion_division") == tostring(TheFaction)
	end
	return false
end

function getACLFromPlayer(player)
	if isElement(player) and getElementType(player) == "player" then
		local accName = getAccountName ( getPlayerAccount ( player ) )
		if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Desarrollador" ) ) then
			return "Desarrollador"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrador.General" ) ) then
			return "Administrador.General"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
			return "Admin"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Sup.Staff" ) ) then
			return "Sup.Staff"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "SuperModerador" ) ) then
			return "SuperModerador"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderador" ) ) then
			return "Moderador"
		elseif isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderador A Pruebas" ) ) then
			return "Moderador A Pruebas"
		end
	end
	return false
end


local vehiculos_radios = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [596]=true, [598]=true, [599]=true, [597]=true, [432]=true, [601]=true, [497]=true, [430]=true }


function inPlayerVehiclePolice(p) 
	if isElement(p) and p:getType() == "player" then 
		if p:isInVehicle() then
			local veh = p:getOccupiedVehicle()
			if vehiculos_radios[veh:getModel()] then
				return true
			end
		end
	end
	return false
end

function MensajeRol(player, texto, tip )
	local x, y, z = getElementPosition( player )
	local chatCol = ColShape.Sphere(x, y, z, 5)
	local nearPlayers = chatCol:getElementsWithin("player")
	if tip == 1 then
		for index, v in ipairs(nearPlayers) do
			v:outputChat("* ".._getPlayerNameR(player).." "..(texto or ""), 240, 0, 240, true)
		end
	else
		for index, v in ipairs(nearPlayers) do
			v:outputChat("#F000F0*".._getPlayerNameR(player).." "..(texto or ""), 240, 0, 240, true)
		end
	end
	if isElement(chatCol) then
		chatCol:destroy()
	end
end

function MensajeRol2(player, texto, tip )
	local x, y, z = getElementPosition( player )
	local chatCol = ColShape.Sphere(x, y, z, 5)
	local nearPlayers = chatCol:getElementsWithin("player")
	local ID = getElementData(player,"ID")
	if tip == 1 then
		for index, v in ipairs(nearPlayers) do
			v:outputChat("#22CC00* "..(texto or "").." | ".._getPlayerNameR(player).." ["..ID.."]", 240, 0, 240, true)
		end
	else
		for index, v in ipairs(nearPlayers) do
			v:outputChat("#22CC00* "..(texto or "").." | ".._getPlayerNameR(player).." ["..ID.."]", 240, 0, 240, true)
		end
	end
	if isElement(chatCol) then
		chatCol:destroy()
	end
end