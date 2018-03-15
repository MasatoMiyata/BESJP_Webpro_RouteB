% ECS_routeB_CGSdetail_run.m
%--------------------------------------------------------------------------
% �R�W�F�l�i�ڍהŁj�̌v�Z�v���O����
%--------------------------------------------------------------------------
% % ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
% EAC_total_d = inputdata(:,1);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_c_d = inputdata(:,2);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
% mxLAC_ref_c_d = inputdata(:,3);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_h_hr_d = inputdata(:,4);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
% qAC_ref_h_hr_d = inputdata(:,5);
% % ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
% EV_total_d = inputdata(:,6);
% % ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
% EL_total_d = inputdata(:,7);
% % ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
% EW_total_d = inputdata(:,8);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
% EW_hr_d = inputdata(:,9);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
% qW_hr_d = inputdata(:,10);
% % ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
% EEV_total_d = inputdata(:,11);
% % ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
% EPV_total_d = inputdata(:,12);
% % ���td�ɂ����邻�̑��̓d�͏����	MWh/��
% EM_total_d = inputdata(:,13);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
% TAC_c_d = inputdata(:,14);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
% TAC_h_d = inputdata(:,15);
%--------------------------------------------------------------------------
% % % CGS�̔��d�@�e��	kW
% Ecgs_rated = 370;
% % CGS�ݒu�䐔	��
% Ncgs = 2;
% % CGS�̒�i���d����(��ʔ��M�ʊ)	������
% fcgs_e_rated = 0.41;
% % CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
% fcgs_e_75 = 0.39;
% % CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
% fcgs_e_50 = 0.352;
% % CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_rated = 0.34;
% % CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_75 = 0.367;
% % CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_50 = 0.408;
% % �r�M���p�D�揇��(��M��)�@��1	������
% npri_hr_c = 3;
% % �r�M���p�D�揇��(���M��) �@��1	������
% npri_hr_h = 2;
% % �r�M���p�D�揇��(����) �@��1	������
% npri_hr_w = 1;
% % CGS24���ԉ^�]�̗L���@��2	-
% C24ope = 0;
% % �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% qAC_link_c_j_rated = 1583;
% % �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% EAC_link_c_j_rated = 1217.5;
% % CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
% NAC_ref_link = 2;
% % �����̉^�p���ԑтƔ�^�p���ԑт̕��ϓd�͍�	������
% feopeHi = 10;
%--------------------------------------------------------------------------

function y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
    EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
    qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
    Ecgs_rated,Ncgs,fcgs_e_rated,...
    fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
    npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
    EAC_link_c_j_rated,NAC_ref_link,feopeHi)


%% 2.	�v�Z�ݒ�A���O����

% 2.3 ���̑��ݒ�l

% �^�]�����K�v�d�͔䗦	������
feopeMn	= 0.5;
% �^�]�����K�v�r�M�䗦	������
fhopeMn	=0.5;
% CGS��@���͔䗦	������
fesub_CGS_wc = 0.06; % ��p��������ꍇ
fesub_CGS_ac = 0.05; % ��p�����Ȃ��ꍇ
% �K�X�̍��ʔ��M�ʂɑ΂����ʔ��M�ʂ̔䗦	������
flh	=0.90222;
% �d�C�̈ꎟ�G�l���M�[���Z�W��	MJ/kWh
fprime_e = 9.76;
 % �r�M�����^�z�����≷���@�̔r�M���p����COP	������
fCOP_link_hr = 0.75;
% CGS�ɂ��d�͕��ׂ̍ő啉�S��	������
felmax = 0.95;
% CGS�̕W���ғ����� h/��
Tstn = 14;
% ���d�����␳
fcgs_e_cor = 0.99;
% �r�M�̔M�������̕␳
fhr_loss = 0.97;

% 2.4 CGS�������e�W��
[fe2,fe1,fe0,fhr2,fhr1,fhr0] = perfCURVE(fcgs_e_rated,fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50);

% 2.5 �ő�ғ�����
if C24ope == 1
    T_ST = 24;
else
    T_ST = Tstn;
end


%% 3. ���׏W�v�Ɖ^�]���Ԍv�Z

% 3.1 �d�͕���
% Ee_total_d : ���td�����錚���̓d�͏���� [kWh/day]

Ee_total_d = ( EAC_total_d +EV_total_d + EL_total_d + EW_total_d + EEV_total_d + EM_total_d - EPV_total_d ) .* 1000;


% 3.2 �r�M�����^�����z���≷���@�̔r�M���p�\��
% flink_d : ���td�ɂ�����r�M�����^�z�����≷���@�̔r�M���p�\��

flink_rated_b = 0.15;  % �r�M�����^�z�����≷���@�̒�i�^�]���̔r�M�����\�� [-]
flink_min_b = 0.30;    % �r�M�����^�z�����≷���@���r�M�݂̂ŉ^�]�ł���ő啉�ח� [-]
flink_down = 0.125;  % �r�M���x�ɂ��r�M�����\���̒ቺ�� [-]

flink_rated = flink_rated_b * (1 - flink_down);
flink_min   = flink_min_b - (flink_rated_b - flink_rated);

mx      = zeros(365,1);
flink_d = zeros(365,1);
for dd = 1:365
    
    mx(dd,1) = mxLAC_ref_c_d(dd,1);
    
    if mx(dd,1) < flink_min
        
        flink_d(dd,1) = 1.0;
        
    else
        
        k = (flink_rated - flink_min) / (1 - flink_min);
        
        flink_d(dd,1) = 1 - ( (mx(dd,1) - ( k*mx(dd,1) + flink_rated-k ))/mx(dd,1) );
        
    end
end

% 3.3 ��M���r�M����
% qAC_ref_c_hr_d : ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̔r�M����
% EAC_ref_c_hr_d : ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[����ʂ̂����r�M�ɂ��팸�\��

qAC_ref_c_hr_d = EAC_ref_c_d .* ( sum(qAC_link_c_j_rated) ./ sum(EAC_link_c_j_rated)) .* flink_d ./ fCOP_link_hr; 
EAC_ref_c_hr_d = EAC_ref_c_d .* flink_d;


% 3.4 CGS�n���M����
% qhr_total_d : ���td�ɂ�����CGS�r�M�n���̔M����

qhr_ac_c_d = zeros(365,1);  % ���td�ɂ�����CGS�r�M���p���\�Ȕr�M�����^�z�����≷����i�n���j�̔r�M���� MJ/day
qhr_ac_h_d = zeros(365,1);  % ���td�ɂ�����CGS�r�M���p���\�ȉ��M���̔r�M���� MJ/day
qhr_total_d = zeros(365,1); % ���td�ɂ�����CGS�r�M�n���̔M���� MJ/day

for dd = 1:365
    if TAC_c_d(dd) > T_ST
        qhr_ac_c_d(dd) = qAC_ref_c_hr_d(dd) .* T_ST/TAC_c_d(dd);
    else
        qhr_ac_c_d(dd) = qAC_ref_c_hr_d(dd);
    end
    
    if TAC_h_d(dd) > T_ST
        qhr_ac_h_d(dd) = qAC_ref_h_hr_d(dd) .* T_ST/TAC_h_d(dd);
    else
        qhr_ac_h_d(dd) = qAC_ref_h_hr_d(dd);
    end
    
    qhr_total_d(dd) = qhr_ac_c_d(dd) + qhr_ac_h_d(dd) + qW_hr_d(dd);
    
end

% 3.5 ����̓d�͏���ʂɐ�߂�^�p���ԑт̓d�͏���ʂ̔䗦
% feope_R : ����̓d�͏���ʂɐ�߂�^�p���ԑт̓d�͏���ʂ̔䗦

feope_R = (feopeHi .* T_ST) ./ (feopeHi.*T_ST + (24-T_ST));


% 3.6 CGS�^�]����
% Tcgs_d : ���td�ɂ�����CGS�̉ғ����� [hour/��]
Tcgs_d = zeros(365,1);

% ��@���͔䗦
if Ecgs_rated > 50
    fesub_CGS = fesub_CGS_wc;  % 0.06
else
    fesub_CGS = fesub_CGS_ac;  % 0.05
end
   
for dd = 1:365
    
    % a*b�œd�͊�^�]����
    a = qhr_total_d(dd,1) ./ (Ecgs_rated .* 3.6 .* fhopeMn);
    b = fcgs_e_rated ./ fcgs_hr_rated;   %% �d�l���ł� fcgs,h,rated�ƂȂ��Ă���B
            
    % c/d�Ŕr�M��^�]����
    c = Ee_total_d(dd,1) .* feope_R .* ( 1 + fesub_CGS );
    d = Ecgs_rated .* feopeMn;
        
    if TAC_c_d(dd,1) >= TAC_h_d(dd,1)
        
        if a*b >= T_ST && c/d >= T_ST
            
            Tcgs_d(dd,1) = T_ST;
            
        elseif (a*b >= TAC_c_d(dd,1)) && c/d >= TAC_c_d(dd,1)
            
            Tcgs_d(dd,1) = TAC_c_d(dd,1);
            
        else
            
            Tcgs_d(dd,1) = 0;
            
        end
        
    elseif TAC_c_d(dd,1) < TAC_h_d(dd,1)
        
        if a*b >= T_ST && c/d >= T_ST
            
            Tcgs_d(dd,1) = T_ST;
            
        elseif a*b >= TAC_h_d(dd,1) && c/d >= TAC_h_d(dd,1) 
            
            Tcgs_d(dd,1) = TAC_h_d(dd,1);
            
        else
            
            Tcgs_d(dd,1) = 0;
            
        end
    end
     
end


% 3.7 CGS�^�]���Ԃɂ����镉��

Ee_total_on_d  = Ee_total_d .* feope_R .* Tcgs_d/T_ST;
EW_hr_on_d     = EW_hr_d;
qW_hr_on_d     = qW_hr_d;

EAC_ref_c_hr_on_d = zeros(365,1);
EAC_ref_h_hr_on_d = zeros(365,1);
qAC_ref_c_hr_on_d = zeros(365,1);
qAC_ref_h_hr_on_d = zeros(365,1);
qtotal_hr_on_d    = zeros(365,1);

for dd = 1:365
    
    if TAC_c_d(dd,1) <= Tcgs_d (dd,1)
        EAC_ref_c_hr_on_d(dd,1) = EAC_ref_c_hr_d(dd,1);
        qAC_ref_c_hr_on_d(dd,1) = qAC_ref_c_hr_d(dd,1);
    else
        EAC_ref_c_hr_on_d(dd,1) = EAC_ref_c_hr_d(dd,1) .* Tcgs_d(dd,1)./TAC_c_d(dd,1);
        qAC_ref_c_hr_on_d(dd,1) = qAC_ref_c_hr_d(dd,1) .* Tcgs_d(dd,1)./TAC_c_d(dd,1);
    end
    
    if TAC_h_d(dd,1) <= Tcgs_d (dd,1)
        EAC_ref_h_hr_on_d(dd,1) = EAC_ref_h_hr_d(dd,1);
        qAC_ref_h_hr_on_d(dd,1) = qAC_ref_h_hr_d(dd,1);
    else
        EAC_ref_h_hr_on_d(dd,1) = EAC_ref_h_hr_d(dd,1) .* Tcgs_d(dd,1)./TAC_h_d(dd,1);
        qAC_ref_h_hr_on_d(dd,1) = qAC_ref_h_hr_d(dd,1) .* Tcgs_d(dd,1)./TAC_h_d(dd,1);
    end
    

    qtotal_hr_on_d(dd,1) = qAC_ref_c_hr_on_d(dd,1) + qAC_ref_h_hr_on_d(dd,1) + qW_hr_on_d(dd,1);
    
    
end


% 3.8 CGS�ő�ғ��䐔
for dd = 1:365
    
    if Tcgs_d(dd,1)  == 0
        Ndash_cgs_on_max_d(dd,1) = 0;
    else
        Ndash_cgs_on_max_d(dd,1) = qhr_total_d(dd,1) /( Ecgs_rated * fhopeMn) * fcgs_e_rated /(fcgs_hr_rated * Tcgs_d(dd,1));
    end
    
    if (Ndash_cgs_on_max_d(dd,1) >= Ncgs)
        Ncgs_on_max_d(dd,1) = Ncgs;
    else
        Ncgs_on_max_d(dd,1) = Ndash_cgs_on_max_d(dd,1);
    end
    
end

%% 4. CGS�̌v�Z

% 4.1 ���d�d�͕��ׁ@
% Ee_load_d : ���td������CGS�̔��d�d�͕��� [kWh/day]

Ee_load_d = Ee_total_on_d .* felmax .* ( 1 + fesub_CGS );


% 4.2 �^�]�䐔
% Ndash_cgs_on_d : ���td������CGS�̉^�]�䐔�b��l [��]
Ndash_cgs_on_d = zeros(365,1);

for dd = 1:365
    
    if Tcgs_d(dd,1) > 0
        
        Ndash_cgs_on_d(dd,1) = Ee_load_d(dd,1) ./ (Ecgs_rated .* Tcgs_d(dd,1) );
        
    elseif Tcgs_d(dd,1) == 0
        
        Ndash_cgs_on_d(dd,1) = 0;
        
    end
    
    % Ncgs_on_d : ���td������CGS�̉^�]�䐔 [��]
    if Ndash_cgs_on_d(dd,1) >= Ncgs_on_max_d(dd,1)
        Ncgs_on_d(dd,1) = Ncgs_on_max_d(dd,1);
    elseif Ncgs_on_max_d(dd,1) > Ndash_cgs_on_d(dd,1) && Ndash_cgs_on_d(dd,1) > 0
        Ncgs_on_d(dd,1) = ceil(Ndash_cgs_on_d(dd,1));
    elseif Ndash_cgs_on_d(dd,1) <= 0
        Ncgs_on_d(dd,1) = 0;
    end
    
end

% 4.3 ���d���ח��@
% mxLcgs_d : ���td�ɂ�����CGS�̕��ח� [-]
mxLcgs_d = zeros(365,1);

for dd = 1:365
    
    if Tcgs_d(dd,1) > 0
        
        mxLcgs_d(dd,1) = Ee_load_d(dd,1) ./ (Ecgs_rated .* Tcgs_d(dd,1) .* Ncgs_on_d(dd,1) );
        
        if mxLcgs_d(dd,1) > 1
            mxLcgs_d(dd,1) = 1;
        end
        
    elseif Tcgs_d(dd,1) == 0
        
        mxLcgs_d(dd,1) = 0;
        
    end
    
end

% 4.4 ���d�����A�r�M�������
% mxRe_cgs_d : ���td�ɂ�����CGS�̔��d����(��ʔ��M�ʊ)
% mxRhr_cgs_d : ���td�ɂ�����CGS�̔��d����(��ʔ��M�ʊ)

mxRe_cgs_d  = fe2 .* mxLcgs_d.^2 + fe1 .* mxLcgs_d + fe0;
mxRhr_cgs_d = fhr2 .* mxLcgs_d.^2 + fhr1 .* mxLcgs_d + fhr0;


% 4.5 ���d�ʁA�L�����d��
% Ee_cgs_d  : ���td�ɂ�����CGS�̔��d�� [kWh/day]
% Eee_cgs_d : ���td�ɂ�����CGS�̗L�����d�ʁi��@���͂��������d�ʁj [kWh/day]

Ee_cgs_d  = Ecgs_rated .* Ncgs_on_d .* Tcgs_d .* mxLcgs_d;
Eee_cgs_d = Ee_cgs_d ./ ( 1 + fesub_CGS );


% 4.6 �R������ʁA�r�M�����
% Es_cgs_d  : ���td�ɂ�����CGS�̔R������ʁi���ʔ��M�ʊ�j [MJ/day]
% qhr_cgs_d : ���td�ɂ�����CGS�̔r�M����� [MJ/day]

Es_cgs_d  = Ee_cgs_d .* 3.6./(mxRe_cgs_d .* fcgs_e_cor .*flh);
qhr_cgs_d = Es_cgs_d .* fcgs_e_cor .* mxRhr_cgs_d .* flh;


% 4.7	�L���r�M�����
% qehr_cgs_d : ���td�ɂ�����CGS�̗L���r�M����� [MJ/day]

qehr_cgs_d = zeros(365,1);
for dd = 1:365
    
    if qhr_cgs_d(dd,1)*fhr_loss >= qtotal_hr_on_d(dd,1)
        qehr_cgs_d(dd,1) = qtotal_hr_on_d(dd,1);
    else
        qehr_cgs_d(dd,1) = qhr_cgs_d(dd,1) .* fhr_loss;
    end
    
end

% 4.8 �e�p�r�̔r�M���p��

if npri_hr_c == 1
    qpri1_ehr_on_d = qAC_ref_c_hr_on_d;
elseif npri_hr_h == 1
    qpri1_ehr_on_d = qAC_ref_h_hr_on_d;
elseif npri_hr_w == 1
    qpri1_ehr_on_d = qW_hr_on_d;
end

if npri_hr_c == 2
    qpri2_ehr_on_d = qAC_ref_c_hr_on_d;
elseif npri_hr_h == 2
    qpri2_ehr_on_d = qAC_ref_h_hr_on_d;
elseif npri_hr_w == 2
    qpri2_ehr_on_d = qW_hr_on_d;
else
    qpri2_ehr_on_d = zeros(365,1);
end

if npri_hr_c == 3
    qpri3_ehr_on_d = qAC_ref_c_hr_on_d;
elseif npri_hr_h == 3
    qpri3_ehr_on_d = qAC_ref_h_hr_on_d;
elseif npri_hr_w == 3
    qpri3_ehr_on_d = qW_hr_on_d;
else
    qpri3_ehr_on_d = zeros(365,1);
end


qpri1_ehr_d = zeros(365,1);
qpri2_ehr_d = zeros(365,1);
qpri3_ehr_d = zeros(365,1);

qAC_ref_c_ehr_d = zeros(365,1);
qAC_ref_h_ehr_d = zeros(365,1);
qW_ehr_d = zeros(365,1);

for dd = 1:365
    
    if  qehr_cgs_d(dd,1) >= qpri1_ehr_on_d(dd,1)
        
        qpri1_ehr_d(dd,1) = qpri1_ehr_on_d(dd,1);
        
        if qehr_cgs_d(dd,1) - qpri1_ehr_d(dd,1) >= qpri2_ehr_on_d(dd,1)
            
            qpri2_ehr_d(dd,1) = qpri2_ehr_on_d(dd,1);
            
            if qehr_cgs_d(dd,1) - qpri1_ehr_d(dd,1) - qpri2_ehr_d(dd,1) >= qpri3_ehr_on_d(dd,1)
                
                qpri3_ehr_d(dd,1) = qpri3_ehr_on_d(dd,1);
                
            elseif qehr_cgs_d(dd,1) - qpri1_ehr_d(dd,1) - qpri2_ehr_d(dd,1) < qpri3_ehr_on_d(dd,1)
                
                qpri3_ehr_d(dd,1) = qehr_cgs_d(dd,1) - qpri1_ehr_d(dd,1) - qpri2_ehr_d(dd,1);
                
            end
            
        elseif qehr_cgs_d(dd,1) - qpri1_ehr_d(dd,1) < qpri2_ehr_on_d(dd,1)
            
            qpri2_ehr_d(dd,1) = qehr_cgs_d(dd,1) - qpri1_ehr_d(dd,1);
            qpri3_ehr_d(dd,1) = 0;
            
        end
        
        
    elseif qehr_cgs_d(dd,1) < qpri1_ehr_on_d(dd,1)
        
        qpri1_ehr_d(dd,1) = qehr_cgs_d(dd,1);
        qpri2_ehr_d(dd,1) = 0;
        qpri3_ehr_d(dd,1) = 0;
        
    end
    
    
    if npri_hr_c == 0
        qAC_ref_c_ehr_d(dd,1) = 0;
    elseif npri_hr_c == 1
        qAC_ref_c_ehr_d(dd,1) = qpri1_ehr_d(dd,1);
    elseif npri_hr_c == 2
        qAC_ref_c_ehr_d(dd,1) = qpri2_ehr_d(dd,1);
    elseif npri_hr_c == 3
        qAC_ref_c_ehr_d(dd,1) = qpri3_ehr_d(dd,1);
    end
    
    if npri_hr_h == 0
        qAC_ref_h_ehr_d(dd,1) = 0;
    elseif npri_hr_h == 1
        qAC_ref_h_ehr_d(dd,1) = qpri1_ehr_d(dd,1);
    elseif npri_hr_h == 2
        qAC_ref_h_ehr_d(dd,1) = qpri2_ehr_d(dd,1);
    elseif npri_hr_h == 3
        qAC_ref_h_ehr_d(dd,1) = qpri3_ehr_d(dd,1);
    end
    
    if npri_hr_w == 0
        qW_ehr_d(dd,1) = 0;
    elseif npri_hr_w == 1
        qW_ehr_d(dd,1) = qpri1_ehr_d(dd,1);
    elseif npri_hr_w == 2
        qW_ehr_d(dd,1) = qpri2_ehr_d(dd,1);
    elseif npri_hr_w == 3
        qW_ehr_d(dd,1) = qpri3_ehr_d(dd,1);
    end
        
end


% 4.9 �e�p�r�̈ꎟ�G�l���M�[�팸��
EAC_ref_c_red_d = zeros(365,1);
EAC_ref_h_red_d = zeros(365,1);
EW_red_d        = zeros(365,1);

for dd = 1:365
    
    % EAC_ref_c_red_d : ���td�ɂ������[�̈ꎟ�G�l���M�[�팸�� [MJ/day]
    if qAC_ref_c_hr_on_d(dd,1) == 0
        EAC_ref_c_red_d(dd,1) = 0;
    else
        EAC_ref_c_red_d(dd,1) = EAC_ref_c_hr_on_d(dd,1) .* qAC_ref_c_ehr_d(dd,1) ./ qAC_ref_c_hr_on_d(dd,1);
    end
    
    % EAC_ref_h_red_d : ���td�ɂ�����g�[�̈ꎟ�G�l���M�[�팸�� [MJ/day]
    if qAC_ref_h_hr_on_d(dd,1) == 0
        EAC_ref_h_red_d(dd,1) = 0;
    else
        EAC_ref_h_red_d(dd,1) = EAC_ref_h_hr_on_d(dd,1) * qAC_ref_h_ehr_d(dd,1) / qAC_ref_h_hr_on_d(dd,1) ;
    end
    
    % EW_red_d : ���td�ɂ����鋋���̈ꎟ�G�l���M�[�팸�� [MJ/day]
    if qW_hr_on_d(dd,1) == 0
        EW_red_d(dd,1) = 0;
    else
        EW_red_d(dd,1) = EW_hr_on_d(dd,1) * qW_ehr_d(dd,1) / qW_hr_on_d(dd,1);
    end
    
end

% 4.10 �d�͂̈ꎟ�G�l���M�[�팸��
% Ee_red_d : ���td�ɂ����锭�d�ɂ��d�͂̈ꎟ�G�l���M�[�팸�� [MJ/day]
Ee_red_d = Eee_cgs_d .* fprime_e;


% 4.11 CGS�ɂ��ꎟ�G�l���M�[�팸��
% Etotal_cgs_red_d : ���td�ɂ�����CGS�ɂ��ꎟ�G�l���M�[�팸�� [MJ/day]

Etotal_cgs_red_d = EAC_ref_c_red_d + EAC_ref_h_red_d + EW_red_d + Ee_red_d - Es_cgs_d;


y = zeros(1,15);
y(1,1)  = sum(Tcgs_d.* Ncgs_on_d);
y(1,2)  = sum(Ncgs_on_d.*mxLcgs_d)./sum(Ncgs_on_d);
y(1,3)  = sum(Ee_cgs_d)/1000;
y(1,4)  = sum(qhr_cgs_d)/1000;
y(1,5)  = sum(Es_cgs_d)/1000;
y(1,6)  = y(1,3)*3.6/y(1,5)*100;
y(1,7)  = y(1,4)/y(1,5)*100;
y(1,8)  = sum(Eee_cgs_d)/1000;
y(1,9)  = sum(qehr_cgs_d)/1000;
y(1,10) = (y(1,8)*3.6+y(1,9))/y(1,5)*100;
y(1,11) = sum(Ee_red_d)/1000;
y(1,12) = sum(EAC_ref_c_red_d)/1000;
y(1,13) = sum(EAC_ref_h_red_d)/1000;
y(1,14) = sum(EW_red_d)/1000;
y(1,15) = sum(Etotal_cgs_red_d)/1000;


end


%% �T�u�֐�

function [fe2,fe1,fe0,fhr2,fhr1,fhr0] = perfCURVE(fcgs_e_rated,fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50)

% Input
% fcgs_e_rated % CGS�̒�i���d����(��ʔ��M�ʊ)
% fcgs_e_75 % CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)
% fcgs_e_50 % CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)
% fcgs_hr_rated % CGS�̒�i�r�M����(��ʔ��M�ʊ)
% fcgs_hr_75 % CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)
% fcgs_hr_50% CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)
% 
% Output
% fe2	% CGS�̔��d������������2�����̌W����
% fe1	% CGS�̔��d������������1�����̌W����
% fe0	% CGS�̔��d�����������̒萔��
% fhr2 % CGS�̔r�M������������2�����̌W����
% fhr1 % CGS�̔r�M������������1�����̌W����
% fhr0 % CGS�̔r�M�����������̒萔��

fe2 = 8 * ( fcgs_e_rated - 2*fcgs_e_75 +fcgs_e_50 );
fe1 = -2 * (5*fcgs_e_rated - 12*fcgs_e_75 + 7*fcgs_e_50 );
fe0 = 3 * fcgs_e_rated - 8*fcgs_e_75 + 6*fcgs_e_50 ;

fhr2 = 8 * (fcgs_hr_rated - 2*fcgs_hr_75 + fcgs_hr_50 );
fhr1 = -2 * ( 5*fcgs_hr_rated - 12*fcgs_hr_75 + 7*fcgs_hr_50 );
fhr0 = 3 * fcgs_hr_rated - 8*fcgs_hr_75 + 6*fcgs_hr_50 ;

end








