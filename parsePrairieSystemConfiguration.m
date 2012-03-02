function rigConfig = parsePrairieSystemConfiguration(scanConfigDom)
	
	systemConfigItems = scanConfigDom.getElementsByTagName('SystemConfiguration');
	assert(length(systemConfigItems) == 1);
	systemConfigItem = systemConfigItems.item(0);
	
	% parse lasers
	lasersItems = systemConfigItem.getElementsByTagName('Lasers');
	assert(lasersItems.getLength() == 1);
	lasersItem = lasersItems.item(0);
	
	laserItems = lasersItem.getElementsByTagName('Laser');
	for i = 0:laserItems.getLength() - 1
		laserItem = laserItems.item(i);
		
		rigConfig.(['lasers_' num2str(i+1) '_name']) = char(laserItem.getAttribute('name'));
		rigConfig.(['lasers_' num2str(i+1) '_index']) = str2double(char(laserItem.getAttribute('index')));
	end
	
end