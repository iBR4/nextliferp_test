local application = {};



function setDiscordRichPresence()

    if (not isDiscordRichPresenceConnected()) then

        return;

    end



    resetDiscordRichPresenceData();

    local connected = setDiscordApplicationID(application.id);

    if (connected) then

        setDiscordRichPresencePartySize(#getElementsByType("player"), application['max_slots']);

        if (application['buttons'][1].use) then setDiscordRichPresenceButton(1, application['buttons'][1].name, application['buttons'][1].link); end

        if (application['buttons'][2].use) then setDiscordRichPresenceButton(2, application['buttons'][2].name, application['buttons'][2].link); end

        if (application['details']:len() > 0) then setDiscordRichPresenceDetails(application['details']); end

        setDiscordRichPresenceAsset(application['logo'], application['logo_name']);



--[[
        local name = getPlayerName(localPlayer):gsub("_"," ")

        if name then

            local nivel = getElementData(localPlayer, "Nivel") or 1 -- Obteniendo el nivel del jugador

            setDiscordRichPresenceDetails(""..name.." | (Nivel " .. tostring(nivel) .. ")") -- Detalle con el nombre y nivel del jugador

        end

]]
        



        local maxSlots = application['max_slots']

        setDiscordRichPresenceState("#? Roleplay Server") -- Estado con el máximo de jugadores



        setDiscordRichPresenceStartTime(1);

    end

end



addEvent("addPlayerRichPresence", true);

addEventHandler("addPlayerRichPresence", localPlayer,

    function(data)

        application = data;

        setDiscordRichPresence();

    end, false

);

addEvent("addPlayerUpdatePresence", true);

addEventHandler("addPlayerUpdatePresence", localPlayer,
    function(player,nick,level)

        if (not isDiscordRichPresenceConnected()) then
            return;
        end

        local nivel = level or 1 -- Obteniendo el nivel del jugador
        setDiscordRichPresenceDetails(""..nick.." | (Nivel " .. tostring(level) .. ")") -- Detalle con el nombre y nivel del jugador
        print("yes update")
        
    end, false
);

addEventHandler("onClientPlayerJoin", root, 

    function()

        if (not isDiscordRichPresenceConnected()) then

            return;

        end



        setDiscordRichPresencePartySize(#getElementsByType("player"), application['max_slots']);

    end

);


addEventHandler("onClientPlayerQuit", root, 

    function()

        if (not isDiscordRichPresenceConnected()) then

            return;

        end

        setDiscordRichPresencePartySize(#getElementsByType("player"), application['max_slots']);

    end

);

