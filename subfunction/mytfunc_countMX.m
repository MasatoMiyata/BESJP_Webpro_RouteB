function y = mytfunc_countMX(X,mxL)

% �����l
y = 1;

% �Y������}�g���b�N�X��T��
while X > mxL(y)
    y = y + 1;
    if y == length(mxL)
        break
    end
end

end

