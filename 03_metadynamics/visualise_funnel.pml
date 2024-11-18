load ./6GGI-A-GSS_equi.pdb

hide everythin, solvent
show cartoon, all
show sticks, organic

# take a point 10A deeper into the protein core
select p0, ID 1134 ID 1145 ID 3186 ID 4216 ID 4232 ID 4252 ID 4271 ID 4283 ID 4302 
com p0
show spheres, p0_COM

# select all CA within 10A of the grid center, find its COM
select p1, ID 1015 ID 1059 ID 1438 ID 1479 ID 1493 ID 1553 ID 2606 ID 2660 ID 2672 ID 2691 ID 2698 ID 2746 ID 3245 ID 3264 ID 3313 ID 3327 ID 4349 
com p1
show spheres, p1_COM


# draw the funnel
draw_funnel p0_COM, p1_COM, upper_wall=35.000000,                                                      lower_wall=5.000000,                                                      s_cent=20.000000,                                                      beta_cent=1.500000,                                                      wall_width=8.500000,                                                      wall_buffer=1.500000
