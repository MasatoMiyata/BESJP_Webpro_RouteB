% mytfunc_calcOALoad.m
%                                      by Masato Miyata 2012/03/02
%------------------------------------------------------------------
% �O�C���ׁA�O�C��[���ʂȂǂ��Z�o����B
%------------------------------------------------------------------
function [qoaAHU,AHUVovc,Qahu_oac,qoaAHU_CEC] = mytfunc_calcOALoad(ModeOperation,QroomAHUc,Tahu_c,ahuVoa,ahuVsa,...
    HoaDayAve,Hroom,AHUsystemT,ahuaexeff,AEXbypass,ahuOAcool,ahuaexV)


%% �O�C���ׂ̎Z�o
if AHUsystemT == 0
    
    % ��OFF���͊O�C�������Ȃ�
    qoaAHU   = 0;
    AHUVovc  = 0;
    Qahu_oac = 0;
    qoaAHU_CEC = 0;
    
else
    
    % �S�M�����@���� [m3/h] �� [kg/s]
    if ahuaexV*1.293/3600 > ahuVoa
        ahuaexV = ahuVoa;
    elseif ahuaexV <= 0
        ahuaexV = 0;
    else
        ahuaexV = ahuaexV*1.293/3600;
    end
    
    % �O�C���ׂ̎Z�o
    if ModeOperation == -1  % �g�[��
        
        if HoaDayAve > Hroom && AEXbypass == 1
            % �o�C�p�X�L�̏ꍇ�͂��̂܂܊O�C��������B
            qoaAHU = (HoaDayAve-Hroom).*ahuVoa;
        else
            qoaAHU = (HoaDayAve-Hroom).*(ahuVoa-ahuaexV.*ahuaexeff);
        end
        
    elseif ModeOperation == 1 % ��[��
        
        if HoaDayAve < Hroom && AEXbypass == 1
            % �o�C�p�X�L�̏ꍇ�͂��̂܂܊O�C��������B
            qoaAHU = (HoaDayAve-Hroom).*ahuVoa;
        else
            qoaAHU = (HoaDayAve-Hroom).*(ahuVoa-ahuaexV.*ahuaexeff);
        end
        
    else
        error('�^�]���[�h���s���ł�')
    end
    
    % ���z�O�C���� [kW] = [kJ/kgDA * kg/s]
    qoaAHU_CEC = (HoaDayAve-Hroom).*ahuVoa;
    
    % �O�C��[���ʂ̐���
    if ahuOAcool == 1 && Tahu_c>0 % �O�C��[ON�ŗ�[�^�]������Ă�����
        
        % �O�C��[���̕��� [kg/s]
        AHUVovc = QroomAHUc / ((Hroom-HoaDayAve)*(3600/1000)*Tahu_c);
        
        % ����E����
        if AHUVovc < ahuVoa
            AHUVovc = ahuVoa; % �����i�O�C����ʁj
        elseif AHUVovc > ahuVsa*1.293/3600
            AHUVovc = ahuVsa*1.293/3600; % ����i���C���� [m3/h]��[kg/s]�j
        end
        
        % �K�v�O�C�ʁi�O�C��[���̂݁j[kW]
        AHUVovc = AHUVovc - ahuVoa;
    else
        AHUVovc = 0;
    end
    
    % �O�C��[���� [MJ/day]
    if ahuOAcool == 1
        if AHUVovc > 0 % �O�⎞���ʁ��O�ł����
            Qahu_oac = AHUVovc*(Hroom-HoaDayAve)*3600/1000*Tahu_c;
        else
            Qahu_oac = 0;
        end
    else
        Qahu_oac = 0;
    end
    
end

