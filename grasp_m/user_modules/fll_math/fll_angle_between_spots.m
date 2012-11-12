function angle_list = fll_angle_between_spots(coords,cm)

%coods = [x1, err_x1, y1, err_y1; x2, err_x2, y2, err_y2 ...etc.]
%cm is the beam centre coordinates [cx,cy];

%angle_list = [angle1, err_angle1; angle2, err_angle2 ...etc.]
%angle_list is of course 1/2 size coords

if nargin <2; cm = current_beam_centre; end

if nargin <1; 
    
else
    l = size(coords);
    number_of_spots = floor(l(1)/2)*2; %just in case there were an odd number of coordinartes.
    angle_list = [];

    for n = 1:2:number_of_spots
        %Levett Code for Angle Calculation
        
        %prepare spots as vectors
        s1 = [coords(n,1), coords(n,3)];
        err_s1 = [coords(n,2), coords(n,4)];
        s2 = [coords(n+1,1), coords(n+1,3)];
        err_s2 = [coords(n+1,2), coords(n+1,4)];
        
        cntr = [cm(1) cm(2)];
        err_cntr = [0 0];
        
        %Calculate triangle vectors
        [av err_av] = err_sub(s1,err_s1,cntr,err_cntr);
        [bv err_bv] = err_sub(s2,err_s2,cntr,err_cntr);
        [cv err_cv] = err_sub(s1,err_s1,s2,err_s2);
        
        %Calculate Lengths
        [av2 err_av2] = err_power(av,err_av,2);
        [av2sum err_av2sum] = err_add(av2(1),err_av2(1),av2(2),err_av2(2));
        [a err_a] = err_power(av2sum,err_av2sum,0.5);
        
        [bv2 err_bv2] = err_power(bv,err_bv,2);
        [bv2sum err_bv2sum] = err_add(bv2(1),err_bv2(1),bv2(2),err_bv2(2));
        [b err_b] = err_power(bv2sum,err_bv2sum,0.5);
        
        [cv2 err_cv2] = err_power(cv,err_cv,2);
        [cv2sum err_cv2sum] = err_add(cv2(1),err_cv2(1),cv2(2),err_cv2(2));
        [c err_c] = err_power(cv2sum,err_cv2sum,0.5);
        
        %The formula for Beta is:
        % cos(Beta) = (a^2 + b^2 -c^2) / 2ab
        [a2 err_a2]= err_power(a,err_a,2);
        [b2 err_b2]= err_power(b,err_b,2);
        [c2 err_c2]= err_power(c,err_c,2);
        [a2b2sum err_a2b2]= err_add(a2,err_a2,b2,err_b2);
        [sqrsum err_sqrsum]= err_sub(a2b2sum,err_a2b2,c2,err_c2);
        [ab,err_ab]=err_multiply(a,err_a,b,err_b);
        [cosbeta2,err_cosbeta2]=err_divide(sqrsum,err_sqrsum,ab,err_ab);
        cosbeta=cosbeta2/2;
        err_cosbeta=err_cosbeta2/2;
        [beta,err_beta]=err_acos(cosbeta,err_cosbeta);
        
        beta=beta*180/pi;
        err_beta=err_beta*180/pi;
        
        %Put beta and err_beta into store
        angle_list = [angle_list; [beta, err_beta]];
    end
end
