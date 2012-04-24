% mytfunc_csv2xml_L.m
%                                             by Masato Miyata 2012/04/21
%------------------------------------------------------------------------
% �ȃG�l��F�Ɩ��ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
% ���́F
%  xmldata  : xml�f�[�^
%  filename : �Ɩ��̎Z��V�[�g(CSV)�t�@�C����
% �o�́F
%  xmldata  : xml�f�[�^
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_L(xmldata,filename)

% clear
% clc
% filename = '../InputFiles/�ȃG�l����[�gB_�Ɩ�_template.csv';
% inputfilename = 'routeB_XMLtemplate.xml';
% xmldata = xml_read(inputfilename);
% xmldata = mytfunc_csv2xml_CommonSetting(xmldata,'../InputFiles/�ȃG�l����[�gB_����_template.csv');


% CSV�t�@�C���̓ǂݍ���
LightData = textread(filename,'%s','delimiter','\n','whitespace','');

% �Ɩ���`�t�@�C���̓ǂݍ���
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
UnitID    = {};
LightRoomIndex = {};
LightUnitType = {};
LightUnitName = {};
LightPower = {};
LightCount = {};
LightControlFlag_C1 = {};
LightControlFlag_C2 = {};
LightControlFlag_C3 = {};
LightControlFlag_C4 = {};
LightControlFlag_C5 = {};

for iUNIT = 11:size(LightDataCell,1)
    
    % ���ID
    eval(['UnitID = [UnitID; ''LUnit_',int2str(iUNIT-10),'''];'])
    
    % �K���Ǝ���
    if isempty(LightDataCell{iUNIT,2})
        if iUNIT > 11
            roomFloor  = [roomFloor;roomFloor(end)];
            roomName   = [roomName;roomName(end)];
        else
            error('��߂̎������󔒂ł��B')
        end
    else
        roomFloor = [roomFloor;LightDataCell{iUNIT,1}];
        roomName  = [roomName;LightDataCell{iUNIT,2}];
    end
    
    % ���w��
    if isempty(LightDataCell{iUNIT,9})
        LightRoomIndex  = [LightRoomIndex;'Null'];
    else
        LightRoomIndex  = [LightRoomIndex;LightDataCell{iUNIT,9}];
    end
    
    % �Ɩ����`��
    if isempty(LightDataCell{iUNIT,10})
        LightUnitType   = [LightUnitType;'Null'];
    else
        LightUnitType   = [LightUnitType;LightDataCell{iUNIT,10}];
    end
    
    % �Ɩ�����
    if isempty(LightDataCell{iUNIT,11})
        LightUnitName   = [LightUnitName;'Null'];
    else
        LightUnitName   = [LightUnitName;LightDataCell(iUNIT,11)];
    end
    
    % ����d��
    LightPower = [LightPower;str2double(LightDataCell(iUNIT,12))];
    
    % �䐔
    LightCount = [LightCount;str2double(LightDataCell(iUNIT,13))];
    
    % �ݎ����m����
    if strcmp(LightDataCell(iUNIT,14),'����')
        LightControlFlag_C1 = [LightControlFlag_C1;'dimmer'];
    elseif strcmp(LightDataCell(iUNIT,14),'�ꊇ�_��')
        LightControlFlag_C1 = [LightControlFlag_C1;'onoff'];
    elseif strcmp(LightDataCell(iUNIT,14),'6.4m�p�_��')
        LightControlFlag_C1 = [LightControlFlag_C1;'sensing64'];
    elseif strcmp(LightDataCell(iUNIT,14),'3.2m�p�_�Łj')
        LightControlFlag_C1 = [LightControlFlag_C1;'sensing32'];
    elseif strcmp(LightDataCell(iUNIT,14),'���_��')
        LightControlFlag_C1 = [LightControlFlag_C1;'eachunit'];
    else
        LightControlFlag_C1 = [LightControlFlag_C1;'None'];
    end
    
    % �^�C���X�P�W���[������
    if strcmp(LightDataCell(iUNIT,15),'����')
        LightControlFlag_C2 = [LightControlFlag_C2;'dimmer'];
    elseif strcmp(LightDataCell(iUNIT,15),'����')
        LightControlFlag_C2 = [LightControlFlag_C2;'onoff'];
    else
        LightControlFlag_C2 = [LightControlFlag_C2;'None'];
    end
    
    % �����Ɠx�␳
    if strcmp(LightDataCell(iUNIT,16),'�^�C�}�[')
        LightControlFlag_C3 = [LightControlFlag_C3;'Timer'];
    elseif strcmp(LightDataCell(iUNIT,16),'���邳�Z���T�[')
        LightControlFlag_C3 = [LightControlFlag_C3;'Sensor'];
    else
        LightControlFlag_C3 = [LightControlFlag_C3;'None'];
    end
    
    % �������p����
    if strcmp(LightDataCell(iUNIT,17),'�Б��̌��A�u���C���h��������Ȃ�')
        LightControlFlag_C4 = [LightControlFlag_C4;'eachSideWithBlind'];
    elseif strcmp(LightDataCell(iUNIT,17),'�Б��̌��A�u���C���h�������䂠��')
        LightControlFlag_C4 = [LightControlFlag_C4;'eachSideWithoutBlind'];
    elseif strcmp(LightDataCell(iUNIT,17),'�����̌��A�u���C���h��������Ȃ�')
        LightControlFlag_C4 = [LightControlFlag_C4;'bothSidesWithBlind'];
    elseif strcmp(LightDataCell(iUNIT,17),'�����̌��A�u���C���h�������䂠��')
        LightControlFlag_C4 = [LightControlFlag_C4;'bothSidesWithoutBlind'];
    else
        LightControlFlag_C4 = [LightControlFlag_C4;'None'];
    end
    
    % ���邳���m����
    if strcmp(LightDataCell(iUNIT,18),'�I���I�t����')
        LightControlFlag_C5 = [LightControlFlag_C5;'dimmer'];
    else
        LightControlFlag_C5 = [LightControlFlag_C5;'None'];
    end
    
end

% �������ɕ��ёւ�
RoomList = {};
UnitList = {};

for iUNIT = 1:size(roomName,1)
    
    if strcmp(roomName(iUNIT),'Null') == 0
        
        if isempty(RoomList) == 1
            RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT),LightRoomIndex(iUNIT)];
            UnitList = [UnitList; UnitID(iUNIT)];
        else
            check = 0;
            for iDB = 1:size(RoomList,1)
                if strcmp(RoomList(iDB,1),roomFloor(iUNIT)) &&...
                        strcmp(RoomList(iDB,2),roomName(iUNIT))
                    check = 1;
                    UnitList{iDB} = [UnitList{iDB}, UnitID(iUNIT)];
                end
            end
            
            % ����������Ȃ���Βǉ�
            if check == 0
                RoomList = [RoomList; roomFloor(iUNIT),roomName(iUNIT),LightRoomIndex(iUNIT)];
                UnitList = [UnitList; UnitID(iUNIT)];
            end
        end
        
    else
        error('�����̂��s���ł��B')
    end
end

% XML�t�@�C������

numOfRoom = size(RoomList,1);

for iROOM = 1:numOfRoom
    
    if strcmp(RoomList(iROOM,2),'Null') == 0
        
        % ��������
        [RoomID,BldgType,RoomType,RoomArea,~,RoomHeight,RoomWidth,RoomDepth] = ...
            mytfunc_roomIDsearch(xmldata,RoomList(iROOM,1),RoomList(iROOM,2));
        
        % ���̑������i�[
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomIDs    = RoomID;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomFloor  = RoomList(iROOM,1);
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomName   = RoomList(iROOM,2);
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.BldgType   = BldgType;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomType   = RoomType;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomArea   = RoomArea;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomHeight = RoomHeight;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomWidth  = RoomWidth;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomDepth  = RoomDepth;
        xmldata.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomIndex  = RoomList(iROOM,3);
        
        % ���j�b�g���
        if iscell(UnitList{iROOM}) == 1
            unitNum = length(UnitList{iROOM});
        else
            unitNum = 1;
        end
        
        Count = 0;
        
        for iUNIT = 1:unitNum
            
            if unitNum == 1
                tmpUnitID = UnitList(iROOM);
            else
                tmpUnitID = UnitList{iROOM}(iUNIT);
            end
            
            % ���j�b�g�̏�������
            for iDB = 1:length(UnitID)
                if strcmp(UnitID(iDB),tmpUnitID)
 
                    Count = Count + 1;
       
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ID              = UnitID(iDB);
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.UnitType        = LightUnitType{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.UnitName        = LightUnitName{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.Power           = LightPower{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.Count           = LightCount{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C1  = LightControlFlag_C1{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C2  = LightControlFlag_C2{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C3  = LightControlFlag_C3{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C4  = LightControlFlag_C4{iDB};
                    xmldata.LightingSystems.LightingRoom(iROOM).LightingUnit(Count).ATTRIBUTE.ControlFlag_C5  = LightControlFlag_C5{iDB};
                    
                end
            end
        end
        
    end
end




