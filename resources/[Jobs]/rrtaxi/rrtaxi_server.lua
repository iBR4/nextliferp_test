addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
    function()
		--chauffeurSkins = { [253]=true, [255]=true }
		taxis = { [420]=true, [438]=true }
		playerClients = { }
		playerCols = { }
		playerBlips = { }
		jobClients = { }
		playerJobLocation = {  };
		local XMLTaxiLocations = xmlLoadFile ( "XML\\taxi_locations.xml" )
		if ( not XMLTaxiLocations ) then
			local XMLTaxiLocations = xmlCreateFile ( "XML\\taxi_locations.xml", "taxi_locations" )
			xmlSaveFile ( XMLTaxiLocations )
		end
		
		local taxi_locations = xmlNodeGetChildren(XMLTaxiLocations)
        taxiLocations = {}
        for i,node in ipairs(taxi_locations) do
			taxiLocations[i] = {}
			taxiLocations[i]["x"] = xmlNodeGetAttribute ( node, "posX" )
			taxiLocations[i]["y"] = xmlNodeGetAttribute ( node, "posY" )
			taxiLocations[i]["z"] = xmlNodeGetAttribute ( node, "posZ" )
			taxiLocations[i]["r"] = xmlNodeGetAttribute ( node, "rot" )
        end
        xmlUnloadFile ( XMLTaxiLocations )
    end
)
 
--[[function enterVehicle ( thePlayer, seat, jacked )
    if ( taxis[getElementModel ( source )] ) and ( not chauffeurSkins[getElementModel ( thePlayer )] ) and (seat == 0) then 
		cancelEvent()
        outputChatBox ( "#ffff00[Taxista]#ffffff No eres taxista, no puedes conducir!", thePlayer )
    end
end
addEventHandler ( "onVehicleStartEnter", getRootElement(), enterVehicle )]]

function startJob ( playerSource )
	local x, y, z = getElementPosition ( playerSource )
	if (getElementData(playerSource,"Roleplay:trabajo") == "Taxista") or (getElementData(playerSource,"Roleplay:trabajoVIP") == "Taxista") then
		if not playerClients[ playerSource ] then
			local numLocations = #taxiLocations
			if ( numLocations > 0 ) then
				repeatCount = 0;
				repeat
					local pickupPoint = math.random(numLocations)
					pickupx = taxiLocations[pickupPoint]["x"]
					pickupy = taxiLocations[pickupPoint]["y"]
					pickupz = taxiLocations[pickupPoint]["z"]
					pickupr = taxiLocations[pickupPoint]["r"]
					local jobDistance = getDistanceBetweenPoints3D ( x, y, z, pickupx, pickupy, pickupz );
					repeatCount = repeatCount+1
				until jobDistance > 100 and jobDistance < 800 + repeatCount*100
				
				repeat 
					local id = math.random( 10, 270 ) 
					ped = createPed( tonumber( id ), pickupx, pickupy, pickupz ) 
					setPedRotation ( ped, pickupr )
				until ped
				
				playerClients[ playerSource ] = {  };
				table.insert( playerClients[ playerSource ], ped );
				table.insert( jobClients, ped );
				
				local pedBlip = createBlipAttachedTo ( ped, 41, 2, 255, 0, 0, 255, 1, 99999.0, playerSource)
				playerBlips[ playerSource ] = {  };
				table.insert( playerBlips[ playerSource ], pedBlip );
				
				pedMarker = createMarker ( pickupx, pickupy, 0, cylinder, 6.5, 255, 255, 0, 150, playerSource)
				playerCols[ playerSource ] = {  };
				table.insert( playerCols[ playerSource ], pedMarker );
				addEventHandler( "onMarkerHit", pedMarker, arrivePickup )
				outputChatBox ( "#ffff00[Taxista]#ffffff Activaste tu radio, comenzaste a recibir llamados.", playerSource ,0,0,0,true);
				outputChatBox ( " ", playerSource ,0,0,0,true);
				outputChatBox ( "#ffff00[Taxista]#ffffff Recibiste un llamado, en tu GPS se marco con un icono rojo tu destino", playerSource ,0,0,0,true);
			else
				outputChatBox ( "#ffff00[Taxista]#ffffff No hay pasajeros disponibles, contacta con un administrador", playerSource ,0,0,0,true);
				--exports.infobox:addNotification(playerSource,"No hay pasajeros disponibles, contacta con un administrador", "error")
			end
		else
			outputChatBox ( "#ffff00[Taxista]#ffffff Ya tienes un pasajero pendiente", source ,0,0,0,true);
			--exports.infobox:addNotification(source,"Ya tienes un pasajero pendiente", "error")

		end
		
	else
		outputChatBox ( "#ffff00[Taxista]#ffffff No tienes este trabajo", source ,0,0,0,true);
		--exports.infobox:addNotification(source,"No tienes este trabajo", "error")

	end
end
addCommandHandler ("iniciartaxi", startJob);

function arrivePickup ( playerSource )
	if playerClients[ playerSource ] then
		for k, ped in pairs( playerClients[ playerSource ] ) do
			if ped then
				local x,y,z 	= getElementPosition(ped);
				local tx,ty,tz 	= getElementPosition(playerSource);
				setPedRotation(ped, findRotation(x,y,tx,ty) );
				local numLocations = #taxiLocations
				if ( numLocations > 0 ) then
					local playerVehicle = getPedOccupiedVehicle ( playerSource );
					if playerVehicle and taxis[getElementModel ( playerVehicle )] then
						local speedx, speedy, speedz = getElementVelocity ( playerSource );
						local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5);
						if actualspeed < 0.25 then
							local occupants = getVehicleOccupants(playerVehicle);
							local seats = getVehicleMaxPassengers(playerVehicle);
							local freeSeats = 0;
							for seat = 0, seats do
								local occupant = occupants[seat];
								if not occupant and tonumber(freeSeats) == 0 then
									freeSeats = freeSeats + 1;
									warpPedIntoVehicle ( ped, playerVehicle, seat );
									if playerBlips[ playerSource ] then
										for k, blip in pairs( playerBlips[ playerSource ] ) do
											if blip then
												destroyElement( blip );
												playerBlips[ playerSource ] = nil;
											end
										end
									end
									if playerCols[ playerSource ] then
										for k, col in pairs( playerCols[ playerSource ] ) do
											if col then
												destroyElement( col );
												playerCols[ playerSource ] = nil;
											end
										end
									end
									
									playerJobLocation[ playerSource ] = {  };
									playerJobLocation[ playerSource ] = { ["x"]=x, ["y"]=y, ["z"]=z };

									repeat
										local dropOffPoint = math.random(numLocations)
										dropOffx = taxiLocations[dropOffPoint]["x"]
										dropOffy = taxiLocations[dropOffPoint]["y"]
										dropOffz = taxiLocations[dropOffPoint]["z"]
										local jobDistance = getDistanceBetweenPoints3D ( x, y, z, dropOffx, dropOffy, dropOffz );
									until jobDistance > 1000 and jobDistance < 35000

									local dropOffBlip = createBlip ( dropOffx, dropOffy, dropOffz, 41, 2, 255, 0, 0, 255, 1, 99999.0, playerSource)
									playerBlips[ playerSource ] = {  };
									table.insert( playerBlips[ playerSource ], dropOffBlip );
									
									pedMarker = createMarker ( dropOffx, dropOffy, 0, cylinder, 6.5, 255, 255, 0, 150, playerSource)
									playerCols[ playerSource ] = {  };
									table.insert( playerCols[ playerSource ], pedMarker );
									addEventHandler( "onMarkerHit", pedMarker, arriveDropOff )
									outputChatBox ( "#ffff00[Taxista]#ffffff Acabas de recojer al NPC, Llevalo al destino de tu GPS", playerSource ,0,0,0,true);
									--exports.infobox:addNotification(playerSource,"Acabas de recojer al NPC, Llevalo al destino de tu GPS", "info")
								end
							end
							if tonumber(freeSeats) == 0 then
								outputChatBox ( "#ffff00[Taxista]#ffffff No tienes asientos libres para el NPC", playerSource ,0,0,0,true);
								--exports.infobox:addNotification(playerSource,"No tienes asientos libres para el NPC", "error")
							end
						else
							outputChatBox ( "#ffff00[Taxista]#ffffff Reduce la velocidad, no podras subir al NPC", playerSource ,0,0,0,true);
							--exports.infobox:addNotification(playerSource,"Reduce la velocidad, no podras subir al NPC", "error")

						end
					else
						outputChatBox ( "#ffff00[Taxista]#ffffff Tu no eres el conductor del vehiculo", playerSource ,0,0,0,true);
						--exports.infobox:addNotification(playerSource,"Tu no eres el conductor del vehiculo", "error")

					end
				else
					outputChatBox ( "#ffff00[Taxista]#ffffff No hay pasajeros disponibles, contacta con un administrador", playerSource ,0,0,0,true);
					--exports.infobox:addNotification(playerSource,"No hay pasajeros disponibles, contacta con un administrador", "error")
				end
			end
		end
	end
end

function arriveDropOff ( playerSource )
	if playerClients[ playerSource ] then
		for k, ped in pairs( playerClients[ playerSource ] ) do
			if ped then
				local pedVehicle = getPedOccupiedVehicle ( ped );
				local playerVehicle = getPedOccupiedVehicle ( playerSource );
				if playerVehicle and taxis[getElementModel ( playerVehicle )] then
					if pedVehicle == playerVehicle then
						local speedx, speedy, speedz = getElementVelocity ( playerSource );
						local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5);
						if actualspeed < 0.22 then
							removePedFromVehicle ( ped );
							if playerClients[ playerSource ] then
								for k, ped in pairs( playerClients[ playerSource ] ) do
									if ped then
										destroyElement( ped );
										playerClients[ playerSource ] = nil;
									end
								end
								for k, blip in pairs( playerBlips[ playerSource ] ) do
									if blip then
										destroyElement( blip );
										playerBlips[ playerSource ] = nil;
									end
								end
								for k, col in pairs( playerCols[ playerSource ] ) do
									if col then
										destroyElement( col );
										playerCols[ playerSource ] = nil;
									end
								end
								dx = tonumber(playerJobLocation[ playerSource ]["x"]);
								dy = tonumber(playerJobLocation[ playerSource ]["y"]);
								dz = tonumber(playerJobLocation[ playerSource ]["z"]);
								local tx,ty,tz 	= getElementPosition(playerSource);
								local jobDistance = getDistanceBetweenPoints3D ( dx, dy, dz, tx, ty, tz );		
								local jobDistanceKM = round(jobDistance/1000,2);
								local jobReward = round(300+(jobDistanceKM^0.75)*100);
								givePlayerMoney ( playerSource, jobReward );
								
								for k, jobLocation in pairs( playerJobLocation[ playerSource ] ) do
									if jobLocation then
										playerJobLocation[ playerSource ] = nil;
									end
								end
								outputChatBox ( "#ffff00[Taxista]#ffffff Llevaste al NPC a su destino, recibiste #1E6800$"..jobReward.." #ffffffdolares.", playerSource ,0,0,0,true);
								--exports.infobox:addNotification(playerSource,"Llevaste al NPC a su destino, recibiste $"..jobReward.." pesos, para continuar trabajando /iniciartaxi", "success")
							end
						else
							outputChatBox ( "#ffff00[Taxista]#ffffff Ve mas despacio para bajar al NPC", playerSource ,0,0,0,true);
					--exports.infobox:addNotification(playerSource,"Ve mas despacio para bajar al NPC", "error")

						end
					else
						outputChatBox ( "#ffff00[Taxista]#ffffff No tienes ningun NPC", playerSource ,0,0,0,true);
					--exports.infobox:addNotification(playerSource,"No tienes ningun NPC", "error")

					end
				else
					outputChatBox ( "#ffff00[Taxista]#ffffff No eres el conductor del vehiculo", playerSource ,0,0,0,true);
					--exports.infobox:addNotification(playerSource,"No eres el conductor del vehiculo", "error")

				end
			end
		end
	end
end

function quitJob ( playerSource )
	if playerClients[ playerSource ] then
		for k, ped in pairs( playerClients[ playerSource ] ) do
			if ped then
				destroyElement( ped );
				playerClients[ playerSource ] = nil;
			end
		end
		for k, blip in pairs( playerBlips[ playerSource ] ) do
			if blip then
				destroyElement( blip );
				playerBlips[ playerSource ] = nil;
			end
		end
		for k, col in pairs( playerCols[ playerSource ] ) do
			if col then
				destroyElement( col );
				playerCols[ playerSource ] = nil;
			end
		end
		if playerJobLocation[ playerSource ] then
			for k, jobLocation in pairs( playerJobLocation[ playerSource ] ) do
				if jobLocation then
					destroyElement( jobLocation );
					playerJobLocation[ playerSource ] = nil;
				end
			end
		end
	outputChatBox ( "#ffff00[Taxista]#ffffff Cancelaste el trabajo, no te llegaran llamadas", playerSource ,0,0,0,true);
	else
	outputChatBox ( "#ffff00[Taxista]#ffffff No tienes nada que cancelar", playerSource ,0,0,0,true);
	end
end
addCommandHandler ("taxicancelar", quitJob)

function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end

function round(number, digits)
  local mult = 10^(digits or 0)
  return math.floor(number * mult + 0.5) / mult
end

function addPickup ( playerSource )
    local playerX, playerY, playerZ = getElementPosition( playerSource )
	local playerR = getPedRotation ( playerSource )
	local locationID = #taxiLocations + 1
	local XMLTaxiLocations = xmlLoadFile ( "XML\\taxi_locations.xml" )
	local addNode = xmlCreateChild(XMLTaxiLocations, "location")
	xmlSaveFile(XMLTaxiLocations)
	xmlNodeSetAttribute(addNode, "id", locationID)
    xmlNodeSetAttribute(addNode, "posX", playerX)
	xmlNodeSetAttribute(addNode, "posY", playerY)
	xmlNodeSetAttribute(addNode, "posZ", playerZ)
	xmlNodeSetAttribute(addNode, "rot", playerR)
	xmlSaveFile(XMLTaxiLocations)
	xmlUnloadFile ( XMLTaxiLocations )
	taxiLocations[locationID] = {}
	taxiLocations[locationID]["x"] = playerX
	taxiLocations[locationID]["y"] = playerY
	taxiLocations[locationID]["z"] = playerZ
	taxiLocations[locationID]["r"] = playerR
	outputChatBox ( "#ffff00[Taxista]#ffffff Añadiste una ubicacion nueva.", playerSource ,0,0,0,true );
end
addCommandHandler ("añadirtaxi", addPickup, true)