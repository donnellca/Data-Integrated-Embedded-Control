function AB = find_AB(p,u,U_trans)
[~,i_u] = min(abs([U_trans{:,1}]-u));
TRI_i = U_trans{i_u,2};
TRI_trans = U_trans{i_u,3};
[~,i_p] = find_simplex(p, TRI_i);
AB = transpose(TRI_trans{i_p});
end