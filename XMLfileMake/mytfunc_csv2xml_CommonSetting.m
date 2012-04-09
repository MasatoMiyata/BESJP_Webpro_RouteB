% mytfunc_csv2xml_CommonSetting.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���ʐݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_CommonSetting(xmldata,filename)

% �f�[�^�̓ǂݍ���
commonData = textread(filename,'%s','delimiter','\n','whitespace','');

% �󒲎���`�t�@�C���̓ǂݍ���
for i=1:length(commonData)
    conma = strfind(commonData{i},',');
    for j = 1:length(conma)
        if j == 1
            commonDataCell{i,j} = commonData{i}(1:conma(j)-1);
        elseif j == length(conma)
            commonDataCell{i,j}   = commonData{i}(conma(j-1)+1:conma(j)-1);
            commonDataCell{i,j+1} = commonData{i}(conma(j)+1:end);
        else
            commonDataCell{i,j} = commonData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end


% ���̔��o
roomFloor = {};
roomName  = {};
roomBuildingType = {};
roomRoomType  = {};
roomFloorHeight = {};
roomRoomHeight = {};
roomWidth = {};
roomDepth = {};
roomArea = {};
roomInfo = {};
roomcalcAC = {};
roomcalcL = {};
roomcalcV = {};
roomcalcHW = {};

for iRoom = 11:size(commonDataCell,1)
    
    % �K��
    if isempty(commonDataCell{iRoom,1})
        roomFloor  = [roomFloor;'Null'];
    else
        roomFloor  = [roomFloor;commonDataCell{iRoom,1}];
    end
    
    % ����
    roomName   = [roomName;commonDataCell{iRoom,2}];
    
    % �����p�r
    switch commonDataCell{iRoom,3}
        case '��������'
            roomBuildingType   = [roomBuildingType; 'Office'];
        case '�z�e����'
            roomBuildingType   = [roomBuildingType; 'Hotel'];
        case '�a�@��'
            roomBuildingType   = [roomBuildingType; 'Hospital'];
        case '���i�̔��Ƃ��c�ޓX�ܓ�'
            roomBuildingType   = [roomBuildingType; 'Store'];
        case '�w�Z��'
            roomBuildingType   = [roomBuildingType; 'School'];
        case '���H�X��'
            roomBuildingType   = [roomBuildingType; 'Restaurant'];
        case '�W���'
            roomBuildingType   = [roomBuildingType; 'MeetingPlace'];
        case '�H�ꓙ'
            roomBuildingType   = [roomBuildingType; 'Factory'];
        otherwise
            error('�����p�r���s���ł�')
    end
    
    % ���p�r
    roomRoomType = [roomRoomType;commonDataCell{iRoom,4}];
    
    % �K��
    if isempty(commonDataCell{iRoom,5})
        roomFloorHeight = [roomFloorHeight;'Null'];
    else
        roomFloorHeight = [roomFloorHeight;commonDataCell{iRoom,5}];
    end
    
    % �V�䍂
    if isempty(commonDataCell{iRoom,6})
        roomRoomHeight = [roomRoomHeight;'Null'];
    else
        roomRoomHeight = [roomRoomHeight;commonDataCell{iRoom,6}];
    end
    
    % ���̊Ԍ�
    if isempty(commonDataCell{iRoom,7})
        roomWidth = [roomWidth;'Null'];
    else
        roomWidth = [roomWidth;commonDataCell{iRoom,7}];
    end
    
    % ���̉��s��
    if isempty(commonDataCell{iRoom,8})
        roomDepth = [roomDepth;'Null'];
    else
        roomDepth = [roomDepth;commonDataCell{iRoom,8}];
    end
    
    % ���̖ʐ�
    if isempty(commonDataCell{iRoom,9})
        roomArea = [roomArea;'Null'];
    else
        roomArea = [roomArea;commonDataCell{iRoom,9}];
    end
    
    % ���l
    if isempty(commonDataCell{iRoom,10})
        roomInfo = [roomInfo;'Null'];
    else
        roomInfo = [roomInfo;commonDataCell{iRoom,10}];
    end
    
    % �v�Z�Ώ�
    if isempty(commonDataCell{iRoom,12})
        roomcalcAC = [roomcalcAC;'False'];
    else
        roomcalcAC = [roomcalcAC;'True'];
    end
    
    if isempty(commonDataCell{iRoom,13})
        roomcalcL = [roomcalcL;'False'];
    else
        roomcalcL = [roomcalcL;'True'];
    end
    
    if isempty(commonDataCell{iRoom,14})
        roomcalcV = [roomcalcV;'False'];
    else
        roomcalcV = [roomcalcV;'True'];
    end
    
    if isempty(commonDataCell{iRoom,15})
        roomcalcHW = [roomcalcHW;'False'];
    else
        roomcalcHW = [roomcalcHW;'True'];
    end
    
end

% XML�t�@�C������
for iROOM = 1:size(roomName,1)
    
    eval(['xmldata.Rooms.Room(iROOM).ATTRIBUTE.ID = ''ROOM_',int2str(iROOM),''';'])
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomFloor      = roomFloor{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomName       = roomName{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.BuildingType   = roomBuildingType{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomType       = roomRoomType{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.FloorHeight    = roomFloorHeight{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomHeight     = roomRoomHeight{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomWidth      = roomWidth{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomDepth      = roomDepth{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.RoomArea       = roomArea{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.Info           = roomInfo{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.calcAC         = roomcalcAC{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.calcL          = roomcalcL{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.calcV          = roomcalcV{iROOM};
    xmldata.Rooms.Room(iROOM).ATTRIBUTE.calcHW         = roomcalcHW{iROOM};
    
end
