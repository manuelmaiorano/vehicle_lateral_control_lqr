function X_W_O = affine(Rotation, Translation)
    X_W_O = zeros(3);
    X_W_O(1:2, 1:2) = Rotation;
    X_W_O(1:2, 3)  = Translation;
    X_W_O(3, 3) = 1;
end

