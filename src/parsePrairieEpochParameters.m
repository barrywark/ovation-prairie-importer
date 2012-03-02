function params = parsePrairieEpochParameters(prmPath, ...
		ignoreFields, ...
		ignoreSections, ...
		ADCDeviceParameters, ...
		DACDeviceParameters, ...
		DACStimulusParameters,...
		laserStimulusParameters, ...
		protocolParameters...
		)
% Parse Epoch protocol parameters from Prarie Systems .prm file.

	
	paramLines=importdata(prmPath);
	skipSection = false;
	for n=2:numel(paramLines)
		item=cell2mat(paramLines(n));
		name=item(1:strfind(item,'=')-1);
		
		if(isempty(name)) % Section header
			[~,~,idx] = regexp(item, '^\[(.*)\]$', 'ONCE');
			sectionName = item(idx(1):idx(2));
			if(any(cell2mat(regexp(strtrim(sectionName), ignoreSections))))
				skipSection = true;
			else
				skipSection = false;
			end
		end
		
		if(~skipSection)
			if(any(cell2mat(regexp(strtrim(name), ignoreFields))))
				continue;
			end
			
			paramName = genParamStructName(name);
			
			
			value = item(strfind(item,'=')+1:end);
			%TODO if has "...", parse as string
			
			if(isempty(value) || isempty(paramName))
				continue;
			end
			
			
			if(isempty(regexp(value, '^".*"$', 'ONCE')))
				if(strcmp(value, 'FALSE'))
					value = false;
				elseif(strcmp(value,'TRUE'))
					value = true;
				else
					value = str2double(value);
				end
				
				bulkParams.(paramName) = value;
			else
				[~,~,idx] = regexp(value, '^"(.*)"$');
				value = value(idx{1}(1):idx{1}(2));
				if(isempty(value))
					value = '(empty)';
				end
				bulkParams.(paramName) = value;
			end
		end
	end
	
	params.allParameters = bulkParams;
	params.ADCDeviceParameters = copyStructFields(params.allParameters, ADCDeviceParameters);
	params.DACDeviceParameters = copyStructFields(params.allParameters, DACDeviceParameters);
	params.DACStimulusParameters = copyStructFields(params.allParameters, DACStimulusParameters);
	params.laserStimulusParameters = copyStructFields(params.allParameters, laserStimulusParameters);
	params.protocolParameters = copyStructFields(params.allParameters, protocolParameters);
	
end