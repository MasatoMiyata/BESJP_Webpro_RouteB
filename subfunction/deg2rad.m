% deg2rad.m　　　　　　　　　　　　　　　　　　　　　　　　　　%FUJII
%-----------------------------------------------------------------------------------
% デグリー [°] をラジアン [rad]に変換する            (2004/8/25  Fujii)
%-----------------------------------------------------------------------------------
%　入力  d  : デグリー [°]
%　出力  r  : ラジアン [rad]
%-----------------------------------------------------------------------------------
function [r] = deg2rad(d)

r = d * pi /180.0;

