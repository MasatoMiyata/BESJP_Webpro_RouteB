% mytfunc_csv2xml_L.m
%                                             by Masato Miyata 2012/04/21
%------------------------------------------------------------------------
% �ȃG�l��F�Ɩ��ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
% ���́F
%  xmldata  : xml�f�[�^
%  filename : �Ɩ��̎Z��V�[�g(CSV)�t�@�C����
% �o�́F
%  xmldata  : xml�f�[�^
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_L(xmldata,filename)

% CSV�t�@�C���̓ǂݍ���
LightDataCell = mytfunc_CSVfile2Cell(filename);

% ���̔��o
roomFloor = {};
roomName  = {};
UnitID    = {};
LightRoomIndex = {};
LightUnitType = {};
LightUnitName = {};
LightPower = {};
LightCount = {};
LightRoomDepth = {};
LightRoomWidth = {};
LightControlFlag_C1 = {};
LightControlFlag_C2 = {};
LightControlFlag_C3 = {};
LightControlFlag_C4 = {};
LightControlFlag_C5 = {};
LightControlFlag_C6 = {};

for iUNIT = 11:size(LightDataCell,1)
    
    % ���ID
    eval(['UnitID = [UnitID; ''LUnit_',int2str(iUNIT-10),'''];'])
    
    % �K���Ǝ���
    if isempty(LightDataCell{iUNIT,2})
        if iUNIT > 11
            roomFloor  = [roomFloor;roomFloor(end)];
            roomName   = [roomName;roomName(end)];
        else
            error('��߂̎������󔒂ł��B')
        end
    else
        roomFloor = [roomFloor;LightDataCell{iUNIT,1}];
        roomName  = [roomName;LightDataCell{iUNIT,2}];
    end

    % �Ԍ�
    if isempty(LightDataCell{iUNIT,8})
        LightRoomWidth   = [LightRoomWidth;'Null'];
    else
        LightRoomWidth   = [LightRoomWidth;LightDataCell{iUNIT,8}];
    end
    
    % ���s��
    if isempty(LightDataCell{iUNIT,9})
        LightRoomDepth   = [LightRoomDepth;'Null'];
    else
        LightRoomDepth   = [LightRoomDepth;LightDataCell{iUNIT,9}];
    end
    
    % ���w��
    if isempty(LightDataCell{iUNIT,10})
        LightRoomIndex  = [LightRoomIndex;'Null'];
    else
        LightRoomIndex  = [LightRoomIndex;LightDataCell{iUNIT,10}];
    end
       
    % �Ɩ�����
    if isempty(LightDataCell{iUNIT,11})
        LightUnitName   = [LightUnitName;'Null'];
    else
        LightUnitName   = [LightUnitName;LightDataCell(iUNIT,11)];
    end
    
    % ����d��
    LightPower = [LightPower;str2double(LightDataCell(iUNIT,12))];
    
    % �䐔
    LightCount = [LightCount;str2double(LightDataCell(iUNIT,13))];
    
    % �ݎ����m����iVer2����I�����ύX�j
    if isempty(LightDataCell{iUNIT,14}) == 0
        if strcmp(LightDataCell(iUNIT,14),'��������')
            LightControlFlag_C1 = [LightControlFlag_C1;'dimmer'];
        elseif strcmp(LightDataCell(iUNIT,14),'�_�ŕ���')
            LightControlFlag_C1 = [LightControlFlag_C1;'onoff'];
        elseif strcmp(LightDataCell(iUNIT,14),'������������')
            LightControlFlag_C1 = [LightControlFlag_C1;'limitedVariable'];
        elseif strcmp(LightDataCell(iUNIT,14),'��')
            LightControlFlag_C1 = [LightControlFlag_C1;'None'];
        else
            error('�Ɩ�����C1: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C1 = [LightControlFlag_C1;'None'];
    end
    
    % ���邳���m����iVer2����I�����ύX�AVer.2.4�ōX�ɒǉ��j
    if isempty(LightDataCell{iUNIT,15}) == 0
        if strcmp(LightDataCell(iUNIT,15),'��������')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������(��������u���C���h���p)')
            LightControlFlag_C2 = [LightControlFlag_C2;'variableWithBlind'];
            
        elseif strcmp(LightDataCell(iUNIT,15),'��������BL')
            LightControlFlag_C2 = [LightControlFlag_C2;'variableWithBlind'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������W15')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable_W15'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������W15BL')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable_W15_WithBlind'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������W20')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable_W20'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������W20BL')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable_W20_WithBlind'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������W25')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable_W25'];
        elseif strcmp(LightDataCell(iUNIT,15),'��������W25BL')
            LightControlFlag_C2 = [LightControlFlag_C2;'variable_W25_WithBlind'];
            
        elseif strcmp(LightDataCell(iUNIT,15),'�_�ŕ���')
            LightControlFlag_C2 = [LightControlFlag_C2;'onoff'];
        elseif strcmp(LightDataCell(iUNIT,15),'��')
            LightControlFlag_C2 = [LightControlFlag_C2;'None'];
            
        else
            error('�Ɩ�����C2: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C2 = [LightControlFlag_C2;'None'];
    end
    
    
    % �^�C���X�P�W���[������
    if isempty(LightDataCell{iUNIT,16}) == 0
        if strcmp(LightDataCell(iUNIT,16),'��������')
            LightControlFlag_C3 = [LightControlFlag_C3;'dimmer'];
        elseif strcmp(LightDataCell(iUNIT,16),'�_�ŕ���')
            LightControlFlag_C3 = [LightControlFlag_C3;'onoff'];
        elseif strcmp(LightDataCell(iUNIT,16),'��')
            LightControlFlag_C3 = [LightControlFlag_C3;'None'];
        else
            error('�Ɩ�����C3: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C3 = [LightControlFlag_C3;'None'];
    end
    
    % �����Ɠx�␳�@�\
    if isempty(LightDataCell{iUNIT,17}) == 0
        if strcmp(LightDataCell(iUNIT,17),'�^�C�}����(LED)')
            LightControlFlag_C4 = [LightControlFlag_C4;'timerLED'];
        elseif strcmp(LightDataCell(iUNIT,17),'�^�C�}����(�u����)')
            LightControlFlag_C4 = [LightControlFlag_C4;'timerFLU'];
        elseif strcmp(LightDataCell(iUNIT,17),'�Z���T����(LED)')
            LightControlFlag_C4 = [LightControlFlag_C4;'sensorLED'];
        elseif strcmp(LightDataCell(iUNIT,17),'�Z���T����(�u����)')
            LightControlFlag_C4 = [LightControlFlag_C4;'sensorFLU'];
        elseif strcmp(LightDataCell(iUNIT,17),'��')
            LightControlFlag_C4 = [LightControlFlag_C4;'False'];
        else
            error('�Ɩ�����C4: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C4 = [LightControlFlag_C4;'False'];
    end
    
end

% �������ɕ��ёւ�
RoomList = {};
UnitList = {};

for iUNIT = 1:size(roomName,1)
    
    if strcmp(roomName(iUNIT),'Null') == 0
        
        if isempty(RoomList) == 1
            RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT),...
                LightRoomIndex(iUNIT),LightRoomDepth(iUNIT),LightRoomWidth(iUNIT)];
            UnitList = [UnitList; UnitID(iUNIT)];
        else
            check = 0;
            for iDB = 1:size(RoomList,1)
                if strcmp(RoomList(iDB,1),roomFloor(iUNIT)) &&...
                        strcmp(RoomList(iDB,2),roomName(iUNIT))
                    check = 1;
                    UnitList{iDB} = [UnitList{iDB}, UnitID(iUNIT)];
                end
            end
            
            % ����������Ȃ���Βǉ�
            if check == 0
                RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT),...
                    LightRoomIndex(iUNIT),LightRoomDepth(iUNIT),LightRoomWidth(iUNIT)];
                UnitList = [UnitList; UnitID(iUNIT)];
            end
        end
        
    else
        error('�����̂��s���ł��B')
    end
end

% XML�t�@�C������

numOfRoom = size(RoomList,1);

for iROOM = 1:numOfRoom
    
    if strcmp(RoomList(iROOM,2),'Null') == 0
        
        % ��������
        [RoomID,BldgType,RoomType,RoomArea,~,RoomHeight] = ...
            mytfunc_roomIDsearch(xmldata,RoomList(iROOM,1),RoomList(iROOM,2));
        
        % ���̑������i�[
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomIDs    = RoomID;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomFloor  = RoomList(iROOM,1);
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomName   = RoomList(iROOM,2);
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.BldgType   = BldgType;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomType   = RoomType;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomArea   = RoomArea;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomHeight = RoomHeight;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomIndex  = RoomList(iROOM,3);
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomWidth  = RoomList(iROOM,5);
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomDepth  = RoomList(iROOM,4);
        
        % ���j�b�g���
        if iscell(UnitList{iROOM}) == 1
            unitNum = length(UnitList{iROOM});
        else
            unitNum = 1;
        end
        
        Count = 0;
        
        for iUNIT = 1:unitNum
            
            if unitNum == 1
                tmpUnitID = UnitList(iROOM);
            else
                tmpUnitID = UnitList{iROOM}(iUNIT);
            end
            
            % ���j�b�g�̏�������
            for iDB = 1:length(UnitID)
                if strcmp(UnitID(iDB),tmpUnitID)
 
                    Count = Count + 1;
       
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ID              = UnitID(iDB);
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.UnitName        = LightUnitName{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.Power           = LightPower{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.Count           = LightCount{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C1  = LightControlFlag_C1{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C2  = LightControlFlag_C2{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C3  = LightControlFlag_C3{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C4  = LightControlFlag_C4{iDB};
                    
                end
            end
        end
        
    end
end




