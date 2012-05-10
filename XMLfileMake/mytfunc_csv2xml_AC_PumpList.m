% mytfunc_csv2xml_AC_PumpList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �񎟃|���v�̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_PumpList(xmldata,filename)

pumpListData = textread(filename,'%s','delimiter','\n','whitespace','');

% �|���v�Q��`�t�@�C���̓ǂݍ���
for i=1:length(pumpListData)
    conma = strfind(pumpListData{i},',');
    for j = 1:length(conma)
        if j == 1
            pumpListDataCell{i,j} = pumpListData{i}(1:conma(j)-1);
        elseif j == length(conma)
            pumpListDataCell{i,j}   = pumpListData{i}(conma(j-1)+1:conma(j)-1);
            pumpListDataCell{i,j+1} = pumpListData{i}(conma(j)+1:end);
        else
            pumpListDataCell{i,j} = pumpListData{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

% ���̓ǂݍ���
for iPUMP = 11:size(pumpListDataCell,1)
       
    if isempty(pumpListDataCell{iPUMP,1})==0

        % ID
        xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.Name = pumpListDataCell(iPUMP,1);
        
        % ����
        if isempty(pumpListDataCell{iPUMP,2})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.System = pumpListDataCell(iPUMP,2);
        else
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.System = 'Null';
        end
        
        % �|���v�䐔
        if isempty(pumpListDataCell{iPUMP,4})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.Count = pumpListDataCell(iPUMP,4);
        else
            error('2���|���v�̑䐔���s���ł��B')
        end
        
        % �␅����
        if isempty(pumpListDataCell{iPUMP,5})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.RatedFlow = pumpListDataCell(iPUMP,5);
        else
            error('2���|���v�̒�i���ʂ��s���ł��B')
        end
        
        % ��i����d��
        if isempty(pumpListDataCell{iPUMP,6})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.RatedPower = pumpListDataCell(iPUMP,6);
        else
            error('2���|���v�̒�i����d�͂��s���ł��B')
        end
        
        % ���ʐ������
        if isempty(pumpListDataCell{iPUMP,7})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.FlowControl = pumpListDataCell(iPUMP,7);
        else
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.FlowControl = 'Null';
        end
        
        % �䐔����
        xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.QuantityControl = 'True';
        
        % �݌v���x��
        if isempty(pumpListDataCell{iPUMP,9})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.deltaTemp_Cooling = pumpListDataCell(iPUMP,9);
        else
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.deltaTemp_Cooling = 'Null';
        end
        if isempty(pumpListDataCell{iPUMP,10})==0
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.deltaTemp_Heating = pumpListDataCell(iPUMP,10);
        else
            xmldata.AirConditioningSystem.SecondaryPump(iPUMP-10).ATTRIBUTE.deltaTemp_Heating = 'Null';
        end
        
    end
    
end


