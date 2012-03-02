classdef TestParsePrairieParameters < TestBase
    
    properties
        prmPath
    end
    
    methods
        function self = TestParsePrairieParameters(name)
            self = self@TestBase(name);
        end
        
        
        function testShouldParsePrairieParameters(self)
            expected.allParameters.Number_of_Cycles=1;
            expected.allParameters.Cycle_Period=1001;
            expected.allParameters.Acquisition_Time=500;
            expected.allParameters.Acquisition_Rate=20000;
            expected.allParameters.Points_Hold_Time=0.100000; %Skip??
            expected.allParameters.Points_Move_Time=0.200000; %Skip??
            expected.allParameters.Points_First_Delay=0.000000;
            
            expected.allParameters.DAC0_Protocol=3;
            expected.allParameters.DAC0_Output_Signal=false;
            expected.allParameters.DAC0_DAC_Label='(empty)';
            expected.allParameters.DAC0_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC0_Num_Pulse_Trains=1;
            expected.allParameters.DAC0_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC0_Time_Delay_Between_Pulse_Trains=100.000000; %ms
            expected.allParameters.DAC0_Time_Delay_to_First_Pulse_Train=0.000000; %ms
            expected.allParameters.DAC0_Train_Pulse_Pot_1=3.000000;
            expected.allParameters.DAC0_Train_Pulse_Duration_1=3.000000; %_(ms)
            expected.allParameters.DAC0_Train_Num_Pulses_1=4;
            expected.allParameters.DAC0_Train_First_Pulse_Delay_1=0.000000; %_(ms)
            expected.allParameters.DAC0_Train_Inter_Pulse_Delay_1=100.000000; %_(ms)
            expected.allParameters.DAC0_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC0_Ext_Sensitivity=20; % - Device output is 1V per this mV
            expected.allParameters.DAC0_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC0_Custom_Waveform_Holding_Pot=0;
            
            
            expected.allParameters.DAC1_Protocol=2;
            expected.allParameters.DAC1_Output_Signal=false;
            expected.allParameters.DAC1_DAC_Label='(empty)';
            expected.allParameters.DAC1_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC1_Num_Pulse_Trains=1;
            expected.allParameters.DAC1_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC1_Time_Delay_Between_Pulse_Trains=0.000000;
            expected.allParameters.DAC1_Time_Delay_to_First_Pulse_Train=100.000000;
            expected.allParameters.DAC1_Train_Pulse_Pot_1=5000.000000;
            expected.allParameters.DAC1_Train_Pulse_Duration_1=0.100000;
            expected.allParameters.DAC1_Train_Num_Pulses_1=1;
            expected.allParameters.DAC1_Train_First_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC1_Train_Inter_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC1_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC1_Ext_Sensitivity=2;
            expected.allParameters.DAC1_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC1_Custom_Waveform_Holding_Pot=0;
            
            expected.allParameters.DAC2_Protocol=2;
            expected.allParameters.DAC2_Output_Signal=false;
            expected.allParameters.DAC2_DAC_Label='(empty)';
            expected.allParameters.DAC2_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC2_Num_Pulse_Trains=1;
            expected.allParameters.DAC2_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC2_Time_Delay_Between_Pulse_Trains=0.000000;
            expected.allParameters.DAC2_Time_Delay_to_First_Pulse_Train=0.000000;
            expected.allParameters.DAC2_Train_Pulse_Pot_1=100.000000;
            expected.allParameters.DAC2_Train_Pulse_Duration_1=10.0;
            expected.allParameters.DAC2_Train_Num_Pulses_1=3;
            expected.allParameters.DAC2_Train_First_Pulse_Delay_1=1.000000;
            expected.allParameters.DAC2_Train_Inter_Pulse_Delay_1=1000.000000;
            expected.allParameters.DAC2_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC2_Ext_Sensitivity=20;
            expected.allParameters.DAC2_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC2_Custom_Waveform_Holding_Pot=0;
            
            expected.allParameters.DAC3_Protocol=3;
            expected.allParameters.DAC3_Output_Signal=false;
            expected.allParameters.DAC3_DAC_Label='(empty)';
            expected.allParameters.DAC3_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC3_Num_Pulse_Trains=1;
            expected.allParameters.DAC3_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC3_Time_Delay_Between_Pulse_Trains=0.000000;
            expected.allParameters.DAC3_Time_Delay_to_First_Pulse_Train=0.000000;
            expected.allParameters.DAC3_Train_Pulse_Pot_1=0.000000;
            expected.allParameters.DAC3_Train_Pulse_Duration_1=0.0;
            expected.allParameters.DAC3_Train_Num_Pulses_1=1;
            expected.allParameters.DAC3_Train_First_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC3_Train_Inter_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC3_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC3_Ext_Sensitivity=20;
            expected.allParameters.DAC3_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC3_Custom_Waveform_Holding_Pot=0;
            
            
            expected.allParameters.DAC4_Protocol=3;
            expected.allParameters.DAC4_Output_Signal=false;
            expected.allParameters.DAC4_DAC_Label='(empty)';
            expected.allParameters.DAC4_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC4_Num_Pulse_Trains=1;
            expected.allParameters.DAC4_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC4_Time_Delay_Between_Pulse_Trains=0.000000;
            expected.allParameters.DAC4_Time_Delay_to_First_Pulse_Train=0.000000;
            expected.allParameters.DAC4_Train_Pulse_Pot_1=0.000000;
            expected.allParameters.DAC4_Train_Pulse_Duration_1=0.000000;
            expected.allParameters.DAC4_Train_Num_Pulses_1=1;
            expected.allParameters.DAC4_Train_First_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC4_Train_Inter_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC4_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC4_Ext_Sensitivity=20;
            expected.allParameters.DAC4_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC4_Custom_Waveform_Holding_Pot=0;
            
            expected.allParameters.DAC5_Protocol=2;
            expected.allParameters.DAC5_Output_Signal=true;
            expected.allParameters.DAC5_DAC_Label='(empty)';
            expected.allParameters.DAC5_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC5_Num_Pulse_Trains=1;
            expected.allParameters.DAC5_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC5_Time_Delay_Between_Pulse_Trains=0.000000;
            expected.allParameters.DAC5_Time_Delay_to_First_Pulse_Train=0.000000;
            expected.allParameters.DAC5_Train_Pulse_Pot_1=0.000000;
            expected.allParameters.DAC5_Train_Pulse_Duration_1=0.00000;
            expected.allParameters.DAC5_Train_Num_Pulses_1=0;
            expected.allParameters.DAC5_Train_First_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC5_Train_Inter_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC5_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC5_Ext_Sensitivity=20;
            expected.allParameters.DAC5_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC5_Custom_Waveform_Holding_Pot=0;
            
            expected.allParameters.DAC6_Protocol=2;
            expected.allParameters.DAC6_Output_Signal=true;
            expected.allParameters.DAC6_DAC_Label='(empty)';
            expected.allParameters.DAC6_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC6_Num_Pulse_Trains=1;
            expected.allParameters.DAC6_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC6_Time_Delay_Between_Pulse_Trains=100.000000;
            expected.allParameters.DAC6_Time_Delay_to_First_Pulse_Train=100.000000;
            expected.allParameters.DAC6_Train_Pulse_Pot_1=50.000000;
            expected.allParameters.DAC6_Train_Pulse_Duration_1=0.200000;
            expected.allParameters.DAC6_Train_Num_Pulses_1=7;
            expected.allParameters.DAC6_Train_First_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC6_Train_Inter_Pulse_Delay_1=0.200000;
            expected.allParameters.DAC6_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC6_Ext_Sensitivity=100;
            expected.allParameters.DAC6_Ext_Sensitivity=100;
            expected.allParameters.DAC6_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC6_Custom_Waveform_Holding_Pot=0;
            
            expected.allParameters.DAC7_Protocol=2;
            expected.allParameters.DAC7_Output_Signal=true;
            expected.allParameters.DAC7_DAC_Label='(empty)';
            expected.allParameters.DAC7_Train_Holding_Pot=0.000000;
            expected.allParameters.DAC7_Num_Pulse_Trains=1;
            expected.allParameters.DAC7_Num_Repeat_Pulse_Trains=1;
            expected.allParameters.DAC7_Time_Delay_Between_Pulse_Trains=0.000000;
            expected.allParameters.DAC7_Time_Delay_to_First_Pulse_Train=0.000000;
            expected.allParameters.DAC7_Train_Pulse_Pot_1=0.000000;
            expected.allParameters.DAC7_Train_Pulse_Duration_1=0.00000;
            expected.allParameters.DAC7_Train_Num_Pulses_1=0;
            expected.allParameters.DAC7_Train_First_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC7_Train_Inter_Pulse_Delay_1=0.000000;
            expected.allParameters.DAC7_GFC_Holding_Pot=0.000000;
            expected.allParameters.DAC7_Ext_Sensitivity=20;
            expected.allParameters.DAC7_Custom_Waveform_File='(empty)';
            expected.allParameters.DAC7_Custom_Waveform_Holding_Pot=0;
            
            
            expected.allParameters.Ch_0_Name='(empty)';
            expected.allParameters.Ch_1_Name='(empty)';
            expected.allParameters.Ch_2_Name='(empty)';
            expected.allParameters.Ch_3_Name='(empty)';
            expected.allParameters.Ch_4_Name='(empty)';
            expected.allParameters.Ch_5_Name='(empty)';
            expected.allParameters.Ch_6_Name='(empty)';
            expected.allParameters.Ch_7_Name='(empty)';
            
            expected.allParameters.Ch_0_Units='(empty)';
            expected.allParameters.Ch_1_Units='(empty)';
            expected.allParameters.Ch_2_Units='(empty)';
            expected.allParameters.Ch_3_Units='(empty)';
            expected.allParameters.Ch_4_Units='(empty)';
            expected.allParameters.Ch_5_Units='(empty)';
            expected.allParameters.Ch_6_Units='(empty)';
            expected.allParameters.Ch_7_Units='(empty)';
            
            expected.allParameters.Ch_0_Status=true;
            expected.allParameters.Ch_1_Status=false;
            expected.allParameters.Ch_2_Status=false;
            expected.allParameters.Ch_3_Status=false;
            expected.allParameters.Ch_4_Status=false;
            expected.allParameters.Ch_5_Status=false;
            expected.allParameters.Ch_6_Status=false;
            expected.allParameters.Ch_7_Status=false;
            
            expected.allParameters.Manual_Sensitivity=50.000000; % mV/V
            expected.allParameters.Sensitivity_1=50.000000;
            expected.allParameters.Sensitivity_2=50.000000;
            expected.allParameters.Sensitivity_3=50.000000;
            expected.allParameters.Sensitivity_4=50.000000;
            expected.allParameters.Sensitivity_5=50.000000;
            expected.allParameters.Sensitivity_6=50.000000;
            expected.allParameters.Sensitivity_7=50.000000;
            
            expected.allParameters.Acquire_Loop=false;
            expected.allParameters.Marked_Point_Number=0;
            expected.allParameters.Functional_Mapping=false;
            expected.allParameters.Marked_Point_Devices=1;
            expected.allParameters.Marked_Points_During_Acq=true;
            expected.allParameters.First_Point_Delay=0.000000;
            expected.allParameters.Hold_Time=0.100000;
            expected.allParameters.Move_Time=0.200000;
            expected.allParameters.Sync_With_DAC=true;
            expected.allParameters.Sync_DAC=6;
            expected.allParameters.Replicate_Points=true;
            
            expected.allParameters.Shutter=false;
            
            
            expected.allParameters.Number_Points=7;
            expected.allParameters.Point_0_X=295.000000;
            expected.allParameters.Point_0_Y=152.000000;
            expected.allParameters.Point_0_Z=0.000000;
            expected.allParameters.Point_1_X=295.000000;
            expected.allParameters.Point_1_Y=187.000000;
            expected.allParameters.Point_1_Z=0.000000;
            expected.allParameters.Point_2_X=226.000000;
            expected.allParameters.Point_2_Y=178.000000;
            expected.allParameters.Point_2_Z=0.000000;
            expected.allParameters.Point_3_X=312.000000;
            expected.allParameters.Point_3_Y=235.000000;
            expected.allParameters.Point_3_Z=0.000000;
            expected.allParameters.Point_4_X=298.000000;
            expected.allParameters.Point_4_Y=278.000000;
            expected.allParameters.Point_4_Z=0.000000;
            expected.allParameters.Point_5_X=218.000000;
            expected.allParameters.Point_5_Y=260.000000;
            expected.allParameters.Point_5_Z=0.000000;
            expected.allParameters.Point_6_X=267.000000;
            expected.allParameters.Point_6_Y=297.000000;
            expected.allParameters.Point_6_Z=0.000000;
            
            
            ignoreFields = { 'Shutter/Acq delay',...
                'Open/Close Shutter',...
                'Open Shutter Time',...
                'Output Rate',...
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
                'Ch [0-7] Color',...
                'Ch [0-7]$',...
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
                'Channel Color',...
                'Channel Min-Max',...
                };
            
            
            
            
            ADCDeviceParameters = { 'Acquisition_Rate',...
                'Manual_Sensitivity',...
                '^Sensitivity_[1-7]'
                };
            
            DACDeviceParameters = { 'Points_Hold_Time',... % skip if DAC6 sync
                'Points_Move_Time',...
                'Points_First_Delay',... % skip if DAC6 sync
                'DAC[0-7]_Output_Signal',...
                'DAC[0-7]_Ext_Sensitivity',...
                };
            
            DACStimulusParameters = { 'DAC[0-7]_Num_.*_Pulse_Trains',...
                'DAC[0-7]_Time_Delay_Between_Pulse_Trains',...
                'DAC[0-7]_Time_Delay_to_First_Pulse_Train',...
                'DAC[0-7]_Train_.*',...
                'DAC[0-7]_Custom_Waveform_File',...
                'DAC[0-7]_Custom_Waveform_Holding_Pot',...
                };
            
            laserStimulusParameters = { ...
                'Point_\d.*' ...
                };
            
            protocolParameters = { 'Number_of_Cycles',...
                'Cycle_Period',...
                'Acquisition_Time',...
                'DAC[0-7]_Protocol',...
                'DAC[0-7]_DAC_Label',...
                'DAC[0-7]_Num_.*_Pulse_Trains',...
                'DAC[0-7]_Time_Delay_Between_Pulse_Trains',...
                'DAC[0-7]_Time_Delay_to_First_Pulse_Train',...
                'DAC[0-7]_Train_.*',...
                'DAC[0-7]_Custom_Waveform_Holding_Pot',...
                'Acquire_Loop',...
                'Marked_Point_Number',...
                'Functional_Mapping',...
                'Marked_Point_Devices',...
                'Marked_Points_During_Acq',...
                'First_Point_Delay',...
                'Hold_Time',...
                'Move_Time',...
                'Sync_With_DAC',...
                'Sync_DAC',...
                };
            
            
            expected.ADCDeviceParameters = copyStructFields(expected.allParameters, ADCDeviceParameters);
            expected.DACDeviceParameters = copyStructFields(expected.allParameters, DACDeviceParameters);
            expected.DACStimulusParameters = copyStructFields(expected.allParameters, DACStimulusParameters);
            expected.laserStimulusParameters = copyStructFields(expected.allParameters, laserStimulusParameters);
            expected.protocolParameters = copyStructFields(expected.allParameters, protocolParameters);
            
            
            actual = parsePrairieEpochParameters(self.prmPath, ...
                ignoreFields, ...
                ignoreSections, ...
                ADCDeviceParameters, ...
                DACDeviceParameters, ...
                DACStimulusParameters,...
                laserStimulusParameters, ...
                protocolParameters...
                );
            
            cmp = structCmp(expected, actual);
            assert(cmp);
        end
    end
end