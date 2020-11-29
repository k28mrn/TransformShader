Shader "Custom/Transform"
{
	Properties
	{
		_Frequency("Frequency", Range(0, 3)) = 1
		_Amplitude("Amplitude", Range(0, 1)) = 0.5
		_Speed("Speed", Range(1, 100)) = 1
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			struct vertexInput {
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
			};

			struct fragmentInput {
				float4 position : SV_POSITION;
				float2 uv       : TEXCOORD0;
			};

			// uniform sampler2D _MainTex;
			float _Frequency;
			float _Amplitude;
			float _Speed;
			// float _Time; // TODO: Unityで設定されている

			fragmentInput vert(vertexInput v) {
				fragmentInput o;

				// float offsetY  = sin(v.vertex.x * _Frequency) + cos(v.vertex.z * _Frequency);
				float time = _Time * _Speed;
				float offsetY = sin(time + v.vertex.x * _Frequency) + cos(time + v.vertex.z * _Frequency);
				// offsetY *= sin(_Time * _Speed);
				v.vertex.y += offsetY * 1.0;

				o.position = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(fragmentInput i) : COLOR {
				// y軸は反転
				float2 uv = float2(i.uv.x, 1.0 - i.uv.y);

				// 0 ~ 1 ~ 0 に変換;
				uv *= 2.0;
				if (uv.x > 1.0) uv.x = 1.0 - (uv.x - 1.0);
				if (uv.y > 1.0) uv.y = 1.0 - (uv.y - 1.0);

				// fixed4 texColor = tex2D(_MainTex, uv);
				return fixed4(uv.x, uv.y, 0.0, 1.0);
			}

			ENDCG
		}
	}
}
