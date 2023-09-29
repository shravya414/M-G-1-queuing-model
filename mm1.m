function [arrivedtime,departedtime,nbrarrived]=mm1(lambda,mu,sim_time)
%lambda=9; %arrival rate
%mu=15; %service rate    
%st=1000; %simulation time

curr_time=0; %current time
tstep=1; %average time between consecutive measurement events
curr_passengers=0; %current number of passengers in system
event=zeros(1,3); %constructs vector to keep time for next arrival %(pos 1),next service completion (pos 2) and next% measurement event (pos 3)
event(1)=exprnd(1/lambda); %time for next arrival1
event(2)=inf; %no next service completion (empty system)
event(3)=exprnd(tstep); %time for next measurement event
bag=randi(25,40);
nbrmeasurements=0; %number of measurement events so far
nbrdeparted=0; %number of departed customers
nbrarrived=0; %number of arrived customers 
while curr_time<sim_time
    [curr_time,nextevent]=min(event);
    if nextevent==1 % arrival event
        bag_current=bag;
        event(1)=exprnd(1/lambda)+curr_time;
        curr_passengers=curr_passengers+1;
        nbrarrived=nbrarrived+1; %one more customer has arrived to the system through the simulations
        arrivedtime(nbrarrived)=curr_time; %the new customer arrived at time t
        if curr_passengers==1 %generating departure time for customer
          if bag_current>30
            event(2)=exprnd(1/(2*mu))+curr_time;
          else
            event(2)=exprnd(1/mu)+curr_time;
          end
        end
    elseif nextevent==2
        curr_passengers=curr_passengers-1;
        timeinsystem=curr_time-arrivedtime(nbrarrived-curr_passengers);
        nbrdeparted=nbrdeparted+1; %one more customer has departed from the system through the simulations
        departedtime(nbrdeparted)=timeinsystem;
        if curr_passengers>0
            event(2)=exprnd(1/mu)+curr_time;
        else
            event(2)=inf;
        end
    else
        nbrmeasurements=nbrmeasurements+1; %one more measurement event
        N(nbrmeasurements)=curr_passengers;
        event(3)=event(3)+exprnd(tstep);
    end
end