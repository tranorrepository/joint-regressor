function clusters = learn_clusters(cachdir, pos_train, pos_val, tsize)
% 1. cluster pairwise relative positions
% 2. learn mean relative positions for each type.
conf = global_conf();
cachedir = conf.cachedir;

try
  load([cachedir cluster_name]);
catch
  % cluster relative positions
  clusters = cluster_rp(cat(1, pos_train, pos_val), tsize);
  save([cachedir cluster_name], 'clusters');
end
