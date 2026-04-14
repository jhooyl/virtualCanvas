shader_type canvas_item;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float gray = (color.r + color.g + color.b) / 3.0;
    COLOR = vec4(vec3(gray), color.a);
}