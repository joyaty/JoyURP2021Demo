

namespace Joy.Rendering.Custom
{
    [UnityEngine.CreateAssetMenu(fileName = "ExampleRenderPipelineAsset", menuName = "Rendering/ExampleRenderPipelineAsset")]
    public class ExampleRenderPipelineAsset : UnityEngine.Rendering.RenderPipelineAsset
    {
        protected override UnityEngine.Rendering.RenderPipeline CreatePipeline()
        {
            return new ExampleRenderPipelineInstance(this);
        }
    }
}

