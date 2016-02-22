displacement
a2d (float 
			Ar=0.1,
			Br=0.1)
{
	float disp = 0.;

	float up = 2. * u;
	float vp = v;
	float numinu = floor( up / (2. * Ar) ); 
	float numinv = floor( vp / (2. * Br) );
	float uc = numinu * 2. * Ar + Ar;
	float vc = numinv * 2. * Br + Br;
	
	point PP = point "shader" P;
	float magn = 0.2;
	float size = 1.05;
	float i;
	for (i = 0.; i < 6.0; i += 1.0)
	{
		magn += (noise(size*PP)-0.5)/size;
		size *= 2.0;
	}

	point uvp = point(up, vp, 0.);
	point uvc = point(uc, vc, 0.);
	vector delta = uvp-uvc;

	float oldrad = pow((up-uc)/Ar, 2) + pow((vp-vc)/Br, 2);
	float newrad = oldrad + magn;
	delta = delta * newrad/oldrad;

	float deltau = xcomp(delta);
	float deltav = ycomp(delta);
	float d = pow(deltau/Ar, 2) + pow(deltav/Br, 2);	
	if (d <= 1.) {
		disp = (1. - d) * 0.1;

		if (disp != 0.)
		{
			P = P + normalize(N) * disp;
			N = calculatenormal(P);
		}
	}
}