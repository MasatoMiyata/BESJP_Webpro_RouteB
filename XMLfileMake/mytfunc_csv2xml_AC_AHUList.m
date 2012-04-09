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
    
    % �󒲋@ID
    xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ID = ahuListDataCell(iAHU,1);
    
    % �󒲋@���́i�@��\�̋L���{�n�����j
    if isempty(ahuListDataCell{iAHU,2}) == 0 && isempty(ahuListDataCell{iAHU,3}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Name = strcat(ahuListDataCell(iAHU,2),'_',ahuListDataCell(iAHU,3));
    elseif isempty(ahuListDataCell{iAHU,2}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Name = strcat(ahuListDataCell(iAHU,2));
    elseif isempty(ahuListDataCell{iAHU,3}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Name = strcat(ahuListDataCell(iAHU,3));
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Name = 'Null';
    end
    
    % �󒲋@�䐔
    if isempty(ahuListDataCell{iAHU,4}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Count = ahuListDataCell(iAHU,4);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Count = '1';
    end
    
    % �󒲋@���
    if isempty(ahuListDataCell{iAHU,5}) == 0
        if strcmp(ahuListDataCell(iAHU,5),'�󒲋@') || strcmp(ahuListDataCell(iAHU,5),'AHU') || strcmp(ahuListDataCell(iAHU,5),'�`�g�t')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'AHU';
        elseif strcmp(ahuListDataCell(iAHU,5),'FCU') || strcmp(ahuListDataCell(iAHU,5),'�e�b�t')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'FCU';
        elseif strcmp(ahuListDataCell(iAHU,5),'�����@') || strcmp(ahuListDataCell(iAHU,5),'UNIT') || strcmp(ahuListDataCell(iAHU,5),'�t�m�h�s')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'UNIT';
        elseif strcmp(ahuListDataCell(iAHU,5),'�S�M�����j�b�g') || strcmp(ahuListDataCell(iAHU,5),'AEX') || strcmp(ahuListDataCell(iAHU,5),'�`�d�w')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'AEX';
        else
            ahuListDataCell{iAHU,5}
            error('�󒲋@�^�C�v���s���ł��E')
        end
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.Type = 'AHU';
    end
    
    % ��[�\��
    if isempty(ahuListDataCell{iAHU,6}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.CoolingCapacity = ahuListDataCell(iAHU,6);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.CoolingCapacity = '0';
    end
    
    % �g�[�\��
    if isempty(ahuListDataCell{iAHU,7}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatingCapacity = ahuListDataCell(iAHU,7);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatingCapacity = '0';
    end
    
    % ���C����
    if isempty(ahuListDataCell{iAHU,8}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyAirVolume = ahuListDataCell(iAHU,8);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyAirVolume = '0';
    end
    
    % ���C�t�@������d��
    if isempty(ahuListDataCell{iAHU,9}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyFanPower  = ahuListDataCell(iAHU,9);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.SupplyFanPower = '0';
    end
    
    % �ҋC�t�@������d��
    if isempty(ahuListDataCell{iAHU,10}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ReturnFanPower  = ahuListDataCell(iAHU,10);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ReturnFanPower = '0';
    end
    
    % �O�C�t�@������d��
    if isempty(ahuListDataCell{iAHU,11}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirFanPower  = ahuListDataCell(iAHU,11);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirFanPower = '0';
    end
    
    % �r�C�t�@������d��
    if isempty(ahuListDataCell{iAHU,12}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ExitFanPower = ahuListDataCell(iAHU,12);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.ExitFanPower = '0';
    end
    
    % ���ʐ���
    if isempty(ahuListDataCell{iAHU,13}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FlowControl = ahuListDataCell(iAHU,13);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FlowControl = 'CAV';
    end
    
    % VAV�ŏ��J�x [-]
    if isempty(ahuListDataCell{iAHU,14}) == 0
        % [%]����[-]��
        if str2double(ahuListDataCell(iAHU,14)) > 1 && str2double(ahuListDataCell(iAHU,14)) < 100
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.MinDamperOpening = num2str(str2double(ahuListDataCell(iAHU,14))/100);
        elseif str2double(ahuListDataCell(iAHU,14)) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.MinDamperOpening = '0';
        else
            ahuListDataCell{iAHU,14}
            error('VAV�ŏ��J�x�́��Ŏw�肵�Ă��������B')
        end
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.MinDamperOpening = '1';
    end
    
    % �O�C�J�b�g����
    if isempty(ahuListDataCell{iAHU,15}) == 0
        if strcmp(ahuListDataCell(iAHU,15),'�L')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirCutControl = 'True';
        elseif strcmp(ahuListDataCell(iAHU,15),'��')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirCutControl = 'False';
        else
            error('�O�C�J�b�g����̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
        end
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.OutsideAirCutControl = 'False';
    end
    
    % �O�C��[����
    if isempty(ahuListDataCell{iAHU,16}) == 0
        if strcmp(ahuListDataCell(iAHU,16),'�L')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FreeCoolingControl = 'True';
        elseif strcmp(ahuListDataCell(iAHU,16),'��')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FreeCoolingControl = 'False';
        else
            error('�O�C��[�̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
        end
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.FreeCoolingControl = 'False';
    end
    
    % �S�M�𐧌�
    if isempty(ahuListDataCell{iAHU,17}) == 0
        if strcmp(ahuListDataCell(iAHU,17),'�L')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchanger = 'True';
        elseif strcmp(ahuListDataCell(iAHU,17),'��')
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchanger = 'False';
        else
            error('�S�M�����@�̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
        end
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchanger = 'False';
    end
    
    % �S�M��������
    if isempty(ahuListDataCell{iAHU,18}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerVolume = ahuListDataCell(iAHU,18);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerVolume = '0';
    end
    
    % �S�M�����@����
    if isempty(ahuListDataCell{iAHU,19}) == 0
        % [%]����[-]��
        if str2double(ahuListDataCell(iAHU,19)) > 1 && str2double(ahuListDataCell(iAHU,19)) < 100
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerEfficiency = num2str(str2double(ahuListDataCell(iAHU,19))/100);
        elseif str2double(ahuListDataCell(iAHU,19)) == 0
            xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerEfficiency = '0';
        else
            error('�S�M���������́��Ŏw�肵�Ă��������B')
        end
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerEfficiency = '0';
    end
    
    % �S�M���o�C�p�X
    if isempty(ahuListDataCell{iAHU,18}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerBypass = 'True';
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerBypass = 'False';
    end
    
    % �S�M�����@���[�^����d��
    if isempty(ahuListDataCell{iAHU,21}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerPower = ahuListDataCell(iAHU,21);
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).ATTRIBUTE.HeatExchangerPower = '0';
    end
    
    % �|���v�ڑ��i��j
    if isempty(ahuListDataCell{iAHU,22}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.CoolingID = ...
            strcat(ahuListDataCell(iAHU,22),'_C');
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.CoolingID = 'Null';
    end
    
    % �|���v�ڑ��i���j
    if isempty(ahuListDataCell{iAHU,23}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.HeatingID = ...
            strcat(ahuListDataCell(iAHU,23),'_H');
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).SecondaryPumpRef.ATTRIBUTE.HeatingID = 'Null';
    end
    
    % �M���ڑ��i��j
    if isempty(ahuListDataCell{iAHU,24}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.CoolingID = ...
            strcat(ahuListDataCell(iAHU,24),'_C');
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.CoolingID = 'Null';
    end
    
    % �M���ڑ��i���j
    if isempty(ahuListDataCell{iAHU,25}) == 0
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.HeatingID = ...
            strcat(ahuListDataCell(iAHU,25),'_H');
    else
        xmldata.AirConditioningSystem.AirHandlingUnit(iAHU-10).HeatSourceSetRef.ATTRIBUTE.HeatingID = 'Null';
    end
    
end



