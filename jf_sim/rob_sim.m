classdef rob_sim
    
    % Private variables
    properties(Access = private) 
        last_t_;
        end_sim_;
    end
    
    % Public variables
    properties
        dt_;
        t_;
        k_;
        t_max_;
        map_;
        AVI_;
        myMovie_;
    end
    
    % Methods implementation
    methods
        function obj     = rob_sim(dt, t, t_max, map, AVI, myMovie)
            obj.last_t_  = tic;
            obj.dt_      = dt;
            obj.t_       = t;
            obj.k_       = 1;
            obj.end_sim_ = false;
            obj.t_max_   = t_max;
            obj.map_     = map;
            
            if nargin > 4
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
            
            obj.dt_     = toc(obj.last_t_);
            obj.last_t_ = tic;
            obj.t_(k+1) = obj.t_(k)+obj.dt_;
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