% mytfunc_csv2xml_AC_RoomList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% ���̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_RoomList(xmldata,filename)

roomDefData = textread(filename,'%s','delimiter','\n','whitespace','');

% �󒲎���`�t�@�C���̓ǂݍ���
for i=1:length(roomDefData)
    conma = strfind(roomDefData{i},',');
    for j = 1:length(conma)
        if j == 1
            roomDefDataCell{i,j} = roomDefData{i}(1:conma(j)-1);
        elseif j == length(conma)
            roomDefDataCell{i,j}   = roomDefData{i}(conma(j-1)+1:conma(j)-1);
            roomDefDataCell{i,j+1} = roomDefData{i}(conma(j)+1:end);
        else
            roomDefDataCell{i,j} = roomDefData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���̔��o(�܂��͒P���ɔ����o���B�󔒍s�͒���̏����R�s�[����)
ahuZoneName = {};
ahuZoneType = {};
ahuZoneFH   = [];
ahuZoneRH   = [];
ahuZoneArea = [];
ahuZoneQroom = {};
ahuZoneQoa   = {};

roomFloor = {};
roomName  = {};

count = 0;
for iRoom = 11:size(roomDefDataCell,1)
    
    % �󗓂̏ꍇ�́A������R�s�[(���̓���)
    if isempty(roomDefDataCell{iRoom,8}) && isempty(roomDefDataCell{iRoom,9})
        if iRoom == 11
            error('�󒲎���`�F��ԍŏ��̋󒲃]�[�����󔒂ł�')
        else
            roomFloor{count,end+1} = roomDefDataCell{iRoom,1};
            roomName{count,end+1}  = roomDefDataCell{iRoom,2};
        end
    else
        
        count = count + 1;
        
        % �󒲃]�[���� (�K��_����)
        eval(['tmpname = ''',roomDefDataCell{iRoom,8},'_',roomDefDataCell{iRoom,9},''';'])
        ahuZoneName  = [ahuZoneName;tmpname];
        
        % �����ׂ���������󒲋@
        ahuZoneQroom = [ahuZoneQroom; roomDefDataCell{iRoom,12}];
        % �O�C���ׂ���������󒲋@
        ahuZoneQoa   = [ahuZoneQoa; roomDefDataCell{iRoom,13}];
        
        roomFloor{count,1} = roomDefDataCell{iRoom,1};
        roomName{count,1}  = roomDefDataCell{iRoom,2};
        
    end
end

% XML�t�@�C������
for iZone = 1:size(ahuZoneName,1)
    
    % ID
    eval(['xmldata.AirConditioningSystem.AirConditioningRoom(iZone).ATTRIBUTE.ID  = ''Zone',int2str(iZone),''';'])
    
    tmpIDs = {};
    for iROOM = 1:length(roomName(iZone,:))
        if isempty(roomName{iZone,iROOM}) == 0
            tmpID = mytfunc_roomsearch(xmldata,roomFloor{iZone,iROOM},roomName{iZone,iROOM});
            if isempty(tmpIDs)
                tmpIDs = tmpID;
            else
                tmpIDs = strcat(tmpIDs,',',tmpID);
            end
        end
    end
    xmldata.AirConditioningSystem.AirConditioningRoom(iZone).ATTRIBUTE.RoomIDs         = tmpIDs;
    
    % �O��ID�i�]�[����������j
    xmldata.AirConditioningSystem.AirConditioningRoom(iZone).ATTRIBUTE.EnvelopeID  = ahuZoneName{iZone};
    
    % �󒲋@�Q�Ɓi�������׏����p�j
    xmldata.AirConditioningSystem.AirConditioningRoom(iZone).AirHandlingUnitRef(1).ATTRIBUTE.Load = 'Room';
    xmldata.AirConditioningSystem.AirConditioningRoom(iZone).AirHandlingUnitRef(1).ATTRIBUTE.ID = ahuZoneQroom(iZone);
    % �󒲋@�Q�Ɓi�O�C�����p�j
    xmldata.AirConditioningSystem.AirConditioningRoom(iZone).AirHandlingUnitRef(2).ATTRIBUTE.Load = 'OutsideAir';
    xmldata.AirConditioningSystem.AirConditioningRoom(iZone).AirHandlingUnitRef(2).ATTRIBUTE.ID = ahuZoneQoa(iZone);
    
end

