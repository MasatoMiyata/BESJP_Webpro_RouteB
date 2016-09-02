% mytfunc_csv2xml_AC_AHUList.m
%                                             by Masato Miyata 2012/10/30
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �󒲋@�̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_AHUList(xmldata,filename)

ahuListDataCell = mytfunc_CSVfile2Cell(filename);

% ahuListData = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% % �󒲋@��`�t�@�C���̓ǂݍ���
% for i=1:length(ahuListData)
%     conma = strfind(ahuListData{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             ahuListDataCell{i,j} = ahuListData{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             ahuListDataCell{i,j}   = ahuListData{i}(conma(j-1)+1:conma(j)-1);
%             ahuListDataCell{i,j+1} = ahuListData{i}(conma(j)+1:end);
%         else
%             ahuListDataCell{i,j} = ahuListData{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end

% �󔒂͒���̏��𖄂߂�B
for iAHU = 11:size(ahuListDataCell,1)
    if isempty(ahuListDataCell{iAHU,1}) && isempty(ahuListDataCell{iAHU,3}) == 0
        if iAHU == 11
            error('�ŏ��̍s�͕K���󒲋@�Q���̂���͂��Ă�������')
        else
            ahuListDataCell(iAHU,1) = ahuListDataCell(iAHU-1,1);         % �󒲋@�Q����
            ahuListDataCell(iAHU,20:21) = ahuListDataCell(iAHU-1,20:21); % �|���v�Q�ڑ�
            ahuListDataCell(iAHU,22:23) = ahuListDataCell(iAHU-1,22:23); % �M���Q�ڑ�
        end
    end
end


% �󒲋@�Q���X�g�̍쐬
AHUListName = {};

for iAHU = 11:size(ahuListDataCell,1)
    if isempty(AHUListName)
        AHUListName = ahuListDataCell(iAHU,1);
    else
        check = 0;
        for iDB = 1:length(AHUListName)
            if strcmp(ahuListDataCell(iAHU,1),AHUListName(iDB))
                % �d������
                check = 1;
            end
        end
        if check == 0
            AHUListName = [AHUListName; ahuListDataCell(iAHU,1)];
        end
    end
end


% ���̓ǂݍ���
for iAHUSET = 1:length(AHUListName)
    
    if isempty(AHUListName{iAHUSET}) == 0  % ���̂��󔒂łȂ����
        
        % �󒲋@�Q����
        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).ATTRIBUTE.Name = AHUListName(iAHUSET,1);
        
        iCOUNT = 0;
        
        % �S�s������
        for iDB = 11:size(ahuListDataCell,1)
            if strcmp(AHUListName(iAHUSET,1),ahuListDataCell(iDB,1))
                iCOUNT = iCOUNT + 1;
                
                % �󒲋@�䐔
                if isempty(ahuListDataCell{iDB,2}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Count = ahuListDataCell(iDB,2);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Count = 'Null';
                end
                
                % �󒲋@���
                if isempty(ahuListDataCell{iDB,3}) == 0
                    if strcmp(ahuListDataCell(iDB,3),'�󒲋@') || strcmp(ahuListDataCell(iDB,3),'AHU') || ...
                            strcmp(ahuListDataCell(iDB,3),'�`�g�t') || strcmp(ahuListDataCell(iDB,3),'��C���a�@') || strcmp(ahuListDataCell(iDB,3),'�O�C�����󒲋@')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'AHU';
                    elseif strcmp(ahuListDataCell(iDB,3),'FCU') || strcmp(ahuListDataCell(iDB,3),'�e�b�t')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'FCU';
                    elseif strcmp(ahuListDataCell(iDB,3),'�����@') || strcmp(ahuListDataCell(iDB,3),'UNIT') || strcmp(ahuListDataCell(iDB,3),'�t�m�h�s')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'UNIT';
                    elseif strcmp(ahuListDataCell(iDB,3),'�S�M�����j�b�g') || strcmp(ahuListDataCell(iDB,3),'AEX') || strcmp(ahuListDataCell(iDB,3),'�`�d�w')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'AEX';
                    elseif strcmp(ahuListDataCell(iDB,3),'�����@')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'FAN';
                    elseif strcmp(ahuListDataCell(iDB,3),'���M��')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'RADIATOR';
                    else
                        error('�󒲋@�^�C�v %s �͕s���ł�',ahuListDataCell{iDB,3})
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Type = 'Null';
                end
                
                % ��[�\��
                if isempty(ahuListDataCell{iDB,4}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.CoolingCapacity = ahuListDataCell(iDB,4);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.CoolingCapacity = 'Null';
                end
                
                % �g�[�\��
                if isempty(ahuListDataCell{iDB,5}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatingCapacity = ahuListDataCell(iDB,5);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatingCapacity = 'Null';
                end
                
                % ���C����
                if isempty(ahuListDataCell{iDB,6}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.SupplyAirVolume = ahuListDataCell(iDB,6);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.SupplyAirVolume = 'Null';
                end
                
                % ���C�t�@������d��
                if isempty(ahuListDataCell{iDB,7}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.SupplyFanPower  = ahuListDataCell(iDB,7);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.SupplyFanPower = 'Null';
                end
                
                % �ҋC�t�@������d��
                if isempty(ahuListDataCell{iDB,8}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.ReturnFanPower  = ahuListDataCell(iDB,8);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.ReturnFanPower = 'Null';
                end
                
                % �O�C�t�@������d��
                if isempty(ahuListDataCell{iDB,9}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.OutsideAirFanPower  = ahuListDataCell(iDB,9);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.OutsideAirFanPower = 'Null';
                end
                
                % �r�C�t�@������d��
                if isempty(ahuListDataCell{iDB,10}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.ExitFanPower = ahuListDataCell(iDB,10);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.ExitFanPower = 'Null';
                end
                
                % ���ʐ���
                if isempty(ahuListDataCell{iDB,11}) == 0
                    if strcmp(ahuListDataCell(iDB,11),'�蕗�ʐ���')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FlowControl = 'CAV';
                    elseif strcmp(ahuListDataCell(iDB,11),'�_���p�[����')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FlowControl = 'VAV_Damper';
                    elseif strcmp(ahuListDataCell(iDB,11),'�T�N�V�����x�[������')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FlowControl = 'VAV_Vane';
                    elseif strcmp(ahuListDataCell(iDB,11),'�σs�b�`����')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FlowControl = 'VAV_Pitch';
                    elseif strcmp(ahuListDataCell(iDB,11),'��]������')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FlowControl = 'VAV_INV';
                    else
                        error('�����ʐ���̐ݒ肪�s���ł��B')
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FlowControl = 'Null';
                end
                
                % VAV�ŏ��J�x [-]
                if isempty(ahuListDataCell{iDB,12}) == 0
                    % [%]����[-]��
                    if str2double(ahuListDataCell(iDB,12)) > 1 && str2double(ahuListDataCell(iDB,12)) < 100
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.MinDamperOpening = num2str(str2double(ahuListDataCell(iDB,12))/100);
                    elseif str2double(ahuListDataCell(iDB,12)) == 0
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.MinDamperOpening = '0';
                    else
                        error('VAV�ŏ��J�x %s �͖����ł��B',ahuListDataCell{iDB,12})
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.MinDamperOpening = 'Null';
                end
                
                % �O�C�J�b�g����
                if isempty(ahuListDataCell{iDB,13}) == 0
                    if strcmp(ahuListDataCell(iDB,13),'�L')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.OutsideAirCutControl = 'True';
                    elseif strcmp(ahuListDataCell(iDB,13),'��')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.OutsideAirCutControl = 'False';
                    else
                        error('�O�C�J�b�g����̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.OutsideAirCutControl = 'Null';
                end
                
                % �O�C��[����
                if isempty(ahuListDataCell{iDB,14}) == 0
                    if strcmp(ahuListDataCell(iDB,14),'�L')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FreeCoolingControl = 'True';
                    elseif strcmp(ahuListDataCell(iDB,14),'��')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FreeCoolingControl = 'False';
                    else
                        error('�O�C��[�̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.FreeCoolingControl = 'Null';
                end
                
                % �S�M�𐧌�
                if isempty(ahuListDataCell{iDB,15}) == 0
                    if strcmp(ahuListDataCell(iDB,15),'�L')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchanger = 'True';
                    elseif strcmp(ahuListDataCell(iDB,15),'��')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchanger = 'False';
                    else
                        error('�S�M�����@�̐ݒ肪�s���ł��B�u�L�v���u���v�Ŏw�肵�Ă��������B')
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchanger = 'Null';
                end
                
                % �S�M��������
                if isempty(ahuListDataCell{iDB,16}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerVolume = ahuListDataCell(iDB,16);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerVolume = 'Null';
                end
                
                % �S�M�����@����
                if isempty(ahuListDataCell{iDB,17}) == 0
                    % [%]����[-]��
                    if str2double(ahuListDataCell(iDB,17)) > 1 && str2double(ahuListDataCell(iDB,17)) < 100
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerEfficiency = num2str(str2double(ahuListDataCell(iDB,17))/100);
                    elseif str2double(ahuListDataCell(iDB,17)) == 0
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerEfficiency = '0';
                    else
                        error('�S�M���������́��Ŏw�肵�Ă��������B')
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerEfficiency = 'Null';
                end
                
                % �S�M���o�C�p�X
                if isempty(ahuListDataCell{iDB,18}) == 0
                    if strcmp(ahuListDataCell(iDB,18),'�L')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerBypass = 'True';
                    elseif strcmp(ahuListDataCell(iDB,18),'��')
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerBypass = 'False';
                    else
                        error('�S�M�����@�̃o�C�p�X�̗L���́u�L�v���u���v�Ŏw�肵�Ă��������B')
                    end
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerBypass = 'Null';
                end
                
                % �S�M�����@���[�^����d��
                if isempty(ahuListDataCell{iDB,19}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerPower = ahuListDataCell(iDB,19);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.HeatExchangerPower = 'Null';
                end
                
                % ���l�i�@��\�̋L���j
                if isempty(ahuListDataCell{iDB,24}) == 0
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Info = ahuListDataCell(iDB,24);
                else
                    xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iCOUNT).ATTRIBUTE.Info = 'Null';
                end
                
                
                % �|���v�ڑ��@�Ɓ@�M���ڑ�
                % �ŏ���if���͎b��[�u�B�|���v�ڑ��ƔM���ڑ����V�[�g�̍��[�ֈړ����A��ԏ�̍s�ɓ��͂��郋�[�������΂���if���͕s�v�B
                if strcmp(ahuListDataCell(iDB,3),'�󒲋@') || strcmp(ahuListDataCell(iDB,3),'FCU') || strcmp(ahuListDataCell(iDB,3),'�����@')
                    
                    % �|���v�ڑ��i��j
                    if isempty(ahuListDataCell{iDB,20}) == 0
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).SecondaryPumpRef.ATTRIBUTE.Cooling = ...
                            strcat(ahuListDataCell(iDB,20));
                    else
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).SecondaryPumpRef.ATTRIBUTE.Cooling = 'Null';
                    end
                    
                    % �|���v�ڑ��i���j
                    if isempty(ahuListDataCell{iDB,21}) == 0
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).SecondaryPumpRef.ATTRIBUTE.Heating = ...
                            strcat(ahuListDataCell(iDB,21));
                    else
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).SecondaryPumpRef.ATTRIBUTE.Heating = 'Null';
                    end
                    
                    % �M���ڑ��i��j
                    if isempty(ahuListDataCell{iDB,22}) == 0
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).HeatSourceSetRef.ATTRIBUTE.Cooling = ...
                            strcat(ahuListDataCell(iDB,22));
                    else
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).HeatSourceSetRef.ATTRIBUTE.Cooling = 'Null';
                    end
                    
                    % �M���ڑ��i���j
                    if isempty(ahuListDataCell{iDB,23}) == 0
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).HeatSourceSetRef.ATTRIBUTE.Heating = ...
                            strcat(ahuListDataCell(iDB,23));
                    else
                        xmldata.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).HeatSourceSetRef.ATTRIBUTE.Heating = 'Null';
                    end
                    
                end

            end
        end
        
        if iCOUNT == 0
            error('�Y������󒲋@������܂���');
        end
    end
end


