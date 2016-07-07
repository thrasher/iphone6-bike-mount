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
cut_radius=(width*x_scale)/2-beam_width/2;

module case() {
    union() {
        difference() {
            // outer shell
            scale([x_scale, y_scale, z_scale]) iphone(width, height, depth, corner_radius, facecut);

            // subtract iphone actual dimensions
            iphone(width, height, depth, corner_radius, facecut);

            // upper cuts
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
            
            // flat bottom edge
            translate([-x_scale*width/2, -(y_scale*height/2)-.90, -z_scale*depth/2]) cube([x_scale*width, 1, 1]);    
        }

        // top lock tab
        lock_tab_thickness=.1;
        lock_tab_height=.2;
        translate([-beam_width/2, height/2-.1, z_scale*facecut]) cube([beam_width, lock_tab_thickness, lock_tab_height]);
        translate([-beam_width/2, lock_tab_thickness/2+height/2-.1, z_scale*facecut+lock_tab_height]) rotate([0,90,0]) cylinder(h=beam_width, d=lock_tab_thickness);
    }
}

module mount(stem_dia) {
    outer_dia = stem_dia * .8;
    rise = 1;
    outer_radius=.5;
    wall_thickness=.15;
    inner_radius=outer_radius-wall_thickness;
    
    //translate([0,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=outer_dia);
    hull(){
        translate([0,-.8,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=wall_thickness, d=outer_radius);
        translate([0,.8,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=wall_thickness, d=outer_radius);
        translate([-.3,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=wall_thickness, d=outer_radius);
        translate([.3,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=wall_thickness, d=outer_radius);
    }
    difference() {
    hull(){
        translate([0,-.8,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=outer_radius);
        translate([0,.8,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=outer_radius);
        translate([-.3,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=outer_radius);
        translate([.3,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=outer_radius);
    }
    hull(){
        translate([0,-.8,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=inner_radius);
        translate([0,.8,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=inner_radius);
        translate([-.3,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=inner_radius);
        translate([.3,0,-depth*z_scale/2]) rotate([180,0,0]) cylinder(h=rise, d=inner_radius);
    }
    //translate([0,-outer_dia/2,-depth*z_scale/2 - rise]) rotate([90,90,180]) cylinder(h=outer_dia, d=stem_dia);
    translate([0,-3,-depth*z_scale/2 - rise]) rotate([90,90,180]) cylinder(h=6, d=stem_dia);
    translate([stem_dia/2,.6,-depth*z_scale/2 - rise*.2]) rotate([0,90,180]) cylinder(h=stem_dia, d=.2);
    translate([stem_dia/2,-.6,-depth*z_scale/2 - rise*.2]) rotate([0,90,180]) cylinder(h=stem_dia, d=.2);
    }
}

/**
* PRINTABLE PARTS
*/
module printable_tab() {
    difference() {
        case();
        translate([beam_width/2, -1, -1]) cube([3, 4, 1]);
        translate([-3-beam_width/2, -1, -1]) cube([3, 4, 1]);
        translate([-3,-5,-1]) cube([6, 5, 2]);
    }
}
module printable_mount() {
    mount(1.23);
}
module printable_body() {
    difference() {
        case();
        translate([-beam_width/2, 0, -1]) cube([beam_width, 4, 2]);
        translate([-2, cut_radius, -1]) cube([4, 4, 2]);
    }
}
module model() {
    case();
    mount(1.23);
}

model();
//printable_tab();
//printable_body();
//printable_mount();


echo(version=version());

