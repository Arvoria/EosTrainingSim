local function DeepEqual(expected: table, actual: table): boolean
	if expected == actual then
	  	return true
	end

	local expectedType = type(expected)
	local actualType = type(actual)
	if expectedType ~= actualType then
	  return false
	end
	if expectedType ~= "table" then
	  return false
	end

	local expectedLength = #expected
	local actualLength = #actual

	for key in pairs(expected) do
	  	if actual[key] == nil then
			return false
	  	end
	  	local same = expected[key] == actual[key]
	  	if not same then
			return same
	  	end
	end

	if expectedLength ~= actualLength then
	  	return false
	end

	for key in pairs(actual) do
		if expected[key] == nil then
			return false
	  	end
	end

	return true
end

return DeepEqual