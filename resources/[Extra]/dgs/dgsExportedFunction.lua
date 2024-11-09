dgsExportedFunctionName = {}
dgsResName = getResourceName(getThisResource())

addEventHandler("onClientResourceStart",resourceRoot,function()
	triggerEvent("onDgsStart",resourceRoot,dgsResName)
end)

function dgsImportFunction(name,nameAs)
	if not sourceResource or sourceResource == getThisResource() then return "return true" end
	if not name then
		local allCode = [[
		--Check Error Message Above
		if not dgsImportHead then
			local getResourceRootElement = getResourceRootElement
			local call = call
			local getResourceFromName = getResourceFromName
			local tostring = tostring
			local outputDebugString = outputDebugString
			local DGSCallMT = {}
			dgsImportHead = {}
			dgsImportHead.dgsName = "]]..dgsResName..[["
			dgsImportHead.dgsResource = getResourceFromName(dgsImportHead.dgsName)
			dgsRoot = getResourceRootElement(dgsImportHead.dgsResource)
			addEventHandler("onClientResourceStop",dgsRoot,function()
				outputDebugString("[DGS] Alert! DGS has stopped. Everything keeps disconnected from DGS till the next time DGS starts!",2)
				function onDgsStart(dResN)
					outputDebugString("[DGS] DGS has started, reconnecting to DGS...",3)
					dgsImportHead = nil
					dgsRoot = nil
					loadstring(exports[dResN]:dgsImportFunction())()
					removeEventHandler("onDgsStart",root,onDgsStart)
				end
				addEventHandler("onDgsStart",root,onDgsStart)
			end)
			local isTraceDebug = getElementData(localPlayer,"DGS-DEBUG") == 3
			addEventHandler("onClientElementDataChange",localPlayer,function(key,_,v)
				if key == "DGS-DEBUG" then
					isTraceDebug = v == 3
				end
			end,false)
			function DGSCallMT:__index(k)
				if type(k) ~= 'string' then k = tostring(k) end
				self[k] = function(...)
					if not dgsImportHead then error("DGS import data is missing or DGS is not running, please reimport dgs functions("..getResourceName(getThisResource())..")") end
					if isElement(dgsRoot) then
						if isTraceDebug then
							local data = debug.getinfo(2)
							local retValue = {call(dgsImportHead.dgsResource, k, ...)}
							if k:lower():find("create") then
								if isElement(retValue[1]) then
									call(dgsImportHead.dgsResource, "dgsSetProperty",retValue[1],"debugTrace",{line=data.currentline,file=data.source:gsub("\\","/"):gsub("@",":"),fncName=k})
								end
							end
							return unpack(retValue)
						else
							return call(dgsImportHead.dgsResource, k, ...)
						end
					else
						dgsImportHead = nil
						dgsRoot = nil
						return nil
					end
				end
				return self[k]
			end
			DGS = setmetatable({}, DGSCallMT)

			function unloadDGSFunction()

			end
		end
		]]
		for i,name in ipairs(getResourceExportedFunctions()) do
			allCode = allCode.."\n "..name.." = DGS."..name..";"
		end
		return allCode
	else
		assert(dgsExportedFunctionName[name],"Bad Argument @dgsImportFunction at argument 1, the function is undefined")
		nameAs = nameAs or name
		return nameAs.." = DGS."..name..";"
	end
end

function dgsG2DLoadHooker()
	return [[
		if isGUIGridList then return end
		isGUIGridList = {}
		loadstring(exports.dgs:dgsImportFunction())()
		_guiBringToFront = guiBringToFront
		_guiCreateFont = guiCreateFont
		_guiBlur = guiBlur
		_guiFocus = guiFocus
		_guiGetAlpha = guiGetAlpha
		_guiGetEnabled = guiGetEnabled
		_guiSetFont = guiSetFont
		_guiGetFont = guiGetFont
		_guiGetInputEnabled = guiGetInputEnabled
		_guiGetInputMode = guiGetInputMode
		_guiGetPosition = guiGetPosition
		_guiGetProperties = guiGetProperties
		_guiGetProperty = guiGetProperty
		_guiGetScreenSize = guiGetScreenSize
		_guiGetSize = guiGetSize
		_guiGetText = guiGetText
		_guiGetVisible = guiGetVisible
		_guiMoveToBack = guiMoveToBack
		_guiSetAlpha = guiSetAlpha
		_guiSetEnabled = guiSetEnabled
		_guiSetFont = guiSetFont
		_guiSetInputEnabled = guiSetInputEnabled
		_guiSetInputMode = guiSetInputMode
		_guiSetPosition = guiSetPosition
		_guiSetProperty = guiSetProperty
		_guiSetSize = guiSetSize
		_guiSetText = guiSetText
		_guiSetVisible = guiSetVisible
		_guiCreateBrowser = guiCreateBrowser
		_guiCreateButton = guiCreateButton
		_guiCheckBoxGetSelected = guiCheckBoxGetSelected
		_guiCheckBoxSetSelected = guiCheckBoxSetSelected
		_guiCreateCheckBox = guiCreateCheckBox
		_guiCreateComboBox = guiCreateComboBox
		_guiComboBoxAddItem = guiComboBoxAddItem
		_guiComboBoxClear = guiComboBoxClear
		_guiComboBoxGetItemCount = guiComboBoxGetItemCount
		_guiComboBoxGetItemText = guiComboBoxGetItemText
		_guiComboBoxGetSelected = guiComboBoxGetSelected
		_guiComboBoxIsOpen = guiComboBoxIsOpen
		_guiComboBoxRemoveItem = guiComboBoxRemoveItem
		_guiComboBoxSetItemText = guiComboBoxSetItemText
		_guiComboBoxSetOpen = guiComboBoxSetOpen
		_guiComboBoxSetSelected = guiComboBoxSetSelected
		_guiCreateEdit = guiCreateEdit
		_guiEditGetCaretIndex = guiEditGetCaretIndex
		_guiEditGetMaxLength = guiEditGetMaxLength
		_guiEditIsMasked = guiEditIsMasked
		_guiEditIsReadOnly = guiEditIsReadOnly
		_guiEditSetCaretIndex = guiEditSetCaretIndex
		_guiEditSetMasked = guiEditSetMasked
		_guiEditSetMaxLength = guiEditSetMaxLength
		_guiEditSetReadOnly = guiEditSetReadOnly
		_guiCreateGridList = guiCreateGridList
		_guiGridListAddColumn = guiGridListAddColumn
		_guiGridListAddRow = guiGridListAddRow
		_guiGridListAutoSizeColumn = guiGridListAutoSizeColumn
		_guiGridListClear = guiGridListClear
		_guiGridListGetColumnCount = guiGridListGetColumnCount
		_guiGridListGetColumnTitle = guiGridListGetColumnTitle
		_guiGridListGetColumnWidth = guiGridListGetColumnWidth
		_guiGridListGetItemColor = guiGridListGetItemColor
		_guiGridListGetItemData = guiGridListGetItemData
		_guiGridListGetItemText = guiGridListGetItemText
		_guiGridListGetRowCount = guiGridListGetRowCount
		_guiGridListGetSelectedCount = guiGridListGetSelectedCount
		_guiGridListGetSelectedItem = guiGridListGetSelectedItem
		_guiGridListGetSelectedItems = guiGridListGetSelectedItems
		_guiGridListGetSelectionMode = guiGridListGetSelectionMode
		_guiGridListIsSortingEnabled = guiGridListIsSortingEnabled
		_guiGridListRemoveColumn = guiGridListRemoveColumn
		_guiGridListRemoveRow = guiGridListRemoveRow
		_guiGridListSetColumnTitle = guiGridListSetColumnTitle
		_guiGridListSetColumnWidth = guiGridListSetColumnWidth
		_guiGridListSetItemColor = guiGridListSetItemColor
		_guiGridListSetItemData = guiGridListSetItemData
		_guiGridListSetItemText = guiGridListSetItemText
		_guiGridListSetScrollBars = guiGridListSetScrollBars
		_guiGridListSetSelectedItem = guiGridListSetSelectedItem
		_guiGridListSetSelectionMode = guiGridListSetSelectionMode
		_guiGridListSetSortingEnabled = guiGridListSetSortingEnabled
		_guiCreateMemo = guiCreateMemo
		_guiMemoGetCaretIndex = guiMemoGetCaretIndex
		_guiMemoIsReadOnly = guiMemoIsReadOnly
		_guiMemoSetCaretIndex = guiMemoSetCaretIndex
		_guiMemoSetReadOnly = guiMemoSetReadOnly
		_guiCreateProgressBar = guiCreateProgressBar
		_guiProgressBarGetProgress = guiProgressBarGetProgress
		_guiProgressBarSetProgress = guiProgressBarSetProgress
		_guiCreateRadioButton = guiCreateRadioButton
		_guiRadioButtonGetSelected = guiRadioButtonGetSelected
		_guiRadioButtonSetSelected = guiRadioButtonSetSelected
		_guiCreateScrollBar = guiCreateScrollBar
		_guiScrollBarGetScrollPosition = guiScrollBarGetScrollPosition
		_guiScrollBarSetScrollPosition = guiScrollBarSetScrollPosition
		_guiCreateScrollPane = guiCreateScrollPane
		_guiScrollPaneSetScrollBars = guiScrollPaneSetScrollBars
		_guiCreateStaticImage = guiCreateStaticImage
		_guiStaticImageGetNativeSize = guiStaticImageGetNativeSize
		_guiStaticImageLoadImage = guiStaticImageLoadImage
		_guiCreateTabPanel = guiCreateTabPanel
		_guiGetSelectedTab = guiGetSelectedTab
		_guiSetSelectedTab = guiSetSelectedTab
		_guiCreateTab = guiCreateTab
		_guiDeleteTab = guiDeleteTab
		_guiCreateLabel = guiCreateLabel
		_guiLabelGetColor = guiLabelGetColor
		_guiLabelGetFontHeight = guiLabelGetFontHeight
		_guiLabelGetTextExtent = guiLabelGetTextExtent
		_guiLabelSetColor = guiLabelSetColor
		_guiLabelSetHorizontalAlign = guiLabelSetHorizontalAlign
		_guiLabelSetVerticalAlign = guiLabelSetVerticalAlign
		_guiCreateWindow = guiCreateWindow
		_guiWindowIsMovable = guiWindowIsMovable
		_guiWindowIsSizable = guiWindowIsSizable
		_guiWindowSetMovable = guiWindowSetMovable
		_guiWindowSetSizable = guiWindowSetSizable
		_guiGridListGetHorizontalScrollPosition = guiGridListGetHorizontalScrollPosition
		_guiGridListSetHorizontalScrollPosition = guiGridListSetHorizontalScrollPosition
		_guiGridListGetVerticalScrollPosition = guiGridListGetVerticalScrollPosition
		_guiGridListSetVerticalScrollPosition = guiGridListSetVerticalScrollPosition
		_guiMemoGetVerticalScrollPosition = guiMemoGetVerticalScrollPosition
		_guiMemoSetVerticalScrollPosition = guiMemoSetVerticalScrollPosition
		_guiScrollPaneGetHorizontalScrollPosition = guiScrollPaneGetHorizontalScrollPosition
		_guiScrollPaneGetVerticalScrollPosition = guiScrollPaneGetVerticalScrollPosition
		_guiScrollPaneSetHorizontalScrollPosition = guiScrollPaneSetHorizontalScrollPosition
		_guiScrollPaneSetVerticalScrollPosition = guiScrollPaneSetVerticalScrollPosition
		_guiGridListInsertRowAfter = guiGridListInsertRowAfter
		_guiGetBrowser = guiGetBrowser
	--GUI TO DGS
		guiBringToFront = dgsBringToFront
		guiCreateFont = dgsCreateFont
		guiBlur = dgsBlur
		guiFocus = dgsFocus
		guiGetAlpha = dgsGetAlpha
		guiGetEnabled = dgsGetEnabled
		guiGetFont = dgsGetFont
		guiGetInputEnabled = dgsGetInputEnabled
		guiGetInputMode = dgsGetInputMode
		guiGetPosition = dgsGetPosition
		guiGetProperties = dgsGetProperties
		guiGetProperty = dgsGetProperty
		guiGetScreenSize = dgsGetScreenSize
		guiGetSize = dgsGetSize
		guiGetText = dgsGetText
		guiGetVisible = dgsGetVisible
		guiMoveToBack = dgsMoveToBack
		guiSetAlpha = dgsSetAlpha
		guiSetEnabled = dgsSetEnabled
		guiSetInputEnabled = dgsSetInputEnabled
		guiSetInputMode = dgsSetInputMode
		guiSetPosition = dgsSetPosition
		guiSetSize = dgsSetSize
		guiSetText = dgsSetText
		guiSetVisible = dgsSetVisible
		guiCreateBrowser = dgsCreateBrowser
		guiCreateButton = dgsCreateButton
		guiCheckBoxGetSelected = dgsCheckBoxGetSelected
		guiCheckBoxSetSelected = dgsCheckBoxSetSelected
		guiCreateCheckBox = dgsCreateCheckBox
		guiCreateComboBox = dgsCreateComboBox
		guiComboBoxAddItem = dgsComboBoxAddItem
		guiComboBoxClear = dgsComboBoxClear
		guiComboBoxGetItemCount = dgsComboBoxGetItemCount
		guiComboBoxGetItemText = dgsComboBoxGetItemText
		guiComboBoxGetSelected = dgsComboBoxGetSelectedItem
		guiComboBoxIsOpen = dgsComboBoxGetState
		guiComboBoxRemoveItem = dgsComboBoxRemoveItem
		guiComboBoxSetItemText = dgsComboBoxSetItemText
		guiComboBoxSetOpen = dgsComboBoxSetState
		guiComboBoxSetSelected = dgsComboBoxSetSelectedItem
		guiCreateEdit = dgsCreateEdit
		guiEditGetCaretIndex = dgsEditGetCaretPosition
		guiEditGetMaxLength = dgsEditGetMaxLength
		guiEditIsMasked = dgsEditGetMasked
		guiEditIsReadOnly = dgsEditGetReadOnly
		guiEditSetCaretIndex = dgsEditSetCaretPosition
		guiEditSetMasked = dgsEditSetMasked
		guiEditSetMaxLength = dgsEditSetMaxLength
		guiEditSetReadOnly = dgsEditSetReadOnly
		guiCreateGridList = function(...)
			local gl = dgsCreateGridList(...)
			isGUIGridList[gl] = true
			addEventHandler("onDgsDestroy",gl,function()
				isGUIGridList[source] = nil
			end,false)
			return gl
		end
		guiGridListAddColumn = dgsGridListAddColumn
		guiGridListInsertRowAfter = function(gl,row,...)
			local rowData = dgsGetProperty(gl,"rowData")
			if isGUIGridList[gl] then
				row = tonumber(row) or #rowData
				return dgsGridListInsertRowAfter(gl,row+1,...)-1
			else
				row = tonumber(row) or #rowData+1
				return dgsGridListInsertRowAfter(gl,row,...)
			end
		end
		guiGridListAddRow = function(gl,row,...)
			local rowData = dgsGetProperty(gl,"rowData")
			if isGUIGridList[gl] then
				row = tonumber(row) or #rowData
				return dgsGridListAddRow(gl,row+1,...)-1
			else
				row = tonumber(row) or #rowData+1
				return dgsGridListAddRow(gl,row,...)
			end
		end
		guiGridListGetItemColor = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListGetItemColor(gl,row,...)
		end
		guiGridListGetItemData = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListGetItemData(gl,row,...)
		end
		guiGridListSetItemData = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListSetItemData(gl,row,...)
		end
		guiGridListGetItemText = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListGetItemText(gl,row,...)
		end
		guiGridListSetItemText = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListSetItemText(gl,row,...)
		end
		guiGridListGetSelectedCount = dgsGridListGetSelectedCount
		guiGridListGetSelectedItem = function(gl)
			if isGUIGridList[gl] then
				local selected = dgsGridListGetSelectedItem(gl)
				if selected == -1 then return -1 end
				return selected-1
			else
				return dgsGridListGetSelectedItem(gl)
			end
		end
		guiGridListGetSelectedItems = function(gl,isOrigin)
			local newItems = dgsGridListGetSelectedItems(gl,isOrigin)
			if not isOrigin then
				for k,v in ipairs(newItems) do
					newItems[k].row = newItems[k].row+1
				end
			else
				--To Do
			end
			return newItems
		end
		guiGridListRemoveRow = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListRemoveRow(gl,row,...)
		end
		guiGridListSetItemColor = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListSetItemColor(gl,row,...)
		end
		guiGridListSetSelectedItem = function(gl,row,...)
			if row then
				row = isGUIGridList[gl] and row+1 or row
			end
			return dgsGridListSetSelectedItem(gl,row,...)
		end
		guiGridListAutoSizeColumn = dgsGridListAutoSizeColumn
		guiGridListClear = dgsGridListClear
		guiGridListGetColumnCount = dgsGridListGetColumnCount
		guiGridListGetColumnTitle = dgsGridListGetColumnTitle
		guiGridListGetColumnWidth = dgsGridListGetColumnWidth
		guiGridListGetRowCount = dgsGridListGetRowCount
		guiGridListGetSelectionMode = dgsGridListGetSelectionMode
		guiGridListIsSortingEnabled = dgsGridListGetSortEnabled
		guiGridListRemoveColumn = dgsGridListRemoveColumn
		guiGridListSetColumnTitle = dgsGridListSetColumnTitle
		guiGridListSetColumnWidth = dgsGridListSetColumnWidth
		guiGridListSetScrollBars = dgsGridListSetScrollBarState
		guiGridListSetSelectionMode = dgsGridListSetSelectionMode
		guiGridListSetSortingEnabled = dgsGridListSetSortEnabled
		guiCreateMemo = dgsCreateMemo
		guiMemoGetCaretIndex = dgsMemoGetCaretIndex
		guiMemoIsReadOnly = dgsMemoIsReadOnly
		guiMemoSetCaretIndex = dgsMemoSetCaretIndex
		guiMemoSetReadOnly = dgsMemoSetReadOnly
		guiCreateProgressBar = dgsCreateProgressBar
		guiProgressBarGetProgress = dgsProgressBarGetProgress
		guiProgressBarSetProgress = dgsProgressBarSetProgress
		guiCreateRadioButton = dgsCreateRadioButton
		guiRadioButtonGetSelected = dgsRadioButtonGetSelected
		guiRadioButtonSetSelected = dgsRadioButtonSetSelected
		guiCreateScrollBar = dgsCreateScrollBar
		guiScrollBarGetScrollPosition = dgsScrollBarGetScrollPosition
		guiScrollBarSetScrollPosition = dgsScrollBarSetScrollPosition
		guiCreateScrollPane = dgsCreateScrollPane
		guiScrollPaneSetScrollBars = dgsScrollPaneSetScrollBarState
		guiCreateStaticImage = dgsCreateImage
		guiStaticImageGetNativeSize = dgsImageGetNativeSize
		guiStaticImageLoadImage = dgsImageSetImage
		guiCreateTabPanel = dgsCreateTabPanel
		guiGetSelectedTab = dgsGetSelectedTab
		guiSetSelectedTab = dgsSetSelectedTab
		guiCreateTab = dgsCreateTab
		guiDeleteTab = dgsDeleteTab
		guiCreateLabel = dgsCreateLabel
		guiLabelGetColor = dgsLabelGetColor
		guiLabelGetFontHeight = dgsLabelGetFontHeight
		guiLabelGetTextExtent = dgsLabelGetTextExtent
		guiLabelSetColor = dgsLabelSetColor
		guiLabelSetHorizontalAlign = dgsLabelSetHorizontalAlign
		guiLabelSetVerticalAlign = dgsLabelSetVerticalAlign
		guiCreateWindow = function(...)
			local window = dgsCreateWindow(...)
			dgsSetProperty(window,"ignoreTitle",true)
			dgsWindowSetCloseButtonEnabled(window,false)
			return window
		end
		guiWindowIsMovable = dgsWindowGetMovable
		guiWindowIsSizable = dgsWindowGetSizable
		guiWindowSetMovable = dgsWindowSetMovable
		guiWindowSetSizable = dgsWindowSetSizable
		guiGridListGetHorizontalScrollPosition = dgsGridListGetHorizontalScrollPosition
		guiGridListSetHorizontalScrollPosition = dgsGridListSetHorizontalScrollPosition
		guiGridListGetVerticalScrollPosition = dgsGridListGetVerticalScrollPosition
		guiGridListSetVerticalScrollPosition = dgsGridListSetVerticalScrollPosition
		guiMemoGetVerticalScrollPosition = dgsMemoGetVerticalScrollPosition
		guiMemoSetVerticalScrollPosition = dgsMemoSetVerticalScrollPosition
		guiScrollPaneGetHorizontalScrollPosition = dgsScrollPaneGetHorizontalScrollPosition
		guiScrollPaneGetVerticalScrollPosition = dgsScrollPaneGetVerticalScrollPosition
		guiScrollPaneSetHorizontalScrollPosition = dgsScrollPaneSetHorizontalScrollPosition
		guiScrollPaneSetVerticalScrollPosition = dgsScrollPaneSetVerticalScrollPosition
		guiGetBrowser = dgsGetBrowser

		local fontReplace = {
            ["default-normal"]="default",
			["default-small"]="arial",
			["default-bold-small"]="default-bold",
			["clear-normal"]="clear",
			["sa-gothic"]="beckett",
			["sa-header"]="diploma",
        }
        guiSetFont = function(gl,font)
            return dgsSetFont(gl,fontReplace[font] or font)
		end

		guiSetProperty = function(gl,prop,v)
			local eleType = getElementType(gl)
			if prop == "NormalTextColour" or prop == "HoverTextColour" or prop == "PushedTextColour" then
				local a,r,g,b = getColorFromString("#"..v)
				local ct = dgsGetProperty(gl,"textColor")
				if prop == "NormalTextColour" and type (ct) ~= "table" then
					return dgsSetProperty(gl,"textColor",tocolor(r,g,b,a))
				else
					if type(ct) ~= "table" then
						ct = {ct}
					end
					ct[prop == "NormalTextColour" and 1 or prop == "HoverTextColour" and 2 or 3] = tocolor(r,g,b,a)
					return dgsSetProperty(gl,"textColor",ct)
				end
			elseif prop == "Disabled" then
				return dgsSetProperty(gl,"enabled",not v:lower() == "true")
			elseif prop == "Visible" then
				return dgsSetVisible(gl,v:lower() == "true")
			elseif prop == "ReadOnly" then
				return dgsSetProperty(gl,"readOnly",v:lower() == "true")
			elseif prop == "Alpha" or prop == "Font" or prop == "Text" then
				return dgsSetProperty(gl,prop:lower(),v)
			else
				return dgsSetProperty(gl,prop,v)
			end
		end

		addEvent("onDgsEditAccepted-C",true)
		addEvent("onDgsTextChange-C",true)
		addEvent("onDgsComboBoxSelect-C",true)
		addEvent("onDgsTabSelect-C",true)
		if not getElementData(root,"__DGSDef") then
			setElementData(root,"__DGSDef",true)
			function fncTrans(...)
				triggerEvent(eventName.."-C",source,source,...)
			end
			addEventHandler("onDgsEditAccepted",root,fncTrans)
			addEventHandler("onDgsTextChange",root,fncTrans)
			addEventHandler("onDgsComboBoxSelect",root,fncTrans)
			addEventHandler("onDgsTabSelect",root,fncTrans)
		end
		local eventReplace = {
			onClientGUIAccepted="onDgsEditAccepted-C",
			onClientGUIBlur="onDgsBlur",
			onClientGUIChanged="onDgsTextChange-C",
			onClientGUIClick="onDgsMouseClickUp",
			onClientGUIComboBoxAccepted="onDgsComboBoxSelect-C",
			onClientGUIDoubleClick="onDgsMouseDoubleClick",
			onClientGUIFocus="onDgsFocus",
			onClientGUIMouseDown="onDgsMouseDown",
			onClientGUIMouseUp="onDgsMouseUp",
			onClientGUIMove="onDgsElementMove",
			onClientGUIScroll="onDgsElementScroll",
			onClientGUISize="onDgsElementSize",
			onClientGUITabSwitched="onDgsTabSelect-C",
			onClientMouseEnter="onDgsMouseEnter",
			onClientMouseLeave="onDgsMouseLeave",
			onClientMouseMove="onDgsMouseMove",
			onClientMouseWheel="onDgsMouseWheel",
		}
		_addEventHandler = addEventHandler

		addEventHandler = function(even,...)
			_addEventHandler(eventReplace[even] or even,...)
		end
		local typeReplace ={
			["dgs-dxbutton"]="gui-button",
			["dgs-dxedit"]="gui-edit",
			["dgs-dxprogressbar"]="gui-progressbar",
			["dgs-dxwindow"]="gui-window",
			["dgs-dxlabel"]="gui-label",
			["dgs-dxscrollpane"]="gui-scrollpane",
			["dgs-dxtab"]="gui-tab",
			["dgs-dxmemo"]="gui-memo",
			["dgs-dxtabpanel"]="gui-tabpanel",
			["dgs-dximage"]="gui-staticimage",
			["dgs-dxscrollbar"]="gui-scrollbar",
			["dgs-dxcombobox"]="gui-combobox",
			["dgs-dxcheckbox"]="gui-checkbox",
			["dgs-dxradiobutton"]="gui-radiobutton",
			["dgs-dxgridlist"]="gui-gridlist",
		}
		_getElementType = getElementType

		getElementType = function(gl)
			local typ = _getElementType(gl)
			return typ and typeReplace[typ] or typ
		end
	]]
end

-------Inside DGS
setElementData(root,"__DGSRes",getThisResource(),false)
addEventHandler("onClientResourceStop",resourceRoot,function() setElementData(root,"__DGSRes",false,false) end)

function dgsImportOOPClass()
	local OOPFile = fileOpen("classlib.lua")
	local str = fileRead(OOPFile,fileGetSize(OOPFile))
	fileClose(OOPFile)
	if fileExists("customOOP.lua") then
		local customOOPFileList = fileOpen("customOOP.lua")
		local s = fileRead(customOOPFileList,fileGetSize(customOOPFileList)):gsub("\r\n","\n")
		local list = split(s,"\n")
		for i=1,#list do
			if fileExists(list[i]) then
				local customOOPCode = fileOpen(list[i])
				local s = fileRead(customOOPCode,fileGetSize(customOOPCode))
				fileClose(customOOPCode)
				local f,e = loadstring(s)
				if f then
					str = str.."\n"..s
				else
					outputDebugString("[DGS]Failed to load custom OOP script ("..list[i]..":"..e..")",1)
				end
			else
				outputDebugString("[DGS]Failed to load custom OOP script (Could not find "..list[i]..")",1)
			end
		end
		fileClose(customOOPFileList)
	end
	return str
end