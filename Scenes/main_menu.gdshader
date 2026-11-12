shader_type canvas_item;

uniform vec4 top_color : source_color = vec4(0.12, 0.55, 0.85, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.04, 0.06, 0.12, 1.0);
uniform vec4 grid_color : source_color = vec4(0.18, 0.42, 0.68, 1.0);
uniform vec4 horizon_color : source_color = vec4(0.25, 0.72, 1.0, 1.0);
uniform float speed : hint_range(0.0, 5.0) = 0.8;
uniform float grid_density : hint_range(2.0, 30.0) = 12.0;
uniform float horizon_pos : hint_range(0.1, 0.9) = 0.42;

void fragment() {
	float dy = UV.y - horizon_pos;

	// Přechod ze světlejší modré nahoře do tmavé dole
	vec3 sky = mix(top_color.rgb, bottom_color.rgb, smoothstep(0.0, horizon_pos, UV.y));
	vec3 col = mix(sky, bottom_color.rgb, step(0.0, dy));

	// Perspektivní mřížka pod horizontem
	float safe_dy = max(dy, 0.001);
	float z = 1.0 / safe_dy;
	float x = (UV.x - 0.5) * z;
	vec2 grid_uv = vec2(x, z + TIME * speed) * (grid_density * 0.15);

	vec2 grid = abs(fract(grid_uv - 0.5) - 0.5) / max(fwidth(grid_uv), vec2(0.0001));
	float line = 1.0 - min(min(grid.x, grid.y), 1.0);
	line *= step(0.0, dy) * smoothstep(0.0, 0.12, dy);

	col = mix(col, grid_color.rgb, line * 0.85);

	// Záře na horizontu
	float glow = exp(-abs(dy) * 20.0);
	col += horizon_color.rgb * glow * 0.55;

	// Jemné CRT scanlines
	float scanline = sin(UV.y * 360.0) * 0.03;
	col -= scanline;

	COLOR = vec4(col, 1.0);
}