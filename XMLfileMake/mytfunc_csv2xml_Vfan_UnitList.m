% mytfunc_csv2xml_Vfan_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_Vfan_UnitList(xmldata,filename)

% �f�[�^�̓ǂݍ���
venData = textread(filename,'%s','delimiter','\n','whitespace','');

% �󒲎���`�t�@�C���̓ǂݍ���
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

% ���̔��o
venUnitName = {};
venUnitType = {};
venVolume   = {};
venPower    = {};
venControlFlag_C1 = {};
venControlFlag_C2 = {};
venControlFlag_C3 = {};
venCount  = {};
roomFloor = {};
roomName  = {};

for iUNIT = 11:size(venDataCell,1)
    
    % ����
    if isempty(venDataCell{iUNIT,1})
        venUnitName  = [venUnitName;'Null'];
    else
        venUnitName  = [venUnitName;venDataCell{iUNIT,1}];
    end
    
    % ����
    if strcmp(venDataCell{iUNIT,2},'���C')
        venUnitType  = [venUnitType;'Supply'];
    elseif strcmp(venDataCell{iUNIT,2},'�r�C')
        venUnitType  = [venUnitType;'Exist'];
    else
        venDataCell{iUNIT,2}
        error('���C��ނ��s���ł�')
    end
    
    % ����
    if isempty(venDataCell{iUNIT,8})
        venVolume  = [venVolume;'Null'];
    else
        venVolume  = [venVolume;venDataCell{iUNIT,3}];
    end
    
    % ����d��
    venPower = [venPower;venDataCell{iUNIT,4}];
    
    % �䐔
    venCount = [venCount;venDataCell{iUNIT,9}];
    
    % �������d���@�̗p
    if isempty(venDataCell{iUNIT,5}) == 0
        venControlFlag_C1 = [venControlFlag_C1;'True'];
    else
        venControlFlag_C1 = [venControlFlag_C1;'None'];
    end
    
    % �C���o�[�^�̗p
    if isempty(venDataCell{iUNIT,6}) == 0
        venControlFlag_C2 = [venControlFlag_C2;'True'];
    else
        venControlFlag_C2 = [venControlFlag_C2;'None'];
    end
    
    % �����ʐ���
    if isempty(venDataCell{iUNIT,7}) == 0
        venControlFlag_C3 = [venControlFlag_C3;'COconcentration'];
    elseif isempty(venDataCell{iUNIT,8}) == 0
        venControlFlag_C3 = [venControlFlag_C3;'Temprature'];
    else
        venControlFlag_C3 = [venControlFlag_C3;'None'];
    end
    
    numRoom = (length(venDataCell(iUNIT,:))-9)/2;
    tmpFloor = {};
    tmpName = {};
    for iROOM = 1:numRoom
        n1 = 9 + 2*(iROOM-1) + 1;
        n2 = 9 + 2*(iROOM-1) + 2;
        if isempty(venDataCell{iUNIT,n2})
            tmpFloor = [tmpFloor, 'Null'];
            tmpName  = [tmpName, 'Null'];
        else
            tmpFloor = [tmpFloor, venDataCell{iUNIT,n1}];
            tmpName  = [tmpName, venDataCell{iUNIT,n2}];
        end
    end
    
    roomFloor(iUNIT-10,:) = tmpFloor;
    roomName(iUNIT-10,:)  = tmpName;
    
end

% XML�t�@�C������
for iUNIT = 1:size(venPower,1)
    
    eval(['xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ID = ''VfanUnit_',int2str(iUNIT),''';'])
    
    tmpIDs = {};
    for iROOM = 1:numRoom
        if strcmp(roomName{iUNIT,iROOM},'Null') == 0
            tmpID = mytfunc_roomsearch(xmldata,roomFloor{iUNIT,iROOM},roomName{iUNIT,iROOM});
            if isempty(tmpIDs)
                tmpIDs = tmpID;
            else
            tmpIDs = strcat(tmpIDs,',',tmpID);
            end
        end
    end
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.roomIDs         = tmpIDs;
    
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.UnitName        = venUnitName{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.UnitType        = venUnitType{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.FanVolume       = venVolume{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.FanPower        = venPower{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ControlFlag_C1  = venControlFlag_C1{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ControlFlag_C2  = venControlFlag_C2{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.ControlFlag_C3  = venControlFlag_C3{iUNIT};
    xmldata.VentilationSystems.VentilationFANUnit(iUNIT).ATTRIBUTE.Count           = venCount{iUNIT};
    
end
