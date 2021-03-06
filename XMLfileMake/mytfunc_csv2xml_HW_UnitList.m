% mytfunc_csv2xml_HW_UnitList.m
%                                             by Masato Miyata 2012/04/02
%------------------------------------------------------------------------
% ČGlîFˇCÝčt@CđěŹˇéB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_HW_UnitList(xmldata,filename)

% @íÉÖˇéîń
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
equipFueltype = {};
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
    
        % @íźĚ
        equipName = [equipName; hwequipInfoCell{iUNIT,1}];
        
        % RżíŢ
        if strcmp(hwequipInfoCell{iUNIT,2},'dÍ')
            equipFueltype = [equipFueltype; 'Electric'];
        else
            equipFueltype = [equipFueltype; 'Others'];
        end
        
        % ÁMeĘ
        equipCapacity = [equipCapacity; hwequipInfoCell{iUNIT,3}];
        
        % MšřŚ
        equipEfficiency = [equipEfficiency; hwequipInfoCell{iUNIT,4}];
        
        % Űˇdl
        if strcmp(hwequipInfoCell{iUNIT,5},'ŰˇdlP') || strcmp(hwequipInfoCell{iUNIT,5},'Űˇdl1') 
            equipInsulation = [equipInsulation; 'Level1'];
        elseif strcmp(hwequipInfoCell{iUNIT,5},'ŰˇdlQ') || strcmp(hwequipInfoCell{iUNIT,5},'Űˇdl2')
            equipInsulation = [equipInsulation; 'Level2'];
        elseif strcmp(hwequipInfoCell{iUNIT,5},'ŰˇdlR') || strcmp(hwequipInfoCell{iUNIT,5},'Űˇdl3')
            equipInsulation = [equipInsulation; 'Level3'];
        else
            equipInsulation = [equipInsulation; 'Level0'];
        end
        
        % Úąűa
        equipPipeSize = [equipPipeSize; hwequipInfoCell{iUNIT,6}];
        
        % žzMp
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
        
        % @í\ĚL
        if isempty(hwequipInfoCell{iUNIT,10})
            equipInfo = [equipInfo; 'Null'];
        else
            equipInfo = [equipInfo; hwequipInfoCell{iUNIT,10}];
        end
        
    end
end


% XMLt@CśŹ
for iUNIT = 1:size(equipName,1)
    
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Info        = equipInfo{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.Name        = equipName{iUNIT};
    xmldata.HotwaterSystems.Boiler(iUNIT).ATTRIBUTE.equipFueltype = equipFueltype{iUNIT};
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
