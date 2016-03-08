% mytfunc_climatedataCalc.m
%--------------------------------------------------------------------------
% �C�ۃf�[�^����O�C���A���˗ʂȂǂ��v�Z
% �o��
% y: ���ώZ���˗� [Wh/m2]
% y_ita�F���ˊp�������̓��ώZ���˗ʁi0.89�Ŋ���ς݁j [Wh/m2]
%--------------------------------------------------------------------------

function [y,yita] = mytfunc_climatedataCalc(phi,longi,ToutALL,XouALL,IodALL,IosALL,InnALL)

% �e�X�g�p
% filename = './weathdat/C1_6158195.has';
% [ToutALL,XouALL,IodALL,IosALL,InnALL] = mytfunc_climatedataRead(filename);
% phi   = 34.658;
% longi = 133.918;

y    = zeros(365,22);


% �����ϊO�C���x [��]
y(:,4) = mean(ToutALL,2);
y(:,5) = mean(ToutALL(:,7:18),2);  % 7�`18��
y(:,6) = mean(ToutALL(:,[1:6,19:24]),2);  % 19������6��

% �����ϐ�Ύ��x [g/kgDA]
y(:,7) = mean(XouALL,2).*1000;
y(:,8) = mean(XouALL(:,7:18),2).*1000;  % 7�`18��
y(:,9) = mean(XouALL(:,[1:6,19:24]),2).*1000;  % 19������6��

% ���ˊp�������̒l�̊i�[�p�ϐ�
yita = y;


% ���˗�

% �����烉�W�A���ւ̕ϊ��W��
rad    = 2*pi/360;
% �e���̓���
DAYMAX = [31,28,31,30,31,30,31,31,30,31,30,31];


go    = 1;


for alp = [0,45,90,135,180,225,270,315,360] % ���˗ʂ����߂�ʂ̕��ʊp
    
    % ���˗ʂ����߂�ʂ̌X�Ίp
    if alp == 360
        bet = 0;  % �����ʁi�Ō�̃��[�v�j
    else
        bet = 90;  % �����ʁi�Ō�̃��[�v�ȊO�j
    end
    
    Id = zeros(365,24);
    Id_ita = zeros(365,24);
    Is = zeros(365,24);
    ita = zeros(365,24);
    
    % �ʎZ����(1/1��1�A12/31��365)
    DN = 0;
    
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
                
                tmp(DN,hour)=sinh2;
                
                % ���ˊp����
                ita(DN,hour) = 2.392 * sinh2 - 3.8636 * sinh2^3 + 3.7568 * sinh2^5 - 1.3952 * sinh2^7;
                
                % �X�Ζʓ��˓��˗�(���B���˗�)�iW/m2�j
                Id(DN,hour) = go * Iod * sinh2;
                
                % �X�Ζʓ��˓��˗�(���B���˗�)�iW/m2�j�@���ˊp�������݁i0.89�ŏ����Ċ���ς݁j
                Id_ita(DN,hour) = go * Iod * sinh2 * ita(DN,hour)/0.89;
                
                % �X�Ζʓ��˓��˗�(�V����˗�)�iW/m2�j
                if bet == 90
                    Is(DN,hour) = 0.5*Ios + 0.1*0.5*(Ios + Iod*sinh);
                elseif bet == 0
                    Is(DN,hour) = Ios;
                end
                
            end
        end
    end
    
    % ���g������
    if bet == 90
        Insr = sum(InnALL,2)/2;
    elseif bet == 0
        Insr = sum(InnALL,2);
    end
    
    if alp == 0  % ��
        y(:,10) = sum(Id,2);
        yita(:,10) = sum(Id_ita,2);
        y(:,19) = sum(Is,2);
        yita(:,19) = sum(Is,2);
        y(:,21) = sum(Insr,2);
        yita(:,21) = sum(Insr,2);
    elseif alp == 45
        y(:,11) = sum(Id,2);
        yita(:,11) = sum(Id_ita,2);
    elseif alp == 90
        y(:,12) = sum(Id,2);
        yita(:,12) = sum(Id_ita,2);
    elseif alp == 135
        y(:,13) = sum(Id,2);
        yita(:,13) = sum(Id_ita,2);
    elseif alp == 180
        y(:,14) = sum(Id,2);
        yita(:,14) = sum(Id_ita,2);
    elseif alp == 225
        y(:,15) = sum(Id,2);
        yita(:,15) = sum(Id_ita,2);
    elseif alp == 270
        y(:,16) = sum(Id,2);
        yita(:,16) = sum(Id_ita,2);
    elseif alp == 315
        y(:,17) = sum(Id,2);
        yita(:,17) = sum(Id_ita,2);
    elseif alp == 360  % ����
        y(:,18) = sum(Id,2);
        yita(:,18) = sum(Id_ita,2);
        y(:,20) = sum(Is,2);
        yita(:,20) = sum(Is,2);
        y(:,22) = sum(Insr,2);
        yita(:,22) = sum(Insr,2);
    end
    
    
end

