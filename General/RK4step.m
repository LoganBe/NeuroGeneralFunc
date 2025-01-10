function yout = RK4step(f,yin,dt)

k1 = f(yin);
p1 = yin+k1*dt/2;

k2 = f(p1);
p2 = yin+k2*dt/2;

k3 = f(p2);
p3 = yin+k3*dt;

k4 = f(p3);

yout = yin + (1/6)*(k1 + 2*k2 + 2*k3+k4)*dt;