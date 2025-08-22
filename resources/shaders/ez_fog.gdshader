shader_type spatial;

uniform sampler2D noise;
uniform sampler2D noise2;

void fragment() {
    float scroll_speed = TIME * 0.001;
    vec4 t = texture(noise, vec2(UV.x + scroll_speed, UV.y - scroll_speed));
    vec4 t2 = texture(noise2, vec2(UV.x - scroll_speed, UV.y + scroll_speed));
    //ALBEDO = t.rgb;
    ALPHA = mix(t, t2, 0.5).r;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
