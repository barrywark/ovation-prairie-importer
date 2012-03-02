function params = parsePVDeviceParameters(stateElement, prefix)
% Parse a PVStateShard element
	
	keyElements = stateElement.getElementsByTagName('Key');
	for i = 0:keyElements.getLength() - 1
		keyElem = keyElements.item(i);
		key = char(keyElem.getAttribute('key'));
		value = char(keyElem.getAttribute('value'));
		if(~isnan(str2double(value)))
			value = str2double(value);
		end
		
		params.([prefix '_' key]) = value;
	end
end