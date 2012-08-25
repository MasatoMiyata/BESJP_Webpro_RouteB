% mytfunc_csv2xml_AC_OWALList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �O�ǂ̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------

function xmldata = mytfunc_csv2xml_AC_OWALList(xmldata,filename)

owalListData = textread(filename,'%s','delimiter','\n','whitespace','');

% �O�ǒ�`�t�@�C���̓ǂݍ���
for i=1:length(owalListData)
    conma = strfind(owalListData{i},',');
    for j = 1:length(conma)
        if j == 1
            owalListDataCell{i,j} = owalListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            owalListDataCell{i,j}   = owalListData{i}(conma(j-1)+1:conma(j)-1);
            owalListDataCell{i,j+1} = owalListData{i}(conma(j)+1:end);
        else
            owalListDataCell{i,j} = owalListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% �O�ǖ��̂̓ǂݍ���
OWALList = {};
OWALNum  = [];
for iOWAL = 11:size(owalListDataCell,1)
    if isempty(owalListDataCell{iOWAL,1}) == 0
        OWALList = [OWALList;owalListDataCell{iOWAL,1}];
        OWALNum  = [OWALNum; iOWAL];
    end
end

% �d�l�̓ǂݍ���
for iOWALList = 1:size(OWALList,1)
    
    % ����
    xmldata.AirConditioningSystem.WallConfigure(iOWALList).ATTRIBUTE.Name = OWALList{iOWALList};
    
    % �O�ǂ��ݒu�ǂ�
    if strcmp(owalListDataCell{OWALNum(iOWALList),2},'�O��')
        xmldata.AirConditioningSystem.WallConfigure(iOWALList).ATTRIBUTE.WallType   = 'Air';
    elseif strcmp(owalListDataCell{OWALNum(iOWALList),2},'�ڒn��')
        xmldata.AirConditioningSystem.WallConfigure(iOWALList).ATTRIBUTE.WallType   = 'Ground';
    end
    
    % �M�ї���
    if isempty(owalListDataCell{OWALNum(iOWALList),3}) == 0
        xmldata.AirConditioningSystem.WallConfigure(iOWALList).ATTRIBUTE.Uvalue   = owalListDataCell(OWALNum(iOWALList),3);
    else
        xmldata.AirConditioningSystem.WallConfigure(iOWALList).ATTRIBUTE.Uvalue   = 'Null';
    end
    
    
    % �e���C���[
    count = 0;
    for iELE = 1:10
        
        num = OWALNum(iOWALList)+iELE;
        
        if num < size(owalListDataCell,1)
            if isempty(owalListDataCell{num,4}) == 0
                
                count = count + 1;
                
                % �w�ԍ�
                xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.Layer = int2str(count);
                
                % �ޗ��ԍ�
                xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.MaterialNumber = ...
                    owalListDataCell{num,4};
                
                % �ޗ���
                if isempty(owalListDataCell{num,5}) == 0
                    xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.MaterialName   = ...
                        owalListDataCell{num,5};
                else
                    xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.MaterialName   = '';
                end
                
                % ����
                if isempty(owalListDataCell{num,6}) == 0
                    xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.WallThickness  = ...
                        owalListDataCell{num,6};
                else
                    xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.WallThickness  = '0';
                end
                
                % ���l
                if isempty(owalListDataCell{num,7}) == 0
                    xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.Info  = ...
                        owalListDataCell{num,7};
                else
                    xmldata.AirConditioningSystem.WallConfigure(iOWALList).MaterialRef(count).ATTRIBUTE.Info  = 'Null';
                end
                
            end
        end
    end
end


% ���ǒǉ�
lastnum = length(xmldata.AirConditioningSystem.WallConfigure);

xmldata.AirConditioningSystem.WallConfigure(lastnum+1).ATTRIBUTE.Name = '����_�V���';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).ATTRIBUTE.WallType = 'Internal';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).ATTRIBUTE.Uvalue   = '0.00';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(1).ATTRIBUTE.Layer = '1';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(1).ATTRIBUTE.MaterialNumber = '75';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(1).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(1).ATTRIBUTE.WallThickness = '12';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(2).ATTRIBUTE.Layer = '2';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(2).ATTRIBUTE.MaterialNumber = '32';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(2).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(2).ATTRIBUTE.WallThickness = '9';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(3).ATTRIBUTE.Layer = '3';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(3).ATTRIBUTE.MaterialNumber = '92';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(3).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(3).ATTRIBUTE.WallThickness = '0';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(4).ATTRIBUTE.Layer = '4';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(4).ATTRIBUTE.MaterialNumber = '22';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(4).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(4).ATTRIBUTE.WallThickness = '150';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(5).ATTRIBUTE.Layer = '5';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(5).ATTRIBUTE.MaterialNumber = '41';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(5).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+1).MaterialRef(5).ATTRIBUTE.WallThickness = '3';

xmldata.AirConditioningSystem.WallConfigure(lastnum+2).ATTRIBUTE.Name = '����_����';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).ATTRIBUTE.WallType = 'Internal';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).ATTRIBUTE.Uvalue   = '0.00';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(1).ATTRIBUTE.Layer = '1';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(1).ATTRIBUTE.MaterialNumber = '41';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(1).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(1).ATTRIBUTE.WallThickness = '3';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(2).ATTRIBUTE.Layer = '2';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(2).ATTRIBUTE.MaterialNumber = '22';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(2).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(2).ATTRIBUTE.WallThickness = '150';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(3).ATTRIBUTE.Layer = '3';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(3).ATTRIBUTE.MaterialNumber = '92';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(3).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(3).ATTRIBUTE.WallThickness = '0';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(4).ATTRIBUTE.Layer = '4';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(4).ATTRIBUTE.MaterialNumber = '32';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(4).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(4).ATTRIBUTE.WallThickness = '9';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(5).ATTRIBUTE.Layer = '5';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(5).ATTRIBUTE.MaterialNumber = '75';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(5).ATTRIBUTE.MaterialName = '';
xmldata.AirConditioningSystem.WallConfigure(lastnum+2).MaterialRef(5).ATTRIBUTE.WallThickness = '12';


end