#version 330 compatibility
in vec4  vColor;
in float vLightIntensity;
in vec2  vST;
in vec3  vMCposition;

uniform float uAd;
uniform float uBd;
uniform float uNoiseAmp;
uniform float uNoiseFreq;
uniform float uTol;
uniform float uAlpha;
uniform sampler3D Noise3;

void
main ()
{
	float sp = 2*vST.s;
	float tp = vST.t;
	int numins = int( sp / (2.*uAd) );
	int numint = int( tp / (2.*uBd) );
	float sc = numins * 2. * uAd + uAd;
	float tc = numint * 2. * uBd + uBd;

	vec4 nv = texture3D( Noise3, uNoiseFreq * vMCposition );
	float oldrad = length(vec2(sp-sc, tp-tc));
	float newrad = oldrad + (uNoiseAmp * (nv.r + nv.g + nv.b + nv.a - 2.));
	vec2 stp = vec2(sp-sc, tp-tc) * newrad/oldrad;
	float d = pow(stp.s/uAd, 2)+pow(stp.t/uBd, 2);
	
	if (d <= 1.) {
		float t = smoothstep(1-uTol, 1+uTol, d);
		gl_FragColor = mix(vec4(1, .4, 0., 1.),vec4(1., 1., 1., 1.), t);
	}
	else {
		gl_FragColor = vec4(1., 1., 1., 1.);
		if (uAlpha == 0.)
			discard;
		else
			gl_FragColor.a = uAlpha;
	}

	gl_FragColor.rgb *= vLightIntensity;
}