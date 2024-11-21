shader_type canvas_item;

// The texture you want to mask (this could also be set as the texture on the image node)
uniform sampler2D mask_image;

// Tilemap Position in world space
uniform vec2 tilemap_position;

// Tile size in pixels
uniform vec2 tile_size;

// Texture from the tilemap for masking (likely a generated texture or render target)
uniform sampler2D tilemap_mask_texture;

void fragment() {
    // Get the current pixel position in the world space
    vec2 world_pos = SCREEN_UV * SCREEN_PIXEL_SIZE;

    // Convert the world position to tilemap coordinates
    vec2 tilemap_coords = (world_pos - tilemap_position) / tile_size;

    // Sample the tilemap texture to check if there's a tile here
    // We assume tilemap_mask_texture has white areas for tiles and black for empty spaces
    float tile_alpha = texture(tilemap_mask_texture, tilemap_coords).r;

    // Sample the mask_image texture
    vec4 img_color = texture(mask_image, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);

    // Use the alpha from tile_alpha to determine if we should draw img_color
    // If there's no tile (alpha = 0), we discard the fragment
    if (tile_alpha < 0.5) {
        discard;
    } else {
        COLOR = img_color;
    }
}