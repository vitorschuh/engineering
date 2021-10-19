function [x, t] = pam4(bitstream, ts, dt)
    x = [];
    for i = 1:2:length(bitstream)
        if (bitstream(i) == 0) && (bitstream(i+1) == 0)
            x = [x -3*ones(1, round((ts)/dt))];
  
        elseif bitstream(i) == 0 && bitstream(i+1) == 1
            x = [x -1*ones(1, round((ts)/dt))];
            
        elseif bitstream(i) == 1 && bitstream(i+1) == 0
            x = [x 1*ones(1, round((ts)/dt))];
            
        else
            x = [x 3*ones(1, round((ts)/dt))]; 
            
        end
        t = 0:dt:((length(x)-1)*dt);
    end
end