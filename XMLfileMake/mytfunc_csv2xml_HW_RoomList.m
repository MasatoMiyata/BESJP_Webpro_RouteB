% mytfunc_csv2xml_HW_UnitList.m
%                                             by Masato Miyata 2012/08/24
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_HW_RoomList(xmldata,filename)

% �������Ɋւ�����
hwRoomInfoCell = mytfunc_CSVfile2Cell(filename);
% 
% hwRoomInfoCSV = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% hwRoomInfoCell = {};
% for i=1:length(hwRoomInfoCSV)
%     conma = strfind(hwRoomInfoCSV{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             hwRoomInfoCell{i,j} = hwRoomInfoCSV{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             hwRoomInfoCell{i,j}   = hwRoomInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%             hwRoomInfoCell{i,j+1} = hwRoomInfoCSV{i}(conma(j)+1:end);
%         else
%             hwRoomInfoCell{i,j} = hwRoomInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end

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
    
    if isempty(hwRoomInfoCell{iUNIT,8}) == 0
        
        % ������
        roomFloor = [roomFloor; hwRoomInfoCell(iUNIT,1)];
        roomName  = [roomName; hwRoomInfoCell(iUNIT,2)];
        
        % �����ӏ�
        if isempty(hwRoomInfoCell{iUNIT,6}) == 0
            equipLocation = [equipLocation; hwRoomInfoCell(iUNIT,6)];
        else
            equipLocation = [equipLocation; 'Null'];
        end
        
        % �ߓ����̗L��
        if isempty(hwRoomInfoCell{iUNIT,7}) == 0
            if strcmp(hwRoomInfoCell(iUNIT,7),'����������')
                equipWaterSaving = [equipWaterSaving; 'MixingTap'];
            elseif strcmp(hwRoomInfoCell(iUNIT,7),'�ߓ�B1')
                equipWaterSaving = [equipWaterSaving; 'B1'];
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
end

% �������ɕ��ёւ�
RoomList = {};
UnitNameList = {};
UnitLocationList = {};
UnitWSList = {};

for iUNIT = 1:size(roomName,1)
    
    if isempty(RoomList)
        
        RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT)];
        UnitNameList = [UnitNameList; equipSet(iUNIT)];
        UnitLocationList = [UnitLocationList; equipLocation(iUNIT)];
        UnitWSList = [UnitWSList; equipWaterSaving(iUNIT)];
        
    else
        check = 0;
        for iDB = 1:size(RoomList,1)
            if strcmp(RoomList(iDB,1),roomFloor(iUNIT)) && ...
                    strcmp(RoomList(iDB,2),roomName(iUNIT))
                check = 1;
                
                UnitNameList{iDB} = [UnitNameList{iDB}, equipSet(iUNIT)];
                UnitLocationList{iDB} = [UnitLocationList{iDB}, equipLocation(iUNIT)];
                UnitWSList{iDB} = [UnitWSList{iDB}, equipWaterSaving(iUNIT)];
            end
        end
        
        % ����������Ȃ���Βǉ�
        if check == 0
            RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT)];
            UnitNameList = [UnitNameList; equipSet(iUNIT)];
            UnitLocationList = [UnitLocationList; equipLocation(iUNIT)];
            UnitWSList = [UnitWSList; equipWaterSaving(iUNIT)];
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
    if iscell(UnitNameList{iROOM}) == 1
        unitNum = length(UnitNameList{iROOM});
    else
        unitNum = 1;
    end
       
    for iUNIT = 1:unitNum
        
        if unitNum == 1
            tmpUnitID = UnitNameList(iROOM,1);
            tmpUnitLO = UnitLocationList(iROOM,1);
            tmpUnitWS = UnitWSList(iROOM,1);
        else
            tmpUnitID = UnitNameList{iROOM}(iUNIT);
            tmpUnitLO = UnitLocationList{iROOM}(iUNIT);
            tmpUnitWS = UnitWSList{iROOM}(iUNIT);
        end
        
        xmldata.HotwaterSystems.HotwaterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.Name        = tmpUnitID;  % �@�햼��
        xmldata.HotwaterSystems.HotwaterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.Location    = tmpUnitLO;  % �ݒu�ꏊ
        xmldata.HotwaterSystems.HotwaterRoom(iROOM).BoilerRef(iUNIT).ATTRIBUTE.WaterSaving = tmpUnitWS;  % �ߐ����
    end
    
end



