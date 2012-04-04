% mytfunc_weathdataRead.m
%                                                                                by Masato Miyata 2011/10/15
%-----------------------------------------------------------------------------------------------------------
% �C�ۃf�[�^��ǂݍ���ŉ��x�C���x�C�G���^���s�[�����߁C
% �����ρE�����ρE�镽�ρE���n��@�́@4��ށ@�̋C�ۃf�[�^���쐬����D
%-----------------------------------------------------------------------------------------------------------
% ����
%   filename�F�C�ۃf�[�^�t�@�C����
% �o��
%   OAdataAll�F�����ς̋C�ۃf�[�^�i365�~���x�E���x�E�M�ʁj
%   OAdataDay�F�����ς̋C�ۃf�[�^�i365�~���x�E���x�E�M�ʁj
%   OAdataNgt�F�镽�ς̋C�ۃf�[�^�i365�~���x�E���x�E�M�ʁj
%   OAdataHourly�F�����ʋC�ۃf�[�^�i8760�~���x�E���x�E�M�ʁj
%-----------------------------------------------------------------------------------------------------------

function [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead(filename)

% �C�ۃf�[�^�ǂݍ��݁inewHASP���f���o�����t�@�C����ǂݍ��ށj
weathDataALL = csvread(filename,1,1);

% �����ʃf�[�^�̐���
OAdataHourly(:,1) = weathDataALL(:,6);       % �O�C���x�̎����ʃf�[�^ [��]
OAdataHourly(:,2) = weathDataALL(:,7)./1000; % �O�C���x�̎����ʃf�[�^ [kg/kgDA]
for hh=1:8760
    % �G���^���s�[�̎����ʃf�[�^ [kJ/kgDA]
    OAdataHourly(hh,3) = mytfunc_enthalpy(OAdataHourly(hh,1),OAdataHourly(hh,2));
end


% �����ω�
for type=1:3
    
    OAdataD = zeros(365,3);
    for dd = 1:365
        if type == 1 % ������
            OAdataD(dd,1) = mean(OAdataHourly(24*(dd-1)+1:24*(dd-1)+24,1)); % ���x
            OAdataD(dd,2) = mean(OAdataHourly(24*(dd-1)+1:24*(dd-1)+24,2)); % ���x
            OAdataD(dd,3) = mean(OAdataHourly(24*(dd-1)+1:24*(dd-1)+24,3)); % �M��
        elseif type == 2 % ������
            OAdataD(dd,1) = mean(OAdataHourly(24*(dd-1)+7:24*(dd-1)+18,1)); % ���x
            OAdataD(dd,2) = mean(OAdataHourly(24*(dd-1)+7:24*(dd-1)+18,2)); % ���x
            OAdataD(dd,3) = mean(OAdataHourly(24*(dd-1)+7:24*(dd-1)+18,3)); % �M��
        elseif type == 3 % ��ԕ���
            OAdataD(dd,1) = mean(OAdataHourly([24*(dd-1)+1:24*(dd-1)+6,24*(dd-1)+19:24*(dd-1)+24],1)); % ���x
            OAdataD(dd,2) = mean(OAdataHourly([24*(dd-1)+1:24*(dd-1)+6,24*(dd-1)+19:24*(dd-1)+24],2)); % ���x
            OAdataD(dd,3) = mean(OAdataHourly([24*(dd-1)+1:24*(dd-1)+6,24*(dd-1)+19:24*(dd-1)+24],3)); % �M��
        end
    end
    
    if type == 1
        OAdataAll = OAdataD; % ������
    elseif type == 2
        OAdataDay = OAdataD; % ������
    elseif type == 3
        OAdataNgt = OAdataD; % �镽��
    end
end


end

