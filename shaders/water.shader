shader_type canvas_item;

uniform vec3 color = vec3(1., 0., .5);

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1., 0.));
	float c = rand(i + vec2(0., 1.));
	float d = rand(i + vec2(1., 1.));
	
	vec2 cubic = f * f * (3. - 2. * f);
	// Linear Interpolation
	//return mix(a, b, f.x) + (c - a) * f.y * (1. - f.x) + (d - b) * f.x * f.y;
	// Cubic Interpolation
	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1. - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
	float value = .0;
	float scale = .5;
	
	for(int i = 0; i < 10; i++){
		value += noise(coord) * scale;
		coord *= 2.;
		scale *= .5;
	}
	return value;
}

void fragment(){
	vec2 coord = UV * 20.0;
	
	vec2 motion = vec2(fbm(coord + -TIME * 2.));
	
	float final = fbm(coord + motion);
	COLOR = vec4(color, final);
}