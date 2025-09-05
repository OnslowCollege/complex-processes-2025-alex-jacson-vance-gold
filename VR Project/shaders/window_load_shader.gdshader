shader_type canvas_item;

uniform float reveal_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Only draw pixels above reveal cutoff
    if (UV.y <= reveal_amount) {
        COLOR = texture(TEXTURE, UV);
    } else {
        discard;
    }
}
