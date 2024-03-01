function Action=ActionSelection(currState,Q)
        [val,index] = max(Q(currState(1),currState(2),:));
        [~,yy] = find(Q(currState(1),currState(2),:) == val);
        if size(yy,1) > 1            
            index = 1+round(rand*(size(yy,1)-1));
            Action = yy(index,1);
        else
            Action = index;
        end
end