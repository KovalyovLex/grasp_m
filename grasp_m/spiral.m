function spiral
for i=1:1:300
    j=i;
z(i) = 0.1+j*0.1;
y(i) = sin(z(i)) + sin(z(i)+pi/3) + sin(z(i)+2*pi/3);
x(i) = cos(z(i)) + cos(z(i)+pi/3) + cos(z(i)+2*pi/3);
end
plot3 (x, y, z)
end