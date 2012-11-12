function prt=mf_dfdp_grasp(x,f,p,dp,func,extra)

if nargin <6; extra = []; end

% MFIT function prt=mf_dfdp(x,f,p,dp,func)
%	Called by mf_lsqr.m
%

m=length(x);n=length(p);      %dimensions
ps=p; prt=zeros(m,n);del=zeros(n,1);          % initialise Jacobian to Zero

for j=1:n
      del(j)=dp(j) .*p(j);    %cal delx=fract(dp)*param value(p)
            if p(j)==0
            del(j)=dp(j);     %if param=0 delx=fraction
            end
      p(j)=ps(j) + del(j);
      if del(j)~=0, f1=feval(func,x,p,extra);
            if dp(j) < 0, prt(:,j)=(f1-f)./del(j);
            else
            p(j)=ps(j)- del(j);
            prt(:,j)=(f1-feval(func,x,p,extra))./(2 .*del(j));
            end
      end
      p(j)=ps(j);       %restore p(j)
end
return
