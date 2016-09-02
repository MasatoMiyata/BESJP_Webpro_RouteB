% mytfunc_csv2xml_AC_WINDList.m
%                                             by Masato Miyata 2016/03/20
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% ���̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_WINDList(xmldata, filename)

windListDataCell = mytfunc_CSVfile2Cell(filename);

% windListData = textread(filename,'%s','delimiter','\n','whitespace','');
% 
% % ����`�t�@�C���̓ǂݍ���
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
    
    % �J�������́i�l��2-3 �@�j
    xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Name = ...
        windListDataCell{WINDNum(iWIND),1};
    
    % ���̔M�ї����i�l��2-3 �A�j
    if isempty(windListDataCell{WINDNum(iWIND),2}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue = ...
            windListDataCell{WINDNum(iWIND),2};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue = 'Null';
    end
    
    % ���̓��˔M�擾���i�l��2-3 �B�j
    if isempty(windListDataCell{WINDNum(iWIND),3}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue = ...
            windListDataCell{WINDNum(iWIND),3};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue = 'Null';
    end
    
    % �K���X�̎�ށi�l��2-3 �D�j
    if isempty(windListDataCell{WINDNum(iWIND),5}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassTypeNumber = ...
            windListDataCell{WINDNum(iWIND),5};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassTypeNumber = 'Null';
    end
    
    % ����̎�ށi�l��2-3 �C�j
    if isempty(windListDataCell{WINDNum(iWIND),4}) == 0
        if strcmp(windListDataCell{WINDNum(iWIND),4},'����')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'resin';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'�A���~��������')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'complex';
        elseif strcmp(windListDataCell{WINDNum(iWIND),4},'�A���~')
            xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'aluminum';
        else
            error('����̎�ށi�l��2-3 �C�j: �s���ȑI�����ł�')
        end
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType = 'Null';
    end
    
    % �K���X�̔M�ї����i�l��2-3 �E�j
    if isempty(windListDataCell{WINDNum(iWIND),6}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassUvalue = ...
            windListDataCell{WINDNum(iWIND),6};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassUvalue = 'Null';
    end
    
    % �K���X�̓��˔M�擾���i�l��2-3 �F�j
    if isempty(windListDataCell{WINDNum(iWIND),7}) == 0
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassMvalue = ...
            windListDataCell{WINDNum(iWIND),7};
    else
        xmldata.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassMvalue = 'Null';
    end
    
    % ���l�i�l��2-3 �G�j
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
