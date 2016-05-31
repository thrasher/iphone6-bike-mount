/* 
 * iPhone 6 Bike Mount
 * Holds an iPhone v6, within a Yahoo case, securely on a bike.
 * Copyright 2016 Jason Thrasher
 */
$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

width = 2.814; // iphone in case
height = 5.537; // iphone in case
depth = 0.2225*2; // iphone in case, without face cut
corner_radius = 0.45; // outer radius of torus corner
facecut = 0.148; // height above edge radius center, for face if iphone6

// Renders the outer dimensions of the iPhone
// x/y centered in the middle of the phone, and z centered on corner radius
// w=width, h=height, d=depth, c=corner_radius, f=facecut
module iphone(w, h, d, c, f) {
    c = max(c, d); // outer radius of torus corner
    difference() {
        hull(){
            translate([w/2 - c, -h/2 + c, 0])
                rotate_extrude(angle = -90, convexity = 10) translate([c-d/2, 0, 0]) circle(d = d);
        
            translate([-(w/2 - c), -h/2 + c, 0]) rotate([180,0,0])
                rotate_extrude(angle = -90, convexity = 10) translate([-(c-d/2), 0, 0]) circle(d = d);
        
            translate([-(w/2 - c), h/2 - c, 0]) rotate([180,0,0])
                rotate_extrude(angle = 90, convexity = 10) translate([-(c-d/2), 0, 0]) circle(d = d);
        
            translate([w/2 - c, h/2 - c, 0])
                rotate_extrude(angle = 90, convexity = 10) translate([c-d/2, 0, 0]) circle(d = d);
        }
        
        // make the facecut
        translate([-w/2, -h/2, f]) cube([width, height, 10]);
    }
} // end module

x_scale=1.1;
y_scale=1.05;
z_scale=1.6;
beam_width=.4;
// 
difference() {
    // outer shell
    scale([x_scale, y_scale, z_scale]) iphone(width, height, depth, corner_radius, facecut);

    // subtract iphone actual dimensions
    iphone(width, height, depth, corner_radius, facecut);

    // upper cuts
    cut_radius=(width*x_scale)/2-beam_width/2;
    hull() {
        translate([-width*x_scale/2, cut_radius, -depth]) rotate([0,0,90]) cylinder(h=depth*2, r=cut_radius);
        translate([-width*x_scale/2, height, -depth]) rotate([0,0,90]) cylinder(h=depth*2, r=cut_radius);
    }
    hull() {
        translate([width*x_scale/2, cut_radius, -depth]) rotate([0,0,90]) cylinder(h=depth*2, r=cut_radius);
        translate([width*x_scale/2, height, -depth]) rotate([0,0,90]) cylinder(h=depth*2, r=cut_radius);
    }

    // cutout for earbud socket
    hull(){
        translate([-.7, -5, depth-.2]) rotate([270,0,0]) cylinder(h=3, r=depth);
        translate([.7, -5, depth-.2]) rotate([270,0,0]) cylinder(h=3, r=depth);
    }

    // cutout for front face
    h_tab = .3;
    translate([-x_scale*width/2, -(height/2)+h_tab, 0]) cube([x_scale*width, height-h_tab-.15, 1]);
    
}
//translate([-x_scale*width/2, -(height/2)+h_tab, 0]) cube([x_scale*width, height-h_tab-.15, 1]);

echo(version=version());

