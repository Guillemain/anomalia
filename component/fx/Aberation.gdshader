shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D distortion;
uniform float clignotement;

void fragment(){
	vec2 disp = texture(distortion, SCREEN_UV+vec2((cos(TIME*2.0)*0.2),(sin(TIME*2.0)*0.2))).rb*0.01 + SCREEN_UV;
	vec3 err = texture(distortion, SCREEN_UV+vec2(abs(cos(TIME*.1)*0.2),(sin(TIME*0.02)*0.2))).rgb ;
	err = err * texture(distortion, SCREEN_UV+vec2(abs(cos(TIME*20.0*sin(TIME*2.0))*1.0),(sin(TIME*2.0)*cos(TIME*2.0)*0.2))).rgb ;
	err = clamp(err,0.3,1.0)/0.3;
	
	COLOR.r = clamp(1.0-texture(SCREEN_TEXTURE, disp+err.g*0.001).r + clignotement,0.0,1.0);
	COLOR.g = clamp(1.0-texture(SCREEN_TEXTURE, disp+err.b*0.002).g+ clignotement,0.0,1.0);
	COLOR.b = clamp(1.0-texture(SCREEN_TEXTURE, disp).b+ clignotement,0.0,1.0);
	COLOR.rgb = pow(COLOR.rgb,vec3(2.0,2.0,2.0));
	
	//vec2 center = global_position;
	//float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	//center.x = center.x / screen_size.x;
	//center.x = (center.x - 0.5) / ratio + 0.5;
	//center.y = (screen_size.y - center.y) / screen_size.y;
	//vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	//float mask = (1.0 - smoothstep(size-0.1, size, length(scaledUV - center))) * smoothstep(size-thickness-0.1, size-thickness, length(scaledUV - center));
	//vec2 disp = normalize(SCREEN_UV - center) * force * mask;
	//COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
}