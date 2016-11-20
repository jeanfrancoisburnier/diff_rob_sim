classdef circle
    
    % Private variables
    properties(Access = private)
        pts_;
        qty_;
        phase_;
    end
    
    % Public variables
    properties
        R_;
        ctr_;
    end
    
    % Methods implementation
    methods
        function obj     = circle(R, ctr, qty, phase)
            obj.R_   = R;
            obj.ctr_ = ctr;
            if nargin < 3
                obj = obj.getCircle();
            else
                obj.qty_ = qty;
                if nargin == 4
                    obj.phase_ = phase;
                    obj = obj.getCircle(qty, phase);
                else
                    obj = obj.getCircle(qty);
                end
            end
        end
        
        function drawCircle(obj)
            if ~ishold
                hold on;
                holding = false;
            else
                holding = true;
            end
            plot(obj.pts_(1,:),obj.pts_(2,:));
            
            if ~holding
                hold off;
            end
        end
        
        function obj = getCircle (obj, qty, phase)
            % GETCIRCLE returns the (x,y,z) point of a circle of by a circle
            % structure. If you only want a portion of the circle pass the
            % the angle of the circular sector you want. (Only adapted for
            % circle in a xy plane)

            if nargin < 2
                agl = 2*pi;
            else
                agl = mod(qty,2*pi);
            end
            
            if nargin < 3
                phase = 0;
            end

            r  = obj.R_;

            if(r<=0)
                error('Error - Radius has to be greater than zero');
            end

            ctr = obj.ctr_;

            n = 100; % number of points for angle

            theta = linspace(phase,agl+phase,n); % angle

            % computing x, y and z
            x = r.*cos(theta)+ctr(1);
            y = r.*sin(theta)+ctr(2);

            obj.pts_ = [x;y];
        end
    end
end