function fll_angle_callbacks(to_do,option)

global fit_parameters

switch to_do
    
    case 'load'
        curve_no = get(gcbo,'userdata');
        no_of_cuvres = fit_parameters.number_functions;
        if curve_no > no_of_cuvres; curve_no = 1; end
        
        cx = fit_parameters.values(3 + (curve_no-1)*fit_parameters.no_parameters);
        dcx = fit_parameters.err_values(3 + (curve_no-1)*fit_parameters.no_parameters);
        
        i=findobj('tag',['x' num2str(option)]);
        set(i(1),'string',num2str(cx));
        i=findobj('tag',['dx' num2str(option)]);
        set(i(1),'string',num2str(dcx));
        
        cy = fit_parameters.values(4 + (curve_no-1)*fit_parameters.no_parameters);
        dcy = fit_parameters.err_values(4 + (curve_no-1)*fit_parameters.no_parameters);
        
        i=findobj('tag',['y' num2str(option)]);
        set(i(1),'string',num2str(cy));
        i=findobj('tag',['dy' num2str(option)]);
        set(i(1),'string',num2str(dcy));
        
        curve_no = curve_no +1;
        if curve_no > no_of_cuvres; curve_no = 1; end
        set(gcbo,'userdata',curve_no);
        set(gcbo,'string',['Load' num2str(curve_no)]);
        
        
    case 'loadcm'
        cm=current_beam_centre;
        cm = cm.det1.cm_pixels;
        i=findobj('tag','x0');
        set(i(1),'string',num2str(cm(1)));
        i = findobj('tag','y0');
        set(i(1),'string',num2str(cm(2)));
        
    case 'calculate'
        
        %capture spot coordinates and corresponding errors from the ui window
        i = findobj('tag','x0'); x0 = str2num(get(i(1),'string'));
        i = findobj('tag','y0'); y0 = str2num(get(i(1),'string'));
        i = findobj('tag','x1'); x1 = str2num(get(i(1),'string'));
        i = findobj('tag','y1'); y1 = str2num(get(i(1),'string'));
        i = findobj('tag','x2'); x2 = str2num(get(i(1),'string'));
        i = findobj('tag','y2'); y2 = str2num(get(i(1),'string'));
        i = findobj('tag','dx1'); dx1 = str2num(get(i(1),'string'));
        i = findobj('tag','dy1'); dy1 = str2num(get(i(1),'string'));
        i = findobj('tag','dx2'); dx2 = str2num(get(i(1),'string'));
        i = findobj('tag','dy2'); dy2 = str2num(get(i(1),'string'));
        
        %prepare spots as vectors
        s1 = [x1 y1];
        err_s1 = [dx1 dy1];
        s2 = [x2 y2];
        err_s2 = [dx2 dy2];
        cntr = [x0 y0];
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
        
        %calculate lengths of the triangle
        %a = sqrt(((x1-x2)^2)+((y1-y2)^2));
        %b = sqrt(((x2-x0)^2)+((y2-y0)^2));
        %c = sqrt(((x1-x0)^2)+((y1-y0)^2));
        %cosbeta = -((a^2)-(b^2)-(c^2))/(2*b*c);
        %beta = (acos(cosbeta))*(180/pi);
        %display(a)
        %display(b)
        %display(c)
        %display(cosbeta)
        %display(beta)
        
        %error calculation
        %A = (5*(((dx1)^2)+((dy1)^2)+((dx2)^2)+((dy2)^2)))/((b*c)^2);
        %B = ((((a^2)-(b^2)-(c^2))/((2*b*c)^2))^2)*(((b^2)*(((dx1)^2)+((dy1)^2)))+((c^2)*(((dx2)^2)+((dy2)^2))))
        %d_cosbeta = sqrt(A+B)
        
        %display(A)
        %display(B)
        %d_cosbeta = sqrt(((5*(((dx1)^2)+((dy1)^2)+((dx2)^2)+((dy2)^2)))/((b*c)^2))+((((a^2)-(b^2)-(c^2))/((2*b*c)^2)^2)*sqrt(((b^2)*((dx1^2)+(dy1^2)))+((c^2)*((dx2^2)+(dy2^2)))))
        %d_beta = (d_cosbeta)/(sin(beta))*(180/pi)
        %display(d_cosbeta)
        %display(d_beta)
        
        %inserting the angle plus error back in the ui window
        i = findobj('tag','beta'); set(i(1),'string',num2str(beta));
        i = findobj('tag','beta90'); set(i(1),'string',num2str(90-beta));
        i = findobj('tag','d_beta'); set(i(1),'string',num2str(err_beta));
        
        
        
        
end
