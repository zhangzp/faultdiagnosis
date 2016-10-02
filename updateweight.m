function [ weight,VE] = updateweight( weight,maxiter_reduce,v0,vtarget,type)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

INT = 0.1;
EXT = 3.0;
MAX = 20;
RATIO = 10;
SIG = 0.1;
RHO = SIG/2;
if size(maxiter_reduce,2) == 2
    reduce=maxiter_reduce(1,2);
    max_iter=maxiter_reduce(1,1);
else
    reduce=1;
    max_iter=maxiter_reduce(1,1);
end
i = 0;
ls_failed = 0;
if type==1
    [verr0,dw0] = CG_weight1(weight,v0,vtarget);
elseif type==2
    [verr0,dw0] = CG_weight2(weight,v0,vtarget);
end
VE = verr0;
i = i + (max_iter<0);
sw=dw0;
d0=0;
for dwi=1:size(dw0,1)
    d0=d0-sum(sum(dw0{dwi,1}.^2));
end
wt3 = reduce/(1-d0);
while i < abs(max_iter)
    i = i + (max_iter>0);
    W0 = weight; VE0 = verr0; DW0 = dw0;
    if max_iter>0
        M = MAX;
    else
        M = min(MAX, -max_iter-i);
    end
    while 1
        wt2 = 0; 
        ve2 = verr0; 
        d2 = d0; 
        %dw2 = dw0; 
        ve3 = verr0; 
        dw3 = dw0;
        success = 0;
        while ~success && M > 0
            try
                M = M - 1;
                i = i + (max_iter<0);
                weight3=cell(size(sw,1),1);
                for dwi=1:size(sw,1)
                    weight3{dwi,1} = weight{dwi,1}-wt3*sw{dwi,1};
                end
                if type==1
                    [ve3,dw3] = CG_weight1(weight3, v0,vtarget);
                elseif type==2
                    [ve3,dw3] = CG_weight2(weight3, v0,vtarget);
                end
                anytrue = 0;
                for dwi=1:size(dw3,1)
                    anytrue = anytrue + any(any( isnan(dw3{dwi,1})+isinf(dw3{dwi,1}) ));
                end
                if isnan(ve3) || isinf(ve3) || anytrue
                    error('');
                end
                success = 1;
            catch
                wt3 = (wt2+wt3)/2;
            end
        end
        if ve3 < VE0
            W0=cell(size(sw,1),1);
            for dwi=1:size(sw,1)
                W0{dwi,1} = weight{dwi,1}-wt3*sw{dwi,1};
            end
            VE0 = ve3;
            DW0 = dw3;
        end
        d3=0;
        for dwi=1:size(sw,1)
            d3=d3-sum(sum(sw{dwi,1}.*dw3{dwi,1}));
        end
        if d3 > SIG*d0 || ve3 > verr0+wt3*RHO*d0 || M == 0
            break;
        end
        wt1 = wt2; ve1 = ve2; d1 = d2; %dw1 = dw2;
        wt2 = wt3; ve2 = ve3; d2 = d3; %dw2 = dw3;
        A = 6*(ve1-ve2)+3*(d2+d1)*(wt2-wt1);
        B = 3*(ve2-ve1)-(2*d1+d2)*(wt2-wt1);
        wt3 = wt1-d1*(wt2-wt1)^2/(B+sqrt(B*B-A*d1*(wt2-wt1)));
        if ~isreal(wt3) || isnan(wt3) || isinf(wt3) || wt3 < 0
            wt3 = wt2*EXT;
        elseif wt3 > wt2*EXT
            wt3 = wt2*EXT;
        elseif wt3 < wt2+INT*(wt2-wt1)
            wt3 = wt2+INT*(wt2-wt1);
        end
    end
    while (abs(d3) > -SIG*d0 || ve3 > verr0+wt3*RHO*d0) && M > 0
        if d3 > 0 || ve3 > verr0+wt3*RHO*d0
            wt4 = wt3; ve4 = ve3; d4 = d3;%dw4 = dw3;
        else
            wt2 = wt3; ve2 = ve3; d2 = d3;%dw2 = dw3;
        end
        if ve4 > verr0
            wt3 = wt2-(0.5*d2*(wt4-wt2)^2)/(ve4-ve2-d2*(wt4-wt2));
        else
            A = 6*(ve2-ve4)/(wt4-wt2)+3*(d4+d2);
            B = 3*(ve4-ve2)-(2*d2+d4)*(wt4-wt2);
            wt3 = wt2+(sqrt(B*B-A*d2*(wt4-wt2)^2)-B)/A;
        end
        if isnan(wt3) || isinf(wt3)
            wt3 = (wt2+wt4)/2;
        end
        wt3 = max(min(wt3, wt4-INT*(wt4-wt2)),wt2+INT*(wt4-wt2));
        weight3=cell(size(sw,1),1);
        for dwi=1:size(sw,1)
            weight3{dwi,1} = weight{dwi,1}-wt3*sw{dwi,1};
        end
        if type==1
            [ve3,dw3] = CG_weight1(weight3, v0,vtarget);
        elseif type==2
            [ve3,dw3] = CG_weight2(weight3, v0,vtarget);
        end
        if ve3 < VE0
            W0=cell(size(sw,1),1);
            for dwi=1:size(sw,1)
                W0{dwi,1} = weight{dwi,1}-wt3*sw{dwi,1};
            end
            VE0 = ve3;
            DW0 = dw3;
        end
        M = M - 1; 
        i = i + (max_iter<0);
        d3=0;
        for dwi=1:size(sw,1)
            d3=d3-sum(sum(sw{dwi,1}.*dw3{dwi,1}));
        end
    end
    if abs(d3) < -SIG*d0 && ve3 < verr0+wt3*RHO*d0
        for dwi=1:size(sw,1)
            weight{dwi,1} = weight{dwi,1}-wt3*sw{dwi,1};
        end
        verr0 = ve3; 
        VE = [VE',verr0]';
        %fprintf('%s %6i;  Value %4.6e\r', S, i, verr0);
        d33=0;
        d03=0;
        d00=0;
        for dwi=1:size(sw,1)
            d33=d33+sum(sum(dw3{dwi,1}.^2));
            d00=d00+sum(sum(dw0{dwi,1}.^2));
            d03=d03+sum(sum(dw0{dwi,1}.*dw3{dwi,1}));
        end
        for dwi=1:size(sw,1)
            sw{dwi,1} = dw3{dwi,1}+(d33-d03)*sw{dwi,1}/d00;
        end
        dw0 = dw3;
        d3 = d0;
        d0=0;
        for dwi=1:size(sw,1)
            d0=d0-sum(sum(sw{dwi,1}.*dw0{dwi,1}));
        end
        if d0 > 0
            sw=dw0;
            d0=0;
            for dwi=1:size(sw,1)
                d0=d0-sum(sum(sw{dwi,1}.^2));
            end
        end
        wt3 = wt3 * min(RATIO, d3/(d0-realmin));
        ls_failed = 0;
    else
        weight = W0; verr0 = VE0; dw0 = DW0;
        if ls_failed || i > abs(max_iter)
            break;
        end
        sw=dw0;
        d0=0;
        for dwi=1:size(sw,1)
            d0=d0-sum(sum(sw{dwi,1}.^2));
        end
        wt3 = 1/(1-d0);
        ls_failed = 1;
    end
end
%fprintf('\n');
end

