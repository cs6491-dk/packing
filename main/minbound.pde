Disk solvePair(Disk d1, Disk d2) {
  float dx = d2.x - d1.x,
        dy = d2.y - d1.y;
  float n = sqrt(dx*dx + dy*dy);
  float r = (n+d1.r+d2.r)/2;
  float x = d1.x + dx/n*(r-d1.r),
        y = d1.y + dy/n*(r-d1.r);

  return new Disk(x, y, r);
}

// adapted from http://www.diku.dk/hjemmesider/ansatte/rfonseca/implementations/apollonius.html
Disk solveApollonius(Disk d1, Disk d2, Disk d3, int s1, int s2, int s3)
{

if (d1.x == d2.x) {
  Disk tmp = d2;
  d2 = d3;
  d3 = tmp;
}

float x1 = d1.x;
float y1 = d1.y;
float r1 = d1.r;
float x2 = d2.x;
float y2 = d2.y;
float r2 = d2.r;
float x3 = d3.x;
float y3 = d3.y;
float r3 = d3.r;

float v11 = 2*x2 - 2*x1;
float v12 = 2*y2 - 2*y1;
float v13 = x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2;
float v14 = 2*s2*r2 - 2*s1*r1;

float v21 = 2*x3 - 2*x2;
float v22 = 2*y3 - 2*y2;
float v23 = x2*x2 - x3*x3 + y2*y2 - y3*y3 - r2*r2 + r3*r3;
float v24 = 2*s3*r3 - 2*s2*r2;

float w12 = v12/v11;
float w13 = v13/v11;
float w14 = v14/v11;

float w22 = v22/v21-w12;
float w23 = v23/v21-w13;
float w24 = v24/v21-w14;

float P = -w23/w22;
float Q = w24/w22;
float M = -w12*P-w13;
float N = w14 - w12*Q;

float a = N*N + Q*Q - 1;
float b = 2*M*N - 2*N*x1 + 2*P*Q - 2*Q*y1 + 2*s1*r1;
float c = x1*x1 + M*M - 2*M*x1 + P*P + y1*y1 - 2*P*y1 - r1*r1;

// Find roots of a quadratic equation
//double[] quadSols = Polynomial.solve(new double[]{a,b,c});
//float rs = (float)quadSols[0];
float rs = (-b + sqrt(b*b-4*a*c))/(2*a);
float xs = M+N*rs;
float ys = P+Q*rs;
println(w12 + " " + w13 + " " + w14);
//println(xs + " " + ys + " " + rs);

return new Disk(xs, ys, rs);
}
