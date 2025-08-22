shader_type canvas_item;

uniform float width = 8.0;
uniform float height = 16.0;

void fragment() {
	// This shader requires the Sprite2D to have a texture.
	// The texture's dimensions define the coordinate space for this shader.
	// For example, if the texture is 64x64, you can draw a rectangle
	// up to 64 pixels wide and 64 pixels high.

	// Get the current pixel's coordinate.
	// UV ranges from 0.0 to 1.0 across the texture.
	// TEXTURE_PIXEL_SIZE is a built-in variable equal to vec2(1.0/texture_width, 1.0/texture_height).
	// Dividing UV by TEXTURE_PIXEL_SIZE converts the 0-1 range into pixel coordinates.
	vec2 pixel_coord = UV / TEXTURE_PIXEL_SIZE;

	// Check if the current pixel's coordinate is within the defined width and height.
	if (pixel_coord.x < width && pixel_coord.y < height) {
		// If it is, draw a solid white pixel.
		COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	} else {
		// Otherwise, make the pixel fully transparent.
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}