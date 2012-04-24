% mytfunc_csv2xml_AC_OWALList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% �O�ǂ̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------

function confW = mytfunc_csv2xml_AC_OWALList(filename)

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
for iOWAL = 11:size(owalListDataCell,1)
    if isempty(owalListDataCell(iOWAL,1)) == 0
        OWALList = [OWALList;owalListDataCell{iOWAL,1}];
    end
end

confW = {};
for iOWALList = 1:size(OWALList,1)
    
    % ����
    confW{iOWALList,1} = OWALList{iOWALList};
    % WCON��
    confW{iOWALList,2} = strcat('W',int2str(iOWALList));
    
    for iELE = 2:10
        
        num = 10+11*(iOWALList-1)+iELE;
        
        if num < size(owalListDataCell,1)
            if isempty(owalListDataCell{num,4}) == 0
                
                confW{iOWALList,2*(iELE-2)+2+1} = owalListDataCell{num,4};
                if isempty(owalListDataCell{num,7}) == 0
                    confW{iOWALList,2*(iELE-2)+2+2} = owalListDataCell{num,7};
                else
                    confW{iOWALList,2*(iELE-2)+2+2} = '0';
                end
                
            end
        end 
    end
end

% ���ǒǉ�
confW{iOWALList+1,1} = '����_�V���';
confW{iOWALList+1,2} = 'CEI';
confW{iOWALList+1,3} = '75';
confW{iOWALList+1,4} = '12';
confW{iOWALList+1,5} = '32';
confW{iOWALList+1,6} = '9';
confW{iOWALList+1,7} = '92';
confW{iOWALList+1,8} = '0';
confW{iOWALList+1,9} = '22';
confW{iOWALList+1,10} = '150';
confW{iOWALList+1,11} = '41';
confW{iOWALList+1,12} = '3';

confW{iOWALList+2,1} = '����_����';
confW{iOWALList+2,2} = 'FLO';
confW{iOWALList+2,3} = '41';
confW{iOWALList+2,4} = '3';
confW{iOWALList+2,5} = '22';
confW{iOWALList+2,6} = '150';
confW{iOWALList+2,7} = '92';
confW{iOWALList+2,8} = '0';
confW{iOWALList+2,9} = '32';
confW{iOWALList+2,10} = '9';
confW{iOWALList+2,11} = '75';
confW{iOWALList+2,12} = '12';


end