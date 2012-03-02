function field = genParamStructName(name)
	field = genvarname(regexprep(name, '[\ -/]', '_'));
end