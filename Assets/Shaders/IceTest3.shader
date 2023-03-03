Shader"Custom/IceTest3"
{
    Properties
    {
        _RampTex("Ramp", 2D) = "white" {}
        _BumpTex("Bump", 2D) = "white" {}
        _BumpRamp("Bump Ramp", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _EdgeThickness("Silouette Dropoff Rate", float) = 1.0
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
                #include "../ShaderUtilities/TransparentDistortionPass.hlsl"
                ENDCG
            }
    Pass 
		    {
			    Tags  
			    {
                    "LightMode" = "ForwardBase"
				    "Queue" = "Transparent"
			    }

                Cull Off
                Blend SrcAlpha
                OneMinusSrcAlpha

                CGPROGRAM
			    #pragma multi_compile_instancing
                #pragma vertex vertex
                #pragma fragment fragment
                #include "UnityCG.cginc"
                #include "../ShaderUtilities/TransparentColorLightPass.hlsl"
                ENDCG
            }
    }
}
