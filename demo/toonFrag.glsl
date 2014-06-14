#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float fraction;
uniform float color1;
uniform float color2;
uniform float color3;
uniform float color4;
uniform float color5;
uniform float color6;
uniform float color7;
uniform float color8;

uniform float color_treshold1;
uniform float color_treshold2;
uniform float color_treshold3;
uniform float color_treshold4;
uniform float color_treshold5;
uniform float color_treshold6;
uniform float color_treshold7;

uniform vec4 baseColor;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main() {
	float intensity;
	vec4 color;
	intensity = max(0.0, dot(vertLightDir, vertNormal));

	if (intensity > pow(color_treshold1, fraction)) {
		color = vec4(vec3(color1), 1.0);
	} else if (intensity > pow(color_treshold2, fraction)) {
		color = vec4(vec3(color2), 1.0);
	} else if (intensity > pow(color_treshold3, fraction)) {
		color = vec4(vec3(color3), 1.0);
	} else if (intensity > pow(color_treshold4, fraction)) {
		color = vec4(vec3(color4), 1.0);
	} else if (intensity > pow(color_treshold5, fraction)) {
		color = vec4(vec3(color5), 1.0);
	} else if (intensity > pow(color_treshold6, fraction)) {
		color = vec4(vec3(color6), 1.0);
	} else if (intensity > pow(color_treshold7, fraction)) {
		color = vec4(vec3(color7), 1.0);
	} else {
		color = vec4(vec3(color8), 1.0);
	}

	gl_FragColor = color * vertColor * baseColor;
}
