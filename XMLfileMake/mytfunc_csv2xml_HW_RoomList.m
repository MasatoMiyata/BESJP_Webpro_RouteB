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

% �������󔒂ł���΁A�ЂƂ�̏��𖄂߂�B
for iUNIT = 11:size(hwRoomInfoCell,1)
    if isempty(hwRoomInfoCell{iUNIT,2})
        if iUNIT ~= 1
            hwRoomInfoCell(iUNIT,1) = hwRoomInfoCell(iUNIT-1,1);
            hwRoomInfoCell(iUNIT,2) = hwRoomInfoCell(iUNIT-1,2);
            hwRoomInfoCell(iUNIT,3) = hwRoomInfoCell(iUNIT-1,3);
            hwRoomInfoCell(iUNIT,4) = hwRoomInfoCell(iUNIT-1,4);
            hwRoomInfoCell(iUNIT,5) = hwRoomInfoCell(iUNIT-1,5);
            hwRoomInfoCell(iUNIT,6) = hwRoomInfoCell(iUNIT-1,6);
        else
            error('��߂̎������󔒂ł��B')
        end
    end
end

roomFloor = {};
roomName  = {};
equipWaterSaving = {};
equipSet = {};

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
    equipSet = [equipSet;hwRoomInfoCell(iUNIT,7)];
    
%     tmpHWequip = {};
%     for iEQP = 1:length(hwRoomInfoCell(iUNIT,:))-6
%         if isempty(hwRoomInfoCell{iUNIT,6+iEQP}) == 0
%             tmpHWequip = [tmpHWequip,hwRoomInfoCell(iUNIT,6+iEQP)];
%         else
%             tmpHWequip = [tmpHWequip,'Null'];
%         end
%     end
%     equipList(iUNIT-10,:) =  tmpHWequip;
end


% �������ɕ��ёւ�
RoomList = {};
UnitList = {};

for iUNIT = 1:size(roomName,1)
    
    if isempty(RoomList)== 1
        
        RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT),equipWaterSaving(iUNIT)];
        UnitList = [UnitList; equipSet(iUNIT)];

    else
        check = 0;
        for iDB = 1:size(RoomList,1)
            if strcmp(RoomList(iDB,1),roomFloor(iUNIT)) && ...
                    strcmp(RoomList(iDB,2),roomName(iUNIT))
                check = 1;
                UnitList{iDB} = [UnitList{iDB}, equipSet(iUNIT)];
            end
        end
        
        % ����������Ȃ���Βǉ�
        if check == 0
            RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT),equipWaterSaving(iUNIT)];
            UnitList = [UnitList; equipSet(iUNIT)];
        end
        
    end
end


% XML�t�@�C������

numOfRoom = size(RoomList,1);

for iROOM = 1:numOfRoom
    
    eval(['xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.ID = ''HWroom_',int2str(iROOM),''';'])
    
    [RoomID,BldgType,RoomType,RoomArea,~,~,~,~] = ...
        mytfunc_roomIDsearch(xmldata,RoomList(iROOM,1),RoomList(iROOM,2));
    
    xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.RoomIDs      = RoomID;
    xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.RoomFloor    = RoomList(iROOM,1);
    xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.RoomName     = RoomList(iROOM,2);
    xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.BuildingType = BldgType;
    xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.RoomType     = RoomType;
    xmldata.HotwaterSystems.HotwarterRoom(iROOM).ATTRIBUTE.RoomArea     = RoomArea;
    xmldata.HotwaterSystems.HotwarterRoom(iUNIT).ATTRIBUTE.WaterSaving  = RoomList(iROOM,3);
    
    % ���j�b�g���
    if iscell(UnitList{iROOM}) == 1
        unitNum = length(UnitList{iROOM});
    else
        unitNum = 1;
    end
    
    for iUNIT = 1:unitNum
        
        if unitNum == 1
            tmpUnitID = UnitList(iROOM);
        else
            tmpUnitID = UnitList{iROOM}(iUNIT);
        end
        
        xmldata.HotwaterSystems.HotwarterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.ID = tmpUnitID;
    end
    
end



