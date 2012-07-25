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
    eval(['equipID = [equipID; ''HWUnit_',int2str(iUNIT-10),'''];'])

    % �@�햼��
    if isempty(hwequipInfoCell{iUNIT,1})
        equipName = [equipName; 'Null'];
    else
        equipName = [equipName; hwequipInfoCell{iUNIT,1}];
    end

    % ���M�e��
    equipCapacity = [equipCapacity; hwequipInfoCell{iUNIT,2}];
    
    % �M������
    equipEfficiency = [equipEfficiency; hwequipInfoCell{iUNIT,3}];
    
    % �ۉ��d�l
    if strcmp(hwequipInfoCell{iUNIT,4},'�ۉ��d�l�P')
        equipInsulation = [equipInsulation; 'Level1'];
    elseif strcmp(hwequipInfoCell{iUNIT,4},'�ۉ��d�l�Q')
        equipInsulation = [equipInsulation; 'Level2'];
    elseif strcmp(hwequipInfoCell{iUNIT,4},'�ۉ��d�l�R')
        equipInsulation = [equipInsulation; 'Level3'];
    else
        equipInsulation = [equipInsulation; 'Level0'];
    end
    
    % �ڑ����a
    equipPipeSize = [equipPipeSize; hwequipInfoCell{iUNIT,5}];
    
    % ���z�M���p
    if strcmp(hwequipInfoCell(iUNIT,6),'�L')
        equipSolarSystem = [equipSolarSystem; 'True'];
    else
        equipSolarSystem = [equipSolarSystem; 'None'];
    end
    
        
    % �@��\�̋L��
    if isempty(hwequipInfoCell{iUNIT,7})
        equipInfo = [equipInfo; 'Null'];
    else
        equipInfo = [equipInfo; hwequipInfoCell{iUNIT,7}];
    end
    
end


% XML�t�@�C������
for iUNIT = 1:size(equipID,1)
    
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.ID          = equipID{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Info        = equipInfo{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Name        = equipName{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Capacity    = equipCapacity{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Efficiency  = equipEfficiency{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Insulation  = equipInsulation{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.PipeSize    = equipPipeSize{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.SolarSystem = equipSolarSystem{iUNIT};
    
end
