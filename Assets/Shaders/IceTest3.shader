Shader"Custom/IceTest3"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" 
        _BumpTex("Bump", 2D) = "white" {}
        _DistortStrength("Distort Strength", float) = 1.0
    }

    SubShader
    {

    GrabPass
            {
                "_BackgroundTexture"
            }

    Pass 
		    {
			    Tags  
			    {
				    "Queue" = "Transparent"
			    }

                CGPROGRAM
			    #pragma multi_compile_instancing
                #pragma vertex vertex
                #pragma fragment fragment
                #include "UnityCG.cginc"
                #include "../ShaderUtilities/SeeThroughPass.hlsl"
                ENDCG
            }
    }
}
