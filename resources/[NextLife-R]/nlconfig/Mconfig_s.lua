
function openPanelConfig(player)
	if player:getData("Comida") then
		triggerClientEvent(player,"NextLife:ShowConfig",player,player)
	else
		outputChatBox( "Aparece Primero!", player, 255, 0, 0, true )
	end
end

addEventHandler("onPlayerResourceStart",root,function(startedResource)
	if not startedResource == resource then
		return false
	end
	unbindKey(source,"f10","down", openPanelConfig)
	bindKey(source,"f10","down", openPanelConfig)
end)

