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
    mytfunc_calcK(DBWCONMODE,perDB_WCON,perDB_WIND,confW,confG,WallUvalue,WindowUvalue,WindowMvalue)


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
WindowMyuList = zeros(size(confG,1),1);    % ���̓��˔M�擾��

for iWIND = 1:size(confG,1)
    
    % ���̔M�ї����Ɠ��˔M�擾�������͂���Ă���ꍇ�i���[�g�R�A�S�j
    if isnan(WindowUvalue(iWIND)) == 0  && isnan(WindowMvalue(iWIND)) == 0
        
        if strcmp(confG(iWIND,4),'0')  % �u���C���h��
            
            WindowUvalueList(iWIND) = WindowUvalue(iWIND);
            WindowMyuList(iWIND) = WindowMvalue(iWIND);
            
        elseif strcmp(confG(iWIND,4),'1')  % �u���C���h�L
            
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
                
                if (strcmp(confG(iWIND,2),'resin')||strcmp(confG(iWIND,2),'resin_single')||strcmp(confG(iWIND,2),'resin_double')) && strcmp(confG(iWIND,4),'0')  % �����A�u���C���h��
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,3));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,5));
                elseif (strcmp(confG(iWIND,2),'resin')||strcmp(confG(iWIND,2),'resin_single')||strcmp(confG(iWIND,2),'resin_double')) && strcmp(confG(iWIND,4),'1')  % �����A�u���C���h�L
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,4));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,6));
                elseif (strcmp(confG(iWIND,2),'complex')||strcmp(confG(iWIND,2),'complex_single')||strcmp(confG(iWIND,2),'complex_double')) && strcmp(confG(iWIND,4),'0')  % �����A�u���C���h��
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,7));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,9));
                elseif (strcmp(confG(iWIND,2),'complex')||strcmp(confG(iWIND,2),'complex_single')||strcmp(confG(iWIND,2),'complex_double')) && strcmp(confG(iWIND,4),'1')  % �����A�u���C���h�L
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,8));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,10));
                elseif (strcmp(confG(iWIND,2),'aluminum')||strcmp(confG(iWIND,2),'aluminum_single')||strcmp(confG(iWIND,2),'aluminum_double')) && strcmp(confG(iWIND,4),'0')  % �A���~�A�u���C���h��
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,11));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,13));
                elseif (strcmp(confG(iWIND,2),'aluminum')||strcmp(confG(iWIND,2),'aluminum_single')||strcmp(confG(iWIND,2),'aluminum_double')) && strcmp(confG(iWIND,4),'1')  % �A���~�A�u���C���h�L
                    WindowUvalueList(iWIND) = str2double(perDB_WIND(iDBfind,12));
                    WindowMyuList(iWIND)    = str2double(perDB_WIND(iDBfind,14));
                else
                    error('�����ނ̓��͂��s���ł�')
                end
                
            end
            
        else
            
            % �K���X�̔M�ї����Ɠ��˔M�擾�������͂���Ă���ꍇ�i���[�g�Q�j
            if strcmp(confG(iWIND,5),'Null') == 0 && strcmp(confG(iWIND,6),'Null') == 0
                
                Ug = str2double(confG(iWIND,5)); % �K���X�̔M�ї���
                Mg = str2double(confG(iWIND,6)); % �K���X�̓��˔M�擾��
                
                % �u���C���h�̔M��R�Ɠ��˔M�擾��
                if strcmp(confG(iWIND,4),'0') 
                    dR  =  0;
                    Mgs =  Mg;  % ���˔M�擾��
                elseif strcmp(confG(iWIND,4),'1')
                    dR   = 0.021/Ug + 0.022;
                    Mgs  = -0.1331 * Mg^2 + 0.8258 * Mg;  % ���˔M�擾��
                end
                
                % �W��
                if strcmp(confG(iWIND,2),'resin_single') || strcmp(confG(iWIND,2),'wood_single')
                    kua = 1.531000/2.325000;
                    kub = 1.888926/2.325000;
                    kita = 0.72;
                elseif strcmp(confG(iWIND,2),'resin_double') || strcmp(confG(iWIND,2),'wood_double') || strcmp(confG(iWIND,2),'resin') 
                    kua = 1.531000/2.325000;
                    kub = 2.398526/2.325000;
                    kita = 0.72;
                elseif strcmp(confG(iWIND,2),'wood_aluminum_complex_single') || strcmp(confG(iWIND,2),'resin_aluminum_complex_single')
                    kua = 1.853000/2.317000;
                    kub = 2.026288/2.317000;
                    kita = 0.80;
                elseif strcmp(confG(iWIND,2),'wood_aluminum_complex_double') || strcmp(confG(iWIND,2),'resin_aluminum_complex_double') ||strcmp(confG(iWIND,2),'complex')
                    kua = 1.853000/2.317000;
                    kub = 2.659888/2.317000;
                    kita = 0.80;
                elseif strcmp(confG(iWIND,2),'aluminum_single')
                    kua = 1.883000/2.321000;
                    kub = 3.218862/2.321000;
                    kita = 0.80;
                elseif strcmp(confG(iWIND,2),'aluminum_double') || strcmp(confG(iWIND,2),'aluminum')
                    kua = 1.883000/2.321000;
                    kub = 3.498862/2.321000;
                    kita = 0.80;
                end
                
                Ufg  = kua * Ug + kub;  % ����U�l�i�u���C���h�Ȃ��j
                
                WindowUvalueList(iWIND) = 1/(1/Ufg + dR);  % ����U�l�i�u���C���h���݁j
                
                WindowMyuList(iWIND) = kita * Mgs;  % ���̃Œl�i�u���C���h���݁j
                
  
            else
                error('�K���X�̕����l�̓��͂��s���ł�')
            end
            
        end
    end

% �Օ��W���iSCC�ɉ������ށj
WindowSCCList(iWIND) = WindowMyuList(iWIND)./0.88;
WindowSCRList(iWIND) = 0;

end

