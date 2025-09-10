shader_type sky;
uniform float star_height = 5.;
uniform float star_blend : hint_range(0.0, 0.1, 0.01) = .1;
uniform float depth_blend : hint_range(0.0, 0.1, 0.01) = .1;
uniform float flare_ratio : hint_range(0.0, 0.1, 0.01) = .1;
uniform float star_size = 5.;

// Paramètres pour le soleil
uniform vec3 sun_direction: source_color = vec3(0, 0, 0.7); // Direction du soleil
uniform float sun_angular_size = 0.00005; // Taille angulaire du soleil (très petit)
uniform vec3 sun_color: source_color = vec3(1.0, 0.9, 0.7); // Couleur du soleil
uniform float sun_brightness = 20.0; // Brillance du soleil (augmentée pour compenser la petite taille)

// Fonction pour dessiner le soleil (version ultra-précise)
float Sun(vec3 dir, vec3 sun_dir, float angular_size) {
    vec3 normalized_dir = normalize(dir);
    vec3 normalized_sun_dir = normalize(sun_dir);
    float cos_angle = dot(normalized_dir, normalized_sun_dir);

    // Utilise un seuil très strict pour un soleil petit
    float sun = smoothstep(1.0 - angular_size, 1.0, cos_angle);
    return sun;
}

vec2 RandomVec2(vec2 seed) {
    seed = fract(seed * vec2(123.45, 784.29));
    seed += dot(seed, seed + 875.34);
    float x = fract(seed.x * 164.32);
    float y = fract(seed.y * 287.21);
    return vec2(x, y) - .5;
}

float Star(vec2 uv, float flare) {
    float star = .01 / length(uv);
    float rays = max(0., 1. - abs(uv.x * uv.y) * 1000.) * star;
    star += rays * flare;
    return clamp(pow(star, 4.), 0., 1.);
}

void sky() {
    vec3 sky_color = vec3(0.0);
    float blend = smoothstep(star_blend, 1, abs(EYEDIR.y));
    vec2 uv = EYEDIR.xz / EYEDIR.y * star_height;
    vec2 grid_uv = fract(uv) - .5;
    vec2 grid_id = floor(uv);
    vec2 rv = RandomVec2(grid_id);
    float size = (rv.x * .5) * star_size;
    float flare = smoothstep(star_size * (1. - flare_ratio), star_size, size);
    sky_color += Star(grid_uv, flare) * blend * size;
    sky_color += Star(grid_uv - rv, flare) * blend * size;

    // Ajoute le soleil avec une taille angulaire très petite
    sky_color += sun_color * Sun(EYEDIR, sun_direction, sun_angular_size) * sun_brightness;

    COLOR.rgb += sky_color;
}
