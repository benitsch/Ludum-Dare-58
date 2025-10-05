shader_type canvas_item;


uniform float scale = 1;
uniform vec2 offset;


void fragment() {
	vec2 new_uv = clamp((UV * 2. - 1.) / scale,-1,1);
	new_uv = (new_uv + 1.) * 0.5 + offset;
	COLOR.a = 1. - texture(TEXTURE, new_uv).a;
}
