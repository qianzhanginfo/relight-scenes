function A_all = transforms_propagate(A_k, W_nn)
% Equation 5 in the paper: W_nn * A_all = A_k

A_all = W_nn \ A_k';
A_all = reshape(A_all', 3,3,[]);