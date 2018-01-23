function im = getim(name)
%im = spm_read_vols(spm_vol(name));

nii=nii_tool('load',name );
im=double(nii.img);

end