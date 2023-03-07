Shader "Joy/Unlit/OutlineShader"
{
    Properties
    {
        [MaterialToggle]_OutlineSwitch("OutlineSwitch", Float) = 1
        _Color("Color", Color) = (1,1,1,1)
        [HDR]_OutlineColor("OutlineColor", Color) = (0,0,0,1)
        _OutLineWidth("OutLineWidth", Range(0, 100)) = 2
        [MaterialToggle]_StencilRef("_StencilRef:1 = Disabled,0=Enabled", Float) = 255
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("_StencilComp ", Float) = 0 //0 = Disabled
    }
    SubShader
    {
        Tags {"Queue" = "Geometry" "RenderType" = "Opaque" "DisableBatching" = "True" }
        LOD 100

        Pass
        {
            Name "BASE"
            //Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
            ColorMask RGB
            Stencil
            {
                Ref[_StencilRef]
                Comp [_StencilComp]
                Pass Replace
            }
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            //传入顶点着色器的数据
            struct Attributes
            {
                float4 positionOS   : POSITION;
            };
            //传入片元着色器的数据
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 worldPos: TEXCOORD1;
            };
            CBUFFER_START(UnityPerMaterial)
                float4 _Color;
                
            CBUFFER_END
            float _OutlineSwitch;
            //顶点着色器
            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;

                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.worldPos = TransformObjectToWorld(input.positionOS.xyz);
                return output;
            }
            //片元着色器
            half4 frag(Varyings input) : SV_Target
            {
                 if(_OutlineSwitch==0)
                {
                     discard;
                }
                if(input.worldPos.y<0)
                {
                    discard;
                }
                return _Color;
            }
            ENDHLSL
        }
        Pass
        {
    	    Name "OUTLINE"
            Stencil
            {
                Ref[_StencilRef]
                Comp [_StencilComp]
                Pass Replace
            }
    	    Cull Front
    	    Zwrite On
    	    HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Atributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                //float3 smoothNormal : TEXCOORD3;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 worldPos: TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _OutlineColor;
            float _OutLineWidth;
            float _OutlineSwitch;
            CBUFFER_END

            Varyings vert(Atributes input)
            {
                Varyings o = (Varyings)0;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
               o.positionCS = TransformObjectToHClip(input.positionOS.xyz + input.normalOS.xyz * _OutLineWidth / 900.0);
               o.worldPos = TransformObjectToWorld(input.positionOS.xyz);
               return o;
           }

           float4 frag(Varyings i) : SV_Target
           {
                if(_OutlineSwitch==0)
                {
                     discard;
                }
                if(i.worldPos.y<0)
                {
                    discard;
                }
               return _OutlineColor;
           }
           ENDHLSL
        }


    }
}
