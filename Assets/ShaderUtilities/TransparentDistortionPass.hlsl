#ifndef TRANSPARENT_DISTORTION_PASS_INCLUDED
#define TRANSPARENT_DISTORTION_PASS_INCLUDED

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
    UNITY_DEFINE_INSTANCED_PROP(sampler2D , _BackgroundTexture)
    UNITY_DEFINE_INSTANCED_PROP(sampler2D , _BumpTex)
    UNITY_DEFINE_INSTANCED_PROP(float, _DistortStrength)
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
    float4 grabPos : TEXCOORD0;
};

vertexOutput vertex(vertexInput input)
{
    vertexOutput output;

    // convert input to world space
    output.pos = UnityObjectToClipPos(input.vertex);
    float4 normal4 = float4(input.normal, 0.0);
    float3 normal = normalize(mul(normal4, unity_WorldToObject).xyz);

    // use ComputeGrabScreenPos function from UnityCG.cginc
    // to get the correct texture coordinate
    output.grabPos = ComputeGrabScreenPos(output.pos);

    // distort based on bump map
    float3 bump = tex2Dlod(_BumpTex, float4(input.texCoord.xy, 0, 0)).rgb;
    output.grabPos.x += bump.x * _DistortStrength;
    output.grabPos.y += bump.y * _DistortStrength;

    return output;
}

float4 fragment(vertexOutput input) : COLOR
{
    return tex2Dproj(_BackgroundTexture, input.grabPos);
}

#endif