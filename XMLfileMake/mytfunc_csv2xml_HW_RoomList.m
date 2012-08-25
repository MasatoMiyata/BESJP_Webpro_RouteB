% mytfunc_csv2xml_HW_UnitList.m
%                                             by Masato Miyata 2012/08/24
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
            hwRoomInfoCell(iUNIT,1:5) = hwRoomInfoCell(iUNIT-1,1:5);
        else
            error('��߂̎������󔒂ł��B')
        end
    end
end


%% ���̒��o

roomFloor = {};
roomName  = {};
equipWaterSaving = {};
equipSet = {};
equipLocation = {};

for iUNIT = 11:size(hwRoomInfoCell,1)
    
    % ������
    roomFloor = [roomFloor; hwRoomInfoCell(iUNIT,1)];
    roomName  = [roomName; hwRoomInfoCell(iUNIT,2)];
    
    % �����ӏ�
    equipLocation = [equipLocation; hwRoomInfoCell(iUNIT,6)];
    
    % �ߓ����̗L��
    if isempty(hwRoomInfoCell{iUNIT,7}) == 0
        if strcmp(hwRoomInfoCell(iUNIT,7),'����������')
            equipWaterSaving = [equipWaterSaving; 'MixingTap'];
        elseif strcmp(hwRoomInfoCell(iUNIT,7),'�ߓ��^�V�����[')
            equipWaterSaving = [equipWaterSaving; 'WaterSavingShowerHead'];
        elseif strcmp(hwRoomInfoCell(iUNIT,7),'��')
            equipWaterSaving = [equipWaterSaving; 'None'];
        else
            error('�ߓ����̑I�������s���ł�')
        end
    else
        equipWaterSaving = [equipWaterSaving; 'None'];
    end
    
    % �ڑ��@�탊�X�g
    equipSet = [equipSet;hwRoomInfoCell(iUNIT,8)];
    
end

% �������ɕ��ёւ�
RoomList = {};
UnitList = {};

for iUNIT = 1:size(roomName,1)
    
    if isempty(RoomList)
        
        RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT)];
        UnitList = [UnitList; equipSet(iUNIT),equipLocation(iUNIT),equipWaterSaving(iUNIT)];

    else
        check = 0;
        for iDB = 1:size(RoomList,1)
            if strcmp(RoomList(iDB,1),roomFloor(iUNIT)) && ...
                    strcmp(RoomList(iDB,2),roomName(iUNIT))
                check = 1;
                UnitList{iDB} = [UnitList{iDB}, equipSet(iUNIT),equipLocation(iUNIT),equipWaterSaving(iUNIT)];
            end
        end
        
        % ����������Ȃ���Βǉ�
        if check == 0
            RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT)];
            UnitList = [UnitList; equipSet(iUNIT),equipLocation(iUNIT),equipWaterSaving(iUNIT)];
        end
        
    end
end

% XML�t�@�C������

numOfRoom = size(RoomList,1);

for iROOM = 1:numOfRoom
        
    [RoomID,BldgType,RoomType,RoomArea,~,~] = ...
        mytfunc_roomIDsearch(xmldata,RoomList(iROOM,1),RoomList(iROOM,2));
    
    xmldata.HotwaterSystems.HotwaterRoom(iROOM).ATTRIBUTE.RoomIDs      = RoomID;
    xmldata.HotwaterSystems.HotwaterRoom(iROOM).ATTRIBUTE.RoomFloor    = RoomList(iROOM,1);
    xmldata.HotwaterSystems.HotwaterRoom(iROOM).ATTRIBUTE.RoomName     = RoomList(iROOM,2);
    xmldata.HotwaterSystems.HotwaterRoom(iROOM).ATTRIBUTE.BuildingType = BldgType;
    xmldata.HotwaterSystems.HotwaterRoom(iROOM).ATTRIBUTE.RoomType     = RoomType;
    xmldata.HotwaterSystems.HotwaterRoom(iROOM).ATTRIBUTE.RoomArea     = RoomArea;
    
    % ���j�b�g���
    if iscell(UnitList{iROOM}) == 1
        unitNum = length(UnitList{iROOM});
    else
        unitNum = 1;
    end
    
    for iUNIT = 1:unitNum
        
        if unitNum == 1
            tmpUnitID = UnitList(iROOM,1);
            tmpUnitLO = UnitList(iROOM,2);
            tmpUnitWS = UnitList(iROOM,3);
        else
            tmpUnitID = UnitList{iROOM}(iUNIT,1);
            tmpUnitLO = UnitList{iROOM}(iUNIT,2);
            tmpUnitWS = UnitList{iROOM}(iUNIT,3);
        end
        
        xmldata.HotwaterSystems.HotwaterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.Name        = tmpUnitID;  % �@�햼��
        xmldata.HotwaterSystems.HotwaterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.Location    = tmpUnitLO;  % �ݒu�ꏊ
        xmldata.HotwaterSystems.HotwaterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.WaterSaving = tmpUnitWS;  % �ߐ����
    end
    
end



