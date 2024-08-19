shader_type canvas_item;
uniform float saturation = 1.0;

mat4 saturationMatrix(float sat)
{
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    
    float oneMinusSat = 1.0 - sat;
    
    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3( sat, 0, 0 );
    
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0, sat, 0 );
    
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0, sat );
    return mat4(vec4(red,0),
                 vec4(green,   0),
                 vec4(blue,    0),
                 vec4(0, 0, 0, 1) );
}

void fragment() {
	COLOR = saturationMatrix(saturation) * COLOR;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
