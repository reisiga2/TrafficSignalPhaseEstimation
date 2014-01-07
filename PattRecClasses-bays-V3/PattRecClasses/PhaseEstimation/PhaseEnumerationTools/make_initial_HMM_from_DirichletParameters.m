% this function generates initial hmm from parameters of
% dirichlet distribution. 

function initialHMM = make_initial_HMM_from_DirichletParameters...
    (initialParameters, TransPrameters, EmissionParameters)
    
scaled_initialParameters = scale_matrix (initialParameters);
scaled_TransPrameters = scale_matrix (TransPrameters);
scaled_EmissionParameters = scale_matrix(EmissionParameters);

mc = MarkovChain (scaled_initialParameters,scaled_TransPrameters);
emission = DiscreteD(scaled_EmissionParameters);

initialHMM= HMM(mc, emission);

end