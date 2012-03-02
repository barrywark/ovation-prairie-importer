function [epochGroup] = ImportPrairie(...
        epochGroup, ...
        xmlPath, ...
        maxEpochDuration,...
        skipLineScanImages)
    
    % Import a Prairie View experiment into the Ovation database.
    %
    %    [project,source, epochGroup] = ImportPrairie(...
    %    epochGroup, ...
    %	 xmlPath, ...
    %	 maxEpochDuration,...
    %    skipLineScanImages)
    %
    %    epochGroup:           Imported data is inserted into this ovation.EpochGroup
    %    xmlPath:              Path to Prairie View experiment XML file
    %    maxEpochDuration:     Maximum Epoch duration in seconds
    %    skipLineScanImages:   true or false; if true, none of the images in
    %                          linescan folders are imported
    %
    %    Returns:
    %      epochGroup: ovation.EpochGroup containing the new data
    
    
    import ovation.*;
    
    [baseDir,baseName] = fileparts(xmlPath);
    
    %% Device manufacturers
    
    scanManufacturer = 'Prairie Systems';
    adcManufacturer = 'Prairie Systems';
    dacManufacturer = 'Prairie Systems';
    
    %% Prairie fields to import or ignore
    ignoreFields = { 'Shutter/Acq delay',...
        'Open/Close Shutter',...
        'Open Shutter Time',...
        'Output Rate',...
        'Points Hold Time',...
        'Points Move Time',...
        'Points First Delay',...
        'Points Graph Color', ...
        'DAC[0-7] Graph Color',...
        'DAC[0-7] IV.*',...
        'DAC[0-7] Ramp.*',...
        'System Selector',...
        'Camera Select',...
        'PMT Filter',...
        'Dichroic Select 1',...
        'Dichroic Select 2',...
        'Neutral Density Filter',...
        'Exciter Filter',...
        'Emission Filter',...
        'On/Off',...
        'DAC Out',...
        '^Holding Potential',...
        '^Pulse Potential',...
        '^Pulse Duration',...
        '^Ext Sensitivity',...
        'Frequency',...
        'Frequency Mode',...
        '^Output Rate&',...
        '.*y-min$',...
        '.*y-max$',...
        'Actual Scan Period',...
        'Compose',...
        '^Amplifier',...
        'Shutter Control',...
        'Leak Subtraction',...
        'Leak Subtraction 2',...
        'Number of Pre-pulses',...
        'Shutter Acq',...
        'Scale Data',...
        'Binning Mode',...
        'Offset',...
        'Gain',...
        'Exposure Time',...
        'Interface Name',...
        'Auto. Scale',...
        'Func\..* Map.*',...
        };
    
    ignoreSections = { 'Continuous Pulse',...
        'Channel Units',...
        'Channel Color',...
        'Automatic Gain Sensing',...
        'Gain Channel',...
        'Channel Min-Max',...
        };
    
    ADCDeviceParameters = { 'Acquisition_Rate',...
        'Manual_Sensitivity',... % this is Ch0 sensitivity
        'Sensitivity_[1-7]',...
        'Ch_[0-7]_Status',...
        'Ch_[0-7]_Name',...
        };
    
    DACDeviceParameters = { 'DAC[0-7]_DAC_Label',...
        'DAC[0-7]_Output_Signal',...
        'DAC[0-7]_Ext_Sensitivity',...
        };
    
    DACStimulusParameters = { 'DAC[0-7]_Protocol',...
        'DAC[0-7]_Num_.*_Pulse_Trains',...
        'DAC[0-7]_Time_Delay_Between_Pulse_Trains',...
        'DAC[0-7]_Time_Delay_to_First_Pulse_Train',...
        'DAC[0-7]_Train_.*',...
        'DAC[0-7]_Custom_Waveform_File',...
        'DAC[0-7]_Custom_Waveform_Holding_Pot',...
        };
    
    laserStimulusParameters = { ...
        'Number_Points', ...
        'Point_\d.*' ...
        };
    
    % protocol parameters are more efficient to query, so some redundancy
    % here with device and stimulus parameters
    protocolParameters = { 'Number_of_Cycles',...
        'Cycle_Period',...
        'Acquisition_Time',...
        'Ch_[0-7]_Name' ...
        'Ch_[0-7]_Status'...
        'DAC[0-7]_DAC_Label',...
        'DAC[0-7]_Output_Signal',...
        'DAC[0-7]_Ext_Sensitivity',...
        'DAC[0-7]_Num_.*_Pulse_Trains',...
        'DAC[0-7]_Time_Delay_Between_Pulse_Trains',...
        'DAC[0-7]_Time_Delay_to_First_Pulse_Train',...
        'DAC[0-7]_Train_.*',...
        'Acquire_Loop',...
        'Marked_Point_Number',...
        'Functional_Mapping',...
        'Marked_Point_Devices',...
        'Marked_Points_During_Acq',...
        'First_Point_Delay',... % skip if DAC6 sync
        'Hold_Time',... % skip if DAC6 sync
        'Move_Time',...
        'Sync_With_DAC',...
        'Sync_DAC',...
        };
    
    %% Read XML
    
    scanConfigDom = xmlread(xmlPath);
    scanInfo = scanConfigDom.getDocumentElement();
    expDate = char(scanInfo.getAttribute('date'));
    prarieScanVersion = char(scanInfo.getAttribute('version'));
    
    rigConfig = parsePrairieSystemConfiguration(scanConfigDom);
    
    
    %% Insert Epochs (one Epoch per Sequence item in XML)
    
    epochElements = scanConfigDom.getElementsByTagName('Sequence');
    epoch = [];
    disp('Importing Prairie...');
    for i=0:epochElements.getLength() - 1 % For each Sequence element in the XML file
        disp(['    Epoch ' num2str(i+1) '...']);
        epochItem = epochElements.item(i);
        protocolType = char(epochItem.getAttribute('type'));
        if(strcmp(protocolType, 'TSeries Timed Element'))
            protocolType = 'ZSeries';
        end
        
        % File names
        % the cycle number in the file names of source and reference tiffs
        % always correspond to the cycle number attribute in the xml file
        cycleNumber = str2double(epochItem.getAttribute('cycle'));
        % the cycle number in the file names of prm, dat, and line tiffs
        % correspond to the sequence number in the xml file (i+1 in this
        % loop) but sometimes not the cycle number attribute depending on
        % how the epoch was initiated in Prairie software
        cycleName = ['_Cycle' sprintf('%.3d', i+1)];
        
        % Check for prm and dat files if Linescan
        % NB needs to be modified if there is more than one line
        lineData = ['_Data_Line' sprintf('%.6d', 1)];
        prmPath = fullfile(baseDir, [baseName cycleName lineData '.prm']);
        datPath = fullfile(baseDir, [baseName cycleName lineData '.dat']);
        if strcmp(protocolType, 'Linescan')
            if ~checkPrairieFile(prmPath) || ~checkPrairieFile(datPath)
                disp(['      Skipped Importing Epoch ' num2str(i+1)]);
                continue
            end
        end
        
        % NB We don't know the epoch start/end time!
        % We need at least an epoch start time. For now, we're using the
        % modification date/time of the prm file. This is a bad
        % approximation, at best.
        startTime = org.joda.time.DateTime(java.io.File(prmPath).lastModified());
        endTime = startTime.plusSeconds(maxEpochDuration); % NB we're cheating by picking a large Epoch duration
        
        % NB we're dumping these into protocolParameters now, but they
        % would go in a Stimulus' parameters if there is a stimulus (i.e.
        % command) to the microscope stage.
        parameters.xYStageGridNumXPositions = str2double(char(epochItem.getAttribute('xYStageGridNumXPositions')));
        parameters.xYStageGridNumYPositions = str2double(char(epochItem.getAttribute('xYStageGridNumYPositions')));
        parameters.xYStageGridOverlapPercentage = str2double(char(epochItem.getAttribute('xYStageGridOverlapPercentage')));
        parameters.xYStageGridXOverlap = str2double(char(epochItem.getAttribute('xYStageGridXOverlap')));
        parameters.xYStageGridYOverlap = str2double(char(epochItem.getAttribute('xYStageGridYOverlap')));
        
        % Parse protocol params
        if(strcmp(protocolType, 'Linescan'))
            lineScanParametersItems = epochItem.getElementsByTagName('PVLinescanDefinition');
            assert(length(lineScanParametersItems) == 1);
            lineScanParameters = parsePVLineScanParameters(lineScanParametersItems.item(0));
            parameters = mergeStruct(parameters, lineScanParameters);
            protocolID = ['PVScan.' protocolType '.' parameters.pvLinescanMode];
        elseif(strcmp(protocolType, 'ZSeries'))
            extraParametersItems = epochItem.getElementsByTagName('ExtraParameters');
            assert(length(extraParametersItems) == 1);
            parametersItem = extraParametersItems.item(0);
            parameters.validData = parametersItem.getAttribute('validData');
            protocolID = ['PVScan.' protocolType];
        end
        
        % Parse params from prm
        if(strcmp(protocolType, 'Linescan'))
            prmParameters = parsePrairieEpochParameters(prmPath, ...
                ignoreFields, ...
                ignoreSections, ...
                ADCDeviceParameters, ...
                DACDeviceParameters, ...
                DACStimulusParameters,...
                laserStimulusParameters, ...
                protocolParameters...
                );
            
            parameters = mergeStruct(parameters, prmParameters.protocolParameters);
            
            % If using DAC Sync, remove bogus parameters
            if(prmParameters.protocolParameters.Sync_With_DAC)
                parameters = rmfield(parameters, 'First_Point_Delay');
                parameters = rmfield(parameters, 'Hold_Time');
            end
            
        end
        
        % If we've already imported an epoch, we can set prev/next associations
        if(~isempty(epoch))
            oldEpoch = epoch;
        else
            oldEpoch = [];
        end
        
        epoch = epochGroup.insertEpoch(startTime,...
            endTime,...
            protocolID,...
            struct2map(parameters)...
            );
        
        if(~isempty(oldEpoch))
            epoch.setPreviousEpoch(oldEpoch);
        end
        
        
        % Import images
        if strcmp(protocolType,'Linescan') && skipLineScanImages
            epoch.addTag('LS images not imported');
        else
            % Add linescan reference image as a Resource
            if(strcmp(protocolType, 'Linescan'))
                refImagePath=fullfile(baseDir, [baseName ['-Cycle' sprintf('%.3d', cycleNumber)] '-LinescanReference.tif']);
                if checkPrairieFile(refImagePath)
                    epoch.addResource(refImagePath);
                end
            end
            
            % Collect frame images for each channel
            frameElements = epochItem.getElementsByTagName('Frame');
            frameInfo = [];
            for frame = 0:frameElements.getLength() - 1
                
                frameElement = frameElements.item(frame);
                
                frameIndex = str2double(char(frameElement.getAttribute('index')));
                
                % We don't currently use relative and aboslute time, waiting on
                % Prairie Systems tech support for information on their meaning.
                frameRelativeTime = str2double(char(frameElement.getAttribute('relativeTime')));
                frameAbsoluteTime = str2double(char(frameElement.getAttribute('absoluteTime')));
                
                fileItems = frameElement.getElementsByTagName('File');
                for j=0:fileItems.getLength() - 1
                    fileItem = fileItems.item(j);
                    
                    channelNumber = str2double(char(fileItem.getAttribute('channel')));
                    channelName = char(fileItem.getAttribute('channelName'));
                    tiffFilePath = fullfile(baseDir, char(fileItem.getAttribute('filename')));
                    
                    % We don't currently use preAmpID
                    preAmpID = str2double(char(fileItem.getAttribute('preAmpID')));
                    
                    if(strcmp(protocolType, 'Linescan'))
                        tiffData = rot90(imread(tiffFilePath)); % display time zero on the left
                    elseif(strcmp(protocolType, 'ZSeries'))
                        tiffData = imread(tiffFilePath);
                    end
                    
                    frameInfo(frameIndex).tiffData{channelNumber} = tiffData; %#ok<AGROW>
                end
                
                frameInfo(frameIndex).deviceParameters = parsePVDeviceParameters(frameElement, ['frame_' num2str(frame+1)]); %#ok<AGROW>
            end
            % get deviceParams for first and last frame of a Z series
            firstAndLastFrameParams=mergeStruct(frameInfo(1).deviceParameters,frameInfo(end).deviceParameters);
            
            % put all TIFF images into an appropriate Response. We will have
            % one Response per TIFF channel, corresponding to a 3D matrix,
            % height x width x frames.
            scanDeviceParams = struct();
            
            stacks = struct();
            nFrames = length(frameInfo);
            for j = 1:nFrames
                scanDeviceParams = mergeStruct(scanDeviceParams, firstAndLastFrameParams);
                for k = 1:length(frameInfo(j).tiffData)
                    channelName = ['channel_' num2str(k)];
                    if(~isfield(stacks, channelName))
                        stacks.(channelName) = frameInfo(j).tiffData{k};
                    else
                        if(~isempty(frameInfo(j).tiffData{k})) % Skip empty tiff data (BW 3-11-2011)
                            t = stacks.(channelName);
                            t(:,:,end+1) = frameInfo(j).tiffData{k}; %#ok<AGROW>
                            stacks.(channelName) = t;
                        end
                    end
                end
            end
            
            scanDeviceParams = mergeStruct(scanDeviceParams, rigConfig); % NB <SystemConfig><Lasers> being put in with scanDeviceParams
            
            if(strcmp(protocolType, 'Linescan'))
                units='none';
                labels={'pixel','time'};
                samplingRate=[1, 1/scanDeviceParams.frame_1_scanlinePeriod];
                samplingRateUnits={'pixel','Hz'};
            elseif(strcmp(protocolType, 'ZSeries'))
                units='none';
                labels={'y','x','z'};
                samplingRate=[1,1,1];
                samplingRateUnits={'pixel','pixel','frame'};
            end
            
            channelNames = fieldnames(stacks);
            for j = 1:length(channelNames)
                cName = channelNames{j};
                if(~isempty(stacks.(cName))) % Skip empty tiff data (BW 3-11-2011)
                    data = ovation.NumericData(int32(stacks.(cName)(:)'), size(stacks.(cName)));
                    dev = epochGroup.getExperiment().externalDevice(cName, scanManufacturer);
                    dev.addProperty('version', prarieScanVersion);
                    epoch.insertResponse(dev, ...
                        struct2map(scanDeviceParams), ...
                        data, ...
                        units, ...
                        labels, ...
                        samplingRate, ...
                        samplingRateUnits, ...
                        Response.NUMERIC_DATA_UTI); %TODO
                    % add Linescan source image as a Resource
                    if strcmp(protocolType, 'Linescan')
                        chNumIndex=strfind(cName,'_')+1;
                        sourceImagePath=fullfile(baseDir, [baseName ['-Cycle' sprintf('%.3d', cycleNumber)] '_Ch' cName(chNumIndex:end) 'Source.tif']);
                        if checkPrairieFile(sourceImagePath)
                            epoch.addResource(sourceImagePath);
                        end
                    end
                end
            end
            
        end
        
        
        % Read dat data and put it into Responses
        if(strcmp(protocolType, 'Linescan'))
            
            dat = readDatFile(datPath);
            
            % get active ADC channels
            ADCs=[];
            for j = 0:7
                if prmParameters.ADCDeviceParameters.(['Ch_' num2str(j) '_Status'])
                    ADCs(end+1) = j; %#ok<AGROW>
                end
            end
            
            gains = zeros(length(ADCs),1);
            for j = 1:length(ADCs)
                if ADCs(j) == 0
                    gains(j) = prmParameters.ADCDeviceParameters.Manual_Sensitivity;
                else
                    gains(j) = prmParameters.ADCDeviceParameters.(['Sensitivity_' num2str(ADCs(j))]);
                end
            end
            
            mVDat = dat ./ repmat(gains, 1, size(dat,2)) *1000; % dat in mV
            
            for j = 1:length(ADCs)
                dev = experiment.externalDevice(['ADC' num2str(ADCs(j))], adcManufacturer);
                
                % get ADC parameters for ADC channel to import
                ADCdeviceParams = prefixedFields(prmParameters.ADCDeviceParameters,['Ch_' num2str(ADCs(j))]);
                ADCdeviceParams.Acquisition_Rate=prmParameters.ADCDeviceParameters.Acquisition_Rate;
                if ADCs(j) == 0
                    ADCdeviceParams.Manual_Sensitivity = gains(j);
                else
                    ADCdeviceParams.(['Sensitivity_' num2str(ADCs(j))]) = gains(j);
                end
                
                epoch.insertResponse(dev, ...
                    struct2map(ADCdeviceParams), ...
                    ovation.NumericData(mVDat(j,:)), ...
                    'mV', ...
                    [], ...
                    prmParameters.ADCDeviceParameters.Acquisition_Rate, ...
                    'Hz', ...
                    Response.NUMERIC_DATA_UTI); %TODO
            end
            
            clear mVDat dat;
            
            
            % Create Stimuli for each DAC output
            % skip DACs 5 and 7 (uncaging x and y galvos)
            for c = [0:4,6] % NB 8 DAC channels Max
                dacName = ['DAC' num2str(c)];
                
                % skip DACs that are off
                output = prmParameters.DACDeviceParameters.([dacName '_Output_Signal']);
                if ~output
                    %disp(['    Skipping ' dacName]);
                    continue;
                end
                
                % get parameters for DAC channel to import
                DACdeviceParams = prefixedFields(prmParameters.DACDeviceParameters, dacName);
                DACstimulusParams = prefixedFields(prmParameters.DACStimulusParameters, dacName);
                
                dev = experiment.externalDevice(dacName, dacManufacturer);
                epoch.insertStimulus(dev, ...
                    struct2map(DACdeviceParams), ...
                    'org.hhmi.janelia.murphy.prarie.DAC', ...
                    struct2map(DACstimulusParams), ...
                    'mV', ...
                    []);
            end
            
            
            % Create Stimulus for laser output
            if ~skipLineScanImages
                if isempty(prmParameters.laserStimulusParameters)
                    prmParameters.laserStimulusParameters.Number_Points=0;
                end
                dev = experiment.externalDevice('laser', scanManufacturer);
                epoch.insertStimulus(dev,...
                    struct2map(scanDeviceParams),...
                    'org.hhmi.janelia.murphy.photolysis_points',...
                    struct2map(prmParameters.laserStimulusParameters),...
                    'pixel', ...
                    []);
            end
            
        end
    end
end
