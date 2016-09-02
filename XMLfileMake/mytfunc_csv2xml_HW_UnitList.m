% mytfunc_csv2xml_HW_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% �ȃG�l��F���C�ݒ�t�@�C�����쐬����B
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_HW_UnitList(xmldata,filename)

% �����@��Ɋւ�����
hwequipInfoCell = mytfunc_CSVfile2Cell(filename);
% 
% hwequipInfoCSV = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% hwequipInfoCell = {};
% for i=1:length(hwequipInfoCSV)
%     conma = strfind(hwequipInfoCSV{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             hwequipInfoCell{i,j} = hwequipInfoCSV{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             hwequipInfoCell{i,j}   = hwequipInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%             hwequipInfoCell{i,j+1} = hwequipInfoCSV{i}(conma(j)+1:end);
%         else
%             hwequipInfoCell{i,j} = hwequipInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end

equipInfo = {};
equipName = {};
equipCapacity = {};
equipEfficiency = {};
equipInsulation = {};
equipPipeSize = {};
equipSolarSystem = {};
SolorHeatingSurfaceArea = {};
SolorHeatingSurfaceAzimuth = {};
SolorHeatingSurfaceInclination = {};


for iUNIT = 11:size(hwequipInfoCell,1)
    
    if isempty(hwequipInfoCell{iUNIT,1}) == 0
    
        % �@�햼��
        equipName = [equipName; hwequipInfoCell{iUNIT,1}];
        
        % ���M�e��
        equipCapacity = [equipCapacity; hwequipInfoCell{iUNIT,3}];
        
        % �M������
        equipEfficiency = [equipEfficiency; hwequipInfoCell{iUNIT,4}];
        
        % �ۉ��d�l
        if strcmp(hwequipInfoCell{iUNIT,5},'�ۉ��d�l�P') || strcmp(hwequipInfoCell{iUNIT,5},'�ۉ��d�l1') 
            equipInsulation = [equipInsulation; 'Level1'];
        elseif strcmp(hwequipInfoCell{iUNIT,5},'�ۉ��d�l�Q') || strcmp(hwequipInfoCell{iUNIT,5},'�ۉ��d�l2')
            equipInsulation = [equipInsulation; 'Level2'];
        elseif strcmp(hwequipInfoCell{iUNIT,5},'�ۉ��d�l�R') || strcmp(hwequipInfoCell{iUNIT,5},'�ۉ��d�l3')
            equipInsulation = [equipInsulation; 'Level3'];
        else
            equipInsulation = [equipInsulation; 'Level0'];
        end
        
        % �ڑ����a
        equipPipeSize = [equipPipeSize; hwequipInfoCell{iUNIT,6}];
        
        % ���z�M���p
        if isempty(hwequipInfoCell{iUNIT,7})
            equipSolarSystem = [equipSolarSystem; 'None'];
            
            SolorHeatingSurfaceArea = ...
                [SolorHeatingSurfaceArea; 'Null'];
            SolorHeatingSurfaceAzimuth = ...
                [SolorHeatingSurfaceAzimuth; 'Null'];
            SolorHeatingSurfaceInclination = ...
                [SolorHeatingSurfaceInclination; 'Null'];
            
        else
            equipSolarSystem = [equipSolarSystem; 'True'];
            
            SolorHeatingSurfaceArea = ...
                [SolorHeatingSurfaceArea; hwequipInfoCell{iUNIT,7}];
            SolorHeatingSurfaceAzimuth = ...
                [SolorHeatingSurfaceAzimuth; hwequipInfoCell{iUNIT,8}];
            SolorHeatingSurfaceInclination = ...
                [SolorHeatingSurfaceInclination; hwequipInfoCell{iUNIT,9}];
        end
        
        % �@��\�̋L��
        if isempty(hwequipInfoCell{iUNIT,10})
            equipInfo = [equipInfo; 'Null'];
        else
            equipInfo = [equipInfo; hwequipInfoCell{iUNIT,10}];
        end
        
    end
end


% XML�t�@�C������
for iUNIT = 1:size(equipName,1)
    
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Info        = equipInfo{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Name        = equipName{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Capacity    = equipCapacity{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Efficiency  = equipEfficiency{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Insulation  = equipInsulation{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.PipeSize    = equipPipeSize{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.SolarSystem = equipSolarSystem{iUNIT};
    
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.SolorHeatingSurfaceArea = ...
        SolorHeatingSurfaceArea{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.SolorHeatingSurfaceAzimuth = ...
        SolorHeatingSurfaceAzimuth{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.SolorHeatingSurfaceInclination = ...
        SolorHeatingSurfaceInclination{iUNIT};
    
end
