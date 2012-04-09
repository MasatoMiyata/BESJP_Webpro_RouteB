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

% �󔒂͒���̏��𖄂߂�B
for iREF = 11:size(refListDataCell,1)
    if isempty(refListDataCell{iREF,1})
        if iREF == 11
            error('�ŏ��̍s�͕K���M���Q�R�[�h����͂��Ă�������')
        else
            refListDataCell(iREF,1:6) = refListDataCell(iREF-1,1:6);
        end
    end
end

% �M���Q�̖��̂��E���グ��B
refNameList_C = {};
refNameList_H = {};
for iREF = 11:size(refListDataCell,1)
    if iREF == 11  % �ŏ�������O����
        if isempty(refListDataCell{iREF,11}) == 0  % ��M��������ꍇ
            refNameList_C = refListDataCell(iREF,1);
        end
        if isempty(refListDataCell{iREF,20}) == 0 % ���M��������ꍇ
            refNameList_H = refListDataCell(iREF,1);
        end
        
    else
        
        if isempty(refListDataCell{iREF,11}) == 0  % ��M��������ꍇ
            tmp = 0;
            for iREFLIST = 1:size(refNameList_C,1)
                if strcmp(refListDataCell(iREF,1),refNameList_C(iREFLIST))
                    tmp = 1; % ����LIST�ɂ���ꍇ
                end
            end
            if tmp == 0 % LIST�ɂȂ��ꍇ�͒ǉ�
                refNameList_C = [refNameList_C;refListDataCell(iREF,1)];
            end
        end
        
        if isempty(refListDataCell{iREF,20}) == 0  % ���M��������ꍇ
            tmp = 0;
            for iREFLIST = 1:size(refNameList_H,1)
                if strcmp(refListDataCell(iREF,1),refNameList_H(iREFLIST))
                    tmp = 1; % ����LIST�ɂ���ꍇ
                end
            end
            if tmp == 0 % LIST�ɂȂ��ꍇ�͒ǉ�
                refNameList_H = [refNameList_H;refListDataCell(iREF,1)];
            end
        end
    end
end


% �ő�ݒ�䐔
maxNum = 10;

% XML�t�@�C���ɒǉ�(��M��)
for iREFLIST = 1:size(refNameList_C)
    for iREF = 11:size(refListDataCell,1)
        if strcmp(refNameList_C(iREFLIST),refListDataCell(iREF,1))
            
            xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.ID  = strcat(refListDataCell(iREF,1),'_C');
            xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.Mode = 'Cooling';
            
            % �~�M����
            if strcmp(refListDataCell(iREF,3),'�L')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.ThermalStorage = 'True';
            elseif strcmp(refListDataCell(iREF,3),'��')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.ThermalStorage = 'False';
            else
                error('�M���̒~�M���̐ݒ肪�s���ł��B')
            end
            
            % �䐔����
            if strcmp(refListDataCell(iREF,4),'�L')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.QuantityControl = 'True';
            elseif strcmp(refListDataCell(iREF,4),'��')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.QuantityControl = 'False';
            else
                error('�M���̑䐔����̐ݒ肪�s���ł��B')
            end
            
            
            for iNum = 1:maxNum
                
                eval(['numName = ''',int2str(iNum),'�Ԗ�'';'])
                
                if strcmp(refListDataCell{iREF,9},numName)
                    
                    % �^�]����
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Order = int2str(iNum);
                    
                    % �䐔
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Count  = refListDataCell(iREF,10);
                    
                    % �@����
                    if strcmp(refListDataCell(iREF,8),'�^�[�{�Ⓚ�@�i�W���C�x�[������j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype1';
                    elseif strcmp(refListDataCell(iREF,8),'�^�[�{�Ⓚ�@�i�������C�x�[������j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype2';
                    elseif strcmp(refListDataCell(iREF,8),'�^�[�{�Ⓚ�@�i�������C�C���o�[�^����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype3';
                    elseif strcmp(refListDataCell(iREF,8),'���q�[�g�|���v�i�X�N�����[�C�X���C�h�فj')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype4';
                    elseif strcmp(refListDataCell(iREF,8),'���q�[�g�|���v�i�X�N�����[�C�C���o�[�^�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype5';
                    elseif strcmp(refListDataCell(iREF,8),'���q�[�g�|���v�i�X�N���[���C���k�@�䐔����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype6';
                    elseif strcmp(refListDataCell(iREF,8),'����`���[�i�X�N�����[�C�X���C�h�فj')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype7';
                    elseif strcmp(refListDataCell(iREF,8),'����`���[�i�X�N�����[�C�C���o�[�^�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype8';
                    elseif strcmp(refListDataCell(iREF,8),'����`���[�i�X�N���[���C���k�@�䐔����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype9';
                    elseif strcmp(refListDataCell(iREF,8),'�����z���≷����i�O�d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype10';
                    elseif strcmp(refListDataCell(iREF,8),'�����z���≷����i�j�d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype11';
                    elseif strcmp(refListDataCell(iREF,8),'�����z���≷����i�����Ԍ����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype12';
                    elseif strcmp(refListDataCell(iREF,8),'���C�����z�����≷����i��d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype13';
                    elseif strcmp(refListDataCell(iREF,8),'���������z�����≷����i��d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype14';
                    elseif strcmp(refListDataCell(iREF,8),'�r�M�����^�z�����≷����i��d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype15';
                    elseif strcmp(refListDataCell(iREF,8),'�{�C���i���^�ї��{�C���j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype16';
                    elseif strcmp(refListDataCell(iREF,8),'�{�C���i�^�󉷐��q�[�^�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype17';
                    elseif strcmp(refListDataCell(iREF,8),'�d�C���r���p�}���`')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype18';
                    elseif strcmp(refListDataCell(iREF,8),'�K�X���r���p�}���`')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype19';
                    else
                        refListDataCell(iREF,8)
                        error('�M����ނ��s���ł��B')
                    end
                    
                    % �Ⓚ�\��
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Capacity = refListDataCell(iREF,11);
                    % ��@�G�l���M�[�����
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.MainPower = refListDataCell(iREF,12);
                    
                    % ��@����d��
                    if isempty(refListDataCell{iREF,13})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.SubPower = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.SubPower = refListDataCell(iREF,13);
                    end
                    
                    % �ꎟ�|���v����d��
                    if isempty(refListDataCell{iREF,14})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.PrimaryPumpPower = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.PrimaryPumpPower = refListDataCell(iREF,14);
                    end
                    
                    % ��p����p�\��
                    if isempty(refListDataCell{iREF,15})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTCapacity = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTCapacity = refListDataCell(iREF,15);
                    end
                    
                    % ��p���t�@������d��
                    if isempty(refListDataCell{iREF,16})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTFanPower = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTFanPower = refListDataCell(iREF,16);
                    end
                    
                    % ��p���|���v����d��
                    if isempty(refListDataCell{iREF,17})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTPumpPower = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTPumpPower = refListDataCell(iREF,17);
                    end
                end
            end
            
        end
    end
end

% XML�t�@�C���ɒǉ�(���M��)
for iREFLISTH = 1:size(refNameList_H)
    
    iREFLIST = iREFLISTH + length(refNameList_C);
    
    for iREF = 11:size(refListDataCell,1)
        if strcmp(refNameList_H(iREFLISTH),refListDataCell(iREF,1))
            
            xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.ID  = strcat(refListDataCell(iREF,1),'_H');
            xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.Mode = 'Heating';
            
            % �~�M����
            if strcmp(refListDataCell(iREF,5),'�L')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.ThermalStorage = 'True';
            elseif strcmp(refListDataCell(iREF,5),'��')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.ThermalStorage = 'False';
            else
                error('�M���̒~�M���̐ݒ肪�s���ł��B')
            end
            
            % �䐔����
            if strcmp(refListDataCell(iREF,6),'�L')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.QuantityControl = 'True';
            elseif strcmp(refListDataCell(iREF,6),'��')
                xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).ATTRIBUTE.QuantityControl = 'False';
            else
                error('�M���̑䐔����̐ݒ肪�s���ł��B')
            end
                       
            for iNum = 1:maxNum
                
                eval(['numName = ''',int2str(iNum),'�Ԗ�'';'])
                
                if strcmp(refListDataCell{iREF,18},numName)

                    % �^�]����
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Order = int2str(iNum);

                    % �䐔
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Count  = refListDataCell(iREF,19);
                    
                    if strcmp(refListDataCell(iREF,8),'�^�[�{�Ⓚ�@�i�W���C�x�[������j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype1';
                    elseif strcmp(refListDataCell(iREF,8),'�^�[�{�Ⓚ�@�i�������C�x�[������j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype2';
                    elseif strcmp(refListDataCell(iREF,8),'�^�[�{�Ⓚ�@�i�������C�C���o�[�^����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype3';
                    elseif strcmp(refListDataCell(iREF,8),'���q�[�g�|���v�i�X�N�����[�C�X���C�h�فj')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype4';
                    elseif strcmp(refListDataCell(iREF,8),'���q�[�g�|���v�i�X�N�����[�C�C���o�[�^�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype5';
                    elseif strcmp(refListDataCell(iREF,8),'���q�[�g�|���v�i�X�N���[���C���k�@�䐔����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype6';
                    elseif strcmp(refListDataCell(iREF,8),'����`���[�i�X�N�����[�C�X���C�h�فj')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype7';
                    elseif strcmp(refListDataCell(iREF,8),'����`���[�i�X�N�����[�C�C���o�[�^�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype8';
                    elseif strcmp(refListDataCell(iREF,8),'����`���[�i�X�N���[���C���k�@�䐔����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype9';
                    elseif strcmp(refListDataCell(iREF,8),'�����z���≷����i�O�d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype10';
                    elseif strcmp(refListDataCell(iREF,8),'�����z���≷����i�j�d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype11';
                    elseif strcmp(refListDataCell(iREF,8),'�����z���≷����i�����Ԍ����j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype12';
                    elseif strcmp(refListDataCell(iREF,8),'���C�����z�����≷����i��d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype13';
                    elseif strcmp(refListDataCell(iREF,8),'���������z�����≷����i��d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype14';
                    elseif strcmp(refListDataCell(iREF,8),'�r�M�����^�z�����≷����i��d���p�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype15';
                    elseif strcmp(refListDataCell(iREF,8),'�{�C���i���^�ї��{�C���j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype16';
                    elseif strcmp(refListDataCell(iREF,8),'�{�C���i�^�󉷐��q�[�^�j')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype17';
                    elseif strcmp(refListDataCell(iREF,8),'�d�C���r���p�}���`')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype18';
                    elseif strcmp(refListDataCell(iREF,8),'�K�X���r���p�}���`')
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Type = 'Rtype19';
                    else
                        refListDataCell(iREF,8)
                        error('�M����ނ��s���ł��B')
                    end

                    % ���M�\��
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.Capacity = refListDataCell(iREF,20);
                    
                    % ��@�G�l���M�[�����
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.MainPower = refListDataCell(iREF,21);
                    
                    % ��@����d��
                    if isempty(refListDataCell{iREF,22})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.SubPower = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.SubPower = refListDataCell(iREF,22);
                    end
                    
                    % �ꎟ�|���v����d��
                    if isempty(refListDataCell{iREF,23})
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.PrimaryPumpPower = '0';
                    else
                        xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.PrimaryPumpPower = refListDataCell(iREF,23);
                    end
                    
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTCapacity = '0';
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTFanPower = '0';
                    xmldata.AirConditioningSystem.HeatSourceSet(iREFLIST).HeatSource(iNum).ATTRIBUTE.CTPumpPower = '0';
                    
                end
            end
            
        end
    end
end





