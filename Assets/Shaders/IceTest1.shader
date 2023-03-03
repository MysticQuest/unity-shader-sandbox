Shader "Custom/IceShaderTest1"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _DepthTex ("Depth Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DepthTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;

           v2f vert (appdata v)
           {
               v2f o;
               o.vertex = UnityObjectToClipPos(v.vertex);
               o.uv = TRANSFORM_TEX(v.uv, _MainTex);
               return o;
           }

           fixed4 frag (v2f i) : SV_Target
           {
               fixed4 col = tex2D(_MainTex, i.uv);
               col.rgb *= fixed3(0.9, 0.9, 1); // add blue tint here 
               col.a *= tex2D(_DepthTex,i.uv).r; // use depth texture to control thickness 
               col.a *= tex2D(_NoiseTex,i.uv).r; // use noise texture to add frost patterns 
               col.a *= 0.8; // adjust transparency here 
               return col;
           }
            
           ENDCG
            
       }
   }
}