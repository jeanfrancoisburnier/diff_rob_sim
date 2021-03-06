classdef diff_rob
    
    % Private variables
    properties(Access = private)
        r_w_; % wheel radius
        b_;   % distance between wheels
        gamma_;
        l_w_speed_;
        r_w_speed_;
        vx_;
        vy_;
        current_target_;
        rob_shape_;
    end
    
    % Public variables
    properties
        id_;
        nb_target_;
        targets_;
        x_;
        y_;
        theta_;
        rob_sim_;
    end
    
    % Methods implementation
    methods
        % Class constructor
        function obj = diff_rob(id, target, nb_target, r_w, b, x, y, theta, gamma, rob_sim1)
            obj.id_ = id;
            obj.nb_target_ = nb_target;
            obj.targets_ = target;
            obj.r_w_ = r_w;
            obj.b_ = b;
            obj.x_ = x;
            obj.y_ = y;
            obj.theta_ = theta;
            obj.gamma_ = gamma;
            obj.l_w_speed_ = 0;
            obj.r_w_speed_ = 0;
            obj.vx_ = 0;
            obj.vy_ = 0;
            obj.rob_sim_ = rob_sim1;
            obj.current_target_ = 1;
            obj.rob_shape_ = robot_shape([obj.x_(1),obj.y_(1)],obj.theta_(1));
        end
        
        function obj = compute_new_speed(obj)
            
            k   = obj.rob_sim_.k_;
            dt  = obj.rob_sim_.dt_;
            
            vectx = obj.targets_(obj.current_target_).x_-obj.x_(k);
            vecty = obj.targets_(obj.current_target_).y_-obj.y_(k);

            beta = atan2(vecty,vectx);
            obj.gamma_(k) = limitAngle(beta-obj.theta_(k));

            a = pi/32; b = pi/16; g = pi/8; d = pi/4;
            
            % Speed control
            if (obj.gamma_(k) > -a/2 && obj.gamma_(k) <= a/2)
                l_speed = +5.0;
                r_speed = +5.0;
                %disp('Dr�!');
            elseif (obj.gamma_(k) > a/2 && obj.gamma_(k) <= b+a/2)
                l_speed = +2.5;
                r_speed = +5.0;
                %disp('Tourne un peu � gauche');
            elseif (obj.gamma_(k) > b+a/2 && obj.gamma_(k) <= g+b+a/2)
                l_speed = -5.0;
                r_speed = +5.0;
                %disp('Tourne un peu plus � gauche');
            elseif (obj.gamma_(k) > g+b+a/2 && obj.gamma_(k) <= d+g+b+a/2)
                l_speed = -8.0;
                r_speed = +8.0;
                %disp('Tourne bien � gauche');
            elseif (obj.gamma_(k) > d+g+b+a/2 && obj.gamma_(k) <= pi)
                l_speed = -10.0;
                r_speed = +10.0;
                %disp('Tourne bcp � gauche');
            elseif (obj.gamma_(k) > -pi && obj.gamma_(k) <= -(d+g+b+a/2))
                l_speed = +10.0;
                r_speed = -10.0;
                %disp('Tourne bcp � droite');
            elseif (obj.gamma_(k) > -(d+g+b+a/2) && obj.gamma_(k) <= -(g+b+a/2))
                l_speed = +8.0;
                r_speed = -8.0;
                %disp('Tourne bien � droite');
            elseif (obj.gamma_(k) > -(g+b+a/2) && obj.gamma_(k) <= -(b+a/2))
                l_speed = +5.0;
                r_speed = -5.0;
                %disp('Tourne un peu plus � droite');
            elseif (obj.gamma_(k) > -(b+a/2) && obj.gamma_(k) <= -a/2)
                l_speed = +5.0;
                r_speed = +2.5;
                %disp('Tourne un peu � droite');
            else
                disp('reach single target failure');
                disp(obj.gamma(k)*180/pi);
                error('Reached single target failure');
            end

            %obj.l_w_speed_ = l_speed;
            %obj.r_w_speed_ = r_speed;
            
            obj.l_w_speed_ = firstOrderFilter(obj.l_w_speed_, l_speed, 0.1, dt); % 0.1
            obj.r_w_speed_ = firstOrderFilter(obj.r_w_speed_, r_speed, 0.1, dt);

            % Tangential velocity in polar space
            vphi = 1/2*obj.r_w_*(obj.l_w_speed_+obj.r_w_speed_);

            % Project tangential velocity in cartesian space
            obj.vx_ = cos(obj.theta_(k))*vphi;
            obj.vy_ = sin(obj.theta_(k))*vphi;
        end
        
        function obj = update(obj)
            
            k = obj.rob_sim_.k_;
            dt = obj.rob_sim_.dt_;
            
            obj.x_(k+1) = obj.vx_*dt+obj.x_(k) + 0.007*(rand()-0.5);
            obj.y_(k+1) = obj.vy_*dt+obj.y_(k) + 0.007*(rand()-0.5);
        
            obj.theta_(k+1) =  limitAngle(obj.r_w_/obj.b_*(obj.r_w_speed_-obj.l_w_speed_)*dt+obj.theta_(k)) + 0.007*(rand()-0.5);
            
            obj.rob_shape_ = obj.rob_shape_.update([obj.x_(k+1),obj.y_(k+1)],obj.theta_(k+1));
            obj = obj.CheckReachedTarget();
            
            obj.rob_sim_ = obj.rob_sim_.update();
        end
        
        function display_sim(obj)
            
            k    = obj.rob_sim_.k_;
            time = obj.rob_sim_.t_;
            
            figure(obj.id_);
            subplot(1,2,1);
            
            % Plot robots path travelled so far
            plot(obj.x_(1:k),obj.y_(1:k),'LineWidth',2); hold on;
            
            % Plot initial position
            plot(obj.x_(1),obj.y_(1),'*','MarkerSize',12,'LineWidth',1);
            
            % Plot robots current position
            obj.rob_shape_.drawRobot();
            %plot(obj.x_(k),obj.y_(k),'o','MarkerSize',12,'LineWidth',3);
            
            % Plots robots directions
            plot([obj.x_(k),obj.x_(k)+0.05*cos(obj.theta_(k))],[obj.y_(k),obj.y_(k)+0.05*sin(obj.theta_(k))],'LineWidth',3);
            
            % Plots targets
            for (l = 1:obj.nb_target_)%obj.current_target_)
                %plot(obj.targets_(l).x_,obj.targets_(l).y_,'kx','MarkerSize',3,'LineWidth',1);
                obj.targets_(l).drawTarget();
            end
            
            obj.rob_sim_.map_.drawMap();
            
            hold off;
            axis([-1.062,1.062,-1.562,1.562]);
            axis('equal');
            xlabel('x [m]'); ylabel('y [m]');
            title('Simulation');
            
            subplot(1,2,2);
            
            % Plots gamma angles as function of time
            plot(time(1:k),obj.gamma_(1:k)*180/pi); grid on;
            
            % Add current angle value to plot
            text(time(k),obj.gamma_(k),num2str(obj.gamma_(k)*180/pi));
            axis([0,obj.rob_sim_.t_max_,-180,180]);
            xlabel('time [s]'); ylabel('\gamma [�]');
            title('Direction error');
            
            % adds a new frame to the movie
            if obj.rob_sim_.AVI_
                frame = getframe(1);
                writeVideo(obj.rob_sim_.myMovie_,frame);
            end
        end
        
        function obj = CheckReachedTarget(obj)
            
            k     = obj.rob_sim_.k_;
            vectx = obj.targets_(obj.current_target_).x_-obj.x_(k); % do for current target
            vecty = obj.targets_(obj.current_target_).y_-obj.y_(k);
            
            if (norm([vectx, vecty]) < 0.05)
                disp('Target reached');
                if (obj.current_target_ == obj.nb_target_)
                    obj.rob_sim_ = obj.rob_sim_.endSim(true);
                else
                    obj.current_target_ = obj.current_target_ + 1;
                end
            end
        end
    end
end