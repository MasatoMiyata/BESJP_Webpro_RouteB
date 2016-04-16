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
    
    if isempty(roomDataCell{iUNIT,7}) == 0
        
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
                
                % ���C���
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
                
                % ���C�@�@����
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

venUnitName = {};
venVolume   = {};
venPower    = {};
venControlFlag_C1 = {};
venControlFlag_C2 = {};
venControlFlag_C3 = {};

for iUNIT = 11:size(venDataCell,1)
    
    if isempty(venDataCell{iUNIT,1}) == 0
        
        % ����
        venUnitName  = [venUnitName;venDataCell{iUNIT,1}];
        
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
    
end


%% ���C�i�󒲋@�j�̏���

% ���̔��o
venACUnitName = {};
venACroomType = {};  % 2016/4/13 �ǉ�
venACCoolingCapacity = {};
venACCOP        = {};
venACFanPower   = {};
venACPumpPower  = {};

ACnum = 0;

for iUNIT = 11:size(venACDataCell,1)
        
    if isempty(venACDataCell{iUNIT,1}) == 0
        
        ACnum = ACnum + 1;
        
        % ����
        venACUnitName{ACnum,1} = venACDataCell{iUNIT,1};
        
        % ���C�Ώێ��̗p�r
        if strcmp(venACDataCell{iUNIT,2},'�G���x�[�^�@�B��')
            venACroomType{ACnum,1} = 'elevator';
        elseif strcmp(venACDataCell{iUNIT,2},'�d�C��')
            venACroomType{ACnum,1} = 'powerRoom';
        elseif strcmp(venACDataCell{iUNIT,2},'�@�B��')
            venACroomType{ACnum,1} = 'machineRoom';
        else
            venACroomType{ACnum,1} = 'others';
        end
        
        % ��p�\��
        if isempty(venACDataCell{iUNIT,3})
            venACCoolingCapacity{ACnum,1}  = 'Null';
        else
            venACCoolingCapacity{ACnum,1}  = venACDataCell{iUNIT,3};
        end
        
        % COP
        if isempty(venACDataCell{iUNIT,4})
            venACCOP{ACnum,1}  = 'Null';
        else
            venACCOP{ACnum,1}  = venACDataCell{iUNIT,4};
        end
        
        % �|���v����
        if isempty(venACDataCell{iUNIT,5})
            venACPumpPower{ACnum,1}  = 'Null';
        else
            venACPumpPower{ACnum,1}  = venACDataCell{iUNIT,5};
        end
        
        
        % �t�@�������䂠�邩�𒲂ׂ�
        for iFan = 1 : size(venACDataCell,1)
            if iUNIT + iFan > size(venACDataCell,1) 
                break
            end
            if isempty(venACDataCell{iUNIT+iFan,1}) == 0
                break
            end
        end
        venACfanNUM(ACnum) = iFan;
        
        for iFan = 1:venACfanNUM(ACnum)
            
            % �����@ �� ���
            if strcmp(venACDataCell{iUNIT+iFan-1,6},'��')
                venACFanType{ACnum,iFan} = 'AC';
            elseif strcmp(venACDataCell{iUNIT+iFan-1,6},'���C')
                venACFanType{ACnum,iFan} = 'Supply';
            elseif strcmp(venACDataCell{iUNIT+iFan-1,6},'�r�C')
                venACFanType{ACnum,iFan} = 'Exist';
            elseif strcmp(venACDataCell{iUNIT+iFan-1,6},'�z��')
                venACFanType{ACnum,iFan} = 'Circulation';
            else
                venACFanType{ACnum,iFan} = 'Null';
            end
            
            % �����@ �� �݌v����
            if isempty(venACDataCell{iUNIT+iFan-1,7})
                venACFanVolume{ACnum,iFan} = 'Null';
            else
                venACFanVolume{ACnum,iFan} = venACDataCell{iUNIT+iFan-1,7};
            end
            
            % �����@ �� �d���@�o��
            if isempty(venACDataCell{iUNIT+iFan-1,8})
                venACFanPower{ACnum,iFan} = 'Null';
            else
                venACFanPower{ACnum,iFan} = venACDataCell{iUNIT+iFan-1,8};
            end
            
            % �����@ �� �������d���@�̗L��
            if strcmp(venACDataCell{iUNIT+iFan-1,9},'�L')
                venACFanControlFlag_C1{ACnum,iFan} = 'True';
            else
                venACFanControlFlag_C1{ACnum,iFan} = 'None';
            end
            
            % �����@ �� �C���o�[�^�̗L��
            if strcmp(venACDataCell{iUNIT+iFan-1,10},'�L')
                venACFanControlFlag_C2{ACnum,iFan} = 'True';
            else
                venACFanControlFlag_C2{ACnum,iFan} = 'None';
            end
            
            % �����@ �� �����ʐ���̗L��
            if strcmp(venACDataCell{iUNIT+iFan-1,11},'CO�Z�x����')
                venACFanControlFlag_C3{ACnum,iFan} = 'COconcentration';
            elseif strcmp(venACDataCell{iUNIT+iFan-1,11},'���x����')
                venACFanControlFlag_C3{ACnum,iFan} = 'Temprature';
            else
                venACFanControlFlag_C3{ACnum,iFan} = 'None';
            end
            
        end
        
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
    
    for iUNIT = 1:unitNum
        if unitNum == 1
            xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationUnitRef(iUNIT).ATTRIBUTE.Name       = UnitList(iROOM,1);
            xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationUnitRef(iUNIT).ATTRIBUTE.UnitType   = UnitTypeList(iROOM,1);
        else
            xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationUnitRef(iUNIT).ATTRIBUTE.Name       = UnitList{iROOM}(iUNIT);
            xmldata.VentilationSystems.VentilationRoom(iROOM).VentilationUnitRef(iUNIT).ATTRIBUTE.UnitType   = UnitTypeList{iROOM}(iUNIT);
        end
    end
    
end

% ���C�t�@��
for iUNIT = 1:length(venUnitName)
    
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.Name      = venUnitName(iUNIT);
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.FanVolume = venVolume(iUNIT);
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.FanPower  = venPower(iUNIT);
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ControlFlag_C1 = venControlFlag_C1(iUNIT);
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ControlFlag_C2 = venControlFlag_C2(iUNIT);
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ControlFlag_C3 = venControlFlag_C3(iUNIT);
    
end

% ���C��֋󒲋@
for iUNIT = 1:length(venACUnitName)
    
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.Name             = venACUnitName{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.roomType         = venACroomType{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.CoolingCapacity  = venACCoolingCapacity{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.COP              = venACCOP{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.PumpPower        = venACPumpPower{iUNIT};
    
    for iFan = 1:venACfanNUM(iUNIT)
        
        xmldata.VentilationSystems.VentilationACUnit(iUNIT).Fan(iFan).ATTRIBUTE.FanType = venACFanType{iUNIT,iFan};
        xmldata.VentilationSystems.VentilationACUnit(iUNIT).Fan(iFan).ATTRIBUTE.FanVolume = venACFanVolume{iUNIT,iFan};
        xmldata.VentilationSystems.VentilationACUnit(iUNIT).Fan(iFan).ATTRIBUTE.FanPower = venACFanPower{iUNIT,iFan};
        xmldata.VentilationSystems.VentilationACUnit(iUNIT).Fan(iFan).ATTRIBUTE.ControlFlag_C1 = venACFanControlFlag_C1{iUNIT,iFan};
        xmldata.VentilationSystems.VentilationACUnit(iUNIT).Fan(iFan).ATTRIBUTE.ControlFlag_C2 = venACFanControlFlag_C2{iUNIT,iFan};
        xmldata.VentilationSystems.VentilationACUnit(iUNIT).Fan(iFan).ATTRIBUTE.ControlFlag_C3 = venACFanControlFlag_C3{iUNIT,iFan};
        
    end
end










