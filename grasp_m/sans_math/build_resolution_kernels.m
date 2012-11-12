function resolution_kernels =  build_resolution_kernels(x_in, kernel_data)

%Input 'kernel_data' comes in with possible fields:
%kernel_data.sigmawidth
%kernel_data.finesse
%kernel_data.lambda.fwhm, kernel_data.lambda.shape
%kernel_data.theta.fwhm, kernel_data.theta.shape
%kernel_data.pixel.fwhm, kernel_data.pixel.shape
%kernel_data.binning.fwhm, kernel_data.binning.shape
%kernel_data.cm

%Output 'resolution_kernels' (struct) : fields   .x  .weight .sigma
%params(1) = sigmawidth, params(2) = finesse (number of points in kernel)
%x_in = q points of data to be convoluted
%lambda (struct): fields   .fwhn(length x_in)  .shape
%theta (struct):  fields   .fwhm(length x_in) .shape .kernel (real measured kernel)
%pixel (struct):  fields   .fwhm(length x_in) .shape
%binning (struct): fields  .fwhm(length x_in) .shape
%aperture (struct): fields .fwhm(lenght x_in) .shape


global status_flags

%Notes on Sigma's for Various Shapes
%
%Gausian:  FWHM = (2*sqrt(2*log(2))) = 2.3548 sigma
%TopHat:   FWHM = 3.4 sigma,  HWHM = 1.7 sigma
%Triangular: FWHM = 2.45 sigma,  FWHM = Base Half-Width

%Keep a copy of all the component parameters used to generate the kernels
resolution_kernels = kernel_data; 
resolution_kernels.history = {' ', '***** Resolution *****',' '};

temp = fieldnames(kernel_data); %Check if prebuilt kernel ONLY is coming though

if length(temp)==2; %i.e. only x and weight
    return
end



%Plot resolution Kernels
if status_flags.resolution_control.show_kernels_check==1;
    figure; legend_str = [];
end



%Build Resolution Component Kernels for every q-point
for n = 1:length(x_in)
    
    fwhm_max = max([kernel_data.lambda.fwhm(n),kernel_data.theta.fwhm(n),kernel_data.pixel.fwhm(n),kernel_data.binning.fwhm(n)]); %Find the largest fwhm and use to generate the new_x data
    
    %Make x coordinate range in high resolution for each x_in point
    low = x_in(n)-kernel_data.fwhmwidth*fwhm_max; high = x_in(n)+kernel_data.fwhmwidth*fwhm_max;
    dx = (high -low) /(kernel_data.finesse-1); %Make sure there is an ODD number of points
    new_x = low:dx:high; %Kernel x-range in higher resolution than the original data
    
    %***** Delta-Function Starter Kernel - default kernel to start convoluting with *****
    [weight_final] = delta_kernel_1d(x_in(n),1,new_x,dx); %Arguments (xcentre,intint,x_range,dx)
    weight_final = weight_final*dx;
    
    if status_flags.command_window.display_params ==1;
    if n==1;
        disp(' ');
        disp('Building Real-Shape Resolution Kernel for I vs. Q data');
    end
    end
    
    %***** Wavelength Resolution Smearing *****
    if status_flags.resolution_control.wavelength_check ==1; %Use wavelength resolution
        if status_flags.resolution_control.wavelength_type == 1; %Triangular wavelength distribution, i.e. velocity selector
%        if strcmp(kernel_data.lambda.shape,'triangular');
            [weight] = triangle_kernel_1d(x_in(n),kernel_data.lambda.fwhm(n),1,new_x,dx); %Arguments (x0,basehalfwidth,intint,x_range,dx)
            if status_flags.command_window.display_params ==1;
            if n==1;disp('Wavelength:  Triangular (selector) Kernel');end
            end
        elseif status_flags.resolution_control.wavelength_type ==2; %Top-Hat Wavelength distribution, i.e. D33 double-blind chopper
            [weight] = tophat_kernel_1d(x_in(n),kernel_data.lambda.fwhm(n)/2,1,new_x,dx); %Arguments (x0,halfwidth,intint,x_range,dx)
            if status_flags.command_window.display_params ==1;
            if n==1; disp('Wavelength:  Top-Hat (e.g. D33 TOF) Kernel'); end
            end
        end
        weight = weight*dx;
        %Convolute with previous kernel
        weight_final = conv(weight_final,weight,'same'); %Convolution
        if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Wavelength Resolution'; end
        
        %Plot resolution Kernels
        if status_flags.resolution_control.show_kernels_check==1;
            if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
                hold on; plot(new_x,weight,'-r.');
            end
            if n == length(x_in); legend_str = [legend_str, {'Wavelength'}];end
        end
    else
        if status_flags.command_window.display_params ==1;
        if n==1;disp('Wavelength:  NONE');end
        end
    end
    
    %***** Divergence Resolution Smearing *****
    if status_flags.resolution_control.divergence_check ==1; %Use divergence resolution
        
        %Use Geometric Beam Profile - Generate in any case as default in case measured profile does not exist
        if status_flags.resolution_control.divergence_type == 1
            [weight] = tophat_kernel_1d(x_in(n),kernel_data.theta.fwhm(n)/2,1,new_x,dx); %Arguments (x0,halfwidth,intint,x_range,dx)
            div_legend_txt = 'Geometric Divergence';
            if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Geometric Divergence'; end
            if status_flags.command_window.display_params ==1;
            if n==1; disp('Divergence:  Geometric Divergence (Top-Hat) Kernel'); end
            end
            weight = weight*dx;
            
        elseif status_flags.resolution_control.divergence_type == 2 & isfield(kernel_data.cm,'x_kernel_weight');
            %Use Measured Beam Profle Kernel
            temp = not(isnan(kernel_data.cm.x_kernel_q)); %Stip out the padding NaN's
            temp = find(temp);
            weight = interp1(kernel_data.cm.x_kernel_q(temp)+x_in(n),kernel_data.cm.x_kernel_weight(temp),new_x,'linear','extrap');
            weight = weight /sum(weight); %Normalise to 1
            div_legend_txt = 'Measured Beam Profile Divergence';
            if n ==1; resolution_kernels.history{length(resolution_kernels.history)} = 'Measured Beam Profile Divergence'; end
            if status_flags.command_window.display_params ==1;
            if n==1; disp('Divergence:  Measured Beam Profile Divergence Kernel'); end
            end
        end
        
        %Convolute with previous kernel
        weight_final = conv(weight_final,weight,'same'); %Convolute
        
        %Plot resolution Kernels
        if  status_flags.resolution_control.show_kernels_check==1;
            if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
                hold on; plot(new_x,weight,'-g.');
            end
            if n == length(x_in); legend_str = [legend_str, {div_legend_txt}];end
        end
    else
        div_legend_txt = 'No Divergence Smearing';
        if status_flags.command_window.display_params ==1;
        if n==1; disp('Divergence:  NONE');end
        end
    end
    
    
    %***** Sample Aperture Smearing *****
    if status_flags.resolution_control.aperture_check == 1 && status_flags.resolution_control.divergence_type ~= 2; %Use Sample Aperture smearing
        if strcmp(kernel_data.aperture.shape,'tophat');
            [weight] = tophat_kernel_1d(x_in(n),kernel_data.aperture.fwhm(n)/2,1,new_x,dx); %Arguments (x0,halfwidth,intint,x_range,dx)
            ap_legend_txt = 'Sample Aperture Smearing';
            if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Sample Aperture Smearing'; end
            if status_flags.command_window.display_params ==1;
            if n==1; disp('Sample Aperture Smearing: Top-Hat Kernel'); end
            end
        end
        weight = weight*dx;
        
        %Convolute with previous kernel
        weight_final = conv(weight_final,weight,'same'); %Convolute
        
        %Plot resolution Kernels
        if  status_flags.resolution_control.show_kernels_check==1;
            if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
                hold on; plot(new_x,weight,'-b.','markersize',20);
            end
            if n == length(x_in); legend_str = [legend_str, {ap_legend_txt}];end
        end
    else
        div_legend_txt = 'No Sample Aperture Smearing';
        if status_flags.command_window.display_params ==1;
        if n==1; disp('Sample Aperture Smearing: NONE'); end
        end
    end

    
    %***** Pixelation Resolution Smearing *****
    if status_flags.resolution_control.pixelation_check ==1; %Use pixelation resolution
        if strcmp(kernel_data.pixel.shape,'tophat');
            [weight] = tophat_kernel_1d(x_in(n),kernel_data.pixel.fwhm(n)/2,1,new_x,dx); %Arguments (x0,halfwidth,intint,x_range,dx)
            if status_flags.command_window.display_params ==1;
            if n==1; disp('Detector Pixelation Smearing: Top-Hat Kernel'); end
            end
        end
        weight = weight*dx;
        if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Pixelation Smearing'; end

        %Convolute with previous kernel
        weight_final = conv(weight_final,weight,'same'); %Convolution
        
        %Plot resolution Kernels
        if  status_flags.resolution_control.show_kernels_check==1;
            if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
                hold on; plot(new_x,weight,'-c.');
            end
            if n == length(x_in); legend_str = [legend_str, {'Detector Pixelation'}];end
        end
    else
        if status_flags.command_window.display_params ==1;
        if n==1; disp('Detector Pixelation Smearing: NONE'); end
        end
    end
    
       
    
    %***** Binning Resolution Smearing *****
    if status_flags.resolution_control.binning_check ==1; %Use binning resolution
        if strcmp(kernel_data.binning.shape,'tophat');
            [weight] = tophat_kernel_1d(x_in(n),kernel_data.binning.fwhm(n)/2,1,new_x,dx); %Arguments (x0,halfwidth,intint,x_range,dx)
            if status_flags.command_window.display_params ==1;
            if n==1; disp('Binning Resolution Smearing: Top-Hat Kernel'); end
            end
        end
        weight = weight*dx;
        if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Bin Smearing'; end

        %Convolute with previous kernel
        weight_final = conv(weight_final,weight,'same'); %Convolution
        
        %Plot resolution Kernels
        if  status_flags.resolution_control.show_kernels_check==1;
            if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
                hold on; plot(new_x,weight,'-m.');
            end
            if n == length(x_in); legend_str = [legend_str, {'Binning Resolution'}];end
        end
    else
        if status_flags.command_window.display_params ==1;
        if n==1; disp('Binning Resolution Smearing: NONE'); end
        end
    end
    
    
    
    
    %***** Display combined resolution kernel *****
    if status_flags.resolution_control.show_kernels_check==1;
        if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
            hold on; plot(new_x,weight_final,'-w.');
        end
        if status_flags.command_window.display_params ==1;
        if n == length(x_in); legend_str = [legend_str, {'Combined Resolution Kernel'}];end
        end
    end
    
    
    %Prepare Final Resolution Kernel for storage
    resolution_kernels.x{n} = new_x;
    resolution_kernels.weight{n} = weight_final;
    
    %Std deviation of this distribution - Gaussian Equivalent Resolution for export
    variance = sum(weight_final.*(new_x- x_in(n)).^2)/(sum(weight_final));
    sigma = sqrt(variance);
    resolution_kernels.fwhm(n,1) = sigma *(2*sqrt(2*log(2)));
    
    %Check if using Real Shape Kernel, Gaussian Equivalent Kernel or Classic Resolution
    if status_flags.resolution_control.convolution_type == 3; %Classic Resolution
        if n ==1; resolution_kernels.history = {'Using Classic Gaussian Resolution'}; end

        if status_flags.command_window.display_params ==1;
            if n == 1; disp(' '); disp('Using Classic Gaussian Resolution'); end
        end
        [weight] = gauss_kernel_1d(x_in(n),resolution_kernels.classic_res.fwhm(n)/(2*sqrt(2*log(2))),1,new_x); %Arguments (xcentre,sigma_x,intint,x_range,dx)
        weight = weight*dx;
        resolution_kernels.weight{n} = weight;
    elseif status_flags.resolution_control.convolution_type == 2 %Gaussian Equivalent resolution
        if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Using Gaussian Equivalent Kernel'; end
        if status_flags.command_window.display_params ==1;
        if n == 1; disp(' ');disp(['Generating Gaussian Equivalent Kernel (from Real Shape Kernel - with ' div_legend_txt ' )']); end
        end
        [weight] = gauss_kernel_1d(x_in(n),resolution_kernels.fwhm(n)/(2*sqrt(2*log(2))),1,new_x); %Arguments (xcentre,sigma_x,intint,x_range,dx)
        weight = weight*dx;
        resolution_kernels.weight{n} = weight;
    elseif status_flags.resolution_control.convolution_type == 1
        if n ==1; resolution_kernels.history{length(resolution_kernels.history)+1} = 'Using Real Shape Kernel'; end
        if status_flags.command_window.display_params ==1;
        if n == 1; disp(' ');disp(['Using Real Shape Kernel (with ' div_legend_txt ' )']); end
        end
    end
    
    %Plot Classic Gaussian resolution
    if status_flags.resolution_control.show_kernels_check==1;
        if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
            %Plot classic gaussian resolution
            [weight] = gauss_kernel_1d(x_in(n),resolution_kernels.classic_res.fwhm(n)/(2*sqrt(2*log(2))),1,new_x); %Arguments (xcentre,sigma_x,intint,x_range,dx)
            weight = weight*dx;
            hold on; plot(new_x,weight,'-b.');
        end
        if n == length(x_in); legend_str = [legend_str, {'Classic Gaussian Resolution'}];end
    end

    %Plot Gaussian Equivalent resolution
    if status_flags.resolution_control.show_kernels_check==1;
        if n ==1 || n == round(length(x_in)/2) || n == length(x_in);
            %Plot gaussian of same sigma as final resolution width - just to compare
            [weight] = gauss_kernel_1d(x_in(n),resolution_kernels.fwhm(n)/(2*sqrt(2*log(2))),1,new_x); %Arguments (xcentre,sigma_x,intint,x_range,dx)
            weight = weight*dx;
            hold on; plot(new_x,weight,'-y.');
        end
        if n == length(x_in); legend_str = [legend_str, {'Gausian Equivalent Kernel'}];end
    end
    
    
    
    
    %Add legend to Kernels plot
    if status_flags.resolution_control.show_kernels_check==1;
        if n == length(x_in);
            legend(legend_str);
        end
    end
    
    
end