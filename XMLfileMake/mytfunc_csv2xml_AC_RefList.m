% mytfunc_csv2xml_AC_RefList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �M���̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_RefList(xmldata,filename)

refListData = textread(filename,'%s','delimiter','\n','whitespace','');

% �M���Q��`�t�@�C���̓ǂݍ���
for i=1:length(refListData)
    conma = strfind(refListData{i},',');
    for j = 1:length(conma)
        if j == 1
            refListDataCell{i,j} = refListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            refListDataCell{i,j}   = refListData{i}(conma(j-1)+1:conma(j)-1);
            refListDataCell{i,j+1} = refListData{i}(conma(j)+1:end);
        else
            refListDataCell{i,j} = refListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% �i�ŏ���3��́j�󔒂͒���̏��𖄂߂�B
for iREF = 11:size(refListDataCell,1)
    if isempty(refListDataCell{iREF,1})
        if iREF == 11
            error('�ŏ��̍s�͕K���M���Q�R�[�h����͂��Ă�������')
        else
            refListDataCell(iREF,1:3) = refListDataCell(iREF-1,1:3);
        end
    end
end

% �i�~�M�֘A�j�󔒂͒���̏��𖄂߂�B
for iREF = 11:size(refListDataCell,1)
    if isempty(refListDataCell{iREF,4})
        if iREF == 11
            refListDataCell{iREF,4} = 'None';
        else
            refListDataCell(iREF,4) = refListDataCell(iREF-1,4);
        end
        
    else
        
        if strcmp(refListDataCell(iREF,4),'�~�M')
            refListDataCell{iREF,4} = 'Charge';
        elseif strcmp(refListDataCell(iREF,4),'���M')
            refListDataCell{iREF,4} = 'Discharge';
        else
            refListDataCell{iREF,4} = 'None';
        end
        
    end
end


%% �M���Q���X�g(�~�M���[�h��)���쐬
RefListName = {};
RefListCHmode = {};
RefListQuantityConrol = {};
RefListThermalStorage_Mode = {};
RefListThermalStorage_StorageSize = {};

for iREF = 11:size(refListDataCell,1)
    
    if isempty(RefListName)
        RefListName                       = refListDataCell(iREF,1);
        RefListCHmode                     = refListDataCell(iREF,2);
        RefListQuantityConrol             = refListDataCell(iREF,3);
        RefListThermalStorage_Mode        = refListDataCell(iREF,4);
        RefListThermalStorage_StorageSize = refListDataCell(iREF,5);
    else
        check = 0;
        for iDB = 1:length(RefListName)
            if strcmp(refListDataCell(iREF,1),RefListName(iDB)) && strcmp(refListDataCell(iREF,4),RefListThermalStorage_Mode(iDB))
                % �d������
                check = 1;
            end
        end
        if check == 0
            % �M���Q���̒ǉ�
            RefListName                       = [RefListName; refListDataCell(iREF,1)];
            RefListCHmode                     = [RefListCHmode; refListDataCell(iREF,2)];
            RefListQuantityConrol             = [RefListQuantityConrol; refListDataCell(iREF,3)];
            RefListThermalStorage_Mode        = [RefListThermalStorage_Mode; refListDataCell(iREF,4)];
            RefListThermalStorage_StorageSize = [RefListThermalStorage_StorageSize; refListDataCell(iREF,5)];
        end
    end
    
end

% �M���Q�̃��[�v
for iREFSET = 1:length(RefListName)
    
    % �Q�̑���
    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.Name = RefListName(iREFSET,1);
    
    if strcmp(RefListCHmode(iREFSET,1),'�L')
        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.CHmode = 'True';
    else
        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.CHmode = 'False';
    end
    
    if strcmp(RefListQuantityConrol(iREFSET,1),'�L')
        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.QuantityControl = 'True';
    else
        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.QuantityControl = 'False';
    end
    
    % �~�M���[�h
    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.StorageMode = RefListThermalStorage_Mode(iREFSET,1);
    
    if isempty(RefListThermalStorage_StorageSize{iREFSET,1}) == 0
        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.StorageSize = RefListThermalStorage_StorageSize(iREFSET,1);
    else
        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).ATTRIBUTE.StorageSize = 'Null';
    end
    
    
    iCOUNT = 0;
    for iDB = 11:size(refListDataCell,1)
        
        % �󔒍s���΂�
        if isempty(refListDataCell{iDB,6}) == 0
            
            if strcmp(RefListName(iREFSET,1),refListDataCell(iDB,1)) && strcmp(RefListThermalStorage_Mode(iREFSET,1),refListDataCell(iDB,4))
                
                iCOUNT = iCOUNT + 1;
                
                if strcmp(refListDataCell(iDB,6),'���q�[�g�|���v')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AirSourceHP';
                elseif strcmp(refListDataCell(iDB,6),'���q�[�g�|���v(���k�@�䐔����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AirSourceHP_MultiCompressor';
                elseif strcmp(refListDataCell(iDB,6),'���⎮�X�N�����[�`���[')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'WaterCoolingChiller_Screw';
                elseif strcmp(refListDataCell(iDB,6),'���⎮�X�N���[���`���[')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'WaterCoolingChiller_Scroll';
                elseif strcmp(refListDataCell(iDB,6),'�^�[�{�Ⓚ�@')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'TurboREF';
                elseif strcmp(refListDataCell(iDB,6),'�C���o�[�^�^�[�{�Ⓚ�@')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'TurboREF_INV';
                elseif strcmp(refListDataCell(iDB,6),'�u���C���^�[�{�Ⓚ�@(�~�M��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'TurboREF_Brine_Storage';
                elseif strcmp(refListDataCell(iDB,6),'�u���C���^�[�{�Ⓚ�@(�Ǌ|��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'TurboREF_Brine_nonStorage';
                elseif strcmp(refListDataCell(iDB,6),'�X�~�M�p��⎮�q�[�g�|���v')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AirSourceHP_ICE';
                elseif strcmp(refListDataCell(iDB,6),'�X�~�M�p��⎮�q�[�g�|���v(���k�@�䐔����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AirSourceHP_MultiCompresor_ICE';
                elseif strcmp(refListDataCell(iDB,6),'�X�~�M�p���⎮�X�N�����[�`���[')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'WaterCoolingChiller_Screw_ICE';
                elseif strcmp(refListDataCell(iDB,6),'�X�~�M�p���⎮�X�N���[���`���[')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'WaterCoolingChiller_Scroll_ICE';
                elseif strcmp(refListDataCell(iDB,6),'�����z���≷���@(�s�s�K�X)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AbsorptionWCB_DF_CityGas';
                elseif strcmp(refListDataCell(iDB,6),'�����z���≷���@(LPG)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AbsorptionWCB_DF_LPG';
                elseif strcmp(refListDataCell(iDB,6),'�����z���≷���@(�d��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AbsorptionWCB_DF_Oil';
                elseif strcmp(refListDataCell(iDB,6),'�����z���≷���@(����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AbsorptionWCB_DF_Kerosene';
                elseif strcmp(refListDataCell(iDB,6),'���C�z���Ⓚ�@')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AbsorptionChiller_Steam';
                elseif strcmp(refListDataCell(iDB,6),'�������z���Ⓚ�@')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'AbsorptionChiller_HotWater';
                elseif strcmp(refListDataCell(iDB,6),'���^�ї��{�C��(�s�s�K�X)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'OnePassBoiler_CityGas';
                elseif strcmp(refListDataCell(iDB,6),'���^�ї��{�C��(LPG)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'OnePassBoiler_LPG';
                elseif strcmp(refListDataCell(iDB,6),'���^�ї��{�C��(�d��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'OnePassBoiler_Oil';
                elseif strcmp(refListDataCell(iDB,6),'���^�ї��{�C��(����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'OnePassBoiler_Kerosene';
                elseif strcmp(refListDataCell(iDB,6),'�^�󉷐��q�[�^(�s�s�K�X)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'VacuumBoiler_CityGas';
                elseif strcmp(refListDataCell(iDB,6),'�^�󉷐��q�[�^(LPG)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'VacuumBoiler_LPG';
                elseif strcmp(refListDataCell(iDB,6),'�^�󉷐��q�[�^(�d��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'VacuumBoiler_Oil';
                elseif strcmp(refListDataCell(iDB,6),'�^�󉷐��q�[�^(����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'VacuumBoiler_Kerosene';
                elseif strcmp(refListDataCell(iDB,6),'�r���p�}���`�G�A�R��(�d�C��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'EHP';
                elseif strcmp(refListDataCell(iDB,6),'�r���p�}���`�G�A�R��(�s�s�K�X��)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'GHP_CityGas';
                elseif strcmp(refListDataCell(iDB,6),'�r���p�}���`�G�A�R��(LPG)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'GHP_LPG';
                elseif strcmp(refListDataCell(iDB,6),'���[���G�A�R��')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'RoomAirConditioner';
                elseif strcmp(refListDataCell(iDB,6),'FF���g�[�@(�s�s�K�X)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'FFtypeHeater_CityGas';
                elseif strcmp(refListDataCell(iDB,6),'FF���g�[�@(LPG)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'FFtypeHeater_LPG';
                elseif strcmp(refListDataCell(iDB,6),'FF���g�[�@(����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'FFtypeHeater_Kerosene';
                elseif strcmp(refListDataCell(iDB,6),'�n��M����(�␅)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'DHC_CoolingWater';
                elseif strcmp(refListDataCell(iDB,6),'�n��M����(����)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'DHC_HeatingWater';
                elseif strcmp(refListDataCell(iDB,6),'�n��M����(���C)')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'DHC_Steam';
                elseif strcmp(refListDataCell(iDB,6),'�M������')
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Type = 'HEX';
                else
                    refListDataCell(iDB,6)
                    error('�M����ނ��s���ł��B')
                end
                
                if isempty(refListDataCell{iDB,7}) == 0
                    if length(refListDataCell{iDB,7}) > 1 && strcmp(refListDataCell{iDB,7}(end-1:end),'�Ԗ�')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Order_Cooling  = refListDataCell{iDB,7}(1:end-2);
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Order_Cooling  = refListDataCell{iDB,7};
                    end
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Order_Cooling  = 'Null';
                end
                
                if isempty(refListDataCell{iDB,8}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Count_Cooling  = refListDataCell(iDB,8);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Count_Cooling  = 'Null';
                end
                
                if isempty(refListDataCell{iDB,9}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SupplyWaterTemp_Cooling  = refListDataCell(iDB,9);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SupplyWaterTemp_Cooling  = 'Null';
                end
                
                if isempty(refListDataCell{iDB,10}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Capacity_Cooling  = refListDataCell(iDB,10);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Capacity_Cooling  = 'Null';
                end
                
                if isempty(refListDataCell{iDB,11}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.MainPower_Cooling   = refListDataCell(iDB,11);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.MainPower_Cooling   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,12}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SubPower_Cooling   = refListDataCell(iDB,12);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SubPower_Cooling   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,13}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.PrimaryPumpPower_Cooling   = refListDataCell(iDB,13);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.PrimaryPumpPower_Cooling   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,14}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.CTCapacity_Cooling   = refListDataCell(iDB,14);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.CTCapacity_Cooling   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,15}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.CTFanPower_Cooling   = refListDataCell(iDB,15);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.CTFanPower_Cooling   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,16}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.CTPumpPower_Cooling   = refListDataCell(iDB,16);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.CTPumpPower_Cooling   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,17}) == 0
                    if length(refListDataCell{iDB,17}) > 1 && strcmp(refListDataCell{iDB,17}(end-1:end),'�Ԗ�')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Order_Heating   = refListDataCell{iDB,17}(1:end-2);
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Order_Heating   = refListDataCell{iDB,17};
                    end
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Order_Heating   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,18}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Count_Heating     = refListDataCell(iDB,18);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Count_Heating     = 'Null';
                end
                
                if isempty(refListDataCell{iDB,19}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SupplyWaterTemp_Heating     = refListDataCell(iDB,19);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SupplyWaterTemp_Heating     = 'Null';
                end
                
                if isempty(refListDataCell{iDB,20}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Capacity_Heating   = refListDataCell(iDB,20);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Capacity_Heating   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,21}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.MainPower_Heating    = refListDataCell(iDB,21);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.MainPower_Heating    = 'Null';
                end
                
                if isempty(refListDataCell{iDB,22}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SubPower_Heating   = refListDataCell(iDB,22);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.SubPower_Heating   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,23}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.PrimaryPumpPower_Heating   = refListDataCell(iDB,23);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.PrimaryPumpPower_Heating   = 'Null';
                end
                
                if isempty(refListDataCell{iDB,24}) == 0
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Info = refListDataCell(iDB,24);
                else
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFSET).HeatSource(iCOUNT).ATTRIBUTE.Info = 'Null';
                end
                
            end
        end
    end
    
    if iCOUNT == 0
        error('�M���Q %s �ɑ�����@�킪������܂���B',RefListName{iREFSET,1})
    end
    
end





