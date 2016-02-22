surface
a1 (float 
			Ar=0.4,
			Br=0.4, 
			Ks=0.5, 
			Kd=0.5, 
			Ka=0.1, 
			roughness=0.1; 
		color specularcolor=color(1, 1, 1))
{
	float up = 2. * u;
	float vp = v;
	float numinu = floor( up / (2 * Ar) ); 
	float numinv = floor( vp / (2 * Br) );
	float uc = numinu * 2. * Ar + Ar;
	float vc = numinv * 2. * Br + Br;

	color dotColor = Cs;
	if (mod(numinu+numinv, 2) == 0) {
		if (pow((up-uc)/Ar, 2)+pow((vp-vc)/Br,2) <= 1 ) {
			dotColor = (1., .5, .2);
		}
	}

	varying vector Nf = faceforward( normalize(N), I );
	vector V = normalize( -I );
	Oi = 1.;
	Ci = Oi * ( dotColor * ( Ka * ambient() + Kd * diffuse(Nf) ) + specularcolor * Ks * specular( Nf, V, roughness ) );
}