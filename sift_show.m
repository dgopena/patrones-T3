function [f, d] = sift_show(img, c)
  imshow(img);

  [f, d] = vl_sift(single(gs(img)));

  perm = randperm(size(f,2));
  sel = perm(1:min(c, size(f,2)));
  h1 = vl_plotframe(f(:,sel));
  h2 = vl_plotframe(f(:,sel));
  set(h1,'color','k','linewidth',3);
  set(h2,'color','y','linewidth',2);

  h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel));
  set(h3,'color','g');
end
