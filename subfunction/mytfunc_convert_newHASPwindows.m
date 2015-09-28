% mytfunc_convert_newHASPwindows.m
%                                               2015/09/06 by Masato Miyata
%--------------------------------------------------------------------------
% ����25�N��̃K���X�ԍ���newHASP�p�̃K���X�ԍ��ɒu������v���O�����B
%--------------------------------------------------------------------------

function [WNDW,TYPE] = mytfunc_convert_newHASPwindows(WNUM)

switch WNUM
    case '104'  % ���w 8mm+ A6 + 8mm
        WNDW = 'DL06';
        TYPE = '4';
    case '103'  % ���w 6mm+ A6 + 6mm
        WNDW = 'DL06';
        TYPE = '3';
    case '2'  % �P�� 5mm
        WNDW = 'SNGL';
        TYPE = '2';
    case '3'  % �P�� 6mm
        WNDW = 'SNGL';
        TYPE = '3';
    case '4'  % �P�� 8mm
        WNDW = 'SNGL';
        TYPE = '4';
    otherwise
        error('mytfunc_convert_newHASPwindows�F�K���X���o�^����Ă��܂���')
end