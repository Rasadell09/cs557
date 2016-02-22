#version 330 compatibility
in vec2 vST;

uniform float uScenter;
uniform float uTcenter;
uniform float uDs;
uniform float uDt;
uniform float uMagFactor;
uniform float uRotAngle;
uniform float uSharpFactor;
uniform sampler2D uImageUnit;

void
main ()
{
	vec2 ct = vec2(uScenter, uTcenter);
	vec3 rgb = texture2D(uImageUnit, vST).rgb;

	if ((vST.s>(ct.s-uDs)) && (vST.s<(ct.s+uDs)) && (vST.t>(ct.t-uDt)) && (vST.t<(ct.t+uDt))) {
		vec2 magst = (vST - ct)/uMagFactor;
		vec2 rotst = vec2(magst.s*cos(uRotAngle)-magst.t*sin(uRotAngle), magst.s*sin(uRotAngle)+magst.t*cos(uRotAngle));
		vec2 comst = rotst + ct;
		ivec2 ires = textureSize(uImageUnit, 0);
		vec3 irgb = texture2D(uImageUnit, comst).rgb;
		float ResS = float(ires.s);
		float ResT = float(ires.t);
		vec2 stp0 = vec2(1./ResS, 0. );
		vec2 st0p = vec2(0. , 1./ResT);
		vec2 stpp = vec2(1./ResS, 1./ResT);
		vec2 stpm = vec2(1./ResS, -1./ResT);
		vec3 i00 = texture2D( uImageUnit, comst ).rgb;
		vec3 im1m1 = texture2D( uImageUnit, comst-stpp ).rgb;
		vec3 ip1p1 = texture2D( uImageUnit, comst+stpp ).rgb;
		vec3 im1p1 = texture2D( uImageUnit, comst-stpm ).rgb;
		vec3 ip1m1 = texture2D( uImageUnit, comst+stpm ).rgb;
		vec3 im10 = texture2D( uImageUnit, comst-stp0 ).rgb;
		vec3 ip10 = texture2D( uImageUnit, comst+stp0 ).rgb;
		vec3 i0m1 = texture2D( uImageUnit, comst-st0p ).rgb;
		vec3 i0p1 = texture2D( uImageUnit, comst+st0p ).rgb;
		vec3 target = vec3(0.,0.,0.);
		target += 1.*(im1m1+ip1m1+ip1p1+im1p1);
		target += 2.*(im10+ip10+i0m1+i0p1);
		target += 4.*(i00);
		target /= 16.;
		rgb = mix( target, irgb, uSharpFactor );
	}

	gl_FragColor = vec4(rgb, 1.);
}