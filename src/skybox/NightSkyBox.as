package skybox
{
	import com.yogurt3d.core.sceneobjects.SkyBox;
	import com.yogurt3d.core.texture.CubeTextureMap;
	
	import flash.display.BitmapData;
	
	public class NightSkyBox extends SkyBox
	{
		[Embed(source='../resources/skybox/night/arch_positive_x.jpg')]
		private var embedpositiveX:Class;
		
		[Embed(source='../resources/skybox/night/arch_positive_y.jpg')]
		private var embedpositiveY:Class;
		
		[Embed(source='../resources/skybox/night/arch_positive_z.jpg')]
		private var embedpositiveZ:Class;
		
		[Embed(source='../resources/skybox/night/arch_negative_x.jpg')]
		private var embednegativeX:Class;
		
		[Embed(source='../resources/skybox/night/arch_negative_y.jpg')]
		private var embednegativeY:Class;
		
		[Embed(source='../resources/skybox/night/arch_negative_z.jpg')]
		private var embednegativeZ:Class;
		
			
		public function NightSkyBox(size:Number = 100.0)
		{
			var cubeTexture:CubeTextureMap = new CubeTextureMap();
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_X, new embednegativeX() );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Y, new embednegativeY() );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Z, new embednegativeZ() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_X, new embedpositiveX() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Y, new embedpositiveY() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Z, new embedpositiveZ() );
			super(cubeTexture,	size );
			
		}
	}
}