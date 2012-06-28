% mytfunc_csv2xml_AC_WINDList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% �ȃG�l��F�@��E���\�icsv�t�@�C���j��ǂ݂��݁AXML�t�@�C����f���o���B
% ���̐ݒ�t�@�C����ǂݍ��ށB
%------------------------------------------------------------------------

function confG = mytfunc_csv2xml_AC_WINDList(filename)

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
for iWIND = 11:size(windListDataCell,1)
    if isempty(windListDataCell(iWIND,1)) == 0
        WINDList = [WINDList;windListDataCell{iWIND,1}];
    end
end

% �d�l�̓ǂݍ���
confG = {};
for iWIND = 1:size(WINDList,1)
    
    % �u���C���h�̎�ނ͗\��4��ލ쐬����B
    for iBLIND = 1:4
        
        % ����
        confG{3*(iWIND-1)+iBLIND,1} = strcat(windListDataCell{10+iWIND,1},'_',int2str(iBLIND-1));
        
        % �����
        if strcmp(windListDataCell{10+iWIND,2},'�P�K���X')
            confG{3*(iWIND-1)+iBLIND,2} = 'SNGL';
        elseif strcmp(windListDataCell{10+iWIND,2},'���w�K���X�i����w6mm�j') || ...
                strcmp(windListDataCell{10+iWIND,2},'���w�K���X(����w6mm)')
            confG{3*(iWIND-1)+iBLIND,2} = 'DL06';
        elseif strcmp(windListDataCell{10+iWIND,2},'���w�K���X�i����w12mm�j') || ...
                strcmp(windListDataCell{10+iWIND,2},'���w�K���X�i����w12mm)') 
            confG{3*(iWIND-1)+iBLIND,2} = 'DL12';
        else
            windListDataCell{10+iWIND,2}
            error('�K���X�̎�ނ��s���ł�')
        end
        
        % �i��ԍ�
        confG{3*(iWIND-1)+iBLIND,3} = windListDataCell{10+iWIND,4};
        % �u���C���h
        confG{3*(iWIND-1)+iBLIND,4} = int2str(iBLIND-1);
        
    end
    
end

lastnum = size(confG,1);
confG{lastnum+1,1} = 'Null';
confG{lastnum+1,2} = 'SNGL';
confG{lastnum+1,3} = '1';
confG{lastnum+1,4} = '0';

end
