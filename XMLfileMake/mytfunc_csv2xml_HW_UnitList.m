% mytfunc_csv2xml_HW_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_HW_UnitList(xmldata,filename)

% �����@��Ɋւ�����
hwequipInfoCSV = textread(filename,'%s','delimiter','\n','whitespace','');

hwequipInfoCell = {};
for i=1:length(hwequipInfoCSV)
    conma = strfind(hwequipInfoCSV{i},',');
    for j = 1:length(conma)
        if j == 1
            hwequipInfoCell{i,j} = hwequipInfoCSV{i}(1:conma(j)-1);
        elseif j == length(conma)
            hwequipInfoCell{i,j}   = hwequipInfoCSV{i}(conma(j-1)+1:conma(j)-1);
            hwequipInfoCell{i,j+1} = hwequipInfoCSV{i}(conma(j)+1:end);
        else
            hwequipInfoCell{i,j} = hwequipInfoCSV{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

equipID   = {};
equipInfo = {};
equipName = {};
equipCount = {};
equipCapacity = {};
equipEfficiency = {};
equipInsulation = {};
equipPipeSize = {};
equipSolarSystem = {};

for iUNIT = 11:size(hwequipInfoCell,1)
    
    % �@��R�[�h
    equipID = [equipID; hwequipInfoCell{iUNIT,1}];
    % �@��\�̋L��
    if isempty(hwequipInfoCell{iUNIT,2})
        equipInfo = [equipInfo; 'Null'];
    else
        equipInfo = [equipInfo; hwequipInfoCell{iUNIT,2}];
    end
    % �@�햼��
    if isempty(hwequipInfoCell{iUNIT,3})
        equipName = [equipName; 'Null'];
    else
        equipName = [equipName; hwequipInfoCell{iUNIT,3}];
    end
    
    % �䐔
    equipCount = [equipCount; hwequipInfoCell{iUNIT,4}];
    
    % ���M�e��
    equipCapacity = [equipCapacity; hwequipInfoCell{iUNIT,5}];
    
    % �M������
    equipEfficiency = [equipEfficiency; hwequipInfoCell{iUNIT,6}];
    
    % �ۉ��d�l
    if strcmp(hwequipInfoCell{iUNIT,7},'�ۉ��d�l�P')
        equipInsulation = [equipInsulation; 'Level1'];
    elseif strcmp(hwequipInfoCell{iUNIT,7},'�ۉ��d�l�Q')
        equipInsulation = [equipInsulation; 'Level2'];
    elseif strcmp(hwequipInfoCell{iUNIT,7},'�ۉ��d�l�R')
        equipInsulation = [equipInsulation; 'Level3'];
    else
        equipInsulation = [equipInsulation; 'Level0'];
    end
    
    % �ڑ����a
    equipPipeSize = [equipPipeSize; hwequipInfoCell{iUNIT,8}];
    
    % ���z�M���p
    if strcmp(hwequipInfoCell(iUNIT,9),'�L')
        equipSolarSystem = [equipSolarSystem; 'True'];
    else
        equipSolarSystem = [equipSolarSystem; 'None'];
    end
end


% XML�t�@�C������
for iUNIT = 1:size(equipID,1)
    
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.ID          = equipID{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Info        = equipInfo{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Name        = equipName{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Count       = equipCount{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Capacity    = equipCapacity{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Efficiency  = equipEfficiency{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Insulation  = equipInsulation{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.PipeSize    = equipPipeSize{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.SolarSystem = equipSolarSystem{iUNIT};
    
end
