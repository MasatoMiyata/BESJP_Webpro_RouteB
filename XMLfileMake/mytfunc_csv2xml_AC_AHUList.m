% mytfunc_csv2xml_AC_AHUList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �󒲋@�̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_AHUList(xmldata,filename)

ahuListData = textread(filename,'%s','delimiter','\n','whitespace','');

% �󒲋@��`�t�@�C���̓ǂݍ���
for i=1:length(ahuListData)
    conma = strfind(ahuListData{i},',');
    for j = 1:length(conma)
        if j == 1
            ahuListDataCell{i,j} = ahuListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            ahuListDataCell{i,j}   = ahuListData{i}(conma(j-1)+1:conma(j)-1);
            ahuListDataCell{i,j+1} = ahuListData{i}(conma(j)+1:end);
        else
            ahuListDataCell{i,j} = ahuListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���̓ǂݍ���(CSV�t�@�C������I��)

for iAHU = 11:size(ahuListDataCell,1)
    
    if isempty(ahuListDataCell(iAHU,1))
        
        eval(['disp(''�󔒍s���΂��܂��F ',filename,'�@�� ',int2str(iAHU),'�s��'')'])
        
    else
        
        % �󒲋@����
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Name = ahuListDataCell(iAHU,1);
                
        % �󒲋@�䐔
        if isempty(ahuListDataCell{iAHU,2}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Count = ahuListDataCell(iAHU,2);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Count = 'Null';
        end
        
        % �󒲋@���
        if isempty(ahuListDataCell{iAHU,3}) == 0
            if strcmp(ahuListDataCell(iAHU,3),'�󒲋@') || strcmp(ahuListDataCell(iAHU,3),'AHU') || ...
                    strcmp(ahuListDataCell(iAHU,3),'�`�g�t') || strcmp(ahuListDataCell(iAHU,3),'��C���a�@') || strcmp(ahuListDataCell(iAHU,3),'�O�C�����󒲋@')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'AHU';
            elseif strcmp(ahuListDataCell(iAHU,3),'FCU') || strcmp(ahuListDataCell(iAHU,3),'�e�b�t')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'FCU';
            elseif strcmp(ahuListDataCell(iAHU,3),'�����@') || strcmp(ahuListDataCell(iAHU,3),'UNIT') || strcmp(ahuListDataCell(iAHU,3),'�t�m�h�s')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'UNIT';
            elseif strcmp(ahuListDataCell(iAHU,3),'�S�M�����j�b�g') || strcmp(ahuListDataCell(iAHU,3),'AEX') || strcmp(ahuListDataCell(iAHU,3),'�`�d�w')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'AEX';
            else
                error('�󒲋@�^�C�v %s �͕s���ł�',ahuListDataCell{iAHU,3})
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'Null';
        end
        
        % ��[�\��
        if isempty(ahuListDataCell{iAHU,4}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.CoolingCapacity = ahuListDataCell(iAHU,4);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.CoolingCapacity = 'Null';
        end
        
        % �g�[�\��
        if isempty(ahuListDataCell{iAHU,5}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatingCapacity = ahuListDataCell(iAHU,5);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatingCapacity = 'Null';
        end
        
        % ���C����
        if isempty(ahuListDataCell{iAHU,6}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyAirVolume = ahuListDataCell(iAHU,6);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyAirVolume = 'Null';
        end
        
        % ���C�t�@������d��
        if isempty(ahuListDataCell{iAHU,7}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyFanPower  = ahuListDataCell(iAHU,7);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyFanPower = 'Null';
        end
        
        % �ҋC�t�@������d��
        if isempty(ahuListDataCell{iAHU,8}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ReturnFanPower  = ahuListDataCell(iAHU,8);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ReturnFanPower = 'Null';
        end
        
        % �O�C�t�@������d��
        if isempty(ahuListDataCell{iAHU,9}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirFanPower  = ahuListDataCell(iAHU,9);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirFanPower = 'Null';
        end
        
        % �r�C�t�@������d��
        if isempty(ahuListDataCell{iAHU,10}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ExitFanPower = ahuListDataCell(iAHU,10);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ExitFanPower = 'Null';
        end
        
        % ���ʐ���
        if isempty(ahuListDataCell{iAHU,11}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FlowControl = ahuListDataCell(iAHU,11);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FlowControl = 'Null';
        end
        
        % VAV�ŏ��J�x [-]
        if isempty(ahuListDataCell{iAHU,12}) == 0
            % [%]����[-]��
            if str2double(ahuListDataCell(iAHU,12)) > 1 && str2double(ahuListDataCell(iAHU,12)) < 100
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.MinDamperOpening = num2str(str2double(ahuListDataCell(iAHU,12))/100);
            elseif str2double(ahuListDataCell(iAHU,12)) == 0
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.MinDamperOpening = '0';
            else
                error('VAV�ŏ��J�x %s �͖����ł��B',ahuListDataCell{iAHU,12})
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.MinDamperOpening = 'Null';
        end
        
        % �O�C�J�b�g����
        if isempty(ahuListDataCell{iAHU,13}) == 0
            if strcmp(ahuListDataCell(iAHU,13),'�L')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirCutControl = 'True';
            elseif strcmp(ahuListDataCell(iAHU,13),'��')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirCutControl = 'False';
            else
                error('�O�C�J�b�g����̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirCutControl = 'Null';
        end
        
        % �O�C��[����
        if isempty(ahuListDataCell{iAHU,14}) == 0
            if strcmp(ahuListDataCell(iAHU,14),'�L')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FreeCoolingControl = 'True';
            elseif strcmp(ahuListDataCell(iAHU,14),'��')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FreeCoolingControl = 'False';
            else
                error('�O�C��[�̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FreeCoolingControl = 'Null';
        end
        
        % �S�M�𐧌�
        if isempty(ahuListDataCell{iAHU,15}) == 0
            if strcmp(ahuListDataCell(iAHU,15),'�L')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchanger = 'True';
            elseif strcmp(ahuListDataCell(iAHU,15),'��')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchanger = 'False';
            else
                error('�S�M�����@�̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchanger = 'Null';
        end
        
        % �S�M��������
        if isempty(ahuListDataCell{iAHU,16}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerVolume = ahuListDataCell(iAHU,16);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerVolume = 'Null';
        end
        
        % �S�M�����@����
        if isempty(ahuListDataCell{iAHU,17}) == 0
            % [%]����[-]��
            if str2double(ahuListDataCell(iAHU,17)) > 1 && str2double(ahuListDataCell(iAHU,17)) < 100
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerEfficiency = num2str(str2double(ahuListDataCell(iAHU,17))/100);
            elseif str2double(ahuListDataCell(iAHU,17)) == 0
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerEfficiency = '0';
            else
                error('�S�M���������́��Ŏw�肵�Ă��������B')
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerEfficiency = 'Null';
        end
        
        % �S�M���o�C�p�X
        if isempty(ahuListDataCell{iAHU,18}) == 0
            if strcmp(ahuListDataCell(iAHU,18),'�L')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerBypass = 'True';
            elseif strcmp(ahuListDataCell(iAHU,18),'��')
                xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerBypass = 'False';
            else
                error('�S�M�����@�̃o�C�p�X�̗L���́u�L�v���u���v�Ŏw�肵�Ă��������B')
            end
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerBypass = 'Null';
        end
        
        % �S�M�����@���[�^����d��
        if isempty(ahuListDataCell{iAHU,19}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerPower = ahuListDataCell(iAHU,19);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerPower = 'Null';
        end
        
        % �|���v�ڑ��i��j
        if isempty(ahuListDataCell{iAHU,20}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.CoolingID = ...
                strcat(ahuListDataCell(iAHU,20));
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.CoolingID = 'Null';
        end
        
        % �|���v�ڑ��i���j
        if isempty(ahuListDataCell{iAHU,21}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.HeatingID = ...
                strcat(ahuListDataCell(iAHU,21));
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.HeatingID = 'Null';
        end
        
        % �M���ڑ��i��j
        if isempty(ahuListDataCell{iAHU,22}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.CoolingID = ...
                strcat(ahuListDataCell(iAHU,22));
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.CoolingID = 'Null';
        end
        
        % �M���ڑ��i���j
        if isempty(ahuListDataCell{iAHU,23}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.HeatingID = ...
                strcat(ahuListDataCell(iAHU,23));
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.HeatingID = 'Null';
        end
       
        % �@��\�̋L��
        if isempty(ahuListDataCell{iAHU,24}) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Info = ahuListDataCell(iAHU,24);
        else
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Info = 'Null';
        end
        
    end
end



