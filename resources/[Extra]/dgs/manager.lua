-------------------------------------------------Parent/Layer Manager
--Speed Up
local tableInsert = table.insert
local tableRemove = table.remove
local tableFind = table.find
local isElement = isElement
local assert = assert
local tostring = tostring
local tonumber = tonumber
local mathMin = math.min
local mathMax = math.max
local mathClamp = math.restrict

BottomFatherTable = {}		--Store Bottom Father Element
CenterFatherTable = {}		--Store Center Father Element (Default)
TopFatherTable = {}			--Store Top Father Element
dgsWorld3DTable = {}
dgsScreen3DTable = {}
FatherTable = {}			--Store Father Element
ChildrenTable = {}			--Store Children Element
LayerCastTable = {center=CenterFatherTable,top=TopFatherTable,bottom=BottomFatherTable}

function dgsSetLayer(dgsEle,layer,forceDetatch)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsSetLayer",1,"dgs-dxelement")) end
	if dgsElementType[dgsEle] == "dgs-dxtab" then return false end
	if not(layerBuiltIn[layer]) then error(dgsGenAsrt(layer,"dgsSetLayer",2,"string","top/center/bottom")) end
	local hasParent = isElement(FatherTable[dgsEle])
	if hasParent and not forceDetatch then return false end
	if hasParent then
		local id = tableFind(ChildrenTable[FatherTable[dgsEle]],dgsEle)
		if id then
			tableRemove(ChildrenTable[FatherTable[dgsEle]],id)
		end
		FatherTable[dgsEle] = nil
	end
	local oldLayer = dgsElementData[dgsEle].alwaysOn or "center"
	if oldLayer == layer then return false end
	local id = tableFind(LayerCastTable[oldLayer],dgsEle)
	if id then
		tableRemove(LayerCastTable[oldLayer],id)
	end
	dgsSetData(dgsEle,"alwaysOn",layer == "center" and false or layer)
	tableInsert(LayerCastTable[layer],dgsEle)
	return true
end

function dgsGetLayer(dgsEle)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsGetLayer",1,"dgs-dxelement")) end
	return dgsElementData[dgsEle].alwaysOn or "center"
end

function dgsSetCurrentLayerIndex(dgsEle,index)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsSetCurrentLayerIndex",1,"dgs-dxelement")) end
	if not(type(index) == "number") then error(dgsGenAsrt(index,"dgsSetCurrentLayerIndex",2,"number")) end
	local layer = dgsElementData[dgsEle].alwaysOn or "center"
	local hasParent = isElement(FatherTable[dgsEle])
	local theTable = hasParent and ChildrenTable[FatherTable[dgsEle]] or LayerCastTable[layer]
	local index = mathClamp(index,1,#theTable+1)
	local id = tableFind(theTable,dgsEle)
	if id then
		tableRemove(theTable,id)
	end
	tableInsert(theTable,index,dgsEle)
	return true
end

function dgsGetCurrentLayerIndex(dgsEle)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsGetCurrentLayerIndex",1,"dgs-dxelement")) end
	local layer = dgsElementData[dgsEle].alwaysOn or "center"
	local hasParent = isElement(FatherTable[dgsEle])
	local theTable = hasParent and ChildrenTable[FatherTable[dgsEle]] or LayerCastTable[layer]
	return tableFind(theTable,dgsEle) or false
end

function dgsGetLayerElements(layer)
	if not(layerBuiltIn[layer]) then error(dgsGenAsrt(layer,"dgsGetLayerElements",1,"string","top/center/bottom")) end
	return #LayerCastTable[layer] or false
end

function dgsGetChild(parent,id) return ChildrenTable[parent][id] or false end
function dgsGetChildren(parent) return ChildrenTable[parent] or {} end
function dgsGetParent(child) return FatherTable[child] or false end
function dgsGetDxGUINoParent(alwaysBottom) return alwaysBottom and BottomFatherTable or CenterFatherTable end

function dgsGetDxGUIFromResource(res)
	local res = res or sourceResource
	if res then
		local serialized,cnt = {},0
		for k,v in pairs(boundResource[res] or {}) do
			cnt = cnt+1
			serialized[cnt] = k
		end
		return serialized
	end
end

function dgsSetParent(child,parent,nocheckfather,noUpdatePosSize)
	if parent == resourceRoot then parent = nil end
	if not(dgsIsType(child)) then error(dgsGenAsrt(child,"dgsSetParent",1,"dgs-dxelement")) end
	if not(not dgsElementData[child] or not dgsElementData[child].attachTo) then error(dgsGenAsrt(child,"dgsSetParent",1,_,_,_,"attached dgs element can not have a parent")) end
	local _parent = FatherTable[child]
	local parentTable = isElement(_parent) and ChildrenTable[_parent] or CenterFatherTable
	if isElement(parent) then
		if not dgsIsType(parent) then return end
		if not nocheckfather then
			local id = tableFind(parentTable,child)
			if id then
				tableRemove(parentTable,id)
			end
		end
		FatherTable[child] = parent
		ChildrenTable[parent] = ChildrenTable[parent] or {}
		tableInsert(ChildrenTable[parent],child)
		setElementParent(child,parent)
	else
		local id = tableFind(parentTable,child)
		if id then
			tableRemove(parentTable,id)
		end
		FatherTable[id] = nil
		tableInsert(CenterFatherTable,child)
		setElementParent(child,resourceRoot)
	end
	---Update Position and Size
	if not noUpdatePosSize then
		local rlt = dgsElementData[child].relative
		local pos = rlt[1] and dgsElementData[child].rltPos or dgsElementData[child].absPos
		local size = rlt[2] and dgsElementData[child].rltSize or dgsElementData[child].absSize
		calculateGuiPositionSize(child,pos[1],pos[2],rlt[1] and true or false,size[1],size[2],rlt[2] and true or false)
	end
	if dgsElementType[child] == "dgs-dxscrollpane" then
		local scrollbars = (dgsElementData[child] or {}).scrollbars
		if scrollbars then
			dgsSetParent(scrollbars[1],parent)
			dgsSetParent(scrollbars[2],parent)
			configScrollPane(child)
		end
	end
	return true
end

function blurEditMemo()
	local dgsType = dgsGetType(MouseData.focused)
	if dgsType == "dgs-dxedit" then
		guiBlur(GlobalEdit)
	elseif dgsType == "dgs-dxmemo" then
		guiBlur(GlobalMemo)
	end
end

function dgsBringToFront(dgsEle,mouse,dontMoveParent,dontChangeData)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsBringToFront",1,"dgs-dxelement")) end
	local parent = FatherTable[dgsEle]	--Get Parent
	local lastFront = MouseData.focused
	if not dontChangeData then
		MouseData.focused = dgsEle
		if dgsGetType(dgsEle) == "dgs-dxedit" then
			MouseData.editCursor = true
			resetTimer(MouseData.EditMemoTimer)
			guiFocus(GlobalEdit)
			dgsElementData[GlobalEdit].linkedDxEdit = dgsEle
		elseif dgsElementType[dgsEle] == "dgs-dxmemo" then
			MouseData.editCursor = true
			resetTimer(MouseData.EditMemoTimer)
			guiFocus(GlobalMemo)
			dgsElementData[GlobalMemo].linkedDxMemo = dgsEle
		elseif dgsEle ~= lastFront then
			local dgsType = dgsGetType(lastFront)
			if dgsType == "dgs-dxedit" then
				guiBlur(GlobalEdit)
			elseif dgsType == "dgs-dxmemo" then
				guiBlur(GlobalMemo)
			end
		end
		if isElement(lastFront) and dgsElementData[lastFront].clearSelection then
			dgsSetData(lastFront,"selectfrom",dgsElementData[lastFront].cursorpos)
		end
	end
	if dgsElementData[dgsEle].changeOrder then
		if not isElement(parent) then
			local layer = dgsElementData[dgsEle].alwaysOn or "center"
			local layerTable = LayerCastTable[layer]
			local id = tableFind(layerTable,dgsEle)
			if id then
				tableRemove(layerTable,id)
				tableInsert(layerTable,dgsEle)
			end
		else
			local parents = dgsEle
			while true do
				local uparents = FatherTable[parents]	--Get Parent
				if isElement(uparents) then
					local children = ChildrenTable[uparents]
					local id = tableFind(children,parents)
					if id then
						tableRemove(children,id)
						tableInsert(children,parents)
						if dgsElementType[parents] == "dgs-dxscrollpane" then
							local scrollbar = dgsElementData[parents].scrollbars
							dgsBringToFront(scrollbar[1],"left",_,true)
							dgsBringToFront(scrollbar[2],"left",_,true)
						end
					end
					parents = uparents
				else
					local id = tableFind(CenterFatherTable,parents)
					if id then
						tableRemove(CenterFatherTable,id)
						tableInsert(CenterFatherTable,parents)
						if dgsElementType[parents] == "dgs-dxscrollpane" then
							local scrollbar = dgsElementData[parents].scrollbars
							dgsBringToFront(scrollbar[1],"left",_,true)
							dgsBringToFront(scrollbar[2],"left",_,true)
						end
					end
					break
				end
				if dontMoveParent then
					break
				end
			end
		end
	end
	dgsFocus(dgsEle)
	lastFront = dgsEle
	if mouse == "left" then
		MouseData.clickl = dgsEle
		if MouseData.interfaceHit and MouseData.interfaceHit[5] then
			MouseData.lock3DInterface = MouseData.interfaceHit[5]
		end
		MouseData.clickData = nil
	elseif mouse == "right" then
		MouseData.clickr = dgsEle
	end
	return true
end

function dgsMoveToBack(dgsEle)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsMoveToBack",1,"dgs-dxelement")) end
	if dgsElementData[dgsEle].changeOrder then
		local parent = FatherTable[dgsEle]	--Get Parent
		if isElement(parent) then
			local children = ChildrenTable[parent]
			local id = tableFind(children,dgsEle)
			if id then
				tableRemove(children,id)
				tableInsert(children,1,dgsEle)
				return true
			end
			return false
		else
			local layer = dgsElementData[dgsEle].alwaysOn or "center"
			local layerTable = LayerCastTable[layer]
			local id = tableFind(layerTable,dgsEle)
			if id then
				tableRemove(layerTable,id)
				tableInsert(layerTable,1,dgsEle)
				return true
			end
			return false
		end
	end
end

------------------------------------------------Type Manager
dgsElementType = {}
dgsType = {
	"dgs-dx3dinterface",
	"dgs-dx3dline",
	"dgs-dx3dtext",
	"dgs-dx3dimage",
	"dgs-dxbutton",
	"dgs-dxedit",
	"dgs-dxmemo",
	"dgs-dxdetectarea",
	"dgs-dxgridlist",
	"dgs-dximage",
	"dgs-dxradiobutton",
	"dgs-dxcheckbox",
	"dgs-dxlabel",
	"dgs-dxscrollbar",
	"dgs-dxscrollpane",
	"dgs-dxselector",
	"dgs-dxswitchbutton",
	"dgs-dxwindow",
	"dgs-dxprogressbar",
	"dgs-dxtabpanel",
	"dgs-dxtab",
	"dgs-dxcombobox",
	"dgs-dxcombobox-Box",
	"dgs-dxcustomrenderer",
	"dgs-dxbrowser",
}

dgsScreen3DType = {
	"dgs-dx3dimage",
	"dgs-dx3dtext",
}

dgsWorld3DType = {
	"dgs-dx3dinterface",
	"dgs-dx3dline",
}

for i=1,#dgsType do
	dgsType[dgsType[i]] = dgsType[i]
end

for i=1,#dgsWorld3DType do
	dgsWorld3DType[dgsWorld3DType[i]] = dgsWorld3DType[i]
end

function dgsGetType(dgsEle)
	if isElement(dgsEle) then return tostring(dgsElementType[dgsEle] or getElementType(dgsEle)) end
	local theType = type(dgsEle)
	if theType == "userdata" and dgsElementType[dgsEle] then return "destroyed element" end
	return theType
end

function dgsIsType(dgsEle,isType)
	if isType then
		if isElement(dgsEle) then
			local t = dgsElementData[dgsEle] and dgsElementData[dgsEle].asPlugin
			if isType == t then return true end
			local t = dgsElementType[dgsEle]
			if isType == t then return true end
			local t = getElementType(dgsEle)
			return t == isType
		else
			return type(dgsEle) == isType
		end
	else
		return isElement(dgsEle) and ((dgsElementType[dgsEle] or (dgsElementData[dgsEle] and dgsElementData[dgsEle].asPlugin) or ""):sub(1,6) == "dgs-dx")
	end
end

function dgsGetPluginType(dgsEle) return dgsEle and (dgsElementData[dgsEle] and dgsElementData[dgsEle].asPlugin or false) or dgsGetType(dgsEle) end

function dgsSetType(dgsEle,myType)
	if isElement(dgsEle) and type(myType) == "string" then
		dgsElementType[dgsEle] = myType
		return true
	end
	return false
end

function dgsIsMaterialElement(ele)
	if isElement(ele) then
		local eleType = getElementType(ele)
		return eleType == "shader" or eleType == "texture"
	end
	return false
end

------------------------------------------------Property Manager
dgsElementData = {[resourceRoot] = {}}		----The Global BuiltIn DGS Element Data Table

function dgsGetData(dgsEle,key)
	return dgsElementData[dgsEle] and dgsElementData[dgsEle][key] or false
end

function dgsSetData(dgsEle,key,value,nocheck)
	local dgsType,key = dgsGetType(dgsEle),tostring(key)
	if not (isElement(dgsEle) and dgsType) then return false end
	dgsElementData[dgsEle] = dgsElementData[dgsEle] or {}
	local oldValue = dgsElementData[dgsEle][key]
	if oldValue == value then return true end
	dgsElementData[dgsEle][key] = value
	if nocheck then return true end
	if dgsType == "dgs-dxscrollbar" then
		if key == "length" then
			local w,h = dgsGetSize(dgsEle,false)
			local isHorizontal = dgsElementData[dgsEle].isHorizontal
			if (value[2] and value[1]*(isHorizontal and w-h*2 or h-w*2) or value[1]) < dgsElementData[dgsEle].minLength then
				dgsElementData[dgsEle].length = {dgsElementData[dgsEle].minLength,false}
			end
		elseif key == "position" then
			if oldValue then
				if not dgsElementData[dgsEle].locked then
					local grades = dgsElementData[dgsEle].grades
					local scaler = dgsElementData[dgsEle].map
					--local nValue,oValue = value/100*(scaler[2]-scaler[1])+scaler[1],oldValue/100*(scaler[2]-scaler[1])+scaler[1]
					local nValue,oValue = value,oldValue
					if grades then
						nValue,oValue = nValue/100*grades+0.5,oValue/100*grades+0.5
						nValue,oValue = nValue-nValue%1,oValue-oValue%1
						dgsSetData(dgsEle,"currentGrade",nValue)
						dgsElementData[dgsEle][key] = nValue/grades*100
					else
						dgsElementData[dgsEle][key] = nValue
					end
					triggerEvent("onDgsElementScroll",dgsEle,dgsEle,dgsElementData[dgsEle][key],oldValue,nValue,oValue)
				else
					dgsElementData[dgsEle][key] = oldValue
				end
			end
		elseif key == "grades" then
			if value then
				local currentGrade = dgsElementData[dgsEle].position/100*value+0.5
				dgsSetData(dgsEle,"currentGrade",currentGrade-currentGrade%1)
			else
				dgsSetData(dgsEle,"currentGrade",false)
			end
		end
	elseif dgsType == "dgs-dxgridlist" then
		if key == "columnHeight" or key == "mode" or key== "scrollBarThick" or key== "leading" then
			configGridList(dgsEle)
		elseif key == "rowData" then
			if dgsElementData[dgsEle].autoSort then
				dgsElementData[dgsEle].nextRenderSort = true
			end
		elseif key == "rowMoveOffset" then
			dgsGridListUpdateRowMoveOffset(dgsEle)
		elseif key == "defaultSortFunctions" then
			local sortFunction = dgsElementData[dgsEle].sortFunction
			local oldDefSortFnc = oldValue
			local oldUpperSortFnc = sortFunctions[oldDefSortFnc[1]]
			local oldLowerSortFnc = sortFunctions[oldDefSortFnc[2]]
			local defSortFnc = dgsElementData[dgsEle].defaultSortFunctions
			local upperSortFnc = sortFunctions[defSortFnc[1]]
			local lowerSortFnc = sortFunctions[defSortFnc[2]]
			local oldSort = sortFunction == oldLowerSortFnc and lowerSortFnc or upperSortFnc
		end
	elseif dgsType == "dgs-dxscrollpane" then
		if key == "scrollBarThick" or key == "scrollBarState" or key == "scrollBarOffset" or key == "scrollBarLength" then
			configScrollPane(dgsEle)
		end
	elseif dgsType == "dgs-dxswitchbutton" then
		if key == "state" then
			triggerEvent("onDgsSwitchButtonStateChange",dgsEle,value,oldValue)
		end
	elseif dgsType == "dgs-dxcombobox" then
		if key == "scrollBarThick" then
			assert(type(value) == "number","Bad argument 'dgsSetData' at 3,expect number got"..type(value))
			local scrollbar = dgsElementData[dgsEle].scrollbar
			configComboBox(dgsEle)
		elseif key == "listState" then
			triggerEvent("onDgsComboBoxStateChange",dgsEle,value == 1 and true or false)
		elseif key == "viewCount" then
			dgsComboBoxSetViewCount(dgsEle,value)
		elseif key == "itemHeight" and dgsElementData[dgsEle].viewCount then
			dgsComboBoxSetViewCount(dgsEle,dgsElementData[dgsEle].viewCount)
		end
	elseif dgsType == "dgs-dxtabpanel" then
		if key == "selected" then
			local old,new = oldValue,value
			local tabs = dgsElementData[dgsEle].tabs
			triggerEvent("onDgsTabPanelTabSelect",dgsEle,new,old,tabs[new],tabs[old])
			if isElement(tabs[new]) then
				triggerEvent("onDgsTabSelect",tabs[new],new,old,tabs[new],tabs[old])
			end
		elseif key == "tabPadding" then
			local width = dgsElementData[dgsEle].absSize[1]
			local change = value[2] and value[1]*width or value[1]
			local old = oldValue[2] and oldValue[1]*width or oldValue[1]
			local tabs = dgsElementData[dgsEle].tabs
			dgsSetData(dgsEle,"tabLengthAll",dgsElementData[dgsEle].tabLengthAll+(change-old)*#tabs*2)
		elseif key == "tabGapSize" then
			local width = dgsElementData[dgsEle].absSize[1]
			local change = value[2] and value[1]*width or value[1]
			local old = oldValue[2] and oldValue[1]*width or oldValue[1]
			local tabs = dgsElementData[dgsEle].tabs
			dgsSetData(dgsEle,"tabLengthAll",dgsElementData[dgsEle].tabLengthAll+(change-old)*mathMax((#tabs-1),1))
		elseif key == "tabAlignment" then
			dgsElementData[dgsEle].showPos = 0
		elseif key == "tabHeight" then
			dgsElementData[dgsEle].configNextFrame = true
		end
	elseif dgsType == "dgs-dxtab" then
		if key == "text" then
			if type(value) == "table" then
				dgsElementData[dgsEle]._translationText = value
				value = dgsTranslate(dgsEle,value,sourceResource)
			else
				dgsElementData[dgsEle]._translationText = nil
			end
			local tabpanel = dgsElementData[dgsEle].parent
			local w = dgsElementData[tabpanel].absSize[1]
			local t_minWid = dgsElementData[tabpanel].tabMinWidth
			local t_maxWid = dgsElementData[tabpanel].tabMaxWidth
			local minwidth = t_minWid[2] and t_minWid[1]*w or t_minWid[1]
			local maxwidth = t_maxWid[2] and t_maxWid[1]*w or t_maxWid[1]
			dgsElementData[dgsEle].text = tostring(value)
			dgsSetData(dgsEle,"width",mathClamp(dxGetTextWidth(tostring(value),dgsElementData[dgsEle].textSize[1],dgsElementData[dgsEle].font or dgsElementData[tabpanel].font),minwidth,maxwidth))
			return triggerEvent("onDgsTextChange",dgsEle)
		elseif key == "width" then
			local tabpanel = dgsElementData[dgsEle].parent
			dgsSetData(tabpanel,"tabLengthAll",dgsElementData[tabpanel].tabLengthAll+(value-oldValue))
		end
	elseif dgsType == "dgs-dxedit" then
		if key == "text" then
			local txtSize = dgsElementData[dgsEle].textSize
			local success = handleDxEditText(dgsEle,value)
			return success
		elseif key == "textSize" then
			dgsElementData[dgsEle].textFontLen = dxGetTextWidth(dgsElementData[dgsEle].text,value[1],dgsElementData[dgsEle].font)
		elseif key == "font" then
			local txtSize = dgsElementData[dgsEle].textSize
			dgsElementData[dgsEle].textFontLen = dxGetTextWidth(dgsElementData[dgsEle].text,txtSize[1],dgsElementData[dgsEle].font)
		elseif key == "padding" then
			configEdit(dgsEle)
		end
	elseif dgsType == "dgs-dxmemo" then
		if key == "text" then
			return handleDxMemoText(dgsEle,value)
		elseif key == "scrollBarThick" then
			configMemo(dgsEle)
		elseif key == "textSize" then
			dgsMemoRebuildTextTable(dgsEle)
		elseif key == "font" then
			dgsMemoRebuildTextTable(dgsEle)
		elseif key == "wordWrap" then
			if value then
				dgsMemoRebuildWordWrapMapTable(dgsEle)
			end
		end
	elseif dgsType == "dgs-dxprogressbar" then
		if key == "progress" then
			triggerEvent("onDgsProgressBarChange",dgsEle,value,oldValue)
		end
	elseif dgsType == "dgs-dx3dinterface" then
		if key == "size" then
			local temprt = dgsElementData[dgsEle].renderTarget
			if isElement(temprt) then
				destroyElement(temprt)
			end
			local renderTarget = dxCreateRenderTarget(value[1],value[2],true)
			dgsSetData(dgsEle,"renderTarget",renderTarget)
		end
	elseif dgsType == "dgs-dximage" then
		if key == "UVSize" then
			local sx,sy,relative = value[1],value[2],value[3]
			if not sx and not sy then
				dgsElementData[dgsEle].renderBuffer.UVSize = {}
			else
				local texture = dgsElementData[dgsEle].image
				if isElement(texture) and getElementType(texture) ~= "shader" then
					local mx,my = dxGetMaterialSize(texture)
					local sx,sy = tonumber(sx),tonumber(sy)
					local sx,sy = relative and (sx or 1)*mx or (sx or mx),relative and (sy or 1)*my or (sy or my)
					dgsElementData[dgsEle].renderBuffer.UVSize = {sx,sy}
				end
			end
		elseif key == "UVPos" then
			local x,y,relative = value[1],value[2],value[3]
			if not x and not y then
				dgsElementData[dgsEle].renderBuffer.UVPos = {}
			else
				local texture = dgsElementData[dgsEle].image
				if isElement(texture) and getElementType(texture) ~= "shader" then
					local x,y,relative = value[1],value[2],value[3]
					local mx,my = dxGetMaterialSize(texture)
					local x,y = tonumber(x),tonumber(y)
					local x,y = relative and (x or 0)*mx or (x or mx),relative and (y or 0)*my or (y or my)
					dgsElementData[dgsEle].renderBuffer.UVPos = {x,y}
				end
			end
		elseif key == "image" then
			local imgType = dgsGetType(value)
			if isElement(value) and imgType ~= "shader" and imgType ~= "dgs-dxcustomrenderer" then
				local UVPos,UVSize = dgsElementData[dgsEle].UVPos or {0,0,true},dgsElementData[dgsEle].UVSize or {1,1,true}
				local x,y,relative = UVPos[1],UVPos[2],UVPos[3]
				local sx,sy,relative = UVSize[1],UVSize[2],UVSize[3]
				local mx,my = dxGetMaterialSize(value)
				local x,y,sx,sy = tonumber(x),tonumber(y),tonumber(sx),tonumber(sy)
				local x,y = relative and (x or 0)*mx or (x or mx),relative and (y or 0)*my or (y or my)
				local sx,sy = relative and (sx or 1)*mx or (sx or mx),relative and (sy or 1)*my or (sy or my)
				dgsElementData[dgsEle].renderBuffer.UVPos = {x,y}
				dgsElementData[dgsEle].renderBuffer.UVSize = {sx,sy}
			end
		end
	end
	if key == "text" then
		if type(value) == "table" then
			dgsElementData[dgsEle]._translationText = value
			value = dgsTranslate(dgsEle,value,sourceResource)
		else
			dgsElementData[dgsEle]._translationText = nil
		end
		dgsElementData[dgsEle].text = tostring(value)
		triggerEvent("onDgsTextChange",dgsEle)
	elseif key == "caption" then
		if type(value) == "table" then
			dgsElementData[dgsEle]._translationText = value
			value = dgsTranslate(dgsEle,value,sourceResource)
		else
			dgsElementData[dgsEle]._translationText = nil
		end
		dgsElementData[dgsEle].caption = tostring(value)
	elseif key == "ignoreParentTitle" then
		configPosSize(dgsEle,false,true)
		if dgsType == "dgs-dxscrollpane" then
			configScrollPane(dgsEle)
		end
	elseif key == "ignoreTitle" then
		local children = dgsGetChildren(dgsEle)
		for i=1,#children do
			if not dgsElementData[children[i]].ignoreParentTitle then
				configPosSize(children[i],false,true)
				if dgsElementType[children[i]] == "dgs-dxscrollpane" then
					configScrollPane(children[i])
				end
			end
		end
	end
	return true
end

compatibility = {}
function checkCompatibility(dgsEle,key)
	local eleTyp = dgsGetType(dgsEle)
	if compatibility[eleTyp] then
		for k,v in pairs(compatibility[eleTyp]) do
			if key == k then
				if not getElementData(localPlayer,"DGS-DEBUG-C") then
					outputDebugString("Deprecated property '"..k.."' @dgsSetProperty with "..eleTyp..". To fix, run it again with command /debugdgs c",2)
					return true
				else
					outputDebugString("Found deprecated property '"..k.."' @dgsSetProperty with "..eleTyp..", replace with "..v,2)
					return false
				end
			end
		end
	end
	return true
end

function dgsSetProperty(dgsEle,key,value,...)
	local isTable = type(dgsEle) == "table"
	if not(dgsIsType(dgsEle) or isTable) then error(dgsGenAsrt(dgsEle,"dgsSetProperty",1,"dgs-dxelement/table")) end
	if isTable then
		for k,v in ipairs(dgsEle) do
			dgsSetProperty(v,key,value,...)
		end
		return true
	else
		assert(checkCompatibility(dgsEle,key),"DGS Compatibility Check")
		if key == "functions" then
			if value then
				local fnc
				if type(value) == "function" then
					fnc = value
				else
					fnc = loadstring(value)
				end
				assert(fnc,"Bad argument @dgsSetProperty at argument 2, failed to load function")
				value = {fnc,{...}}
			end
		elseif key == "text" then
			if dgsElementType[dgsEle] == "dgs-dxmemo" then
				return handleDxMemoText(dgsEle,value)
			elseif dgsElementType[dgsEle] == "dgs-dxedit" then
				return handleDxEditText(dgsEle,value)
			end
		elseif key == "absPos" then
			dgsSetPosition(dgsEle,value[1],value[2],false)
		elseif key == "rltPos" then
			dgsSetPosition(dgsEle,value[1],value[2],true)
		elseif key == "absSize" then
			dgsSetSize(dgsEle,value[1],value[2],false)
		elseif key == "rltSize" then
			dgsSetSize(dgsEle,value[1],value[2],true)
		end
		return dgsSetData(dgsEle,tostring(key),value)
	end
end

function dgsGetProperty(dgsEle,key)
	if not(dgsIsType(dgsEle)) then error(dgsGenAsrt(dgsEle,"dgsGetProperty",1,"dgs-dxelement")) end
	return (dgsElementData[dgsEle] or {})[key] or false
end

function dgsSetProperties(dgsEle,theTable)
	local isTable = type(dgsEle) == "table"
	if not(dgsIsType(dgsEle) or isTable) then error(dgsGenAsrt(dgsEle,"dgsSetProperties",1,"dgs-dxelement/table")) end
	if not(type(theTable) == "table") then error(dgsGenAsrt(theTable,"dgsSetProperties",2,"table")) end
	local dxElements = isTable and dgsEle or {dgsEle}
	for i=1,#dxElements do
		local dgsEle = dxElements[i]
		for key,value in pairs(theTable) do
			dgsSetProperty(dgsEle,key,value)
		end
	end
	return success
end

function dgsGetProperties(dgsEle,properties)
	if not(dgsIsType(dgsEle) or isTable) then error(dgsGenAsrt(dgsEle,"dgsGetProperties",1,"dgs-dxelement/table")) end
	if not(not properties or type(properties) == "table") then error(dgsGenAsrt(properties,"dgsGetProperties",2,"table/none")) end
	if not dgsElementData[dgsEle] then return false end
	if not properties then return dgsElementData[dgsEle] end
	local data = {}
	for k,key in ipairs(properties) do
		data[key] = dgsElementData[dgsEle][key]
	end
	return data
end

function dgsSetPropertyInherit(dxgui,key,value,...)
	local isTable = type(dxgui) == "table"
	if not(dgsIsType(dgsEle) or isTable) then error(dgsGenAsrt(dgsEle,"dgsSetPropertyInherit",1,"dgs-dxelement/table")) end
	local dxElements = isTable and dxgui or {dxgui}
	for i=1,#dxElements do
		local dgsEle = dxElements[i]
		dgsSetProperty(dgsEle,key,value)
		for index,child in ipairs(dgsGetChildren(dgsEle)) do
			dgsSetPropertyInherit(child,key,value,...)
		end
	end
	return true
end