% mytfunc_calcK.m
%----------------------------------------------------------------------------
% ���M�ї����A���ˎ擾�W���Ȃǂ����߂�
%----------------------------------------------------------------------------
function [WallNameList,WallUvalueList,WindowNameList,WindowUvalueList,WindowMyuList,WindowSCCList,WindowSCRList] = ...
    mytfunc_calcK(dumy)

% WCON�f�[�^�x�[�X�̓ǂݍ���
DB_WCON = textread('./newhasp/wcontabl.dat','%s','delimiter','\n','whitespace','');

% ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�P�ʁA�M�`�����A�e�ϔ�M)
for i=1:length(DB_WCON)
    conma = strfind(DB_WCON{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_WCON{i,j} = str2double(DB_WCON{i}(1:conma(j)-1));
        elseif j == length(conma)
            perDB_WCON{i,j}   = str2double(DB_WCON{i}(conma(j-1)+1:conma(j)-1));
            perDB_WCON{i,j+1} = str2double(DB_WCON{i}(conma(j)+1:end));
        else
            perDB_WCON{i,j} = str2double(DB_WCON{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end

% SI�P�ʌn�ɕύX
for iDB = 1:length(perDB_WCON)
    if perDB_WCON{iDB,2} == 0 && perDB_WCON{iDB,3} ~= 0
        % kcal/mh��C ����@W/(m�EK)
        perDB_WCON{iDB,3} = perDB_WCON{iDB,3} * 4.2*1000/3600;
    end
end

% WIND�f�[�^�x�[�X�̓ǂݍ���
DB_WIND = textread('./newhasp/wndwtabl.dat','%s','delimiter','\n','whitespace','');

% ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�P�ʁA�M�`�����A�e�ϔ�M)
for i=1:length(DB_WIND)
    conma = strfind(DB_WIND{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_WIND{i,j} = str2double(DB_WIND{i}(1:conma(j)-1));
        elseif j == length(conma)
            perDB_WIND{i,j}   = str2double(DB_WIND{i}(conma(j-1)+1:conma(j)-1));
            perDB_WIND{i,j+1} = str2double(DB_WIND{i}(conma(j)+1:end));
        else
            perDB_WIND{i,j} = str2double(DB_WIND{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end


%% �O�ǎd�l�̌v�Z

% WCON�t�@�C���̓ǂݍ���
WCON = textread('./database/WCON.csv','%s','delimiter','\n','whitespace','');

% ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�P�ʁA�M�`�����A�e�ϔ�M)
for i=1:length(WCON)
    conma = strfind(WCON{i},',');
    for j = 1:length(conma)
        if j == 1
            perWCON{i,j} = (WCON{i}(1:conma(j)-1));
        elseif j == length(conma)
            perWCON{i,j}   = (WCON{i}(conma(j-1)+1:conma(j)-1));
            perWCON{i,j+1} = (WCON{i}(conma(j)+1:end));
        else
            perWCON{i,j} = (WCON{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end
WallNameList = perWCON(2:end,1);

% �O�ǂ�U�l�v�Z
WallUvalueList = [];
for iWALL = 1:size(perWCON,1)-1
    
    % ��񔲏o
    tmp = str2double(perWCON(iWALL+1,3:end));
    
    R = 1/9 + 1/23;
    for iELE = 1:length(tmp)/2
        
        % �ޗ��ԍ�
        elenum = tmp(2*(iELE)-1);
        
        if isnan(elenum) == 0
            
            if elenum <= 90
                % ��C�w�ȊO
                R = R +  0.001*tmp(2*(iELE))/perDB_WCON{elenum,3};
            else
                % ��C�w
                R = R +  perDB_WCON{elenum,3};
            end
        end
    end
    
    % �ۑ�
    WallUvalueList = [WallUvalueList; 1/R];
    
end



%% ���d�l�̌v�Z

% WIND�t�@�C���̓ǂݍ���
WIND = textread('./database/WIND.csv','%s','delimiter','\n','whitespace','');

% ���ʂ̊i�[ perDB_WIND(���́A����A�i��ԍ��A�u���C���h)
for i=1:length(WIND)
    conma = strfind(WIND{i},',');
    for j = 1:length(conma)
        if j == 1
            perWIND{i,j} = (WIND{i}(1:conma(j)-1));
        elseif j == length(conma)
            perWIND{i,j}   = (WIND{i}(conma(j-1)+1:conma(j)-1));
            perWIND{i,j+1} = (WIND{i}(conma(j)+1:end));
        else
            perWIND{i,j} = (WIND{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end

WindowNameList = perWIND(2:end,1);

for iWIND = 2:size(perWIND,1)
    
    % ���̎��
    if strcmp(perWIND(iWIND,2),'SNGL')
        startNum = 2;
    elseif strcmp(perWIND(iWIND,2),'DL06')
        startNum = 110;
    elseif strcmp(perWIND(iWIND,2),'DL12')
        startNum = 298;
    end
    
    % �u���C���h�̎��
    if strcmp(perWIND(iWIND,4),'0')
        blindnum = 3;
    elseif strcmp(perWIND(iWIND,4),'1')
        blindnum = 6;
    elseif strcmp(perWIND(iWIND,4),'2')
        blindnum = 9;
    elseif strcmp(perWIND(iWIND,4),'3')
        blindnum = 12;
    end
    
    % ����U�l
    WindowUvalueList(iWIND-1) = perDB_WIND{startNum + str2double(perWIND{iWIND,3}),blindnum};
    
    % ���̓��ːN����
    WindowMyuList(iWIND-1)    = 0.88 * (perDB_WIND{startNum + str2double(perWIND{iWIND,3}),blindnum+1} + ...
        perDB_WIND{startNum + str2double(perWIND{iWIND,3}),blindnum+2} );
    
    % ����SCC(�Օ��W��)
    WindowSCCList(iWIND-1)    = perDB_WIND{startNum + str2double(perWIND{iWIND,3}),blindnum+1};
    % ����SCR(�Օ��W��)
    WindowSCRList(iWIND-1)    = perDB_WIND{startNum + str2double(perWIND{iWIND,3}),blindnum+2};
        
end








