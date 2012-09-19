% mytfunc_calcK.m
%----------------------------------------------------------------------------
% ���M�ї����A���ˎ擾�W���Ȃǂ����߂�
%----------------------------------------------------------------------------
function [WallNameList,WallUvalueList,WindowNameList,WindowUvalueList,WindowMyuList,...
    WindowSCCList,WindowSCRList] = ...
    mytfunc_calcK(DBWCONMODE,confW,confG,WallUvalue,WindowUvalue,WindowMvalue)


switch DBWCONMODE
    
    case {'newHASP'}  % newHASP�̃f�[�^�t�@�C�����g�p����ꍇ
        
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
        
    case {'Regulation'}
        
        % WCON�f�[�^�x�[�X�̓ǂݍ��݁iHeatThermalConductivity.csv�j
        DB_WCON = textread('./database/HeatThermalConductivity.csv','%s','delimiter','\n','whitespace','');
        
        % ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�ޗ����A�M�`�����A�e�ϔ�M�A��M�A���x)
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
        
        
        % WIND�f�[�^�x�[�X�̓ǂݍ���
        DB_WIND = textread('./database/WindowHeatTransferPerformance.csv','%s','delimiter','\n','whitespace','');
        
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
        
        
    otherwise
        error('WCON, WIND�f�[�^�x�[�X�t�@�C���̎w�肪�s���ł�')
end



%% �O�ǎd�l�̌v�Z

% �O�ǖ��̃��X�g
WallNameList = confW(:,1);

% �O�ǂ�U�l�v�Z
WallUvalueList = [];
for iWALL = 1:size(confW,1)
    
    % ��񔲏o
    tmp = str2double(confW(iWALL,3:end));
    
    R = 1/9 + 1/23;
    for iELE = 1:length(tmp)/2
        
        % �ޗ��ԍ�
        elenum = tmp(2*(iELE)-1);
        
        if isnan(elenum) == 0
            
            % �����l����ł���΃G���[
            if isnan(perDB_WCON{elenum,3})
                error('���ޔԍ����s���ł�')
            end
            
            switch DBWCONMODE
                case {'newHASP'}
                    if elenum <= 90
                        % ��C�w�ȊO
                        R = R +  0.001*tmp(2*(iELE))/perDB_WCON{elenum,3};
                    else
                        % ��C�w
                        R = R +  perDB_WCON{elenum,3};
                    end
                case {'Regulation'}
                    if elenum <= 300
                        % ��C�w�ȊO
                        R = R +  0.001*tmp(2*(iELE))/perDB_WCON{elenum,3};
                    else
                        % ��C�w
                        R = R +  perDB_WCON{elenum,3};
                    end
            end
            
        end
    end
    
    % ����U�l�����ړ��͂���Ă���΁A���̒l��D�悷��B
    if isnan(WallUvalue(iWALL))
        WallUvalueList = [WallUvalueList; 1/R];
    else
        WallUvalueList = [WallUvalueList; WallUvalue(iWALL)];
    end
    
end


%% ���d�l�̌v�Z

% �����̃��X�g
WindowNameList = confG(:,1);

for iWIND = 1:size(confG,1)
    
    switch DBWCONMODE
        case {'newHASP'}
            
            % ���̎��
            if strcmp(confG(iWIND,2),'SNGL')
                startNum = 2;
            elseif strcmp(confG(iWIND,2),'DL06')
                startNum = 110;
            elseif strcmp(confG(iWIND,2),'DL12')
                startNum = 298;
            end
            
            % �u���C���h�̎��
            if strcmp(confG(iWIND,4),'0')
                blindnum = 3;
            elseif strcmp(confG(iWIND,4),'1')
                blindnum = 6;
            elseif strcmp(confG(iWIND,4),'2')
                blindnum = 9;
            elseif strcmp(confG(iWIND,4),'3')
                blindnum = 12;
            end
            
            % ����U�l
            WindowUvalueList(iWIND) = perDB_WIND{startNum + str2double(confG{iWIND,3}),blindnum};
            
            % ���̓��ːN����
            WindowMyuList(iWIND)    = 0.88 * (perDB_WIND{startNum + str2double(confG{iWIND,3}),blindnum+1} + ...
                perDB_WIND{startNum + str2double(confG{iWIND,3}),blindnum+2} );
            
            % ����SCC(�Օ��W��)
            WindowSCCList(iWIND)    = perDB_WIND{startNum + str2double(confG{iWIND,3}),blindnum+1};
            % ����SCR(�Օ��W��)
            WindowSCRList(iWIND)    = perDB_WIND{startNum + str2double(confG{iWIND,3}),blindnum+2};
            
            
        case {'Regulation'}
            
            % ���ԍ�����ł���΃G���[
            if isnan(confG{iWIND,3})
                error('���ԍ����s���ł�')
            end
            
            % U�l
            if isnan(WindowUvalue(iWIND))
                % �f�[�^�x�[�X���Q��
                if strcmp(confG(iWIND,4),'0')  % �u���C���h�Ȃ�
                    % ����U�l
                    WindowUvalueList(iWIND) = perDB_WIND{str2double(confG(iWIND,3)),5};
                elseif strcmp(confG(iWIND,4),'1')  % �u���C���h����
                    % ����U�l
                    WindowUvalueList(iWIND) = perDB_WIND{str2double(confG(iWIND,3)),6};
                end
            else
                % ����U�l�����ړ��͂���Ă���΁A���̒l��D�悷��B
                WindowUvalueList(iWIND) = WindowUvalue(iWIND);
            end
            
            % �ʒl
            if isnan(WindowMvalue(iWIND))
                % �f�[�^�x�[�X���Q��
                if strcmp(confG(iWIND,4),'0')  % �u���C���h�Ȃ�
                    % ���̓��ːN����
                    WindowMyuList(iWIND) = perDB_WIND{str2double(confG(iWIND,3)),7};
                elseif strcmp(confG(iWIND,4),'1')  % �u���C���h����
                    % ���̓��ːN����
                    WindowMyuList(iWIND) = perDB_WIND{str2double(confG(iWIND,3)),8};
                end
            else
                % ����M�l�����ړ��͂���Ă���΁A���̒l��D�悷��B
                WindowMyuList(iWIND) = WindowMvalue(iWIND);
            end
            
            % �Օ��W���iSCC�ɉ������ށj
            WindowSCCList(iWIND) = WindowMyuList(iWIND)./0.88;
            WindowSCRList(iWIND) = 0;
            
    end
end

