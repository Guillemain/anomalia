shader_type canvas_item;

// from https://github.com/gdquest-demos/godot-shaders re-adapted fgor GODOT 4

uniform vec4 line_color : source_color ;
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform float add_l;
void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	color.rgb = clamp(color.rgb+add_l,0.0,1.0);
	COLOR = mix(color , line_color, outline - color.a);
}