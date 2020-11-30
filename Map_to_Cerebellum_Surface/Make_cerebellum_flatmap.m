Data=suit_map2surf('results_dense_subcortical_tfce_ztstat_uncp_c2.nii', 'space', 'FSL', 'stats', @minORmax);
Data=suit_map2surf('results_dense_subcortical_tfce_ztstat_fwep_c1.nii', 'space', 'FSL', 'stats', @minORmax);
mymap=[0 0.3 1; 0 0.35 1; 0 0.3 1; 0 0.4 1; 0 0.45 1; 0 0.5 1; 0 0.55 1; 0 0.6 1; 0 0.65 1; 0 0.7 1; 0 0.75 1; 0 0.8 1; 0 0.85 1; 0 0.9 1; 0 0.95 1; 0 1 1];
suit_plotflatmap(Data,'threshold',2, 'cscale', [1.8 3], 'cmap',hot)
suit_plotflatmap(Data,'threshold',1.3, 'cscale', [1 2.5], 'cmap',mymap)