% mytfunc_calcK.m
%----------------------------------------------------------------------------
% �ǁE���ɂ��āA���M�ї����Ɠ��˔M�擾�������߂�B
%----------------------------------------------------------------------------
% �i���́j
% DBWCONMODE    : ���ރf�[�^�x�[�X���[�h�i'newHASP' or 'Regulation'�j
% confW         : �ǂ̑w�\��
% confG         : ���̍\���i���́A����ށA���ԍ��A�u���C���h�̗L���j
% WallUvalue    : �ǂ̔M�ї����i���͂���Ă���ꍇ�j
% WindowUvalue  : ���̔M�ї����i���͂���Ă���ꍇ�j
% WindowMvalue  : ���̓��˔M�擾���i���͂���Ă���ꍇ�j
% �i�o�́j
% WallNameList     : �ǖ��̃��X�g
% WallUvalueList   : �ǂ̔M�ї����̃��X�g
% WindowNameList   : �J�������̂̃��X�g
% WindowUvalueList : ���̔M�ї����̃��X�g
% WindowMyuList    : ���̓��˔M�擾���̃��X�g
%----------------------------------------------------------------------------
function [WallNameList,WallUvalueList,WindowNameList,WindowUvalueList,WindowMyuList,...
    WindowSCCList,WindowSCRList] = ...
    mytfunc_calcK(DBWCONMODE,confW,confG,WallUvalue,WindowUvalue,WindowMvalue)


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
DB_WIND = textread('./database/WindowHeatTransferPerformance_H28.csv','%s','delimiter','\n','whitespace','');

% ���ʂ̊i�[ perDB_WCON(�ޗ��ԍ��A�P�ʁA�M�`�����A�e�ϔ�M)
for i=1:length(DB_WIND)
    conma = strfind(DB_WIND{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_WIND{i,j} = (DB_WIND{i}(1:conma(j)-1));
        elseif j == length(conma)
            perDB_WIND{i,j}   = (DB_WIND{i}(conma(j-1)+1:conma(j)-1));
            perDB_WIND{i,j+1} = (DB_WIND{i}(conma(j)+1:end));
        else
            perDB_WIND{i,j} = (DB_WIND{i}(conma(j-1)+1:conma(j)-1));
        end
    end
end


%% �ǂ̔M�ї���

% �O�ǖ��̃��X�g
WallNameList = confW(:,1);

% �O�ǂ�U�l�v�Z
WallUvalueList = [];
for iWALL = 1:size(confW,1)
    
    % ��񔲏o
    tmp = str2double(confW(iWALL,3:end));
    
    %     R = 1/9 + 1/23;
    R = 0.11 + 0.04;
    
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


%% ���̔M�ї����Ɠ��˔M�擾���̌v�Z

WindowNameList = confG(:,1);               % �����̃��X�g
WindowUvalueList = zeros(size(confG,1),1); % ���̔M�ї���
WindowMyuList = zeros(size(confG,1),1);    % ���̔M�ї���

for iWIND = 1:size(confG,1)
    
    % ���̔M�ї����Ɠ��˔M�擾�������͂���Ă���ꍇ�i���[�g�R�A�S�j
    if isnan(WindowUvalue(iWIND)) == 0  && isnan(WindowMvalue(iWIND)) == 0
        
        if strcmp(confG(iWIND,4),'0')  % �u���C���h��
            
            WindowUvalueList(iWIND) = WindowUvalue(iWIND);
            WindowMyuList(iWIND) = WindowMvalue(iWIND);
            
        elseif strcmp(confG(iWIND,4),'1')
            
            % �K���X�̔M�ї����Ɠ��˔M�擾�������͂���Ă���ꍇ�́A�u���C���h�̌��ʂ�������
            if strcmp(confG(iWIND,5),'Null') == 0 && strcmp(confG(iWIND,6),'Null') == 0
                
                Ug = str2double(confG(iWIND,5));
                Mg = str2double(confG(iWIND,6));
                Ufg = WindowUvalue(iWIND);
                Mfg = WindowMvalue(iWIND);
                
                dR   = 0.021/Ug + 0.022;  % �u���C���h
                WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����
                
                Mgs = -0.1331 * Mg^2 + 0.8258 * Mg;  % �u���C���h
                WindowMyuList(iWIND) = (Mfg/Mg) * Mgs;   % �u���C���h �{ ����
                
            else
                WindowUvalueList(iWIND) = WindowUvalue(iWIND);
                WindowMyuList(iWIND) = WindowMvalue(iWIND);
            end
            
        end
        
    else
        
        % �K���X�L�������͂���Ă���ꍇ�i���[�g�P�j
        if strcmp(confG(iWIND,3),'Null') == 0
            
            % �f�[�^�x�[�X������
            iDBfind = NaN;
            for iDB = 3:size(perDB_WIND,1)
                if strcmp(perDB_WIND(iDB,1),confG(iWIND,3))
                    iDBfind  = iDB;
                end
            end
            
            if isnan(iDBfind)
                error('�K���X�L�����s���ł�')
            else
                
                if strcmp(confG(iWIND,2),'resin') && strcmp(confG(iWIND,4),'0')  % �����A�u���C���h��
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,3));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,5));
                elseif strcmp(confG(iWIND,2),'resin') && strcmp(confG(iWIND,4),'1')  % �����A�u���C���h�L
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,4));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,6));
                elseif strcmp(confG(iWIND,2),'complex') && strcmp(confG(iWIND,4),'0')  % �����A�u���C���h��
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,7));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,9));
                elseif strcmp(confG(iWIND,2),'complex') && strcmp(confG(iWIND,4),'1')  % �����A�u���C���h�L
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,8));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,10));
                elseif strcmp(confG(iWIND,2),'aluminum') && strcmp(confG(iWIND,4),'0')  % �A���~�A�u���C���h��
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,11));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,13));
                elseif strcmp(confG(iWIND,2),'aluminum') && strcmp(confG(iWIND,4),'1')  % �A���~�A�u���C���h�L
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,12));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,14));
                else
                    error('�����ނ̓��͂��s���ł�')
                end
                
            end
            
        else
            
            % �K���X�̔M�ї����Ɠ��˔M�擾�������͂���Ă���ꍇ�i���[�g�Q�j
            if strcmp(confG(iWIND,5),'Null') == 0 && strcmp(confG(iWIND,6),'Null') == 0
                
                Ug = str2double(confG(iWIND,5));
                Mg = str2double(confG(iWIND,6));
                
                if strcmp(confG(iWIND,2),'resin') && strcmp(confG(iWIND,4),'0')  % �����A�u���C���h��
                    
                    dR   = 0;  % �u���C���h
                    Ufg  = 0.6435 * Ug + 1.0577;  % ����i�����j
                    WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����i�����j
                    
                    Mgs =  Mg;  % �u���C���h
                    WindowMyuList(iWIND) = 0.72 * Mgs;   % �u���C���h �{ ����i�����j

                   
                elseif strcmp(confG(iWIND,2),'resin') && strcmp(confG(iWIND,4),'1')  % �����A�u���C���h�L
                    
                    dR   = 0.021/Ug + 0.022;  % �u���C���h
                    Ufg  = 0.6435 * Ug + 1.0577;  % ����i�����j
                    WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����i�����j
                    
                    Mgs = -0.1331 * Mg^2 + 0.8258 * Mg;  % �u���C���h
                    WindowMyuList(iWIND) = 0.72 * Mgs;   % �u���C���h �{ ����i�����j
                    
                elseif strcmp(confG(iWIND,2),'complex') && strcmp(confG(iWIND,4),'0')  % �����A�u���C���h��

                    dR   = 0;  % �u���C���h
                    Ufg  = 0.7623 * Ug + 1.2363;  % ����i�����j
                    WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����i�����j
                    
                    Mgs =  Mg;  % �u���C���h
                    WindowMyuList(iWIND) = 0.80 * Mgs;   % �u���C���h �{ ����
                    
                elseif strcmp(confG(iWIND,2),'complex') && strcmp(confG(iWIND,4),'1')  % �����A�u���C���h�L

                    dR   = 0.021/Ug + 0.022;  % �u���C���h
                    Ufg  = 0.7623 * Ug + 1.2363;  % ����i�����j
                    WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����i�����j
                    
                    Mgs = -0.1331 * Mg^2 + 0.8258 * Mg;  % �u���C���h
                    WindowMyuList(iWIND) = 0.80 * Mgs;   % �u���C���h �{ ����i�����j
                    
                elseif strcmp(confG(iWIND,2),'aluminum') && strcmp(confG(iWIND,4),'0')  % �A���~�A�u���C���h��

                    dR   = 0;  % �u���C���h
                    Ufg  = 0.7699 * Ug + 1.5782;  % ����i�A���~�j
                    WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����i�A���~�j
                    
                    Mgs =  Mg;  % �u���C���h
                    WindowMyuList(iWIND) = 0.80 * Mgs;   % �u���C���h �{ ����i�A���~�j
                    
                elseif strcmp(confG(iWIND,2),'aluminum') && strcmp(confG(iWIND,4),'1')  % �A���~�A�u���C���h�L

                    dR   = 0.021/Ug + 0.022;  % �u���C���h
                    Ufg  = 0.7699 * Ug + 1.5782;  % ����i�A���~�j
                    WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % �u���C���h �{ ����i�A���~�j
                    
                    Mgs = -0.1331 * Mg^2 + 0.8258 * Mg;  % �u���C���h
                    WindowMyuList(iWIND) = 0.80 * Mgs;   % �u���C���h �{ ����i�A���~�j
                    
                else
                    error('�����ނ̓��͂��s���ł�')
                end
                
            else
                error('�K���X�̕����l�̓��͂��s���ł�')
            end
            
        end
    end

% �Օ��W���iSCC�ɉ������ށj
WindowSCCList(iWIND) = WindowMyuList(iWIND)./0.88;
WindowSCRList(iWIND) = 0;

end

