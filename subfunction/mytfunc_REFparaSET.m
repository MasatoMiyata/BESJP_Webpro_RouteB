% mytfunc_REFparaSET.m
%                                          by Masato Miyata 2011/04/24
%----------------------------------------------------------------------
% �ȃG�l��F�M�������̒��o
%----------------------------------------------------------------------
% ����
%  data : �����f�[�^�i�����l,����l,�␳�l,x4,x3,x2,x1,a�j
%  x    : ��������x�̒l�i�O�C���x�A��p�����x�Ȃǁj
% �o��
%  y    : x�̏������ɂ���������i�ő�\�͔�A�ő���͔䓙�j�̒l
%----------------------------------------------------------------------
function y = mytfunc_REFparaSET(data,x)

% DEBUG�p�f�[�^
% clear
% clc
% data = [-15	-8	0.8 0	0	0	0.0255	0.847
%     -8	4.5	0.8 0	0	0	0.0153	0.762
%     4.5	15.5	0.8 0	0	0	0.0255	0.847];
% x = -15;

if isempty(data) == 0
    
    % �������̐�
    curveNum = size(data,1);
    
    % �����l
    minX = data(:,1);
    % ����l
    maxX = data(:,2);
    % �p�����[�^
    para = data(:,3:end);
    
    % ����Ɖ������߂�
    if x < minX(1)
        x = minX(1);
    elseif x > maxX(end)
        x = maxX(end);
    end
    
    % �Y������p�����[�^�Z�b�g
    paraSET = zeros(1,6);
    
    for i=curveNum:-1:1
        if x <= maxX(i)
            paraSET = para(i,:);
        end
    end
    
    % �v�Z�l
    y = paraSET(1).*(paraSET(2).*x^4 + paraSET(3).*x^3 + paraSET(4).*x^2 + paraSET(5).*x + paraSET(6));
    
else
    
    % data ����s��ł������ꍇ
    y = 1;
    
end
