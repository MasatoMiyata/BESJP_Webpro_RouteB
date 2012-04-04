% mytfunc_enthalpy.m
%                                               By Miyata Masato 2006/11/15
%--------------------------------------------------------------------------
% h     : �G���^���s�[ [kJ/kg]
% Tdb   : �������x [��]
% X     : ��Ύ��x [kg/kgDA]
%--------------------------------------------------------------------------
function h = mytfunc_enthalpy(Tdb,X)

Ca = 1.006;       % ������C�̒舳��M [kJ/kg�K]
Cw = 1.805;       % �����C�̒舳��M [kJ/kg�K]
Lw = 2502;        % ���̏������M [kJ/kg]

if length(Tdb)~=length(X)
	error(' ���x�Ǝ��x�̃f�[�^�����Ⴂ�܂� ')
else
	if size(Tdb,1)~=size(X,1)
		Tdb = Tdb';
	end
	h = (Ca.*Tdb + (Cw.*Tdb+Lw).*X);
end