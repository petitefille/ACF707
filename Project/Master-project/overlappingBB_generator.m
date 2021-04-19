function A = overlappingBB_generator(returns,b,n)

    scen = overlappingBB(returns,b);
    [R,C] = size(scen);
    A = [];
    
    % if n <= R
    
    % else
    nrRow_A = R;
    while nrRow_A <= n
        A = [A ; scen];
        [nrRow_A,~] = size(A);
        scen = overlappingBB(returns,b);
        
    end 
    
    A = A(1:n,:);
    
    

end