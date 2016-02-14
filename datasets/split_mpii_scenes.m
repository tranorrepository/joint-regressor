function mpii_data = split_mpii_scenes(mpii_data, threshold)
%SPLIT_MPII_SCENES Label the scenes in the MPII dataset. Uses imhist_dist
%to determine distance between consecutive frames, and cuts off scene when
%distance rises above certain threshold.
mpii_rshift = mpii_data(2:end);
splits = false([1 length(mpii_data)]);
dists = zeros([1 length(mpii_data)]);
parfor i=1:length(mpii_rshift)
    fst = mpii_data(i);
    snd = mpii_rshift(i);
    im1 = readim(fst);
    im2 = readim(snd);
    dists(i) = imhist_dist(im1, im2, 32);
    if dists(i) > threshold
        splits(i) = true;
    end
end

scene_num = 1;

for i=1:length(mpii_data)
    mpii_data(i).scene_num = scene_num;
    if splits(i)
        % Note that splits(end) will always be false, so the following
        % should be safe
        fprintf(...
            'Scene boundary detected between "%s" and "%s" at distance %f\n', ...
            mpii_data(i).image_path, mpii_data(i+1).image_path, dists(i));
        scene_num = scene_num + 1;
    end
end

fprintf('Found %i scenes\n', scene_num);
end