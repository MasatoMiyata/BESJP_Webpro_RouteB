clear

addpath('./subfunction')

% �f�[�^�x�[�X�ǂݍ���
mytscript_readDBfiles;

climateAREASET = {'1','2','3','4','5','6','7','8'};

TallDailyAve   = zeros(8,365);
TallMonthlyAve = zeros(8,12);

for C = 1:8
    
    % �n��敪
    climateAREA = climateAREASET{C};
    
    check = 0;
    for iDB = 1:length(perDB_climateArea(:,2))
        if strcmp(perDB_climateArea(iDB,1),climateAREA) || strcmp(perDB_climateArea(iDB,2),climateAREA)
            % �C�ۃf�[�^�t�@�C����
            eval(['climatedatafile  = ''./weathdat/C1_',perDB_climateArea{iDB,6},''';'])
            check = 1;
        end
    end
    if check == 0
        error('�n��敪���s���ł�')
    end
    
    % ���˃f�[�^�ǂݍ���
    [Tall,Xall,IodALL,IosALL,InnALL] = mytfunc_climatedataRead(climatedatafile);
    
    % �����ϊO�C���x
    TallDailyAve(C,:) = mean(Tall,2);
    
    % �����ϊO�C���x
    TallMonthlyAve(C,1)  = mean(TallDailyAve(C,1:31));     % 1��
    TallMonthlyAve(C,2)  = mean(TallDailyAve(C,32:59));    % 2��
    TallMonthlyAve(C,3)  = mean(TallDailyAve(C,60:90));    % 3��
    TallMonthlyAve(C,4)  = mean(TallDailyAve(C,91:120));   % 4��
    TallMonthlyAve(C,5)  = mean(TallDailyAve(C,121:151));  % 5��
    TallMonthlyAve(C,6)  = mean(TallDailyAve(C,152:181));  % 6��
    TallMonthlyAve(C,7)  = mean(TallDailyAve(C,182:212));  % 7��
    TallMonthlyAve(C,8)  = mean(TallDailyAve(C,213:243));  % 8��
    TallMonthlyAve(C,9)  = mean(TallDailyAve(C,244:273));  % 9��
    TallMonthlyAve(C,10) = mean(TallDailyAve(C,274:304));  % 10��
    TallMonthlyAve(C,11) = mean(TallDailyAve(C,305:334));  % 11��
    TallMonthlyAve(C,12) = mean(TallDailyAve(C,335:365));  % 12��
    
    
    % HDD(18-18)
    HDD18 = 0;
    for dd = 1:size(Tall,1)
        if TallDailyAve(C,dd) <= 18
            HDD18 = HDD18 + (18 - TallDailyAve(C,dd));
        end
    end
    
    % CDD(24-24)
    CDD24 = 0;
    for dd = 1:size(Tall,1)
        if TallDailyAve(C,dd) > 24
            CDD24 = CDD24 +(TallDailyAve(C,dd) - 24);
        end
    end
    
    % �o��
    eval(['disp(''�n�� ',climateAREA,'�@�F�@��[�x�� CDD24-24�@',int2str(CDD24),''')'])
    eval(['disp(''�n�� ',climateAREA,'�@�F�@�g�[�x�� HDD18-18�@',int2str(HDD18),''')'])

end




