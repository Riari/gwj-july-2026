shader_type canvas_item;

uniform bool flash_active = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (flash_active) {
        tex_color.rgb = vec3(1.0) - tex_color.rgb;
    }
    COLOR = tex_color;
}