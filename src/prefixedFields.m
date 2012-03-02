function result = prefixedFields(s, prefix)
	% Collects fields from a struct whose name has the specified prefix.
	%
	%    result = prefixedFields(s, prefix)
	%
	%      s: struct
	%      prefix: field name prefix
	%
	% Usage
	% =====	
	% >>> s.abc_def = 1;
	% >>> s.def_abc = 2;
	% >>> prefixedFields(s, 'abc')
	% 
	% ans = 
	% 
	% abc_def: 1
	% 
	% >>> prefixedFields(s, 'def')
	% 
	% ans = 
	% 
	% def_abc: 2
	% 
	% >>> prefixedFields(s, 'xyz')
	
	fnames = fieldnames(s);
	for i = 1:length(fnames)
		if(regexp(fnames{i}, ['^' prefix]))
			result.(fnames{i}) = s.(fnames{i});
		end
	end
	
end