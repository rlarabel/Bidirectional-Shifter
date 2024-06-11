restart

#Wait out 100ns GSR (important for post-route timing simulation, but not for behavioral simulations)
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns

add_force clr {1 0ns}
run 100ns

add_force clr {0 0ns}
add_force M {01 0ns}
add_force S {01 0ns}
add_force I {0000 0ns}
run 40ns

add_force M {10 0ns}
add_force S {01 0ns}
add_force I {0000 0ns}
run 30ns

add_force clr {1 0ns}
run 20ns

add_force clr {0 0ns}
add_force M {11 0ns}
add_force S {01 0ns}
add_force A {1111 0ns}
run 10ns

add_force M {0000 0ns}
add_force S {01 0ns}
add_force A {1010 0ns}
run 50ns


