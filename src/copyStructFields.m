function result = copyStructFields(src, fields)

	srcFields = fieldnames(src);
	for i = 1:length(srcFields)
		field = srcFields{i};
		if(any(cell2mat(regexp(field, fields))))
			result.(field) = src.(field);
		end
	end
end