function v = readDatFile(datFile)
% Read a Prarie systems .dat file
%
%    v = readDatFile(datFile)
%
%    Returns a matrix nChannels x nSamples.
%
% From Prarie View Documentation
% ------------------------------
% Acquisition Binary File Format
% 
% The format for the binary file that is used within TriggerSync for saving experiment data is as follows:
% 
% The file begins with 616 bytes of header (starting with ÎDTLGÌ), which appears is irrelevant for the purposes of extracting data, but a good check to validate the file format.
% 
% The next byte (first important value) at a hex address of 268 is the number of channels/sets of data stored as a 4 byte long.
% 
% The value after that at address 26C is the number of data points in the sample stored as a 4 byte long.
% 
% The rest of the file starting at address 270 is a listing of all of the data values in the following order:
% 
%     Channel 1:Value 1, Channel 1:Value 2 . . . Channel 1:Value N
% 
%     Channel 2:Value 1, Channel 2:Value 2 . . . Channel 2:Value N
% 
%     Channel M:Value 1, Channel M:Value 2 . . . Channel M:Value N
% 
% Each of these values is stored in a 32 bit IEEE single precision floating point format.
% 
% All values are stored as big endian. 
	

	precision='float32';  % single precision 32 bit floating point
	machineformat='ieee-be';  % big endian
	byteOrder = 'b'; % big endian
	fileID=fopen(datFile);
	
	% Skip header, 616 bytes from file start
	HEADER_BYTES = 616;
	status = fseek(fileID, HEADER_BYTES, 'bof');
	if(status ~= 0)
		error(ferror(fileID));
	end
	
	% Read number of channels
	INTEGER_TYPE = 'int32';
	nChannels = fread(fileID, 1, INTEGER_TYPE, byteOrder);
	
	% Read number of samples
	nSamples = fread(fileID, 1, INTEGER_TYPE, byteOrder);
	
	% Read channels column-wise into result, then transpose to 
	% [nChannels x nSamples].
	v = fread(fileID, [nSamples, nChannels], precision, machineformat)';
	
	fclose(fileID);
end