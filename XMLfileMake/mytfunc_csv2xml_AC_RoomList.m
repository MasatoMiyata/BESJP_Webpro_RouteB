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

% �������󔒂ł���Β��O�̎��������R�s�[����B
for iROOM = 11:size(roomDefDataCell,1)
    if isempty(roomDefDataCell{iROOM,10})
        if iROOM == 11
            error('��߂̎������󔒂ł��B')
        else
            roomDefDataCell(iROOM, 9) = roomDefDataCell(iROOM-1,9);
            roomDefDataCell(iROOM,10) = roomDefDataCell(iROOM-1,10);
            roomDefDataCell(iROOM,11) = roomDefDataCell(iROOM-1,11);
            roomDefDataCell(iROOM,12) = roomDefDataCell(iROOM-1,12);
        end
    end
end

    

% �󒲃]�[�����X�g�̍쐬
ZoneList_Floor = {};
ZoneList_Name  = {};
ZoneList_AHUR  = {};
ZoneList_AHUO  = {};

for iROOM = 11:size(roomDefDataCell,1)
    
    if isempty(ZoneList_Name)
        
        if isempty(roomDefDataCell{iROOM,9}) == 0
            ZoneList_Floor = roomDefDataCell(iROOM,9);
        else
            ZoneList_Floor = 'Null';
        end
        
        ZoneList_Name  = roomDefDataCell(iROOM,10);
        
        if isempty(roomDefDataCell{iROOM,11}) == 0
            ZoneList_AHUR  = roomDefDataCell(iROOM,11);
        else
            ZoneList_AHUR  = 'Null';
        end
        
        if isempty(roomDefDataCell{iROOM,12}) == 0
            ZoneList_AHUO  = roomDefDataCell(iROOM,12);
        else
            ZoneList_AHUO  = 'Null';
        end
        
    else
        
        check = 0;
        
        for iDB = 1:length(ZoneList_Name)
            if strcmp(ZoneList_Floor(iDB),roomDefDataCell(iROOM,9)) && ...
                    strcmp(ZoneList_Name(iDB),roomDefDataCell(iROOM,10))
                % �d������
                check = 1;
            end
        end
        
        if check == 0
            % �]�[�����ǉ�
            if isempty(roomDefDataCell{iROOM,9}) == 0 
                ZoneList_Floor = [ZoneList_Floor; roomDefDataCell(iROOM,9)];
            else
                ZoneList_Floor = [ZoneList_Floor; 'Null'];
            end
            
            ZoneList_Name  = [ZoneList_Name; roomDefDataCell(iROOM,10)];
            
            if isempty(roomDefDataCell{iROOM,11}) == 0
                ZoneList_AHUR  = [ZoneList_AHUR; roomDefDataCell(iROOM,11)];
            else
                ZoneList_AHUR  = [ZoneList_AHUR; 'Null'];
            end
            
            if isempty(roomDefDataCell{iROOM,12}) == 0
                ZoneList_AHUO  = [ZoneList_AHUO; roomDefDataCell(iROOM,12)];
            else
                ZoneList_AHUO  = [ZoneList_AHUO; 'Null'];
            end
        end
    end
end

% XML�Ɋi�[
for iZONE = 1:length(ZoneList_Name)
    
    eval(['xmldata.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ID = ''Z',int2str(iZONE),''';'])
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ACZoneFloor = ZoneList_Floor(iZONE);
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ACZoneName  = ZoneList_Name(iZONE);
    
    % �󒲋@�Q�Ɓi�������׏����p�j
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(1).ATTRIBUTE.Load = 'Room';
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(1).ATTRIBUTE.ID = ZoneList_AHUR(iZONE);
    
    % �󒲋@�Q�Ɓi�O�C�����p�j
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(2).ATTRIBUTE.Load = 'OutsideAir';
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(2).ATTRIBUTE.ID = ZoneList_AHUO(iZONE);
    
    Rcount = 0;
    for iDB = 11:size(roomDefDataCell,1)
        if  strcmp(roomDefDataCell(iDB,9),ZoneList_Floor(iZONE)) && ...
                strcmp(roomDefDataCell(iDB,10),ZoneList_Name(iZONE))
            
            % ��������
            [RoomID,BldgType,RoomType,RoomArea,FloorHeight,RoomHeight,~,~] = ...
                mytfunc_roomIDsearch(xmldata,roomDefDataCell(iDB,1),roomDefDataCell(iDB,2));
            
            Rcount = Rcount + 1;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.ID           = RoomID;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomFloor    = roomDefDataCell(iDB,1);
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomName     = roomDefDataCell(iDB,2);
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.BuildingType = BldgType;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomType     = RoomType;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.FloorHeight  = FloorHeight;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomHeight   = RoomHeight;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomArea     = RoomArea;

        end        
    end
end

