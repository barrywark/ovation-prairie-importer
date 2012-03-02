
classdef TestParsePrairieSystemConfiguration < TestBase
    
    properties
        xmlPath
    end
    
    methods
        function self = TestParsePrairieSystemConfiguration(name)
            self = self@TestBase(name);
            self.xmlPath = 'fixtures/LineScan-01042011-1453-883/LineScan-01042011-1453-883.xml';
        end
        
        function testShouldParseSystemConfiguration
            %% Read XML
            
            scanConfigDom = xmlread(xmlPath);
            scanInfo = scanConfigDom.getDocumentElement();
            expDate = char(scanInfo.getAttribute('date'));
            prarieScanVersion = char(scanInfo.getAttribute('version'));
            
            config = parsePrairieSystemConfiguration(scanConfigDom);
            
            assert(length(config.lasers) == 1);
            assert(strcmp(config.lasers(1).name, 'Pockels'));
            assert(0 == config.lasers(1).index);
        end
    end
end