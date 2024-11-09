local screenW, screenH = guiGetScreenSize()

panelState = false

function crearVentanaStats(cuenta, nombre, edad, nacionalidad, sexo, trabajo, faccion, familia)



        ventana = guiCreateWindow(0.34, 0.23, 0.32, 0.61, "Stats de: Thomas_Smith", true)

        guiWindowSetSizable(ventana, false)

        guiSetAlpha(ventana, 0.94)



        btnCerrar = guiCreateButton(0.92, 0.06, 0.06, 0.05, "X", true, ventana)

        guiSetProperty(btnCerrar, "NormalTextColour", "FFFF0000")



        tabPanel = guiCreateTabPanel(0.02, 0.07, 0.95, 0.91, true, ventana)



        tabGeneral = guiCreateTab("Principal", tabPanel)



        name = guiCreateLabel(9, 10, 403, 54, "Nombre completo: Thomas Smith", false, tabGeneral)

        guiSetFont(name, "clear-normal")



        Sexo = guiCreateLabel(0.02, 0.18, 0.95, 0.13, "Sexo: Desconocido", true, tabGeneral)

        guiSetFont(Sexo, "clear-normal")



       nacio = guiCreateLabel(0.02, 0.26, 0.95, 0.13, "Nacionalidad: Desconocido", true, tabGeneral)

        guiSetFont(nacio, "clear-normal")



        Edad = guiCreateLabel(0.02, 0.22, 0.95, 0.13, "Edad: Desconocido", true, tabGeneral)

        guiSetFont(Edad, "clear-normal")



        nivel = guiCreateLabel(0.02, 0.42, 0.95, 0.13, "Nivel: Desconocido", true, tabGeneral)

        guiSetFont(nivel, "clear-normal")



       	Trabajito = guiCreateLabel(0.02, 0.57, 0.95, 0.13, "", true, tabGeneral)

        guiSetFont(Trabajito, "clear-normal")



        Trabajito2 = guiCreateLabel(0.02, 0.62, 0.95, 0.13, "", true, tabGeneral)

        guiSetFont(Trabajito2, "clear-normal")



        Facciones = guiCreateLabel(0.02, 0.73, 0.95, 0.13, "", true, tabGeneral)

        guiSetFont(Facciones, "clear-normal")





tabSanciones = guiCreateTab("Sanciones", tabPanel)



gridListSanciones = guiCreateGridList(0.02, 0.02, 0.96, 0.95, true, tabSanciones)

guiGridListAddColumn(gridListSanciones, "Tipo", 0.25)

guiGridListAddColumn(gridListSanciones, "Motivo", 0.25)

guiGridListAddColumn(gridListSanciones, "Tiempo", 0.25)

guiGridListAddColumn(gridListSanciones, "Staff", 0.25)



tabstats = guiCreateTab("Habilidades", tabPanel)



        ppizzero = guiCreateLabel(0.02, 0.03, 0.60, 0.09, "Pizzero: En proceso", true, tabstats)

        guiSetFont(ppizzero, "default-bold-small")

        guiLabelSetVerticalAlign(ppizzero, "center")



        pbasurero = guiCreateLabel(0.02, 0.12, 0.60, 0.09, "Basurero: En proceso", true, tabstats)

        guiSetFont(pbasurero, "default-bold-small")

        guiLabelSetVerticalAlign(pbasurero, "center")



        pjardinero = guiCreateLabel(0.02, 0.21, 0.60, 0.09, "Jardinero: En proceso", true, tabstats)

        guiSetFont(pjardinero, "default-bold-small")

        guiLabelSetColor(pjardinero, 255, 254, 254)

        guiLabelSetVerticalAlign(pjardinero, "center")



        ccarpintero = guiCreateLabel(0.02, 0.30, 0.60, 0.10, "Carpintero: En proceso", true, tabstats)

        guiSetFont(ccarpintero, "default-bold-small")

        guiLabelSetVerticalAlign(ccarpintero, "center")



        ccamionero = guiCreateLabel(0.02, 0.40, 0.60, 0.10, "Camionero: En proceso", true, tabstats)

        guiSetFont(ccamionero, "default-bold-small")

        guiLabelSetVerticalAlign(ccamionero, "center")



        ccarnicero = guiCreateLabel(0.02, 0.50, 0.60, 0.10, "Carnicero: En proceso", true, tabstats)

        guiSetFont(ccarnicero, "default-bold-small")

        guiLabelSetVerticalAlign(ccarnicero, "center")



        ttaxista = guiCreateLabel(0.5, 0.03, 0.60, 0.09, "Taxista: En proceso", true, tabstats)

        guiSetFont(ttaxista, "default-bold-small")

        guiLabelSetVerticalAlign(ttaxista, "center")



        mmozo = guiCreateLabel(0.5, 0.12, 0.60, 0.09, "Mozo: En proceso", true, tabstats)

        guiSetFont(mmozo, "default-bold-small")

        guiLabelSetVerticalAlign(mmozo, "center")



        mminero = guiCreateLabel(0.5, 0.21, 0.60, 0.09, "Minero: En proceso", true, tabstats)

        guiSetFont(mminero, "default-bold-small")

        guiLabelSetVerticalAlign(mminero, "center")



        bBusetero = guiCreateLabel(0.5, 0.30, 0.60, 0.09, "Colectivero: En proceso", true, tabstats)

        guiSetFont(bBusetero, "default-bold-small")

        guiLabelSetVerticalAlign(bBusetero, "center")



        Oobrero = guiCreateLabel(0.5, 0.40, 0.60, 0.09, "Obrero: En proceso", true, tabstats)

        guiSetFont(Oobrero, "default-bold-small")

        guiLabelSetVerticalAlign(Oobrero, "center")



        Lladron = guiCreateLabel(0.5, 0.50, 0.60, 0.09, "Ladron: En proceso", true, tabstats)

        guiSetFont(Lladron, "default-bold-small")

        guiLabelSetVerticalAlign(Lladron, "center")



tabextra = guiCreateTab("Extra", tabPanel)



        skin = guiCreateLabel(0.02, 0.03, 0.21, 0.09, "Skin: 123", true, tabextra)

        guiSetFont(skin, "default-bold-small")

        guiLabelSetVerticalAlign(skin, "center")

        vida = guiCreateLabel(0.02, 0.12, 0.21, 0.09, "vida: 100", true, tabextra)

        guiSetFont(vida, "default-bold-small")

        guiLabelSetVerticalAlign(vida, "center")

        cha = guiCreateLabel(0.02, 0.21, 0.21, 0.09, "Chaleco: 100", true, tabextra)

        guiSetFont(cha, "default-bold-small")

        guiLabelSetVerticalAlign(cha, "center")

        dinero = guiCreateLabel(0.02, 0.30, 0.42, 0.10, "Dinero en mano: $96390113", true, tabextra)

        guiSetFont(dinero, "default-bold-small")

        guiLabelSetVerticalAlign(dinero, "center")

        dinb = guiCreateLabel(0.02, 0.40, 0.42, 0.10, "Dinero en banco: $630358", true, tabextra)

        guiSetFont(dinb, "default-bold-small")

        guiLabelSetVerticalAlign(dinb, "center")

        radio = guiCreateLabel(0.02, 0.50, 0.42, 0.10, "Radio: -4.5 Hz", true, tabextra)

        guiSetFont(radio, "default-bold-small")

        guiLabelSetVerticalAlign(radio, "center")

        tele = guiCreateLabel(0.02, 0.60, 0.42, 0.10, "Telefono: 25486", true, tabextra)

        guiSetFont(tele, "default-bold-small")

        guiLabelSetVerticalAlign(tele, "center")

        rol = guiCreateLabel(0.02, 0.70, 0.42, 0.10, "Puntos de rol: X", true, tabextra)

        guiSetFont(rol, "default-bold-small")

        guiLabelSetVerticalAlign(rol, "center")



      	adv = guiCreateLabel(0.02, 0.78, 0.42, 0.10, "", true, tabextra)

        guiSetFont(adv, "default-bold-small")

        guiLabelSetVerticalAlign(adv, "center")



        perso = guiCreateGridList(0.60, 0.12, 0.38, 0.38, true, tabextra)

        guiGridListAddColumn(perso, "Personajes", 0.9)

        persola = guiCreateLabel(0.68, 0.00, 0.21, 0.09, "Personajes:", true, tabextra)

        guiSetFont(persola, "default-bold-small")

        guiLabelSetHorizontalAlign(persola, "center", false)

        guiLabelSetVerticalAlign(persola, "center")

        serial1 = guiCreateLabel(0.69, 0.51, 0.21, 0.09, "Serial:", true, tabextra)

        guiSetFont(serial1, "default-bold-small")

        guiLabelSetHorizontalAlign(serial1, "center", false)

        guiLabelSetVerticalAlign(serial1, "center")

        serial = guiCreateLabel(0.43, 0.60, 0.57, 0.10, "SIN ENCONTRAR", true, tabextra)

        guiSetFont(serial, "default-bold-small")

        guiLabelSetColor(serial, 3, 254, 246)

        guiLabelSetHorizontalAlign(serial, "center", false)

        guiLabelSetVerticalAlign(serial, "center")

        copiarserial = guiCreateButton(0.04, 0.90, 0.26, 0.08, "Copiar Serial", true, tabextra)

        guiSetFont(copiarserial, "default-bold-small")

        guiSetProperty(copiarserial, "NormalTextColour", "FFFEFEFE")

        ip1 = guiCreateLabel(0.69, 0.70, 0.21, 0.09, "IP:", true, tabextra)

        guiSetFont(ip1, "default-bold-small")

        guiLabelSetHorizontalAlign(ip1, "center", false)

        guiLabelSetVerticalAlign(ip1, "center")

        ip2 = guiCreateLabel(0.69, 0.80, 0.21, 0.08, "Comming Soon", true, tabextra)

        guiSetFont(ip2, "default-bold-small")

        guiLabelSetColor(ip2, 3, 254, 246)

        guiLabelSetHorizontalAlign(ip2, "center", false)

        guiLabelSetVerticalAlign(ip2, "center")

        copiarip = guiCreateButton(0.32, 0.90, 0.26, 0.08, "Copiar IP", true, tabextra)

        guiSetFont(copiarip, "default-bold-small")

        guiSetProperty(copiarip, "NormalTextColour", "FFFEFEFE")

end







function borrarPanelStats()

    destroyElement(tabPanel)

    destroyElement(ventana)

    panelState = false

    showCursor(false)

    guiSetInputEnabled( false )

end



addEvent("winstats", true)

function verifyPanel(tabla,pe,n,s,e,data)

    if panelState == false then

        crearVentanaStats(tabla,pe,n,s,e)

        showCursor(true)

        panelState = true

        addEventHandler("onClientGUIClick", btnCerrar, borrarPanelStats, false)

        guiSetText(ventana,"Stats de: "..getPlayerName(localPlayer):gsub("_"," "))

        guiSetText(name,"Nombre Completo: "..getPlayerName(localPlayer):gsub("_"," "))

        guiSetText(Sexo,"Sexo: "..s)

        guiSetText(nacio,"Nacionalidad: "..n)

        guiSetText(Edad,"Edad: "..e)

        guiSetText(nivel,"Eres nivel: "..(getElementData(localPlayer,"Nivel")or 1).." - ("..(getElementData(localPlayer,"PlayerExp")or 1).." de reputacion, se resetea al pasar de nivel)")



	if getElementData(localPlayer,"Roleplay:trabajo") == "Camionero" or getElementData(localPlayer,"Roleplay:trabajo") == "Carpintero" or getElementData(localPlayer,"Roleplay:trabajo") == "Jardinero" or getElementData(localPlayer,"Roleplay:trabajo") == "Pizzero" or getElementData(localPlayer,"Roleplay:trabajo") == "Taxista" or getElementData(localPlayer,"Roleplay:trabajo") == "Ladron" then

        guiSetText(Trabajito,"Trabajo I: "..getElementData(localPlayer,"Roleplay:trabajo"))

    end



    if getElementData(localPlayer,"Roleplay:trabajoVIP") == "Camionero"  or getElementData(localPlayer,"Roleplay:trabajoVIP") == "Carpintero" or getElementData(localPlayer,"Roleplay:trabajoVIP") == "Jardinero" or getElementData(localPlayer,"Roleplay:trabajoVIP") == "Pizzero" or getElementData(localPlayer,"Roleplay:trabajoVIP") == "Taxista" or getElementData(localPlayer,"Roleplay:trabajoVIP") == "Ladron" then

        guiSetText(Trabajito2,"Trabajo II: "..getElementData(localPlayer,"Roleplay:trabajoVIP"))

    end



		if getElementData(localPlayer,"Roleplay:faccion") == "Policia" or getElementData(localPlayer,"Roleplay:faccion") == "Mecanico" or getElementData(localPlayer,"Roleplay:faccion") == "Medico" then

        guiSetText(Facciones,"Faccion: "..getElementData(localPlayer,"Roleplay:faccion"))

    end


        local dataEmpleo = data[localPlayer]

        print(inspect(dataEmpleo))

		guiSetText(ppizzero,"Pizzero: "..(dataEmpleo["PizzeroLv"] or 1).." lvl "..(dataEmpleo["PizzeroExp"] or 0).." Exp")

		guiSetText(pbasurero,"Basurero: "..(getElementData(localPlayer,"Basurero:Nivel") or 1).." lvl "..(getElementData(localPlayer,"Basurero:Exp") or 0).." Exp")

		guiSetText(ccamionero,"Camionero: "..(dataEmpleo["CamioneroLv"]).." lvl "..(dataEmpleo["CamioneroExp"]).." Exp")

		guiSetText(pjardinero,"Jardinero: "..(dataEmpleo["JardineroLv"]).." lvl "..(dataEmpleo["JardineroExp"]).." Exp")

        guiSetText(ccarpintero,"Carpintero: "..(dataEmpleo["CarpinteroLv"] or 1).." lvl "..(dataEmpleo["CarpinteroExp"] or 0).." Exp")

		guiSetText(bBusetero,"Colectivero: "..(getElementData(localPlayer,"Roleplay:ExpJobColectivero") or 1).." lvl "..(getElementData(localPlayer,"ExpJobColectivero:Exp") or 0).." Exp")

		guiSetText(mminero,"Minero: "..(dataEmpleo["MineroLv"] or 1).." lvl "..(dataEmpleo["MineroExp"] or 0).." Exp")



        



        --

        guiSetText(skin,"Skin: #"..getElementModel(localPlayer))

        guiSetText(vida,"Vida: "..math.floor(localPlayer:getHealth()))

        guiSetText(cha,"Chaleco: "..getPedArmor(localPlayer))

        guiSetText(dinero,"Dinero en Mano: "..getPlayerMoney())

        guiSetText(dinb,"Dinero en Banco: "..(getElementData(localPlayer,"Roleplay:bank_balance") or 0))

        guiSetText(radio,"Radio: "..(getElementData(localPlayer,"frecuencia") or 0).." Hz")

        guiSetText(tele,"Telefono: "..(getElementData(localPlayer,"Roleplay:NumeroTelefono") or 0))

        guiSetText(rol,"Puntos de rol: +"..(getElementData(localPlayer,"Roleplay:rol") or 0).."  "..(localPlayer:getData("-rol") or 0))

        --guiSetText(adv,"Advertencias: #"..(localPlayer:getData("warn") or 0))

        guiSetText(serial, getPlayerSerial())



        guiGridListClear(perso)

        if pe and type(pe) == "table" then

            for i, v in ipairs(pe) do

                local row = guiGridListAddRow(perso)

                guiGridListSetItemText(perso, row, 1, v.Cuenta, false, true)

                guiGridListSetItemData(perso, row, 1, v.Cuenta)

            end

    end



        for k, value in ipairs(tabla) do

            local k = k - 1

            guiGridListAddRow(gridListSanciones)

            guiGridListSetItemText(gridListSanciones, k, 1, value.tipo, false, false)

            guiGridListSetItemColor(gridListSanciones, k, 1, 255, 166, 0, 255)

            guiGridListSetItemText(gridListSanciones, k, 2, value.motivo, false, false)

            guiGridListSetItemColor(gridListSanciones, k, 2, 255, 166, 0, 255)

            if tonumber(value.tiempo) then

                guiGridListSetItemText(gridListSanciones, k, 3, value.tiempo, false, false)

                guiGridListSetItemColor(gridListSanciones, k, 3, 255, 166, 0, 255)

            else

                guiGridListSetItemText(gridListSanciones, k, 3, "#", false, false)

                guiGridListSetItemColor(gridListSanciones, k, 3, 255, 166, 0, 255)

            end

            guiGridListSetItemText(gridListSanciones, k, 4, value.staff, false, false)

            guiGridListSetItemColor(gridListSanciones, k, 4, 255, 166, 0, 255)

        end

        guiSetInputEnabled( true )

    else

        borrarPanelStats()

    end

end

addEventHandler("winstats", getRootElement(), verifyPanel)