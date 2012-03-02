function params = parsePVLineScanParameters(pvLineScanDefinitionNode)
% Parse a PVLineScanDefinition XML node into a parameters struct
	
	params.pvLinescanMode = char(pvLineScanDefinitionNode.getAttribute('mode'));
	if(strcmp(params.pvLinescanMode, 'freeHand'))
		freehandElements = pvLineScanDefinitionNode.getElementsByTagName('Freehand');
		for i=0:freehandElements.getLength() - 1
			element = freehandElements.item(i);
			params.(['x_' num2str(i+1)]) = str2double(char(element.getAttribute('x')));
			params.(['y_' num2str(i+1)]) = str2double(char(element.getAttribute('y')));
		end
	elseif(strcmp(params.pvLinescanMode, 'straightLine'))
		lineElements = pvLineScanDefinitionNode.getElementsByTagName('Line');
		assert(length(lineElements) == 1);
		lineElement = lineElements.item(0);
		attributes = lineElement.getAttributes();
		for j = 0:attributes.getLength()-1
			attr = attributes.item(j);
			params.(char(attr.getName())) = str2double(char(attr.getValue()));
		end
	else
		error(['Unknown linescan mode: ' params.pvLinescanMode]);
	end
end