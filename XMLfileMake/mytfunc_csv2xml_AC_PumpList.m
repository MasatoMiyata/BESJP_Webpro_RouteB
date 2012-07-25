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

% �󔒂͒���̏��𖄂߂�B
for iPUMP = 11:size(pumpListDataCell,1)
    if isempty(pumpListDataCell{iPUMP,1}) && isempty(pumpListDataCell{iPUMP,5}) == 0
        if iPUMP == 11
            error('�ŏ��̍s�͕K���|���v�Q�R�[�h����͂��Ă�������')
        else
            pumpListDataCell(iPUMP,1:4) = pumpListDataCell(iPUMP-1,1:4);
        end
    end
end

% �|���v�Q���X�g�̍쐬
PumpListName = {};
PumpListQcontrol = {};
PumpListdTc  = {};
PumpListdTh  = {};

for iPUMP = 11:size(pumpListDataCell,1)
    if isempty(PumpListName)
        PumpListName = pumpListDataCell(iPUMP,1);
        PumpListQcontrol = pumpListDataCell(iPUMP,2);
        PumpListdTc  = pumpListDataCell(iPUMP,3);
        PumpListdTh  = pumpListDataCell(iPUMP,4);
    else
        check = 0;
        for iDB = 1:length(PumpListName)
            if strcmp(pumpListDataCell(iPUMP,1),PumpListName(iDB))
                % �d������
                check = 1;
            end
        end
        if check == 0
            PumpListName = [PumpListName; pumpListDataCell(iPUMP,1)];
            PumpListQcontrol = [PumpListQcontrol; pumpListDataCell(iPUMP,2)];
            PumpListdTc  = [PumpListdTc; pumpListDataCell(iPUMP,3)];
            PumpListdTh  = [PumpListdTh; pumpListDataCell(iPUMP,4)];
        end
    end
end


% ���̓ǂݍ���
for iPUMPSET = 1:length(PumpListName)
    
    if isempty(PumpListName{iPUMPSET})==0
        
        % ID
        xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.Name = PumpListName(iPUMPSET,1);
        
        % �䐔����
        if strcmp(PumpListQcontrol(iPUMPSET,1),'�L')
            xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.QuantityControl = 'True';
        else
            xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.QuantityControl = 'False';
        end
        
        % �݌v���x��
        if isempty(PumpListdTc{iPUMPSET,1})==0
            xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.deltaTemp_Cooling = PumpListdTc(iPUMPSET,1);
        else
            xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.deltaTemp_Cooling = 'Null';
        end
        if isempty(PumpListdTh{iPUMPSET,1})==0
            xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.deltaTemp_Heating = PumpListdTh(iPUMPSET,1);
        else
            xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).ATTRIBUTE.deltaTemp_Heating = 'Null';
        end
        
        iCOUNT = 0;
        
        for iDB = 11:size(pumpListDataCell,1)
            if strcmp(PumpListName(iPUMPSET,1),pumpListDataCell(iDB,1))
                iCOUNT = iCOUNT + 1;
                
                % �^�]����                
                if isempty(pumpListDataCell{iDB,5}) == 0
                    if length(pumpListDataCell{iDB,5}) > 1 && strcmp(pumpListDataCell{iDB,5}(end-1:end),'�Ԗ�')
                        xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.Order  = pumpListDataCell{iDB,5}(1:end-2);
                    else
                        xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.Order  = pumpListDataCell{iDB,5};
                    end
                else
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.Order  = 'Null';
                end
                
                % �|���v�䐔
                if isempty(pumpListDataCell{iDB,6})==0
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.Count = pumpListDataCell(iDB,6);
                else
                    error('2���|���v�̑䐔 %s �͕s���ł��B', pumpListDataCell{iDB,6})
                end
                
                % �␅����
                if isempty(pumpListDataCell{iDB,7})==0
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.RatedFlow = pumpListDataCell(iDB,7);
                else
                    error('2���|���v�̒�i���ʂ��s���ł��B')
                end
                
                % ��i����d��
                if isempty(pumpListDataCell{iDB,8})==0
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.RatedPower = pumpListDataCell(iDB,8);
                else
                    error('2���|���v�̒�i����d�͂��s���ł��B')
                end
                
                % ���ʐ������
                if isempty(pumpListDataCell{iDB,9})==0
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.FlowControl = pumpListDataCell(iDB,9);
                else
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.FlowControl = 'Null';
                end
                
                % �ϗ��ʎ��ŏ�����
                if isempty(pumpListDataCell{iDB,10})==0
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.MinValveOpening = pumpListDataCell(iDB,10);
                else
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.MinValveOpening = 'Null';
                end
                
                % ���l
                if isempty(pumpListDataCell{iDB,11})==0
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.Info = pumpListDataCell(iDB,11);
                else
                    xmldata.AirConditioningSystem.SecondaryPumpSet(iPUMPSET).SecondaryPump(iCOUNT).ATTRIBUTE.Info = 'Null';
                end
                
            end
        end
        
        if iCOUNT == 0
            error('�񎟃|���v�Q %s �ɑ�����@�킪������܂���B',PumpListName{iPUMPSET,1})
        end
        
    end
    
end
