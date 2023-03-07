using UnityEngine;
using UnityEngine.Rendering;

namespace Joy.Rendering.Custom
{ 
    public class ExampleRenderPipelineInstance : RenderPipeline
    {
        private ExampleRenderPipelineAsset m_RenderPipelineAsset;

        public ExampleRenderPipelineInstance(ExampleRenderPipelineAsset renderPipelineAsset)
        {
            m_RenderPipelineAsset = renderPipelineAsset;
        }

        protected override void Render(ScriptableRenderContext context, Camera[] cameras)
        {
            CommandBuffer commandBuffer = new CommandBuffer();
            commandBuffer.ClearRenderTarget(RTClearFlags.All, Color.grey, 1f, 0u);
            context.ExecuteCommandBuffer(commandBuffer);
            commandBuffer.Release();
            context.Submit();
        }
    }
}
