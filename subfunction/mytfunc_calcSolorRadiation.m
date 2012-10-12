% mytfunc_calcSolorRadiation.m
%                                                 by Masato Miyata 2012/10/12
%-----------------------------------------------------------------------------
% ���˗ʂ����߂�v���O����
% 
% ����
% climatedatafile : �C�ۃf�[�^�̃t�@�C����
% phi             : �ܓx
% longi           : �o�x
% alp             : ���˗ʂ����߂�ʂ̕��ʊp
% bet             : ���˗ʂ����߂�ʂ̌X�Ίp
% go              : ���˗ʂ����߂�ʂ̒��B���ˏƎ˗� [-]
%-----------------------------------------------------------------------------
function [dailyIds,hourlyIds] = mytfunc_calcSolorRadiation(IodALL,IosALL,InnALL,phi,longi,alp,bet,go)

% % �C�ۃf�[�^�t�@�C����
% climatedatafile  = './weathdat/C1_6158195.has';
% �C�ۃf�[�^�ǂݍ���
% [~,~,IodALL,IosALL,InnALL] = mytfunc_climatedataRead(climatedatafile);
% phi   = 34.658;
% longi = 133.918;
% alp   = 0;
% bet   = 30;
% go    = 1;

% �萔
% gs     = 0.808;     % �V����˂̓��˔M�擾�� [-]
rhoG  = 0.8;
rad    = 2*pi/360;  % �����烉�W�A���ւ̕ϊ��W��

%% �X�Ζʂ̓��˗ʌv�Z

% �e���̓���
DAYMAX = [31,28,31,30,31,30,31,31,30,31,30,31];
% �ʎZ����(1/1��1�A12/31��365)
DN = 0;

% ���ώZ���˗�
Id = zeros(365,24);
Is = zeros(365,24);
In = zeros(365,24);
gt = zeros(365,24);
dailyIds = zeros(365,1);

for month = 1:12
    for day = 1:DAYMAX(month)
        
        % �����J�E���g
        DN = DN + 1;
        
        for hour = 1:24
            
            % ���˗� [W/m2]
            Iod  = IodALL(DN,hour); % �@���ʒ��B���˗� [W/m2]
            Ios  = IosALL(DN,hour); % �����ʓV����˗� [W/m2]
            Ion  = InnALL(DN,hour); % �����ʖ�ԕ��˗� [W/m2]
            
            % �����W���������߂�
            t = hour + 0 / 60;
            % ���Ԉ܂����߂�(HASP���ȏ�P24(2-22)�Q��)
            del = del04(month,day);
            % �ώ��������߂�
            e = eqt04(month,day);
            % ���p�����߂�
            Tim = (15.0 * t + 15.0 * e + longi - 315.0) * rad;
            
            sinPhi = sin(deg2rad(phi)); % �ܓx�̐���
            cosPhi = cos(deg2rad(phi)); % �ܓx�̗]��
            sinAlp = sin(alp * rad);    % ���ʊp����
            cosAlp = cos(alp * rad);    % ���ʊp�]��
            sinBet = sin(bet * rad);    % �X�Ίp����
            cosBet = cos(bet * rad);    % �X�Ίp�]��
            sinDel = sin(del);          % ���Ԉ܂̐���
            cosDel = cos(del);          % ���Ԉ܂̗]��
            sinTim = sin(Tim);          % ���p�̐���
            cosTim = cos(Tim);          % ���p�̗]��
            
            % ���z���x�̐��������߂�(HASP���ȏ� P25 (2.25)�Q�� )
            sinh   = sinPhi * sinDel + cosPhi * cosDel * cosTim;
            
            % ���z���x�̗]���A���z���ʂ̐����E�]�������߂�(HASP ���ȏ�P25 (2.25)�Q��)
            cosh   = sqrt(1 - sinh^2);                           % ���z���x�̗]��
            sinA   = cosDel * sinTim / cosh;                     % ���z���ʂ̐���
            cosA   = (sinh * sinPhi - sinDel)/(cosh * cosPhi);   % ���z���ʂ̗]��
            
            % �X�Εǂ��猩�����z���x�����߂�(HASP ���ȏ� P26(2.26)�Q��)
            sinh2  = sinh * cosBet + cosh * sinBet * (cosA * cosAlp + sinA * sinAlp);
            
            if sinh2 < 0
                sinh2 = 0;
            end
            
            % �X�Ζʓ��˓��˗�(���B���˗�)�iW/m2�j
            Id(DN,hour) = go * Iod * sinh2;
            % �X�Ζʓ��˓��˗�(�V����˗�)�iW/m2�j
            Is(DN,hour) = (1+cosBet)/2*Ios + (1-cosBet)/2*rhoG*(Iod*sinh+Ios);
            % �X�Ζʖ�ԕ��˗�
            In(DN,hour) = (1+cosBet)/2*Ion;
            
            % �W���K���X�̒��B���˔M�擾�������߂�i���̎��j�D
            gt(DN,hour) = glassf04(sinh2);
            
            % �Q�l�i�ʂ��猩�����z���x�j
            % DATA(DN,hour) = asin(sinh2)/rad;
            
        end
    
        % ���ώZ���˗� [MJ/m2/day]
        dailyIds(DN,:) =sum(Id(DN,:) + Is(DN,:))*(3600)/1000000;

    end
end

% �����ʓ��˗� [W/m2]
hourlyIds = Id + Is;



