function samples = Q1_gen_samples(num_sample)
num_grid = floor(sqrt(num_sample));
domain = linspace(-3,3,num_grid);
rep = ones(size(domain));
samples = [];
for i=domain
    samples = [samples,[domain;rep*i]];
end
end