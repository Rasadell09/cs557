#version 330 compatibility
out vec4  vColor;
out float vLightIntensity;
out vec2  vST;
out vec3  vMCposition;

const vec3 LIGHTPOS = vec3( 0., 0., 10. );

void
main( )
{
	vColor = gl_Color;
	vLightIntensity  = abs( dot( normalize(LIGHTPOS - vec3( gl_ModelViewMatrix * gl_Vertex )), normalize( gl_NormalMatrix * gl_Normal ) )  );
	vST = gl_MultiTexCoord0.st;
	vMCposition = gl_Vertex.xyz;
	
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
