% mytfunc_csv2xml_AC_WINDList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% ���̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_WINDList(xmldata, filename)

windListData = textread(filename,'%s','delimiter','\n','whitespace','');

% ����`�t�@�C���̓ǂݍ���
for i=1:length(windListData)
    conma = strfind(windListData{i},',');
    for j = 1:length(conma)
        if j == 1
            windListDataCell{i,j} = windListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            windListDataCell{i,j}   = windListData{i}(conma(j-1)+1:conma(j)-1);
            windListDataCell{i,j+1} = windListData{i}(conma(j)+1:end);
        else
            windListDataCell{i,j} = windListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% �����̂̓ǂݍ���
WINDList = {};
WINDNum  = [];
for iWIND = 11:size(windListDataCell,1)
    if isempty(windListDataCell{iWIND,1}) == 0
        WINDList = [WINDList;windListDataCell{iWIND,1}];
        WINDNum  = [WINDNum; iWIND];
    end
end

% �d�l�̓ǂݍ���
for iWIND = 1:size(WINDList,1)
    
    % ����
    xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Name = ...
        windListDataCell{WINDNum(iWIND),1};
    
    % ���M�ї���
    if isempty(windListDataCell{WINDNum(iWIND),2}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue = ...
            windListDataCell{WINDNum(iWIND),2};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue = 'Null';
    end
    
    % ���ːN����
    if isempty(windListDataCell{WINDNum(iWIND),3}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue = ...
            windListDataCell{WINDNum(iWIND),3};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue = 'Null';
    end
    
    % �i��ԍ�
    if isempty(windListDataCell{WINDNum(iWIND),4}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.WindowTypeNumber = ...
            windListDataCell{WINDNum(iWIND),4};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.WindowTypeNumber = 'Null';
    end
    
    % �����
    WindowTypeClass = '';
    if strcmp(windListDataCell{WINDNum(iWIND),5},'�P�K���X')
        WindowTypeClass  = 'SNGL';
    elseif strcmp(windListDataCell{WINDNum(iWIND),5},'���w�K���X�i����w6mm�j') || ...
            strcmp(windListDataCell{WINDNum(iWIND),5},'���w�K���X(����w6mm)')
        WindowTypeClass = 'DL06';
    elseif strcmp(windListDataCell{WINDNum(iWIND),5},'���w�K���X�i����w12mm�j') || ...
            strcmp(windListDataCell{WINDNum(iWIND),5},'���w�K���X�i����w12mm)')
        WindowTypeClass = 'DL12';
    else
        WindowTypeClass = windListDataCell{WINDNum(iWIND),5};
    end
    xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.WindowTypeClass = ...
        WindowTypeClass;
    
    % ���l
    if isempty(windListDataCell{WINDNum(iWIND),6}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Info = ...
            windListDataCell{WINDNum(iWIND),6};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Info = '';
    end
    
end

lastnum = length(xmldata.AirConditioningSystem.WindowConfigure);

xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Name = 'Null';
xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.WindowTypeClass = 'SNGL';
xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.WindowTypeNumber = '1';
xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Uvalue = 'Null';
xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Mvalue = 'Null';
xmldata.AirConditioningSystem.WindowConfigure(lastnum+1).ATTRIBUTE.Info = '';

end
