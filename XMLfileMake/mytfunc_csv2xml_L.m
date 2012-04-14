% mytfunc_csv2xml_L.m
%                                             by Masato Miyata 2012/04/14
%------------------------------------------------------------------------
% �ȃG�l��F�Ɩ��ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_L(xmldata,filename)

% �f�[�^�̓ǂݍ���
LightData = textread(filename,'%s','delimiter','\n','whitespace','');

% �󒲎���`�t�@�C���̓ǂݍ���
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
LightRoomIndex = {};
LightUnitType = {};
LightUnitName = {};
LightPower = {};
LightCount = {};
LightControlFlag_C1 = {};
LightControlFlag_C2 = {};
LightControlFlag_C3 = {};
LightControlFlag_C4 = {};

for iUNIT = 11:size(LightDataCell,1)
    
    % �K��
    if isempty(LightDataCell{iUNIT,1})
        roomFloor  = [roomFloor;'Null'];
    else
        roomFloor  = [roomFloor;LightDataCell{iUNIT,1}];
    end
    
    % ����
    if isempty(LightDataCell{iUNIT,2})
        roomName  = [roomName;'Null'];
    else
        roomName  = [roomName;LightDataCell{iUNIT,2}];
    end
    
    % ���w��
    if isempty(LightDataCell{iUNIT,8})
        LightRoomIndex  = [LightRoomIndex;'Null'];
    else
        LightRoomIndex  = [LightRoomIndex;LightDataCell{iUNIT,8}];
    end
    
    % �Ɩ����`��
    if isempty(LightDataCell{iUNIT,9})
        LightUnitType   = [LightUnitType;'Null'];
    else
        LightUnitType   = [LightUnitType;LightDataCell{iUNIT,9}];
    end
    
    % �Ɩ�����
    if isempty(LightDataCell{iUNIT,10})
        LightUnitName   = [LightUnitName;'Null'];
    else
        LightUnitName   = [LightUnitName;LightDataCell{iUNIT,10}];
    end
    
    % ����d��
    LightPower = [LightPower;LightDataCell{iUNIT,11}];
    
    % �䐔
    LightCount = [LightCount;LightDataCell{iUNIT,12}];
    
    % �ݎ����m����
    if isempty(LightDataCell{iUNIT,13}) == 0
        LightControlFlag_C1 = [LightControlFlag_C1;'dimmer'];
    elseif isempty(LightDataCell{iUNIT,14}) == 0
        LightControlFlag_C1 = [LightControlFlag_C1;'onoff'];
    elseif isempty(LightDataCell{iUNIT,15}) == 0
        LightControlFlag_C1 = [LightControlFlag_C1;'sensing64'];
    elseif isempty(LightDataCell{iUNIT,16}) == 0
        LightControlFlag_C1 = [LightControlFlag_C1;'sensing32'];
    elseif isempty(LightDataCell{iUNIT,17}) == 0
        LightControlFlag_C1 = [LightControlFlag_C1;'eachunit'];
    else
        LightControlFlag_C1 = [LightControlFlag_C1;'None'];
    end
    
    % �^�C���X�P�W���[������
    if isempty(LightDataCell{iUNIT,18}) == 0
        LightControlFlag_C2 = [LightControlFlag_C2;'dimmer'];
    elseif isempty(LightDataCell{iUNIT,19}) == 0
        LightControlFlag_C2 = [LightControlFlag_C2;'onoff'];
    else
        LightControlFlag_C2 = [LightControlFlag_C2;'None'];
    end
    
    % �����Ɠx�␳
    if isempty(LightDataCell{iUNIT,20}) == 0
        LightControlFlag_C3 = [LightControlFlag_C3;'True'];
    else
        LightControlFlag_C3 = [LightControlFlag_C3;'None'];
    end
    
    % ���邳���m����
    if isempty(LightDataCell{iUNIT,21}) == 0
        LightControlFlag_C4 = [LightControlFlag_C4;'dimmer'];
    elseif isempty(LightDataCell{iUNIT,22}) == 0
        LightControlFlag_C4 = [LightControlFlag_C4;'eachSideWithBlind'];
    elseif isempty(LightDataCell{iUNIT,23}) == 0
        LightControlFlag_C4 = [LightControlFlag_C4;'eachSideWithoutBlind'];
    elseif isempty(LightDataCell{iUNIT,24}) == 0
        LightControlFlag_C4 = [LightControlFlag_C4;'bothSidesWithBlind'];
    elseif isempty(LightDataCell{iUNIT,25}) == 0
        LightControlFlag_C4 = [LightControlFlag_C4;'bothSidesWithoutBlind'];
    else
        LightControlFlag_C4 = [LightControlFlag_C4;'None'];
    end
    
end

% XML�t�@�C������
roomNum = 0;

for iUNIT = 1:size(LightPower,1)
   
    if strcmp(roomName(iUNIT),'Null') == 0
        roomNum = roomNum + 1;
        unitNum = 1;
        
        % ��������
        [RoomID,BldgType,RoomType,RoomArea,~,RoomHeight,RoomWidth,RoomDepth] = ...
            mytfunc_roomIDsearch(xmldata,roomFloor{iUNIT},roomName{iUNIT});
        
        % ���̑������i�[
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomIDs    = RoomID;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomFloor  = roomFloor{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomName   = roomName{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.BldgType   = BldgType;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomType   = RoomType;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomArea   = RoomArea;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomHeight = RoomHeight;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomWidth  = RoomWidth;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomDepth  = RoomDepth;
        xmldata.LightingSystems.LightingRoom(roomNum).ATTRIBUTE.RoomIndex  = LightRoomIndex{iUNIT};
        
        % ���j�b�g���
        eval(['xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ID = ''LUnit_',int2str(iUNIT),''';'])
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.UnitType        = LightUnitType{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.UnitName        = LightUnitName{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.Power           = LightPower{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.Count           = LightCount{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C1  = LightControlFlag_C1{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C2  = LightControlFlag_C2{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C3  = LightControlFlag_C3{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C4  = LightControlFlag_C4{iUNIT};
        
    else
        
        unitNum = unitNum + 1;
        % ���j�b�g���
        eval(['xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ID = ''LUnit_',int2str(iUNIT),''';'])
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.UnitType        = LightUnitType{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.UnitName        = LightUnitName{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.Power           = LightPower{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.Count           = LightCount{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C1  = LightControlFlag_C1{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C2  = LightControlFlag_C2{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C3  = LightControlFlag_C3{iUNIT};
        xmldata.LightingSystems.LightingRoom(roomNum).LightingUnit(unitNum).ATTRIBUTE.ControlFlag_C4  = LightControlFlag_C4{iUNIT};
        
    end
end




