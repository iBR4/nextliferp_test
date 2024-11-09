CursorData = {
	size = 18,
	enabled = false,
	color = tocolor(255,255,255,255),
}

function dgsSetCustomCursorImage(cursorType,image,rotation,rotationCenter,offset,scale)
	local style = styleSettings.cursor
	if not cursorType then	--Apply all (image in current style)
		for k,v in pairs(cursorTypesBuiltIn) do
			local texture = dgsCreateTextureFromStyle(style[k].image)
			CursorData[k] = {texture,style[k].rotation or 0,style[k].rotationCenter or {0,0},style[k].offset or {0,0},style[k].scale,{dxGetMaterialSize(texture)}}
		end
	else
		if not(type(cursorType) == "string" and cursorTypesBuiltIn[cursorType]) then error(dgsGenAsrt(cursorType,"dgsSetCustomCursorImage",1,"string",_,_,"unsupported type")) end
		if image then
			if not(isMaterial(image)) then error(dgsGenAsrt(image,"dgsSetCustomCursorImage",2,"material")) end
			CursorData[k] = {image,rotation or style[k].rotation or 0,rotationCenter or style[k].rotationCenter or {0,0},offset or style[k].offset or {0,0},scale or style[k].scale,{dxGetMaterialSize(image)}}
		else
			CursorData[k] = nil
		end
	end
	return true
end

function dgsGetCustomCursorImage(cursorType)
	if not(type(cursorType) == "string" and cursorTypesBuiltIn[cursorType]) then error(dgsGenAsrt(cursorType,"dgsGetCustomCursorImage",1,"string",_,_,"unsupported type")) end
	return CursorData[cursorType] or false
end

function dgsSetCustomCursorEnabled(state)
	CursorData.enabled = state and true or false
	return true
end

function dgsGetCustomCursorEnabled()
	return CursorData.enabled
end

function dgsSetCustomCursorSize(size)
	if not(type(size) == "number") then error(dgsGenAsrt(size,"dgsSetCustomCursorSize",1,"number")) end
	CursorData.size = size
	return true
end

function dgsGetCustomCursorSize()
	return CursorData.size
end

function dgsGetCustomCursorType()
	return MouseData.cursorType or "arrow"
end

function dgsSetCustomCursorColor(color)
	if not(type(color) == "number") then error(dgsGenAsrt(color,"dgsSetCustomCursorColor",1,"number")) end
	CursorData.color = color
	return true
end

function dgsGetCustomCursorColor()
	return CursorData.color
end