% mytfunc_csv2xml_AC_WINDList.m
%                                             by Masato Miyata 2016/03/20
%------------------------------------------------------------------------
% ÈGlîF@íE¢\icsvt@CjðÇÝ±ÝAXMLt@Cðf«o·B
% ÌÝèt@CðÇÝÞB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_WINDList(xmldata, filename)

windListDataCell = mytfunc_CSVfile2Cell(filename);

% windListData = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% % è`t@CÌÇÝÝ
% for i=1:length(windListData)
%     conma = strfind(windListData{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             windListDataCell{i,j} = windListData{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             windListDataCell{i,j}   = windListData{i}(conma(j-1)+1:conma(j)-1);
%             windListDataCell{i,j+1} = windListData{i}(conma(j)+1:end);
%         else
%             windListDataCell{i,j} = windListData{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end

% ¼ÌÌÇÝÝ
WINDList = {};
WINDNum  = [];
for iWIND = 11:size(windListDataCell,1)
    if isempty(windListDataCell{iWIND,1}) == 0
        WINDList = [WINDList;windListDataCell{iWIND,1}];
        WINDNum  = [WINDNum; iWIND];
    end
end

% dlÌÇÝÝ
for iWIND = 1:size(WINDList,1)
    
    % Jû¼Ìil®2-3 @j
    xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Name = ...
        windListDataCell{WINDNum(iWIND),1};
    
    % ÌMÑ¬¦il®2-3 Aj
    if isempty(windListDataCell{WINDNum(iWIND),2}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue = ...
            windListDataCell{WINDNum(iWIND),2};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue = 'Null';
    end
    
    % ÌúËMæ¾¦il®2-3 Bj
    if isempty(windListDataCell{WINDNum(iWIND),3}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue = ...
            windListDataCell{WINDNum(iWIND),3};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue = 'Null';
    end
    
    % KXÌíÞil®2-3 Dj
    if isempty(windListDataCell{WINDNum(iWIND),5}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassTypeNumber = ...
            windListDataCell{WINDNum(iWIND),5};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassTypeNumber = 'Null';
    end
    
    % ïÌíÞil®2-3 Cj
    if isempty(windListDataCell{WINDNum(iWIND),4}) == 0
        if strcmp(windListDataCell{WINDNum(iWIND),4},'÷')  % VerÎ
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'resin';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'A~÷¡') % VerÎ
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'complex';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'A~') % VerÎ
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'aluminum';
            
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'Ø»(PÂKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'wood_single';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'÷»(PÂKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'resin_single';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'à®Ø¡»(PÂKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'wood_aluminum_complex_single';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'à®÷¡»(PÂKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'resin_aluminum_complex_single';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'à®»(PÂKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'aluminum_single';
            
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'Ø»(¡wKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'wood_double';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'÷»(¡wKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'resin_double';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'à®Ø¡»(¡wKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'wood_aluminum_complex_double';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'à®÷¡»(¡wKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'resin_aluminum_complex_double';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'à®»(¡wKX)')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'aluminum_double';
            
        else
            error('ïÌíÞil®2-3 Cj: s³ÈIðÅ·')
        end
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'Null';
    end
    
    % KXÌMÑ¬¦il®2-3 Ej
    if isempty(windListDataCell{WINDNum(iWIND),6}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassUvalue = ...
            windListDataCell{WINDNum(iWIND),6};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassUvalue = 'Null';
    end
    
    % KXÌúËMæ¾¦il®2-3 Fj
    if isempty(windListDataCell{WINDNum(iWIND),7}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassMvalue = ...
            windListDataCell{WINDNum(iWIND),7};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassMvalue = 'Null';
    end
    
    % õlil®2-3 Gj
    if size(windListDataCell,2) > 7
        if isempty(windListDataCell{WINDNum(iWIND),8}) == 0
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Info = ...
                windListDataCell{WINDNum(iWIND),8};
        else
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Info = '';
        end
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Info = '';
    end
    
end

% lastnum = length(xmldata.AirConditioningSystem.WindowConfigure);
% 
% xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Name = 'Null';
% xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.WindowTypeClass = 'SNGL';
% xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.WindowTypeNumber = '1';
% xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Uvalue = 'Null';
% xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Mvalue = 'Null';
% xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Info = '';

end
