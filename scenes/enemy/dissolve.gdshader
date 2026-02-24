shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.0);
uniform sampler2D noise_tex;
uniform vec4 edge_color : source_color = vec4(1.0, 0.3, 0.0, 1.0);
uniform float edge_width = 0.1;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float noise = texture(noise_tex, UV).r;

    if (noise < dissolve_amount) {
        discard;
    }

    float edge = smoothstep(dissolve_amount, dissolve_amount + edge_width, noise);
    vec4 final_color = mix(edge_color, tex, edge);

    COLOR = final_color;
}
