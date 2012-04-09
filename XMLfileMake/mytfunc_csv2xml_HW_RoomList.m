% mytfunc_csv2xml_HW_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_HW_RoomList(xmldata,filename)

% �������Ɋւ�����
hwRoomInfoCSV = textread(filename,'%s','delimiter','\n','whitespace','');

hwRoomInfoCell = {};
for i=1:length(hwRoomInfoCSV)
    conma = strfind(hwRoomInfoCSV{i},',');
    for j = 1:length(conma)
        if j == 1
            hwRoomInfoCell{i,j} = hwRoomInfoCSV{i}(1:conma(j)-1);
        elseif j == length(conma)
            hwRoomInfoCell{i,j}   = hwRoomInfoCSV{i}(conma(j-1)+1:conma(j)-1);
            hwRoomInfoCell{i,j+1} = hwRoomInfoCSV{i}(conma(j)+1:end);
        else
            hwRoomInfoCell{i,j} = hwRoomInfoCSV{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

roomFloor = {};
roomName  = {};
equipWaterSaving = {};
equipList = {};

for iUNIT = 11:size(hwRoomInfoCell,1)
    
    % ������
    roomFloor = [roomFloor; hwRoomInfoCell(iUNIT,1)];
    roomName  = [roomName; hwRoomInfoCell(iUNIT,2)];
    
    % �ߓ����̗L��
    if isempty(hwRoomInfoCell(iUNIT,6)) == 0
        equipWaterSaving = [equipWaterSaving; 'MixingTap'];
    else
        equipWaterSaving = [equipWaterSaving; 'None'];
    end
    
    % �ڑ��@�탊�X�g
    tmpHWequip = {};
    for iEQP = 1:length(hwRoomInfoCell(iUNIT,:))-7
        if isempty(hwRoomInfoCell{iUNIT,7+iEQP}) == 0
            tmpHWequip = [tmpHWequip,hwRoomInfoCell(iUNIT,7+iEQP)];
        else
            tmpHWequip = [tmpHWequip,'Null'];
        end
    end
    equipList(iUNIT-10,:) =  tmpHWequip;
end


% XML�t�@�C������
for iUNIT = 1:size(roomName,1)
    
    eval(['xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.ID = ''HWroom_',int2str(iUNIT),''';'])
    
    [RoomID,BldgType,RoomType,RoomArea,~,~,~,~] = ...
        mytfunc_roomIDsearch(xmldata,roomFloor{iUNIT},roomName{iUNIT});
    
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.RoomIDs      = RoomID;
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.RoomFloor    = roomFloor{iUNIT};
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.RoomName     = roomName{iUNIT};
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.BuildingType = BldgType;
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.RoomType     = RoomType;
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.RoomArea     = RoomArea;
    
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.WaterSaving = equipWaterSaving{iUNIT};
    
    for iEQP = 1:length(equipList(iUNIT,:))
        if strcmp(equipList(iUNIT,iEQP),'Null') == 0
            xmldata.HotwaterSystems.HotwarterRoom(iUNIT).BoilerRef(iEQP).ATTRIBUTE.ID = equipList(iUNIT,iEQP);
        end
    end
    
end



