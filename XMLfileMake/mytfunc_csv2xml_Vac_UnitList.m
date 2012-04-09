% mytfunc_csv2xml_Vac_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_Vac_UnitList(xmldata,filename)

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
venCoolingCapacity = {};
venCOP        = {};
venFanPower   = {};
venPumpPower  = {};
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
    
    % ��p�\��
    if isempty(venDataCell{iUNIT,2})
        venCoolingCapacity  = [venCoolingCapacity;'Null'];
    else
        venCoolingCapacity  = [venCoolingCapacity;venDataCell{iUNIT,2}];
    end
    
    % COP
    if isempty(venDataCell{iUNIT,3})
        venCOP  = [venCOP;'Null'];
    else
        venCOP  = [venCOP;venDataCell{iUNIT,3}];
    end
    
    % �����@����
    if isempty(venDataCell{iUNIT,5})
        venFanPower  = [venFanPower;'0'];
    else
        venFanPower  = [venFanPower;venDataCell{iUNIT,5}];
    end
    
    % �|���v����
    if isempty(venDataCell{iUNIT,6})
        venPumpPower  = [venPumpPower;'0'];
    else
        venPumpPower  = [venPumpPower;venDataCell{iUNIT,6}];
    end
    
    % �䐔
    venCount = [venCount;venDataCell{iUNIT,7}];
        
    numRoom = (length(venDataCell(iUNIT,:))-7)/2;
    tmpFloor = {};
    tmpName = {};
    for iROOM = 1:numRoom
        n1 = 7 + 2*(iROOM-1) + 1;
        n2 = 7 + 2*(iROOM-1) + 2;
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
for iUNIT = 1:size(venUnitName,1)
    
    eval(['xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.ID = ''VacUnit_',int2str(iUNIT),''';'])
    
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
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.roomIDs    = tmpIDs;
    
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.UnitName   = venUnitName{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.CoolingCapacity  = venCoolingCapacity{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.COP        = venCOP{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.FanPower   = venFanPower{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.PumpPower  = venPumpPower{iUNIT};
    xmldata.VentilationSystems.VentilationACUnit(iUNIT).ATTRIBUTE.Count      = venCount{iUNIT};
    
end
