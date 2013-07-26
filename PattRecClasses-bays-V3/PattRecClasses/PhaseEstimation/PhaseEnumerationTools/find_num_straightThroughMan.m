% input: one sigle phase that finds number of straight throgh maneuvers.


function numStraightThroughMan = find_num_straightThroughMan(phase)
    
straightManIndex=[1 4 7 10];    

    if size(phase,2)~=12
        error('there should be 12 maneuvers specified in one phase');
    end

   numStraightThroughMan = sum( phase(straightManIndex));
    
    
end