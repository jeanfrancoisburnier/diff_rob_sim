classdef rob_sim_robotran
    
    % Private variables
    properties(Access = private) 
        end_sim_;
    end
    
    % Public variables
    properties
        t_;
        k_;
        map_;
        AVI_;
        myMovie_;
    end
    
    % Methods implementation
    methods
        function obj     = rob_sim_robotran(t, map, AVI, myMovie)
            obj.t_       = t;
            obj.k_       = 1;
            obj.end_sim_ = false;
            obj.map_     = map;
            
            if nargin > 2
                obj.AVI_     = AVI;
                obj.myMovie_ = myMovie;
            else
                obj.AVI_     = false;
            end
        end
        
        function obj = update(obj)
            
            k           = obj.k_;
            if (obj.end_sim_)
                obj.t_(k) = inf;
                return;
            end
            obj.k_      = obj.k_+1;
        end
        
        function current_time = getCurrentTime(obj)
            current_time = obj.t_(obj.k_);
        end
        
        function obj = endSim(obj,val)
            obj.end_sim_ = val;
        end
    end
end