% Copyright (c) 2012 Physion Consulting, LLC

function testfixture(test_folder)
    % This script builds a new Ovation database for testing and imports the
    % test fixture. Run this script from the test directory.
    %
    % After running runtestsuite, you may run runtests (the Matlab xUnit test
    % runner) to re-run the test suite without building a new database or
    % re-importing the test fixture data.
    %
    % Run the test suite with:
    %    runtests(test_folder, '-xmlfile', 'test-output.xml');
        
    error(nargchk(0, 1, nargin)); %#ok<NCHKI>
    if(nargin < 1)
        test_folder = pwd();
    end
    
    % N.B. these values should match in TestBase
    connection_file = fullfile(test_folder, 'ovation', 'prairie_matlab_test.connection');
    username = 'TestUser';
    password = 'password';
    
    
    % Delete the test database if it exists
    if(exist(connection_file, 'file') ~= 0)
        ovation.util.deleteLocalOvationDatabase(connection_file, true);
    end
    
    % Create a test database
    system('mkdir -p ovation');
    
    connection_file = ovation.util.createLocalOvationDatabase(fullfile(test_folder, 'ovation'), ...
        'prairie_matlab_test',...
        username,...
        password,...
        'license.txt',...
        'ovation-development');
    
    import ovation.*
    
    ctx = Ovation.connect(fullfile(pwd(), connection_file), username, password);
    
    project = ctx.insertProject('TestImportMapping',...
        'TestImportMapping',...
        datetime());
    
    project.insertExperiment('TestImportMapping',...
        datetime());
end
