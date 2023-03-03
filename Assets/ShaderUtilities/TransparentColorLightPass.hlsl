#ifndef TRANSPARENT_COLOR_LIGHT_PASS_INCLUDED
#define TRANSPARENT_COLOR_LIGHT_PASS_INCLUDED

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    UNITY_DEFINE_INSTANCED_PROP(sampler2D , _RampTex)
    UNITY_DEFINE_INSTANCED_PROP(sampler2D , _BumpTex)
    UNITY_DEFINE_INSTANCED_PROP(sampler2D , _BumpRamp)
    UNITY_DEFINE_INSTANCED_PROP(uniform float4 , _Color)
    UNITY_DEFINE_INSTANCED_PROP(uniform float , _EdgeThickness)
    UNITY_DEFINE_INSTANCED_PROP(sampler2D , _BackgroundTexture)
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)


struct vertexInput
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float3 texCoord : TEXCOORD0;
};

struct vertexOutput
{
    float4 pos : SV_POSITION;
    float3 normal : NORMAL;
    float3 texCoord : TEXCOORD0;
    float3 viewDir : TEXCOORD1;
};

vertexOutput vertex(vertexInput input)
{
    vertexOutput output;

				// convert input to world space
    output.pos = UnityObjectToClipPos(input.vertex);
    float4 normal4 = float4(input.normal, 0.0);
    output.normal = normalize(mul(normal4, unity_WorldToObject).xyz);
    output.viewDir = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, input.vertex).xyz);

                // texture coordinates
    output.texCoord = input.texCoord;

    return output;
}

float4 fragment(vertexOutput input) : COLOR
{
    // compute sillouette factor
    float edgeFactor = abs(dot(input.viewDir, input.normal));
    float oneMinusEdge = 1.0 - edgeFactor;
    // get sillouette color
    float3 rgb = tex2D(_RampTex, float2(oneMinusEdge, 0.5)).rgb;
    // get sillouette opacity
    float opacity = min(1.0, _Color.a / edgeFactor);
    opacity = pow(opacity, _EdgeThickness);

    // apply bump map
    float3 bump = tex2D(_BumpTex, input.texCoord.xy).rgb + input.normal.xyz;
    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    float ramp = clamp(dot(bump, lightDir), 0.001, 1.0);
    float4 lighting = float4(tex2D(_BumpRamp, float2(ramp, 0.5)).rgb, 1.0);

    return float4(rgb, opacity) * lighting;
}

#endif