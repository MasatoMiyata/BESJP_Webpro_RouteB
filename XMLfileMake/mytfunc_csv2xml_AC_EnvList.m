% mytfunc_csv2xml_EnvList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �O�ǂ̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------

function xmldata = mytfunc_csv2xml_AC_EnvList(xmldata,filename)

envListData = textread(filename,'%s','delimiter','\n','whitespace','');

% �O��d�l��`�t�@�C���̓ǂݍ���
for i=1:length(envListData)
    conma = strfind(envListData{i},',');
    for j = 1:length(conma)
        if j == 1
            envListDataCell{i,j} = envListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            envListDataCell{i,j}   = envListData{i}(conma(j-1)+1:conma(j)-1);
            envListDataCell{i,j+1} = envListData{i}(conma(j)+1:end);
        else
            envListDataCell{i,j} = envListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% �󔒂͒���̏��𖄂߂�B
for iENV = 11:size(envListDataCell,1)
    if isempty(envListDataCell{iENV,3}) == 0  % ����͕��ʂōs���B
        if isempty(envListDataCell{iENV,1}) && isempty(envListDataCell{iENV,2})
            if iENV == 11
                error('�ŏ��̍s�͕K���󒲃]�[�����̂���͂��Ă�������')
            else
                envListDataCell(iENV,1:2) = envListDataCell(iENV-1,1:2);
            end
        end
    end
end

% �O�烊�X�g�̍쐬
EnvList_Floor    = {};
EnvList_RoomName = {};

for iENV = 11:size(envListDataCell,1)
    if isempty(EnvList_Floor)
        EnvList_Floor = envListDataCell(iENV,1);
        EnvList_RoomName = envListDataCell(iENV,2);
    else
        
        check = 0;
        for iDB = 1:length(EnvList_Floor)
            if strcmp(envListDataCell(iENV,1),EnvList_Floor(iDB)) && ...
                    strcmp(envListDataCell(iENV,2),EnvList_RoomName(iDB))
                % �d������
                check = 1;
            end
        end
        
        if check == 0
            EnvList_Floor    = [EnvList_Floor; envListDataCell(iENV,1)];
            EnvList_RoomName = [EnvList_RoomName; envListDataCell(iENV,2)];
        end
        
    end
end

% �]�[��ID��T��
EnvList_ZoneID = cell(length(EnvList_RoomName),1);
for iENV = 1:length(EnvList_RoomName)
    
    if isempty(EnvList_RoomName{iENV}) == 0
        
        check = 0;
        for iDB = 1:length(xmldata.AirConditioningSystem.AirConditioningZone)
            tmpFloor = xmldata.AirConditioningSystem.AirConditioningZone(iDB).ATTRIBUTE.ACZoneFloor;
            tmpName  = xmldata.AirConditioningSystem.AirConditioningZone(iDB).ATTRIBUTE.ACZoneName;
            tmpID    = xmldata.AirConditioningSystem.AirConditioningZone(iDB).ATTRIBUTE.ID;
            if strcmp(tmpFloor,EnvList_Floor(iENV,1)) && strcmp(tmpName,EnvList_RoomName(iENV,1))
                check = 1;
                EnvList_ZoneID{iENV} = tmpID;
            end
        end
        if check == 0
            EnvList_Floor(iENV,1)
            EnvList_RoomName(iENV,1)
            error('�]�[��ID��������܂���')
        end
    end
    
end


% ���̓ǂݍ���(CSV�t�@�C������I��)
for iENVSET = 1:length(EnvList_Floor)
    
    % �O��Z�b�g�̏��
    xmldata.AirConditioningSystem.Envelope(iENVSET).ATTRIBUTE.ACZoneID    = EnvList_ZoneID(iENVSET,1);
    xmldata.AirConditioningSystem.Envelope(iENVSET).ATTRIBUTE.ACZoneFloor = EnvList_Floor(iENVSET,1);
    xmldata.AirConditioningSystem.Envelope(iENVSET).ATTRIBUTE.ACZoneName  = EnvList_RoomName(iENVSET,1);
    
    iCOUNT = 0;
    
    for iDB = 11:size(envListDataCell,1)
        if strcmp(EnvList_Floor(iENVSET,1),envListDataCell(iDB,1)) && ...
                strcmp(EnvList_RoomName(iENVSET,1),envListDataCell(iDB,2))
            
            if isempty(envListDataCell{iDB,3}) == 0
                
                iCOUNT = iCOUNT + 1;
                
                % ����
                if strcmp(envListDataCell(iDB,3),'�k')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'N';
                elseif strcmp(envListDataCell(iDB,3),'�k��')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'NE';
                elseif strcmp(envListDataCell(iDB,3),'��')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'E';
                elseif strcmp(envListDataCell(iDB,3),'�쓌')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'SE';
                elseif strcmp(envListDataCell(iDB,3),'��')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'S';
                elseif strcmp(envListDataCell(iDB,3),'�쐼')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'SW';
                elseif strcmp(envListDataCell(iDB,3),'��')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'W';
                elseif strcmp(envListDataCell(iDB,3),'�k��')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'NW';
                elseif strcmp(envListDataCell(iDB,3),'����') || strcmp(envListDataCell(iDB,3),'����')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'Horizontal';
                elseif strcmp(envListDataCell(iDB,3),'���A') || strcmp(envListDataCell(iDB,3),'�n��')
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Direction   = 'Shade';
                else
                    error('���ʁ@%s�@�͕s���ł��B', envListDataCell{iDB,3})
                end
                
                % �݁i���悯���ʌW���j
                if isempty(envListDataCell{iDB,4}) == 0
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Eaves_Cooling = envListDataCell(iDB,4);
                else
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Eaves_Cooling = 'Null';
                end
                if isempty(envListDataCell{iDB,5}) == 0
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Eaves_Heating = envListDataCell(iDB,5);
                else
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Eaves_Heating = 'Null';
                end
                
                % �O�ǃ^�C�v
                xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.WallConfigure = envListDataCell(iDB,6);
                
                % �O��ʐρi���ʐρ{�O�ǖʐρj
                xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.WallArea = envListDataCell(iDB,7);
                
                % �����
                if isempty(envListDataCell{iDB,8}) == 0
                    
                    % �����
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.WindowType = envListDataCell(iDB,8);
                    
                    % ���ʐ�
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.WindowArea = envListDataCell(iDB,9);
                    
                    % �����(�u���C���h��ނŏꍇ����)
                    if strcmp(envListDataCell{iDB,10},'�L')
                        xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Blind  = 'True';
                    else
                        xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Blind  = 'False';
                    end
                    
                else
                    % ���^�C�v(�f�t�H���g�j
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.WindowType    = 'Null';
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.WindowArea    = '0';
                    xmldata.AirConditioningSystem.Envelope(iENVSET).Wall(iCOUNT).ATTRIBUTE.Blind         = 'False';
                end
            end
        end
    end
end



