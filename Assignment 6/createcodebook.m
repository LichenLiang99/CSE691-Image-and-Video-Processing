%create codebook function, implemented according to the Codebook
%Construction Psuedocode

function CBfinal = createcodebook(M,N,Nframes,Red, Green, Blue,alpha,beta,epsilon)

%used to store delta values to see what epsilon values to choose.
%however, this will slow down the execution, so it is commented out in the
%loops and these two variables are abandoned.
deltacounter=1;
deltaarray=[];

%records the index to save the codewords, so this variable should
%eventually be product of MxN
CBfinalcounter=0;

%for each pixel in the image
for i = 1:M
    for j = 1:N
        
        %initialize and clear an string array, and reset wordcount counter in the
        %codebook
        codebook={};
        wordcount = 0;
        
        %for each frame, abstract its RGB values at this pixel location.
        %get xt and I according to the psuedocode
        for k = 1:Nframes
            R=Red(:,:,k);
            G=Green(:,:,k);
            B=Blue(:,:,k);
            xt=[R(i,j),G(i,j),B(i,j)];
            I = R(i,j)+ G(i,j)+ B(i,j);
            
            %check whether it exist in the codebook already.
            %each iteration it rest the matched index and the boolean
            %matched
            matchedindex=0;
            matched=0;
            
            %the codebook must not be empty in order to check.
            if ~isempty(codebook)
                ii=1;
                
                %for each codeword in the codebook
                %extract each xt and aux from the codebook and compare it
                %to the xt we are processing now.
                %comparison about color distance and brightness.
                for ii = 1:wordcount
                    curr = codebook(ii);
                    tempVcurr  = curr{1}{1};
                    tempAuxcurr = curr{1}{2};
                    Vcurr = tempVcurr{1};
                    Auxcurr = tempAuxcurr{1};
                    
                    %calls color distance function with parameters:
                    %xt from current pixel and xt from codebook.
                    delta = colordist(xt,Vcurr);
                    
                    %this part was used to find what epsilon value to
                    %choose, then abandoned because it takes too long.
%                     deltaarray(deltacounter) = delta;
%                     deltacounter = deltacounter+1;

                    %calls brightness function with parameters:
                    %xt from current pixel, Imin, Imax, alpha, beta
                    bit = brightness(xt,Auxcurr(1),Auxcurr(2),alpha,beta);
                    
                    %if value from color distance is less than out epsilon,
                    %and brightness = true, we have a match in the
                    %codebook. Turn the flag and save its matched index
                    %location.
                    if (delta < epsilon) && (bit == 1)
                        matched = 1;
                        matchedindex = ii;
                        break;
                    end
                end
            end
            
            %if codebook is empty or does not match any in the codebook,
            %create new codeword by defining vl and aux,
            %update wordcount counter
            %save both into a string array and add to the codebook
            if isempty(codebook) || matched == 0
                vl = [R(i,j),G(i,j),B(i,j)];
                aux = [I,I,1,k-1,k,k];
                wordcount = wordcount+1;
                codeword = {{vl},{aux}};
                codebook(wordcount) = {codeword};
            
            %there is a match from above, update the vl and aux in the
            %codebook
            else
                Vcurr = [((Auxcurr(3)*Vcurr(1)+ xt(1))/(Auxcurr(3)+1)), ((Auxcurr(3)*Vcurr(2)+ xt(2))/(Auxcurr(3)+1)),((Auxcurr(3)*Vcurr(3)+ xt(3))/(Auxcurr(3)+1))];
                Auxcurr = [min(I,Auxcurr(1)), max(I,Auxcurr(2)), Auxcurr(3)+1, max(Auxcurr(4),(k-Auxcurr(6))), Auxcurr(5),k]; 
                curr={{Vcurr},{Auxcurr}};
                codebook(matchedindex) = {curr};
            end
        end
        
        %after all frames are processed, update lambda
        for jj=1:wordcount
            
            curr2 = codebook(jj);
            tempAuxcurr2 = curr2{1}{2};
            Auxcurr2 = tempAuxcurr2{1};
            
            temp = Nframes - Auxcurr2(6) + Auxcurr2(5) - 1;
            lambda = max(Auxcurr2(4),temp);
            Auxcurr2(4)=lambda;
            curr2{1}{2}=Auxcurr2;
            codebook(jj)={curr2};
        end 
        
        %update final counter and add the codeword to the final codebook
        CBfinalcounter = CBfinalcounter+1;
        CBfinal(CBfinalcounter)={codebook};
    end
end

% disp(real(mean(deltaarray)));

end