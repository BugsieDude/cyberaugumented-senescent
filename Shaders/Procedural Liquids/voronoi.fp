/*
// This work is free of known copyright restrictions.
// Written by Tucker Matous, 2016/2019
// Additional credit to various users of Shadertoy.com
*/


//Uncommented nightmare, good luck!
vec4 Process(vec4 color)
{
    const vec2 DENSITY = vec2(4.0, 9.0);
/*    const float dither4x4[16] = 
    {
        0,          8.0/64.0,   2.0/64.0,   10.0/64.0,
        12.0/64.0,  4.0/64.0,   14.0/64.0,  6.0/64.0,
        3.0/64.0,   11.0/64.0,  1.0/64.0,   9.0/64.0,
        15.0/64.0,  7.0/64.0,   13.0/64.0,  5.0/64.0
    }; */
    const float dither2x2[4] =
    {
        0,          2.0/32.0,
        3.0/32.0,   1.0/32.0
    };
    
    vec2 texCoord = gl_TexCoord[0].st;
    ivec2 texRes = textureSize(tex, 0);
    int noiseRes = textureSize(noise, 0).y;
    int colorRes = textureSize(colormap, 0).y;
    
    int ditherCoord = int(texCoord.x*texRes.x)%2 + int(texCoord.y*texRes.y)%2*2;
    texCoord = floor(texCoord*texRes)/texRes;
    
    vec2 point = floor(texCoord*DENSITY);
    vec2 fraction = fract(texCoord*DENSITY);
    vec2 result = vec2(16.0);
    
    for(float x = -2.0; x <= 2.0; x++)
    for(float y = -2.0; y <= 2.0; y++)
    {
        vec2 cell = vec2(x,y);
        vec2 offset = 0.5+0.5*sin(timer+6.2831*texelFetch(noise, ivec2((point+cell)/5.0*noiseRes)%noiseRes, 0).xy);
        vec2 r = cell-fraction+offset; //I forgot what r is supposed to stand for
        
        float dist = dot(r, r);
        if(dist < result.x)
        {
            result.y = result.x;
            result.x = dist;
        } else if(dist < result.y)
        	result.y = dist;
    }
    
    vec4 gradient = texelFetch(colormap, ivec2(0.0, clamp(result.x+dither2x2[ditherCoord]-0.125, 0.0, 0.99)*colorRes), 0);
    
    return gradient*color;
}