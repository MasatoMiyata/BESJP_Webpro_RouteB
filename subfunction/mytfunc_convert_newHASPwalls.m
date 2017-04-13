% mytfunc_convert_newHASPwalls.m
%                                               2015/09/06 by Masato Miyata
%--------------------------------------------------------------------------
% ����25�N��̌��ޔԍ���newHASP�p�̌��ޔԍ��ɒu������v���O�����B
%--------------------------------------------------------------------------

function [Mnum] = mytfunc_convert_newHASPwalls(WNUM)

switch WNUM
    case '1'  % �|
        Mnum = '5';
    case '70'  % ���b�N�E�[�����ϋz����
        Mnum = '75';
    case '62'  % ���������{�[�h
        Mnum = '32';
    case '302'  % �񖧕�C�w
        Mnum = '92';
    case '41'  % �R���N���[�g
        Mnum = '22';
    case '44'  % �C�A�R���N���[�g
        Mnum = '24';
    case '45'  % �R���N���[�g�u���b�N�i�d�ʁj
        Mnum = '25';
    case '46'  % �R���N���[�g�u���b�N�i�y�ʁj
        Mnum = '26';
    case '47'  % �Z�����g�E�����^��
        Mnum = '27';
    case '103'  % �A�X�t�@���g��
        Mnum = '43';
    case '181'  % ���o�@�|���X�`�����t�H�[���ۉ��P��
        Mnum = '82';
    case '67'  % �^�C��
        Mnum = '36';
    case '203'  % ���t���d���E���^���t�H�[���`��P
        Mnum = '85';
    case '101'  % �r�j���n����
        Mnum = '41';
    case '22'  % �y��
        Mnum = '15';
    case '102'  % FRP
        Mnum = '42';
    case '183'  % ���o�@�|���X�`�����t�H�[���ۉ��R��
        Mnum = '83';
    case '107'  % �J�[�y�b�g
        Mnum = '47';
    case '2'  % �A���~�j�E��
        Mnum = '6';
    case '73'  % �P�C�_�J���V�E����1.0mm
        Mnum = '32';
    case '204'  % ���t���d���E���^���t�H�[���`��R
        Mnum = '85';
    case '124'  % �O���X�E�[���f�M�ނQ�S�j�����i0.036�j
        Mnum = '72';
    otherwise
        WNUM
        error('mytfunc_convert_newHASPwalls�F���ނ��o�^����Ă��܂���')
end

