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
LightData = textread(filename,'%s','delimiter','\n','whitespace','');

% �Ɩ���`�t�@�C���̓ǂݍ���
for i=1:length(LightData)
    conma = strfind(LightData{i},',');
    for j = 1:length(conma)
        if j == 1
            LightDataCell{i,j} = LightData{i}(1:conma(j)-1);
        elseif j == length(conma)
            LightDataCell{i,j}   = LightData{i}(conma(j-1)+1:conma(j)-1);
            LightDataCell{i,j+1} = LightData{i}(conma(j)+1:end);
        else
            LightDataCell{i,j} = LightData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

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
   
    % �Ɩ����`��
    if isempty(LightDataCell{iUNIT,11})
        LightUnitType   = [LightUnitType;'Null'];
    else
        LightUnitType   = [LightUnitType;LightDataCell{iUNIT,11}];
    end
    
    % �Ɩ�����
    if isempty(LightDataCell{iUNIT,12})
        LightUnitName   = [LightUnitName;'Null'];
    else
        LightUnitName   = [LightUnitName;LightDataCell(iUNIT,12)];
    end
    
    % ����d��
    LightPower = [LightPower;str2double(LightDataCell(iUNIT,13))];
    
    % �䐔
    LightCount = [LightCount;str2double(LightDataCell(iUNIT,14))];
    
    % �ݎ����m����
    if isempty(LightDataCell{iUNIT,15}) == 0
        if strcmp(LightDataCell(iUNIT,15),'����')
            LightControlFlag_C1 = [LightControlFlag_C1;'dimmer'];
        elseif strcmp(LightDataCell(iUNIT,15),'�ꊇ�_��')
            LightControlFlag_C1 = [LightControlFlag_C1;'onoff'];
        elseif strcmp(LightDataCell(iUNIT,15),'6.4m�p�_��')
            LightControlFlag_C1 = [LightControlFlag_C1;'sensing64'];
        elseif strcmp(LightDataCell(iUNIT,15),'3.2m�p�_�Łj')
            LightControlFlag_C1 = [LightControlFlag_C1;'sensing32'];
        elseif strcmp(LightDataCell(iUNIT,15),'���_��')
            LightControlFlag_C1 = [LightControlFlag_C1;'eachunit'];
        elseif strcmp(LightDataCell(iUNIT,15),'��')
            LightControlFlag_C1 = [LightControlFlag_C1;'None'];
        else
            error('�Ɩ�����C1: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C1 = [LightControlFlag_C1;'None'];
    end
    
    % �^�C���X�P�W���[������
    if isempty(LightDataCell{iUNIT,16}) == 0
        if strcmp(LightDataCell(iUNIT,16),'����')
            LightControlFlag_C2 = [LightControlFlag_C2;'dimmer'];
        elseif strcmp(LightDataCell(iUNIT,16),'����')
            LightControlFlag_C2 = [LightControlFlag_C2;'onoff'];
        elseif strcmp(LightDataCell(iUNIT,16),'��')
            LightControlFlag_C2 = [LightControlFlag_C2;'None'];
        else
            error('�Ɩ�����C2: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C2 = [LightControlFlag_C2;'None'];
    end
    
    % �����Ɠx�␳
    if isempty(LightDataCell{iUNIT,17}) == 0
        if strcmp(LightDataCell(iUNIT,17),'�L')
            LightControlFlag_C3 = [LightControlFlag_C3;'True'];
        elseif strcmp(LightDataCell(iUNIT,17),'��')
            LightControlFlag_C3 = [LightControlFlag_C3;'False'];
        else
            error('�Ɩ�����C3: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C3 = [LightControlFlag_C3;'False'];
    end
    
    % �������p����
    if isempty(LightDataCell{iUNIT,18}) == 0
        if strcmp(LightDataCell(iUNIT,18),'�Б��̌����u���C���h��������Ȃ�')
            LightControlFlag_C4 = [LightControlFlag_C4;'eachSideWithoutBlind'];
        elseif strcmp(LightDataCell(iUNIT,18),'�Б��̌����u���C���h�������䂠��')
            LightControlFlag_C4 = [LightControlFlag_C4;'eachSideWithBlind'];
        elseif strcmp(LightDataCell(iUNIT,18),'�����̌����u���C���h��������Ȃ�')
            LightControlFlag_C4 = [LightControlFlag_C4;'bothSidesWithoutBlind'];
        elseif strcmp(LightDataCell(iUNIT,18),'�����̌����u���C���h�������䂠��')
            LightControlFlag_C4 = [LightControlFlag_C4;'bothSidesWithBlind'];
        elseif strcmp(LightDataCell(iUNIT,18),'��')
            LightControlFlag_C4 = [LightControlFlag_C4;'None'];
        else
            LightDataCell(iUNIT,18)
            error('�Ɩ�����C4: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C4 = [LightControlFlag_C4;'None'];
    end
    
    
    % ���邳���m����
    if isempty(LightDataCell{iUNIT,19}) == 0
        if strcmp(LightDataCell(iUNIT,19),'�L')
            LightControlFlag_C5 = [LightControlFlag_C5;'True'];
        elseif strcmp(LightDataCell(iUNIT,19),'��')
            LightControlFlag_C5 = [LightControlFlag_C5;'False'];
        else
            error('�Ɩ�����C5: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C5 = [LightControlFlag_C5;'False'];
    end
    
    % �Ɠx������������
    if isempty(LightDataCell{iUNIT,20}) == 0
        if strcmp(LightDataCell(iUNIT,20),'�L')
            LightControlFlag_C6 = [LightControlFlag_C6;'True'];
        elseif strcmp(LightDataCell(iUNIT,20),'��')
            LightControlFlag_C6 = [LightControlFlag_C6;'False'];
        else
            error('�Ɩ�����C6: �s���ȑI�����ł�')
        end
    else
        LightControlFlag_C6 = [LightControlFlag_C6;'False'];
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
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.UnitType        = LightUnitType{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.UnitName        = LightUnitName{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.Power           = LightPower{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.Count           = LightCount{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C1  = LightControlFlag_C1{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C2  = LightControlFlag_C2{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C3  = LightControlFlag_C3{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C4  = LightControlFlag_C4{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C5  = LightControlFlag_C5{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C6  = LightControlFlag_C6{iDB};
                    
                end
            end
        end
        
    end
end




