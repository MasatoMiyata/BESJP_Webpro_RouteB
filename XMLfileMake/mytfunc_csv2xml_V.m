% mytfunc_csv2xml_Vfan_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
% ���́F
%  xmldata     : xml�f�[�^
%  filenameRoom : ���C�i���j�̎Z��V�[�g(CSV)�t�@�C����
%  filenameFAN : ���C�i�����@�j�̎Z��V�[�g(CSV)�t�@�C����
%  filenameAC  : ���C�i��[�j�̎Z��V�[�g(CSV)�t�@�C����
% �o�́F
%  xmldata  : xml�f�[�^
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_V(xmldata,filenameRoom,filenameFAN,filenameAC)

% CSV�t�@�C���̓ǂݍ���
roomData  = textread(filenameRoom,'%s','delimiter','\n','whitespace','');
venData   = textread(filenameFAN,'%s','delimiter','\n','whitespace','');
venACData = textread(filenameAC,'%s','delimiter','\n','whitespace','');

% ���C�i���j��`�t�@�C���̓ǂݍ���
for i=1:length(roomData)
    conma = strfind(roomData{i},',');
    for j = 1:length(conma)
        if j == 1
            roomDataCell{i,j} = roomData{i}(1:conma(j)-1);
        elseif j == length(conma)
            roomDataCell{i,j}   = roomData{i}(conma(j-1)+1:conma(j)-1);
            roomDataCell{i,j+1} = roomData{i}(conma(j)+1:end);
        else
            roomDataCell{i,j} = roomData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���C�i�����@�j��`�t�@�C���̓ǂݍ���
for i=1:length(venData)
    conma = strfind(venData{i},',');
    for j = 1:length(conma)
        if j == 1
            venDataCell{i,j} = venData{i}(1:conma(j)-1);
        elseif j == length(conma)
            venDataCell{i,j}   = venData{i}(conma(j-1)+1:conma(j)-1);
            venDataCell{i,j+1} = venData{i}(conma(j)+1:end);
        else
            venDataCell{i,j} = venData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���C�i�󒲋@�j��`�t�@�C���̓ǂݍ���
for i=1:length(venACData)
    conma = strfind(venACData{i},',');
    for j = 1:length(conma)
        if j == 1
            venACDataCell{i,j} = venACData{i}(1:conma(j)-1);
        elseif j == length(conma)
            venACDataCell{i,j}   = venACData{i}(conma(j-1)+1:conma(j)-1);
            venACDataCell{i,j+1} = venACData{i}(conma(j)+1:end);
        else
            venACDataCell{i,j} = venACData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%% ���C�i���j�̏���
roomFloor = {};
roomName  = {};
unitType  = {};
unitName  = {};

% �󔒃Z���𖄂߂�
for iUNIT = 11:size(roomDataCell,1)
    
    if isempty(roomDataCell{iUNIT,2}) == 0
        roomFloor = [roomFloor; roomDataCell{iUNIT,1}];
        roomName  = [roomName; roomDataCell{iUNIT,2}];
        
        if strcmp(roomDataCell{iUNIT,6},'���C')
            unitType  = [unitType; 'Supply'];
        elseif strcmp(roomDataCell{iUNIT,6},'�r�C')
            unitType  = [unitType; 'Exist'];
        elseif strcmp(roomDataCell{iUNIT,6},'�z��')
            unitType  = [unitType; 'Circulation'];
        elseif strcmp(roomDataCell{iUNIT,6},'��[')
            unitType  = [unitType; 'AC'];
        else
            unitType  = [unitType; 'Null'];
        end
        
        unitName  = [unitName; roomDataCell{iUNIT,7}];
    else
        if iUNIT > 11
            roomFloor = [roomFloor; roomFloor(end)];
            roomName  = [roomName; roomName(end)];
            
            if isempty(roomDataCell{iUNIT,6})
                unitType  = [unitType; 'Null'];
            else
                if strcmp(roomDataCell{iUNIT,6},'���C')
                    unitType  = [unitType; 'Supply'];
                elseif strcmp(roomDataCell{iUNIT,6},'�r�C')
                    unitType  = [unitType; 'Exist'];
                elseif strcmp(roomDataCell{iUNIT,6},'�z��')
                    unitType  = [unitType; 'Circulation'];
                elseif strcmp(roomDataCell{iUNIT,6},'��[')
                    unitType  = [unitType; 'AC'];
                else
                    unitType  = [unitType; 'Null'];
                end
            end
            if isempty(roomDataCell{iUNIT,7})
                unitName  = [unitName; 'Null'];
            else
                unitName  = [unitName; roomDataCell{iUNIT,7}];
            end
            
        else
            error('1�s�ڂ͕K����������͂��Ă��������B')
        end
    end
    
end

% �����X�g�쐬
RoomList = {};
UnitList = {};
UnitTypeList = {};

for iUNIT = 1:length(roomName)

    if isempty(RoomList) == 1
        RoomList     = [RoomList; roomFloor(iUNIT),roomName(iUNIT)];
        UnitTypeList = [UnitTypeList; unitType(iUNIT)];
        UnitList     = [UnitList; unitName(iUNIT)];
    else
        check = 0;
        for iDB = 1:size(RoomList,1)
            if strcmp(RoomList(iDB,1),roomFloor(iUNIT)) &&...
                    strcmp(RoomList(iDB,2),roomName(iUNIT))
                check = 1;
                UnitTypeList{iDB} = [UnitTypeList{iDB}, unitType(iUNIT)];
                UnitList{iDB}     = [UnitList{iDB}, unitName(iUNIT)];
            end
        end
        
        % ����������Ȃ���Βǉ�
        if check == 0
            RoomList     = [RoomList; roomFloor(iUNIT),roomName(iUNIT)];
            UnitTypeList = [UnitTypeList; unitType(iUNIT)];
            UnitList     = [UnitList; unitName(iUNIT)];
        end
        
    end
end


%% ���C�i�����@�j�̏���

venUnitID   = {};
venUnitName = {};
venUnitType = {};
venVolume   = {};
venPower    = {};
venControlFlag_C1 = {};
venControlFlag_C2 = {};
venControlFlag_C3 = {};

numRoom = (size(venDataCell,2)-9)/2;

for iUNIT = 11:size(venDataCell,1)
    
    eval(['venUnitID = [venUnitID; ''VfanUnit_',int2str(iUNIT-10),'''];'])
    
    % ����
    if isempty(venDataCell{iUNIT,1})
        venUnitName  = [venUnitName;'Null'];
    else
        venUnitName  = [venUnitName;venDataCell{iUNIT,1}];
    end
    
    % ����
    if isempty(venDataCell{iUNIT,2})
        venVolume  = [venVolume;'Null'];
    else
        venVolume  = [venVolume;venDataCell{iUNIT,2}];
    end
    
    % ����d��
    venPower = [venPower;venDataCell{iUNIT,3}];
    
    % �������d���@�̗p
    if strcmp(venDataCell{iUNIT,4},'�L')
        venControlFlag_C1 = [venControlFlag_C1;'True'];
    else
        venControlFlag_C1 = [venControlFlag_C1;'None'];
    end
    
    % �C���o�[�^�̗p
    if strcmp(venDataCell{iUNIT,5},'�L')
        venControlFlag_C2 = [venControlFlag_C2;'True'];
    else
        venControlFlag_C2 = [venControlFlag_C2;'None'];
    end
    
    % �����ʐ���
    if strcmp(venDataCell{iUNIT,6},'CO�Z�x����')
        venControlFlag_C3 = [venControlFlag_C3;'COconcentration'];
    elseif strcmp(venDataCell{iUNIT,6},'���x����')
        venControlFlag_C3 = [venControlFlag_C3;'Temprature'];
    else
        venControlFlag_C3 = [venControlFlag_C3;'None'];
    end

end


%% ���C�i�󒲋@�j�̏���

% ���̔��o
venACUnitID   = {};
venACUnitName = {};
venACCoolingCapacity = {};
venACCOP        = {};
venACFanPower   = {};
venACPumpPower  = {};
roomFloorAC = {};
roomNameAC  = {};

numRoomAC = (size(venACDataCell,2)-7)/2;

for iUNIT = 11:size(venACDataCell,1)
    
    eval(['venACUnitID = [venACUnitID; ''VacUnit_',int2str(iUNIT-10),'''];'])
    
    % ����
    if isempty(venACDataCell{iUNIT,1})
        venACUnitName  = [venACUnitName;'Null'];
    else
        venACUnitName  = [venACUnitName;venACDataCell{iUNIT,1}];
    end
    
    % ��p�\��
    if isempty(venACDataCell{iUNIT,2})
        venACCoolingCapacity  = [venACCoolingCapacity;'Null'];
    else
        venACCoolingCapacity  = [venACCoolingCapacity;venACDataCell{iUNIT,2}];
    end
    
    % COP
    if isempty(venACDataCell{iUNIT,3})
        venACCOP  = [venACCOP;'Null'];
    else
        venACCOP  = [venACCOP;venACDataCell{iUNIT,3}];
    end
    
    % �����@����
    if isempty(venACDataCell{iUNIT,4})
        venACFanPower  = [venACFanPower;'0'];
    else
        venACFanPower  = [venACFanPower;venACDataCell{iUNIT,4}];
    end
    
    % �|���v����
    if isempty(venACDataCell{iUNIT,5})
        venACPumpPower  = [venACPumpPower;'0'];
    else
        venACPumpPower  = [venACPumpPower;venACDataCell{iUNIT,5}];
    end    

end



%% XML�t�@�C������
for iROOM = 1:size(RoomList,1)
    
    % ��������
    [RoomID,BldgType,RoomType,RoomArea,~,~] = ...
        mytfunc_roomIDsearch(xmldata,RoomList{iROOM,1},RoomList{iROOM,2});
    
    % ���̑������i�[
    xmldata.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomIDs      = RoomID;
    xmldata.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomFloor    = RoomList{iROOM,1};
    xmldata.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomName     = RoomList{iROOM,2};
    xmldata.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.BuildingType = BldgType;
    xmldata.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomType     = RoomType;
    xmldata.VentilationSystems.VentilationRoom(iROOM).ATTRIBUTE.RoomArea     = RoomArea;
    
    % ���j�b�g�����J�E���g
    if iscell(UnitList{iROOM}) == 1
        unitNum = length(UnitList{iROOM});
    else
        unitNum = 1;
    end
    
    Fcount = 0;
    Acount = 0;
    
    for iUNIT = 1:unitNum
        if unitNum == 1
            tmpUnitID   = UnitList(iROOM);
            tmpUnitType = UnitTypeList(iROOM);
        else
            tmpUnitID = UnitList{iROOM}(iUNIT);
            tmpUnitType = UnitTypeList{iROOM}(iUNIT);
        end
        
        % ���j�b�g�̏�������
        check = 0;
        for iDB = 1:length(venUnitName)
            if strcmp(venUnitName(iDB),tmpUnitID)
                
                check = 1;
                Fcount = Fcount + 1;
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.ID              = venUnitID{iDB};
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.UnitName        = venUnitName{iDB};
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.UnitType        = tmpUnitType;
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.FanVolume       = venVolume{iDB};
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.FanPower        = venPower{iDB};
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.ControlFlag_C1  = venControlFlag_C1{iDB};
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.ControlFlag_C2  = venControlFlag_C2{iDB};
                xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationFANUnit(Fcount).ATTRIBUTE.ControlFlag_C3  = venControlFlag_C3{iDB};
                
            end
        end
        if check == 0
            for iDB = 1:length(venACUnitName)
                if strcmp(venACUnitName(iDB),tmpUnitID)
                    
                    check = 1;
                    Acount = Acount + 1;
                    xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(Acount).ATTRIBUTE.ID               = venACUnitID{iDB};
                    xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(Acount).ATTRIBUTE.UnitName         = venACUnitName{iDB};
                    xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(Acount).ATTRIBUTE.CoolingCapacity  = venACCoolingCapacity{iDB};
                    xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(Acount).ATTRIBUTE.COP              = venACCOP{iDB};
                    xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(Acount).ATTRIBUTE.FanPower         = venACFanPower{iDB};
                    xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationACUnit(Acount).ATTRIBUTE.PumpPower        = venACPumpPower{iDB};

                end
            end

            if check == 0
                error('���j�b�g %s ��������܂���', tmpUnitID)
            end
        end
    end
end

