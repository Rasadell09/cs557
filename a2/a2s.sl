surface
a2s (float 
			Ar=0.4,
			Br=0.4, 
			Ks=0.5, 
			Kd=0.5, 
			Ka=0.1, 
			roughness=0.1; 
	color 	specularcolor=color(1, 1, 1))
{
	float up = 2. * u;
	float vp = v;
	float numinu = floor( up / (2 * Ar) ); 
	float numinv = floor( vp / (2 * Br) );
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

	color dotColor = Cs;
	if (d <= 1. ) {
		dotColor = (1., .5, 0.);
	}
	else {
		dotColor = (0., 0.5, 1.);
	}

	varying vector Nf = faceforward( normalize(N), I );
	vector V = normalize( -I );
	Oi = 1.;
	Ci = Oi * ( dotColor * ( Ka * ambient() + Kd * diffuse(Nf) ) + specularcolor * Ks * specular( Nf, V, roughness ) );
}
