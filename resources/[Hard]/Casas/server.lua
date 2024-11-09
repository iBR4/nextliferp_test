-- MySQL Housesystem created & released by Zeus, Do not remove credits! --
-- All Rights go to Zeus --

--[[ Total time token: 
	- 3 hour
	- 1.5 hour
	________
	4.5 hours
]]

------------------------
-- CONNECTION HANDLER --
------------------------

-- Here you can change some settings --
-- FIRST CONNECTION --

local mysqlhost1 = "192.99.152.26"

local mysqluser1 = "u35_D8BzZD6wFy"

local mysqlpassword1 = "e3!D0dT0Y0L1l=T+4W=db7FZ"

local mysqldatabase1 = "s35_onrp"


-- SECOND CONNECTION, OPTIONAL IF CONNECTION 1 DON'T WORK

local mysqlhost2 = "localhost"
local mysqluser2 = "root"
local mysqlpassword2 = ""
local mysqldatabase2 = "cassas"

local dbpTime = 1000 -- How many Miliseconds will use the dbPoll function for waiting for a result

local max_player_houses = 2 -- Define the buyable houses per player
local max_player_houses_vip = 3 -- Define the buyable houses per player VIP
local sellhouse_value = 80 -- The ammount in percent that you get back if you sell a house
local open_key = "H" -- Define the key for the infomenue and the housepanel
local leave_key = "F"
local enter_key = "F"
local close_door_key = "G"

-- I don't know whats the right time for that --

-----------------------------------------------------------------
-- IF YOU CAN'T WRITE IN LUA, DO NOT EDIT ANYTHING ABOVE HERE! --
-----------------------------------------------------------------

-- EVENTS --

addEvent("onHouseSystemHouseCreate", true)
addEvent("onHouseSystemHouseLock", true)
addEvent("onHouseSystemHouseDeposit", true)
addEvent("onHouseSystemHouseWithdraw", true)
-- addEvent("onHouseSystemWeaponDeposit", true)
-- addEvent("onHouseSystemWeaponWithdraw", true)
addEvent("onHouseSystemRentableSwitch", true)
addEvent("onHouseSystemRentalprice", true)
addEvent("onHouseSystemTenandRemove", true)
addEvent("onHouseSystemInfoBuy", true)
addEvent("onHouseSystemInfoRent", true)
addEvent("onHouseSystemInfoEnter", true)

local handler -- local only, we don't need a global handler

local saveableValues = {
	["ID"] = "ID",
	["X"] = "X",	
	["Y"] = "Y",
	["Z"] = "Z",
	["INTX"] = "INTX",
	["INTY"] = "INTY",
	["INTZ"] = "INTZ",
	["MONEY"] = "MONEY",
	["WEAP1"] = "WEAP1",
	["WEAP2"] = "WEAP2",
	["WEAP3"] = "WEAP3",
	["LOCKED"] = "LOCKED",
	["PRICE"] = "PRICE",
	["OWNER"] = "OWNER",
	["RENTABLE"] = "RENTABLE",
	["RENTALPRICE"] = "RENTALPRICE",
	["RENT1"] = "RENT1",
	["RENT2"] = "RENT2",
	["RENT3"] = "RENT3",
	["RENT4"] = "RENT4",
	["RENT5"] = "RENT5",
}


local created = false -- DONT EDIT
local houseid = 0 -- Define the Houseid, 

local house = {} -- The House array
local houseData = {} -- The House Data arry
local houseInt = {} -- The House Interior array
local houseIntData = {} -- The House Interior Data Array xD

local buildStartTick
local buildEndTick

local rentTimer

-- STARTUP EVENT HANDLER --

addEventHandler("onResourceStart", getResourceRootElement(), function()
	handler = dbConnect("sqlite", "houses.db")

	-- If the Handler 1 dont work
	if not(handler) then	
		outputServerLog("[HOUSESYSTEM]MySQL handler 1 not accepted! Trying secondary handler...")	
		handler = dbConnect("sqlite", "houses.db")
		if not(handler) then
			outputServerLog("[HOUSESYSTEM]MySQL handler 2 not accepted! Shutting down...")
			cancelEvent()
		else
			outputServerLog("[HOUSESYSTEM]MySQL handler 2 accepted!")
			housesys_startup()
		end
	else
		outputServerLog("[HOUSESYSTEM]MySQL handler 1 accepted!")
		housesys_startup()
	end
end)

-- SHUTDOWN EVENT HANDLER --
addEventHandler("onResourceStop", getResourceRootElement(), function()
	-- Free the arrays --
	for index, houses in pairs(house) do
		houses = nil
	end
	for index, houseDatas in pairs(houseData) do
		houseDatas = nil
	end
	for index, houseInts in pairs(houseInt) do
		houseInts = nil
	end
	for index, houseIntDatas in pairs(houseIntData) do
		houseIntDatas = nil
	end
	
	houseid = 0
	created = false
end)

--------------
-- COMMANDS --
--------------

-- /unrent --

addCommandHandler("desrentar", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local id = tonumber(getElementData(thePlayer, "house:lastvisit"))
		if(isPlayerRentedHouse(thePlayer, id) == false) then
			outputChatBox("You are not tenad of this house!", thePlayer, 255, 0, 0)
			return
		end
		local sucess = removeHouseTenand(id, thePlayer)
		if(sucess == true) then
			outputChatBox("Has terminado tu estancia!", thePlayer, 0, 255, 0)
		else
			outputChatBox("a ocurrido un error!", thePlayer, 255, 0, 0)
		end
	end
end)

-- /rent --

addCommandHandler("rentar", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local id = tonumber(getElementData(thePlayer, "house:lastvisit"))
		if(houseData[id]["OWNER"] == getAccountName(getPlayerAccount(thePlayer))) then
			outputChatBox("No puedes rentar ! Esta es tu casa!", thePlayer, 255, 0, 0)
			return
		end
		if(tonumber(houseData[id]["RENTABLE"]) ~= 1) then
			outputChatBox("Esta casa no es rentable!", thePlayer, 255, 0, 0)
			return
		end
		if(getPlayerRentedHouse(thePlayer) ~= false) then
			outputChatBox("Ya tienes una casa ! Usa /desrentar primero.", thePlayer, 255, 0, 0)
			return
		end
		local sucess = addHouseTenand(thePlayer, id)
		if(sucess == true) then
			outputChatBox("Ahora eres inquilino de esta casa!", thePlayer, 0, 255, 0)
		else
			outputChatBox("Tu no puedes rentar esta casa!", thePlayer, 255, 0, 0)
		end
	end
end)

-- /createhouse --

addCommandHandler("crearcasa", function(thePlayer)
	local cuenta = getAccountName(getPlayerAccount(thePlayer))	
	if isObjectInACLGroup ("user."..cuenta, aclGetGroup ( "Admin" ) ) then
		if(getElementInterior(thePlayer) ~= 0) then
			outputChatBox("You are not outside!", thePlayer, 255, 0, 0)
			return
		end
		if(isPedInVehicle(thePlayer) == true) then
			outputChatBox("Please exit your vehicle.", thePlayer, 255, 0, 0)
			return
		end
		-- INSERT SECURITY OPTIONS LIKE ADMINLEVEL HERE( if(adminlevel > shit) then ...)
		triggerClientEvent(thePlayer, "onClientHouseSystemGUIStart", thePlayer)
	else
		outputChatBox("Tu no eres admin!", thePlayer, 255, 0, 0)
	end
end)

-- /in --

function bindLeaveHouse ( player )
	executeCommandHandler("salir", player)
	triggerClientEvent (player, "BorrarFoto", player, "" ) 
end

function bindenterHouse ( player )
	executeCommandHandler("entrar", player)
	triggerClientEvent (player, "BorrarFoto", player, "" ) 
end

addCommandHandler("entrar", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisit")
		if(house) then
			local id = tonumber(house)
			if (houseData[id]["OWNER"] == getAccountName(getPlayerAccount(thePlayer))) or (isPlayerRentedHouse(thePlayer, id) == true) then
				if tonumber(houseData[id]["LOCKED"]) == 0 then
					local int, intx, inty, intz, dim = houseIntData[id]["INT"], houseIntData[id]["X"], houseIntData[id]["Y"], houseIntData[id]["Z"], id
					setElementData(thePlayer, "house:in", true)
					setInPosition(thePlayer, intx, inty, intz, int, false, dim)
					unbindKey(thePlayer, open_key, "down", togglePlayerInfomenue, id)
					setElementData(thePlayer, "house:lastvisitINT", id)
					if(houseData[id]["OWNER"] == getAccountName(getPlayerAccount(thePlayer))) or (isPlayerRentedHouse(thePlayer, id) == true) then
					bindKey(thePlayer, open_key, "down", togglePlayerHousemenue, id)
					end
					bindKey(thePlayer, leave_key, "down", bindLeaveHouse )
					unbindKey(thePlayer, enter_key, "down", bindenterHouse)
				else
					outputChatBox("La casa esta bloqueada", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Tu no tienes la llaves de esta casa!", thePlayer, 255, 0, 0)
			end
		end
	end
end)


function player_Spawn ( posX, posY, posZ, spawnRotation, theTeam, theSkin, theInterior, theDimension )
	if theDimension > 1 and theInterior > 0 then
		setElementData(source, "house:lastvisitINT", theDimension)
		bindKey(source, leave_key, "down", bindLeaveHouse )
	end
end
addEventHandler ( "onPlayerSpawn", getRootElement(), player_Spawn )

-- /out --

addCommandHandler("salir", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisitINT")) and (getElementData(thePlayer, "house:lastvisitINT") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisitINT")
		if house then
			if tonumber(houseData[tonumber(house)]["LOCKED"]) == 0 then
				local id = tonumber(house)
				local x, y, z = houseData[id]["X"], houseData[id]["Y"], houseData[id]["Z"]
				setElementData(thePlayer, "house:in", false)
				setInPosition(thePlayer, x, y, z, 0, false, 0)
				unbindKey(thePlayer, leave_key, "down", bindLeaveHouse)
				bindKey(thePlayer, enter_key, "down", bindenterHouse)
			else
				outputChatBox("La casa esta bloqueada", thePlayer, 255, 0, 0)
			end
		end
	end
end)


-- /buyhouse --

addCommandHandler("comprarcasa", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false) then
		local house = getElementData(thePlayer, "house:lastvisit")
		if(house) then
			local id = house
			local owner = houseData[id]["OWNER"]
			if(owner ~= "no-one") then
				outputChatBox("Tu no puedes comprar esta casa!", thePlayer, 255, 0, 0)
			else
				houses = 0
				for index, col in pairs(getElementsByType("colshape")) do
					if(getElementData(col, "house") == true) and (houseData[getElementData(col, "ID")]["OWNER"] == getAccountName(getPlayerAccount(thePlayer))) then
						houses = houses + 1
					end
					end
				end

				if exports["[LS]Donadores"]:isPlayerVIP(getAccountName(getPlayerAccount(thePlayer))) then
					max_houses_player = max_player_houses_vip
				else
					max_houses_player = max_player_houses
				end

				if houses == max_houses_player then
					outputChatBox("Tu ya tienes "..max_player_houses.." casa! Vende alguna para comprar esta.", thePlayer, 255, 0, 0)
					return
				end
				
				local money = getPlayerMoney(thePlayer)
				local price = houseData[id]["PRICE"]
				if(money < price) then outputChatBox("No tienes suficiente dinero! nesecitas "..(price-money).."$ mas!", thePlayer, 255, 0, 0) return end
				setHouseData(id, "OWNER", getAccountName(getPlayerAccount(thePlayer)))
				givePlayerMoney(thePlayer, -price)
				outputChatBox("Felicitaciones! Has comprado esta casa!", thePlayer, 0, 255, 0)
				setElementModel(houseData[id]["PICKUP"], 1272)
				-- setElementModel(houseData[id]["BLIP"], 32)
			end
		end

end)

-- /sellhouse --

addCommandHandler("vendercasa", function(thePlayer)
	if(getElementData(thePlayer, "house:lastvisit")) and (getElementData(thePlayer, "house:lastvisit") ~= false)  then
		local house = getElementData(thePlayer, "house:lastvisit")
		if(house) then
			local id = house
			local owner = houseData[id]["OWNER"]
			if(owner ~= getAccountName(getPlayerAccount(thePlayer))) then
				outputChatBox("Tu no puedes vender estas casa!", thePlayer, 255, 0, 0)
			else
				local price = houseData[id]["PRICE"]
				setHouseData(id, "OWNER", "no-one")
				setHouseData(id, "RENTABLE", 0)
				setHouseData(id, "RENTALPRICE", 0)
				for i = 1, 5, 1 do
					setHouseData(id, "RENT"..i, "no-one")
				end
				givePlayerMoney(thePlayer, math.floor(price/100*sellhouse_value))
				outputChatBox("Bien has vendido la casa por $"..math.floor(price/100*sellhouse_value).." back!", thePlayer, 0, 255, 0)
				setElementModel(houseData[id]["PICKUP"], 1273)
				-- setElementModel(houseData[id]["BLIP"], 31)
			end
		end
	end
end)

-- /deletehouse --

addCommandHandler("borrarcasa", function(thePlayer, cmd, id)
	if(hasObjectPermissionTo ( thePlayer, "function.kickPlayer", false ) ) then
		id = tonumber(id)
		if not(id) then return end
		if not(house[id]) then
			outputChatBox("There is no house with the ID "..id.."!", thePlayer, 255, 0, 0)
			return
		end
		local query = dbQuery(handler, "DELETE FROM houses WHERE ID = '"..id.."';")
		local result = dbPoll(query, dbpTime)
		if(result) then
			-- destroyElement(houseData[id]["BLIP"])
			destroyElement(houseData[id]["PICKUP"])
			destroyElement(houseIntData[id]["PICKUP"])
			houseData[id] = nil
			houseIntData[id] = nil
			destroyElement(house[id])
			destroyElement(houseInt[id])
			outputChatBox("House "..id.." destroyed sucessfully!", thePlayer, 0, 255, 0)
			house[id] = false
		else
			error("House ID "..id.." has been created Ingame, but House is not in the database! WTF")
		end
	else
		outputChatBox("You are not an admin!", thePlayer, 255, 0, 0)
	end
end)

-- /househelp --

addCommandHandler("ayudacasa", function(thePlayer)
	outputChatBox("/comprarcasa, /vendercasa, /rentar", thePlayer, 0, 255, 255)
	outputChatBox("/desrentar, /entrar, /salir", thePlayer, 0, 255, 255)
	outputChatBox("For Admins: /crearcasa, /borrarcasa [id]", thePlayer, 0, 255, 255)
end)

-- INSERT INTO dbs_housesystem.houses (X, Y, Z, INTERIOR, INTX, INTY, INTZ, MONEY, WEAP1, WEAP2, WEAP3) values("0.1", "0.1", "0.1", "5", "0.2", "0.2", "0.2", "2000", "46,1", "22,200", "25, 200")

--------------------
-- BIND FUNCTIONS --
--------------------

function togglePlayerInfomenue(thePlayer, key, state, id)
	if(id) then
		local locked = houseData[id]["LOCKED"]
		local rentable = houseData[id]["RENTABLE"]
		local rentalprice = houseData[id]["RENTALPRICE"] or 0
		local owner = houseData[id]["OWNER"]
		local price = houseData[id]["PRICE"]
		local x, y, z = getElementPosition(house[id])
		local house = getPlayerRentedHouse(thePlayer)
		if(house ~= false) then house = true end
		local isrentedin = isPlayerRentedHouse(thePlayer, id)
		triggerClientEvent(thePlayer, "onClientHouseSystemInfoMenueOpen", thePlayer, owner, x, y, z, price, locked, rentable, rentalprice, id, house, isrentedin)
	end
end

function togglePlayerHousemenue(thePlayer, key, state, id)
	if(id) then
		if(getElementInterior(thePlayer) ~= 0) then
			local locked = houseData[id]["LOCKED"]
			local money = houseData[id]["MONEY"]
			local weap1 = ""
			local weap2 = ""
			local weap3 = ""
			local rentable = houseData[id]["RENTABLE"]
			local rent = houseData[id]["RENTALPRICE"]
			local tenands = getHouseTenands(id)
			local owner = false
			if(getAccountName(getPlayerAccount(thePlayer)) == houseData[id]["OWNER"]) then
				owner = true
			end
			local canadd = canAddHouseTenand(id)
			triggerClientEvent(thePlayer, "onClientHouseSystemMenueOpen", thePlayer, owner, locked, money, weap1, weap2, weap3, id, rentable, rent, tenands, canadd)
		end
	else
		triggerClientEvent(thePlayer, "onClientHouseSystemMenueOpen", thePlayer )
	end
end

-------------------------------
-- HOUSE CREATION ON STARTUP --
-------------------------------

-- BUILDHOUSE FUNCTION --

local function buildHouse(id, x, y, z, interior, intx, inty, intz, money, weapons, locked, price, owner, rentable, rentalprice, rent1, rent2, rent3, rent4, rent5)
	if(id) and (x) and(y) and (z) and (interior) and (intx) and (inty) and (intz) and (money) then
		houseid = id
		house[id] = createColSphere(x, y, z, 1.5) -- This is the house, hell yeah
		houseData[id] = {} 
		local house = house[id] -- I'm too lazy...
		setElementData(house, "house", true) -- Just for client code only 

		--local houseIntPickup = createPickup(intx, inty, intz, 3, 1318, 100)
		--setElementInterior(houseIntPickup, interior)
		--setElementDimension(houseIntPickup, id)
		
		houseInt[id] = createColSphere(intx, inty, intz, 1.5) -- And this is the Exit
		setElementInterior(houseInt[id], interior)
		setElementDimension(houseInt[id], id) -- The House Dimension is the house ID
		setElementData(houseInt[id], "house", false)
		--------------------
		-- EVENT HANDLERS --
		--------------------
	
		-- IN --
		addEventHandler("onColShapeHit", house, function(hitElement)
			if(getElementType(hitElement) == "player") then
				setElementData(hitElement, "house:lastvisit", id)
				bindKey(hitElement, enter_key, "down", bindenterHouse,id )
				bindKey(hitElement, open_key, "down", togglePlayerInfomenue, id)
				bindKey(hitElement, close_door_key, "down", close_and_open_door, id)
				triggerClientEvent ( hitElement, "onGreeting", hitElement, "" ) 
			end
		end)
		
		addEventHandler("onColShapeLeave", house, function(hitElement)
			if(getElementType(hitElement) == "player") then
				setElementData(hitElement, "house:lastvisit", false)
				unbindKey(hitElement,enter_key,"down",bindenterHouse)
				unbindKey(hitElement, open_key, "down", togglePlayerInfomenue, id)
				unbindKey(hitElement, close_door_key, "down", close_and_open_door, id)
				triggerClientEvent ( hitElement, "BorrarFoto", hitElement, "" ) 
			end
		end)
		
		-- OUT --
		
		addEventHandler("onColShapeHit", houseInt[id], function(hitElement, dim)
			if(dim == true) then
				if(getElementType(hitElement) == "player") then
					unbindKey(hitElement, open_key, "down", togglePlayerInfomenue, id)
					setElementData(hitElement, "house:lastvisitINT", id)
					if(houseData[id]["OWNER"] == getAccountName(getPlayerAccount(hitElement))) or (isPlayerRentedHouse(hitElement, id) == true) then
						bindKey(hitElement, enter_key, "down", bindenterHouse ,id)
						bindKey(hitElement, open_key, "down", togglePlayerHousemenue, id)-- id casa
						bindKey(hitElement, close_door_key, "down", close_and_open_door, id)-- id casa
						triggerClientEvent (hitElement, "onGreeting", hitElement, "" ) 
					end
					--outputChatBox(id)
				end
			end
		end)
		
		addEventHandler("onColShapeLeave", houseInt[id], function(hitElement, dim)
			if(dim == true) then
				if(getElementType(hitElement) == "player") then
					setElementData(hitElement, "house:lastvisitINT", false)
					if(houseData[id]["OWNER"] == getAccountName(getPlayerAccount(hitElement))) or (isPlayerRentedHouse(hitElement, id) == true) then
						unbindKey(hitElement, enter_key, "down", bindenterHouse)
						unbindKey(hitElement, open_key, "down", togglePlayerHousemenue, id)
						unbindKey(hitElement, close_door_key, "down", close_and_open_door, id)
						triggerClientEvent ( hitElement, "BorrarFoto", hitElement, "" ) 
					end
					--outputChatBox(id)
				end
			end
		end)
		
		-- Set data for HOUSE --
		houseData[id]["HOUSE"] = house
		houseData[id]["DIM"] = id
		houseData[id]["MONEY"] = money
		-- houseData[id]["WEAPONS"] = weapons
		houseData[id]["INTHOUSE"] = houseInt[id]
		houseData[id]["LOCKED"] = locked
		houseData[id]["PRICE"] = price
		houseData[id]["OWNER"] = owner
		houseData[id]["X"] = x
		houseData[id]["Y"] = y
		houseData[id]["Z"] = z
		houseData[id]["RENTABLE"] = rentable
		houseData[id]["RENTALPRICE"] = rentalprice
		houseData[id]["RENT1"] = rent1
		houseData[id]["RENT2"] = rent2
		houseData[id]["RENT3"] = rent3
		houseData[id]["RENT4"] = rent4
		houseData[id]["RENT5"] = rent5
		-- HOUSE PICKUP --
		local housePickup
		if(owner ~= "no-one") then
			housePickup = createPickup(x, y, z-0.5, 3, 1272, 0)
		else
			housePickup = createPickup(x, y, z-0.5, 3, 1273, 0)
		end
		-- HOUSE BLIP --
		local houseBlip
		if(owner ~= "no-one") then
			-- houseBlip =  createBlip ( x, y, z, 32, 2, 255, 0, 0, 255, 0, 16383.0)
		else
			-- houseBlip =  createBlip ( x, y, z, 31, 2, 255, 0, 0, 255, 0, 16383.0)
		end
		-- SET THE DATA --
		houseData[id]["PICKUP"] = housePickup
		-- houseData[id]["BLIP"] = houseBlip
		
		setElementData(house, "PRICE", price)
		setElementData(house, "OWNER", owner)
		setElementData(house, "LOCKED", locked)
		setElementData(house, "ID", id)
		setElementData(house, "RENTABLE", rentable)
		setElementData(house, "RENTALPRICE", rentalprice)
		
		-- SET DATA FOR HOUSEINTERIOR --
		houseIntData[id] = {}
		houseIntData[id]["OUTHOUSE"] = houseData[id]["HOUSE"]
		houseIntData[id]["INT"] = interior
		houseIntData[id]["X"] = intx
		houseIntData[id]["Y"] = inty
		houseIntData[id]["Z"] = intz
		houseIntData[id]["PICKUP"] = houseIntPickup
		outputServerLog("House with ID "..id.." created sucessfully!")
		buildEndTick = getTickCount()
		-- TRIGGER TO ALL CLIENTS THAT THE HOUSE HAS BEEN CREATEEEEEEEEEEEEEEEEEEEEEEED --
		setTimer(triggerClientEvent, 1000, 1, "onClientHouseSystemColshapeAdd", getRootElement(), house)
	else
		if not(id) then
			error("Arguments @buildHouse not valid! There is no Houseid!")
		else
			error("Arguments @buildHouse not valid! Houseid = "..id)
		end
	end	
end

-- TAKE PLAYER RENT --

local function takePlayerRent()
	for index, player in pairs(getElementsByType("player")) do
		if(getPlayerRentedHouse(player) ~= false) then
			local id = getPlayerRentedHouse(player)
			local owner = houseData[id]["OWNER"]
			local rentable = tonumber(houseData[id]["RENTABLE"])
			if(rentable == 1) then
				local rentprice = tonumber(houseData[id]["RENTALPRICE"])
				takePlayerMoney(player, rentprice) -- Takes the player money for the rent
				outputChatBox("You paid $"..rentprice.." rentalprice!", player, 255, 255, 0)
				if(getPlayerFromName(owner)) then
					givePlayerMoney(getPlayerFromName(owner), rentprice) -- Gives the owner the rentalprice
					outputChatBox("You got $"..rentprice.." from a tenand of your house!", getPlayerFromName(owner), 255, 255, 0)
				end
			end
		end
	end
end

-- HOUSE DATABASE EXECUTION --

function housesys_startup()
	if(created == true) then
		error("Houses Allready created!")
		return
	end
	buildStartTick = getTickCount()
	local query = dbQuery(handler, "SELECT * FROM houses;" )
	local result, numrows = dbPoll(query, dbpTime)
	if (result and numrows > 0) then
		for index, row in pairs(result) do
			local id = row['ID']
			local x, y, z = row['X'], row['Y'], row['Z']
			local int, intx, inty, intz = row['INTERIOR'], row['INTX'], row['INTY'], row['INTZ']
			local money, weap1, weap2, weap3 = row['MONEY'], row['WEAP1'], row['WEAP2'], row['WEAP3']
			local locked = row['LOCKED']
			local price = row['PRICE']
			local owner = row['OWNER']
			local rentable = row['RENTABLE']
			local rentalprice = row['RENTALPRICE']
			local rent1, rent2, rent3, rent4, rent5 = row['RENT1'],row['RENT2'], row['RENT3'], row['RENT4'], row['RENT5']
			local weapontable = {}
			weapontable[1] = "weap1"
			weapontable[2] = "weap2"
			weapontable[3] = "weap3"
			buildHouse(id, x, y, z, int, intx, inty, intz, money, weapontable, locked, price, owner, rentable, rentalprice, rent1, rent2, rent3, rent4, rent5)
		end
		dbFree(query)
	else
		error("Houses Table not Found/empty!")
	end
	created = true
	setTimer(function()
		local elapsed = (buildEndTick-buildStartTick)
		outputServerLog("It took "..(elapsed/1000).." seconds to build all houses.")
	end, 1000, 1)
	rentTimer = setTimer(takePlayerRent, 60*60*1000, 0)
end

-- House Data array set --

function setHouseData(ID, typ, value)
	-- Security array -- 
	houseData[ID][typ] = value
	setElementData(house[ID], typ, value)
	if(saveableValues[typ]) then
		local query = dbQuery(handler, "UPDATE houses SET "..saveableValues[typ].." = '"..value.."' WHERE ID = '"..ID.."';" )
		local result = dbPoll(query, dbpTime)
		if(result) then
			dbFree(query)
		else
			error("Can't save Data: "..typ.." with the value: "..value.." for house ID "..ID.."!")
		end
	end
end


--------------------
-- EVENT HANDLERS --
--------------------

-- INFO RENT -

addEventHandler("onHouseSystemInfoRent", getRootElement(), function(id, value)
	if(houseData[id]) then
		if(value == true) then
			executeCommandHandler("rentar", source)
		else
			executeCommandHandler("desrentar", source)
		end
	end
end)


-- INFO ENTER --

addEventHandler("onHouseSystemInfoEnter", getRootElement(), function(id)
	if(houseData[id]) then
		executeCommandHandler("entrar", source)
	end
end)

-- INFO BUY --
addEventHandler("onHouseSystemInfoBuy", getRootElement(), function(id, value)
	if(houseData[id]) then
		if(value == true) then
			executeCommandHandler("comprarcasa", source)
		else
			executeCommandHandler("vendercasa", source)
		end
	end
end)


-- TENAND REMOVE --

addEventHandler("onHouseSystemTenandRemove", getRootElement(), function(id, value)
	if(houseData[id]) then
		local sucess = removeHouseTenand(id, value)
		if(sucess == true) then
			outputChatBox("You sucessfull removed the tenand "..value.."!", source, 0, 255, 0)
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "TENANDS", getHouseTenands(id))
		end
	end
end)

-- SET RENTALPRICE --

addEventHandler("onHouseSystemRentalprice", getRootElement(), function(id, value)
	if(houseData[id]) then
		local oldvalue = tonumber(houseData[id]["RENTALPRICE"])
		if(oldvalue < value) then
			local tenands = getHouseTenands(id)
			local users = {}
			for i = 1, 5, 1 do
				if(tenands[i] ~= "no-one") then
					users[i] = tenands[i]
				end
			end
			if(#users > 0) then
				outputChatBox("You can't change the rentalprice to a highter value because there are tenands in your house!", source, 255, 0, 0)
				return
			end
		end
		setHouseData(id, "RENTALPRICE", value)
		outputChatBox("You sucessfull set the rentalprice to $"..value.."!", source, 0, 255, 0)
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "RENTALPRICE", value)
	end
end)

-- RENTABLE SWITCH --
addEventHandler("onHouseSystemRentableSwitch", getRootElement(), function(id)
	if(houseData[id]) then
		local state = tonumber(houseData[id]["RENTABLE"])
		if(state == 0) then
			setHouseData(id, "RENTABLE", 1)
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "RENTABLE", true)
			outputChatBox("The house is now rentable!", source, 0, 255, 0)
		else
			setHouseData(id, "RENTABLE", 0)
			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "RENTABLE", false)
			outputChatBox("The house is no longer rentable!", source, 0, 255, 0)
		end
	end
end)


-- CREATE HOUSE --

addEventHandler("onHouseSystemHouseCreate", getRootElement(), function(x, y, z, int, intx, inty, intz, price)
	local query = dbQuery(handler, "INSERT INTO houses (X, Y, Z, INTERIOR, INTX, INTY, INTZ, PRICE, MONEY, OWNER, RENTALPRICE, RENT1, RENT2, RENT3, RENT4, RENT5) values ('"..x.."', '"..y.."', '"..z.."', '"..int.."', '"..intx.."', '"..inty.."', '"..intz.."', '"..price.."', 0, 'no-one', 0, 'no-one', 'no-one', 'no-one', 'no-one', 'no-one');")
	local result, numrows = dbPoll(query, dbpTime)
	if(result) then
		local newid = houseid+1
		outputChatBox("House "..newid.." created sucessfully!", source, 0, 255, 0)
		local weapontable = {}
		weapontable[1] = 0
		weapontable[2] = 0
		weapontable[3] = 0
		buildHouse(newid, x, y, z, int, intx, inty, intz, 0, weapontable, 0, price, "no-one", 0, 0, "no-one", "no-one", "no-one", "no-one", "no-one")
	else
		outputChatBox("An Error occurred while creating the house!", source, 255, 0, 0)
		error("House "..(houseid+1).." could not create!")
	end
end)

-- WITHDRAW WEAPON --

-- addEventHandler("onHouseSystemWeaponWithdraw", getRootElement(), function(id, value)
-- 	local weapons = houseData[id]["WEAPONS"]
-- 	if(gettok(weapons[value], 1, ",")) then
-- 		local weapon, ammo = gettok(weapons[value], 1, ","), gettok(weapons[value], 2, ",")
-- 		giveWeapon(source, weapon, ammo, true)
-- 		outputChatBox("You sucessfull withdraw your weapon slot "..value.."!", source, 0, 255, 0)
-- 		weapons[value] = 0
-- 		setHouseData(id, "WEAPONS", weapons)
-- 		setHouseData(id, "WEAP1", weapons[1])
-- 		setHouseData(id, "WEAP2", weapons[2])
-- 		setHouseData(id, "WEAP3", weapons[3])
-- 		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "WEAPON", value, 0)
-- 	end
-- end)

-- DEPOSIT WEAPON --


-- addEventHandler("onHouseSystemWeaponDeposit", getRootElement(), function(id, value)
-- 	local weapons = houseData[id]["WEAPONS"]
-- 	if(tonumber(weapons[value]) == 0) then
-- 		local weapon = getPedWeapon(source)
-- 		local ammo = getPedTotalAmmo(source)
-- 		if(weapon) and (ammo) and(weapon ~= 0) and (ammo ~= 0) then 
-- 			weapons[value] = weapon..", "..ammo
-- 			takeWeapon(source, weapon)
-- 			outputChatBox("You sucessfull deposit your weapon "..getWeaponNameFromID(weapon).." into your weaponbox!", source, 0, 255, 0)
-- 			setHouseData(id, "WEAPONS", weapons)
-- 			setHouseData(id, "WEAP1", weapons[1])
-- 			setHouseData(id, "WEAP2", weapons[2])
-- 			setHouseData(id, "WEAP3", weapons[3])
-- 			triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "WEAPON", value, weapons[value])
-- 		else
-- 			outputChatBox("You don't have a weapon!", source, 255, 0, 0)
-- 		end
-- 	else
-- 		outputChatBox("There is allready a weapon in that slot!", source, 255, 0, 0)
-- 	end
-- end)

-- LOCK HOUSE --

addEventHandler("onHouseSystemHouseLock", getRootElement(), function(id)
	local state = tonumber(houseData[id]["LOCKED"])
	if(state == 1) then
		setHouseData(id, "LOCKED", 0)
		outputChatBox("The house has been unlocked.", source, 0, 255, 0)
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "LOCKED", 0)
	else
		setHouseData(id, "LOCKED", 1)
		outputChatBox("The house has been locked!", source, 0, 255, 255)
		triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "LOCKED", 1)
	end
end)

function close_and_open_door(player, key, state, id)
	if houseData[id]["OWNER"] == getAccountName(getPlayerAccount(player)) then
		local state = tonumber(houseData[id]["LOCKED"])
		if(state == 1) then
			setHouseData(id, "LOCKED", 0)
			outputChatBox("The house has been unlocked.", source, 0, 255, 0)
		else
			setHouseData(id, "LOCKED", 1)
			outputChatBox("The house has been locked!", source, 0, 255, 255)
		end
	end
end

-- DEPOSIT MONEY --

addEventHandler("onHouseSystemHouseDeposit", getRootElement(), function(id, value)
	if(value > getPlayerMoney(source)-1) then return end
	setHouseData(id, "MONEY", tonumber(houseData[id]["MONEY"])+value)
	outputChatBox("You sucessfull insert "..value.."$ into your cashbox!", source, 0, 255, 0)
	triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "MONEY", tonumber(houseData[id]["MONEY"]))
	givePlayerMoney(source, -value)
end)

-- WITHDRAW MONEY --

addEventHandler("onHouseSystemHouseWithdraw", getRootElement(), function(id, value)
	local money = tonumber(houseData[id]["MONEY"])
	if(money < value) then
		outputChatBox("You don't have so much money in your cashbox!", source, 255, 0, 0)
		return
	end
	setHouseData(id, "MONEY", tonumber(houseData[id]["MONEY"])-value)
	outputChatBox("You sucessfull toke "..value.."$ out of your cashbox!", source, 0, 255, 0)
	triggerClientEvent(source, "onClientHouseSystemMenueUpdate", source, "MONEY", money-value)
	givePlayerMoney(source, value)
end)


----------------------------
-- SETTINGS AND FUNCTIONS --
----------------------------


-- FADE PLAYERS POSITION --
local fadeP = {}
function setInPosition(thePlayer, x, y, z, interior, typ, dim)
	if not(thePlayer) then return end
	if (getElementType(thePlayer) == "vehicle") then return end
	if(isPedInVehicle(thePlayer)) then return end
	if not(x) or not(y) or not(z) then return end
	if not(interior) then interior = 0 end
	if(fadeP[thePlayer] == 1) then return end
	fadeP[thePlayer] = 1
	fadeCamera(thePlayer, false)
	setElementFrozen(thePlayer, true)
	setTimer(
		function()
		fadeP[thePlayer] = 0
		setElementPosition(thePlayer, x, y, z)
		setElementInterior(thePlayer, interior)
		if(dim) then setElementDimension(thePlayer, dim) end
		fadeCamera(thePlayer, true)
		if not(typ) then
			setElementFrozen(thePlayer, false)
		else
			if(typ == true)  then
				setTimer(setElementFrozen, 1000, 1, thePlayer, false)
			end
		end
	end, 1000, 1)
end


-- canAddHouseTenand
-- Checks if there is a free slot in the house

function canAddHouseTenand(id)
	if not(houseData[id]) then return false end
	for i = 1, 5, 1 do
		local name = houseData[id]["RENT"..i]
		if(name == "no-one") then
			return true, i
		end
	end
	return false;
end

-- addHouseTenand
-- Adds a player to a house as tenand

function addHouseTenand(player, id)
	if not(houseData[id]) then return false end
	for i = 1, 5, 1 do
		local name = houseData[id]["RENT"..i]
		if(name == "no-one") then
			setHouseData(id,"RENT"..i, getAccountName(getPlayerAccount(player)))
			return true, i
		end
	end
	return false;
end

-- removeHouseTenand
-- Removes a player from a house

function removeHouseTenand(id, player)
	if not(houseData[id]) then return false end
	if(type(player) == "string") then
		for i = 1, 5, 1 do
			local name = houseData[id]["RENT"..i]
			if(name == player) then
				setHouseData(id,"RENT"..i,"no-one")
				return true
			end
		end
	else
		for i = 1, 5, 1 do
			local name = houseData[id]["RENT"..i]
			if(name == getAccountName(getPlayerAccount(player))) then
				setHouseData(id,"RENT"..i,"no-one")
				return true
			end
		end
	end
	return false;
end

-- getHouseTenands(houseid)
-- Returns a table within all tenands in this house 

function getHouseTenands(id)
	if not(houseData[id]) then return false end
	local rent = {}
	for i = 1, 5, 1 do
		rent[i] = houseData[id]["RENT"..i]
	end
	return rent;
end

-- getPlayerRentedHouse
-- Gets the House where a player is rented in --

function getPlayerRentedHouse(thePlayer)
	for index, house in pairs(getElementsByType("colshape")) do
		if(getElementData(house, "house") == true) and (getElementData(house, "ID")) then
			local id = tonumber(getElementData(house, "ID"))
			if not(id) then return false end
			local rent = {}
			for i = 1, 5, 1 do
				rent[i] = houseData[id]["RENT"..i]
			end
			for index, player in pairs(rent) do
				if(player == getAccountName(getPlayerAccount(thePlayer))) then
					return id;
				end
			end
		end
	end
	return false;
end

-- isPlayerRentedHouse
-- Checks if a player is rented in a specific house

function isPlayerRentedHouse(thePlayer, id)
	if not(houseData[id]) then return false end
	local rent = {}
	for i = 1, 5, 1 do
		rent[i] = houseData[id]["RENT"..i]
	end
	for index, player in pairs(rent) do
		if(player == getAccountName(getPlayerAccount(thePlayer))) then
			return true;
		end
	end
	return false;
end